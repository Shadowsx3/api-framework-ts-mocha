defmodule Mix.Tasks.DistributedTest do
  use Mix.Task

  @shortdoc "Run tests distributed across two nodes"

  @moduledoc """
  Runs ExUnit tests distributed across two nodes.
  Usage:
    mix distributed_test node1@host1 node2@host2
  """

  def run([node1, node2]) do
    # Ensure both nodes are started and connected
    Node.start(String.to_atom(node1))
    Node.set_cookie(:mysecretcookie)
    Node.connect(String.to_atom(node2))

    test_files = Path.wildcard("test/**/*_test.exs")
    {files1, files2} = Enum.split(test_files, div(length(test_files), 2))

    IO.puts("Running tests on #{node1}: #{inspect files1}")
    IO.puts("Running tests on #{node2}: #{inspect files2}")

    # Run on local node
    local = Task.async(fn ->
      System.cmd("mix", ["test"] ++ files1, into: IO.stream(:stdio, :line))
    end)

    # Run on remote node
    remote = Node.spawn_link(String.to_atom(node2), __MODULE__, :remote_run, [files2])

    Task.await(local, :infinity)
    remote
  end

  def remote_run(files) do
    System.cmd("mix", ["test"] ++ files, into: IO.stream(:stdio, :line))
  end
end
