defmodule WildfireWeb.ErrorJSONTest do
  use WildfireWeb.ConnCase, async: true

  test "renders 404" do
    assert WildfireWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert WildfireWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
