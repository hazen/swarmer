defmodule Swarmer.Example do
  @doc """
  Starts a series of workers
  """
  def start_workers(total) do
    1..total
    |> Enum.each(&start_worker(String.to_atom("worker#{&1}")))
  end

  @doc """
  Starts worker and registers name in the cluster, then joins the process
  to the `:fight_club` group
  """
  def start_worker(name) do
    {:ok, pid} = Swarm.register_name(name, Swarmer.Supervisor, :register, [name])
    Swarm.join(:fight_club, pid)
  end

  @doc """
  Gets the pid of the worker with the given name
  """
  def get_worker(name), do: Swarm.whereis_name(name)

  @doc """
  Gets all of the pids that are members of the `:fight_club` group
  """
  def get_fight_clubers(), do: Swarm.members(:fight_club)

  @doc """
  Call some worker by name
  """
  def call_worker(name, msg), do: GenServer.call({:via, :swarm, name}, msg)

  @doc """
  Cast to some worker by name
  """
  def cast_worker(name, msg), do: GenServer.cast({:via, :swarm, name}, msg)

  @doc """
  Publish a message to all members of group `:fight_club`
  """
  def publish_fight_clubers(msg), do: Swarm.publish(:fight_club, msg)

  @doc """
  Call all members of group `:fight_club` and collect the results,
  any failures or nil values are filtered out of the result list
  """
  def call_fight_clubers(msg), do: Swarm.multi_call(:fight_club, msg)
end
