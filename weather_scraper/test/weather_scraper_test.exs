defmodule WeatherScraperTest do
  use ExUnit.Case, async: false

  alias WeatherScraper

  @expected "© The Weather Company, LLC 2025"

  describe "extract_footer_text/1" do
    test "returns the expected span text from sample HTML" do
      html = """
      <div class="Footer--attribution--FK8dr">
        <p data-testid="Copyright" class="TwcCopyright--copyright--CwMY+">
          <span>© The Weather Company, LLC 2025</span>
        </p>
      </div>
      """

      assert WeatherScraper.extract_footer_text(html) == {:ok, @expected}
    end

    test "returns :not_found when span is missing" do
      html = "<html><body><p>No footer here</p></body></html>"
      assert WeatherScraper.extract_footer_text(html) == :not_found
    end
  end

  describe "fetch_and_extract/0 (integration)" do
    @describetag integration: true
    test "against the live site returns at least a value or :not_found" do
      case WeatherScraper.fetch_and_extract() do
        {:ok, text} ->
          assert String.contains?(text, "© The Weather Company")

        :not_found ->
          flunk("Footer span not found on live weather.com")

        {:error, reason} ->
          flunk("HTTP error: #{inspect(reason)}")
      end
    end
  end
end
