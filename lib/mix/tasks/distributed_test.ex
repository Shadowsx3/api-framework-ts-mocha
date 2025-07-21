defmodule Mix.Tasks.DistributedTest do
  use Mix.Task

  @shortdoc "Run tests distributed across two nodes"

  @moduledoc """
  Runs ExUnit tests distributed across two nodes.
  Usage:
    mix distributed_test node1@host1 node2@host2
  """

  def run([node1, node2]) do
    Node.start(String.to_atom(node1))
    Node.set_cookie(:mysecretcookie)
    Node.connect(String.to_atom(node2))

    test_files = Path.wildcard("test/**/*_test.exs")
    {files1, files2} = Enum.split(test_files, div(length(test_files), 2))

    IO.puts("Running tests on #{node1}: #{inspect files1}")
    IO.puts("Running tests on #{node2}: #{inspect files2}")

    # Run on local node
    local = Task.async(fn ->
      Mix.Tasks.Test.run(files1)
    end)

    # Run on remote node and capture output
    remote = Task.async(fn ->
      :rpc.call(String.to_atom(node2), __MODULE__, :run_and_capture, [files2])
    end)

    Task.await(local, :infinity)
    remote_output = Task.await(remote, :infinity)
    IO.puts("\n===== Remote node output =====\n" <> (remote_output || "<no output>"))
  end

  def run_and_capture(files) do
    {:ok, capture_pid} = StringIO.open("")
    old = Process.group_leader()
    Process.group_leader(self(), capture_pid)
    try do
      Mix.Tasks.Test.run(files)
      {:ok, output} = StringIO.contents(capture_pid)
      output
    after
      Process.group_leader(self(), old)
    end
  end
end
