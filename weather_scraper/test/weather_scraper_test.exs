defmodule WeatherScraperTest do
  use ExUnit.Case, async: false

  # alias scraping module
  alias WeatherScraper

  # module attr to hold expected result
  @expected "© The Weather Company, LLC 2025"

  describe "extract_footer_text/1" do
    test "returns the expected span text from sample HTML" do
      # sample html so that we can choose to skip going to the live site
      # and test fn against sample html. also websites change, this will remain constant
      html = """
      <div class="Footer--attribution--FK8dr">
        <p data-testid="Copyright" class="TwcCopyright--copyright--CwMY+">
          <span>© The Weather Company, LLC 2025</span>
        </p>
      </div>
      """

      # assert that we find expected text within sample html
      assert WeatherScraper.extract_footer_text(html) == {:ok, @expected}
    end

    test "returns :not_found when span is missing" do
      # html with target span missing
      html = "<html><body><p>No footer here</p></body></html>"

      # assert we get the :not_found fallback
      assert WeatherScraper.extract_footer_text(html) == :not_found
    end
  end

  describe "fetch_and_extract/0 (integration)" do
    # tagged so we can choose to exclude it when running `$ mix test`
    # usage: `$ mix test --exclude integration`
    @describetag integration: true
    test "against the live site returns at least a value or :not_found" do
      case WeatherScraper.fetch_and_extract() do
        {:ok, text} ->
          # if text extracted properly, ensure it is as expected
          assert String.contains?(text, "© The Weather Company")

        :not_found ->
          # explicitly fail if live structure changed & span is missing
          flunk("Footer span not found on live weather.com")

        {:error, reason} ->
          # fail on http or parsing error, print reason
          flunk("HTTP error: #{inspect(reason)}")
      end
    end
  end
end
