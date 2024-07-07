defmodule Wildfire.Fly.RegionsTest do
  alias Wildfire.Fly.Regions
  use Wildfire.DataCase

  describe "list_regions/0" do
    test "returns a list of region maps" do
      regions = Regions.list_regions()

      assert is_list(regions)
      refute Enum.empty?(regions)

      for region <- regions, key <- Regions.list_keys() do
        assert Map.has_key?(region, key)
      end
    end
  end
end
