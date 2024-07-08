defmodule Wildfire.Fly.Regions do
  @moduledoc """
  Agent for managing Fly.io region data via the Fly CLI.
  """
  use Agent
  require Logger

  @timeout :timer.seconds(15)

  def start_link(_) do
    regions = fetch_regions()
    keys = collect_keys(regions)

    Agent.start_link(fn -> %{regions: regions, keys: keys} end,
      name: __MODULE__,
      timeout: @timeout
    )
  end

  def refresh do
    regions = fetch_regions()
    keys = collect_keys(regions)

    Agent.update(
      __MODULE__,
      fn _state ->
        %{
          regions: regions,
          keys: keys
        }
      end,
      @timeout
    )
  end

  def list_regions do
    Agent.get(__MODULE__, &Map.fetch!(&1, :regions))
  end

  def list_keys do
    Agent.get(__MODULE__, &Map.fetch!(&1, :keys))
  end

  defp collect_keys(regions) do
    for region <- regions, reduce: MapSet.new() do
      mapset ->
        region
        |> Map.keys()
        |> MapSet.new()
        |> MapSet.union(mapset)
    end
  end

  defp fetch_regions do
    Logger.info("Fetching Fly.io regions")

    with {payload, 0} <- System.cmd("fly", ~w(platform regions --json)),
         {:ok, map} <- Jason.decode(payload) do
      map
    else
      {_stderr, exit_status} when is_integer(exit_status) ->
        raise "invalid exit status: #{exit_status}"

      {:error, %Jason.DecodeError{}} ->
        raise "invalid JSON response"
    end
  end
end
