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

    IO.puts("\n\e[34m==> Running tests on #{node1}:\e[0m\n  #{Enum.join(files1, "\n  ")}")
    IO.puts("\e[35m==> Running tests on #{node2}:\e[0m\n  #{Enum.join(files2, "\n  ")}")

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
    print_remote_output(remote_output)
  end

  def run_and_capture(files) do
    System.put_env("MIX_ENV", "test")
    {:ok, capture_pid} = StringIO.open("")
    old = Process.group_leader()
    Process.group_leader(self(), capture_pid)
    try do
      Mix.Tasks.Test.run(files)
      {_input, output} = StringIO.contents(capture_pid)
      output
    after
      Process.group_leader(self(), old)
    end
  end

  def print_remote_output({:badrpc, reason}) do
    IO.puts("\n\e[31m===== Remote node error =====\e[0m")
    IO.inspect(reason, label: "Remote error", pretty: true)
  end

  def print_remote_output(output) when is_binary(output) do
    IO.puts("\n\e[36m===== Remote node output =====\e[0m\n" <> String.trim(output))
  end

  def print_remote_output(other) do
    IO.puts("\n\e[33m===== Remote node unknown result =====\e[0m\n#{inspect(other, pretty: true)}")
  end
end
