defmodule WeatherScraperTest do
  use ExUnit.Case, async: false

  alias WeatherScraper

  @expected "© The Weather Company, LLC 2025"

  test "extract_footer/1 finds the expected text" do
    # Instead of hitting the live site (which can change),
    # store a tiny sample of the footer HTML in a string.
    html = """
    <div class="Footer--attribution--FK8dr">
      <p data-testid="Copyright" class="TwcCopyright--copyright--CwMY+">
        <span>© The Weather Company, LLC 2025</span>
      </p>
    </div>
    """

    assert WeatherScraper.extract_footer(html) == {:ok, @expected}
  end

  @tag :integration
  test "fetch_footer_text/0 against the live site returns at least a value or :not_found" do
    case WeatherScraper.fetch_footer_text() do
      {:ok, text} ->
        assert String.contains?(text, "© The Weather Company")
      :not_found ->
        flunk("Footer span not found on live weather.com")
      {:error, reason} ->
        flunk("HTTP error: #{inspect(reason)}")
    end
  end
end
