defmodule KV.Bucket do
  @moduledoc """
  Module responsible for the setting and retrieving of values in our key value store.
  """

  @doc """
  Start the given bucket with an empty map.
  """
  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Get the value of the specified key stored within the agent.
  """
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @doc """
  Put the value for the specified key stored within the agent.
  """
  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end

  @doc """
  Remove a key and return its value before deletion.
  """
  def delete(bucket, key) do
    Agent.get_and_update(bucket, &Map.pop(&1, key))
  end
end
