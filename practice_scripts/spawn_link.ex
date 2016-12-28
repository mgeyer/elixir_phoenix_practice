defmodule SpawnLink do
  @moduledoc """
  A test to show how a regular spawn command works
  """

  @doc "Note that the spawn command should log an error but not stop execution"
  def start do
    spawn(fn -> raise "oops" end)

    receive do
      :hello -> "Received Hello"
    end
  end
end

defmodule SpawnLinkError do
  @moduledoc """
  A test to show how a spawn_link command works
  """

  @doc "Note that the spawn_link command should raise an error and stop execution"
  def start do
    spawn_link(fn -> raise "oops" end)

    receive do
      :hello -> "Received Hello"
    end
  end
end

defmodule KeyValueStore do
  @moduledoc """
  An example of how to use a process to keep configurations in memory
  """

  @doc """
  Task is generally viewed as the preferred way to manage a new process.
  """
  def start do
    Task.start_link(fn -> loop(%{}) end)
  end


  @doc """
  After receiving any message the function needs to recurse on itself to start listening
  again.
  """
  def loop(store) do
    receive do
      {:get, key, caller} ->
        send(caller, Map.get(store, key))
        loop(store)
      {:puts, key, value} ->
        loop(Map.put(store, key, value))
    end
  end
end
