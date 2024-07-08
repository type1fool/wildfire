defmodule Wildfire.Members do
  use GenServer

  @tracker Wildfire.Tracker

  @default_group_name "members"

  def list(group_name \\ @default_group_name) do
    Phoenix.Tracker.list(@tracker, group_name)
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(opts) do
    my_region = System.get_env("FLY_REGION", "ord")
    group_name = Keyword.get(opts, :name, @default_group_name)

    params = %{
      node: Node.self(),
      machine_id: System.get_env("FLY_MACHINE_ID")
    }

    case Phoenix.Tracker.track(@tracker, self(), group_name, my_region, params) do
      {:ok, ref} ->
        {:ok, %{group_name: group_name, ref: ref}}

      {:error, reason} ->
        raise "failed to init: #{inspect(reason)}"
    end
  end
end
