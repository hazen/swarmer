defmodule SwarmerTest do
  use ExUnit.Case
  # doctest Swarmer

  test "simple up down" do
    {:ok, spid} = Swarmer.Supervisor.start_link()
    Swarmer.Example.start_worker(:test_case)
    assert %{workers: 1, active: 1, specs: 1, supervisors: 0} == Supervisor.count_children(spid)
    Swarmer.Example.publish_fight_clubers({:swarm, :die})
    Process.sleep(2000)
    assert %{workers: 0, active: 0, specs: 1, supervisors: 0} == Supervisor.count_children(spid)
  end
end
