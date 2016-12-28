defmodule KV.Registry do
  @moduledoc """
  Genserver registry used to keep track of different buckets
  """
  use GenServer

  # Client API

  @doc """
  Start the registry.
  """
  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  @doc """
  Lookup the given registry.
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Create a new registry.
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  # Server API

  @doc """
  Initialize the server
  """
  def init(:ok) do # NOTE: Not sure why we would require this as an arg
    names = %{}
    refs  = %{}
    {:ok, {names, refs}}
  end

  @doc """
  See if a given bucket already exists. Return it if so.
  """
  def handle_call({:lookup, name}, _from, {names, _} = state) do
    {:reply, Map.fetch(names, name), state}
  end

  @doc """
  Create a new bucket if it doesn't exist already
  """
  def handle_cast({:create, name}, {names, refs}) do
    if Map.has_key?(names, name) do
      {:noreply, {names, refs}}
    else
      # Create the bucket
      {:ok, bucket} = KV.Bucket.start_link
      # add a reference to its PID in the names state
      names = Map.put(names, name, bucket)
      # Monitor the bucket and add it to existing refs
      ref = Process.monitor(bucket)
      refs = Map.put(names, ref, name)
      {:noreply, {names, refs}}
    end
  end


  @doc """
  Handle down alerts
  """
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end

  @doc """
  Handle all other messages
  """
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
