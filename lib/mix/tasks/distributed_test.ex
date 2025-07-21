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

    # Run on remote node using :rpc
    remote = Task.async(fn ->
      :rpc.call(String.to_atom(node2), Mix.Tasks.Test, :run, [files2])
    end)

    Task.await(local, :infinity)
    Task.await(remote, :infinity)
  end
end
