defmodule WeatherScraper do
  @moduledoc """

  A simple module to fetch weather.com's homepage and extract footer text
  """

  # base URL
  @url "https://weather.com"

  @doc """
  Fetches weather.com's homepage

  returns `{:ok, html}` or `{:error, reason}`
  """
  @spec fetch_homepage() :: {:ok, String.t()} | {:error, any()}
  def fetch_homepage do
    # http get to @url
    case HTTPoison.get(@url, [], follow_redirect: true) do

      # if success status (i.e., 200), return body wrapped in :ok
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      # if unexpected status (i.e., 404, 500), wrap code in :error tuple
      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, {:unexpected_status, code}}

      # shouldn't really get here, maybe network error?
      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Given raw HTML of page, extracts the footer text

  returns `{:ok, footer_text}` or `:not_found` otherwise
  """
  @spec extract_footer_text(String.t()) :: {:ok, String.t()} | :not_found
  def extract_footer_text(html) do
    html
    # parses the html so we can narrow in on footer
    |> Floki.parse_document!()

    # finds specific span we want to target within footer
    |> Floki.find("div.Footer--attribution--FK8dr span")

    # perform pattern matching on result
    |> case do
      # if exactly one node w/ text, extract
      [{_, _, [text]}] ->
        # print some details for debugging
        IO.inspect(text, label: "Extracted footer text")

        # trim and return wrapped in :ok
        {:ok, String.trim(text)}

      # any result other than above means not found
      _ ->
        IO.puts("Footer span not found")
        :not_found
    end
  end


  @doc """
  fetch + extract in one call
  """
  @spec fetch_and_extract() :: {:ok, String.t()} | {:error, any()} | :not_found
  def fetch_and_extract do
    with {:ok, html} <- fetch_homepage(),
         {:ok, text} <- extract_footer_text(html) do
      # if both calls succeed, return text
      {:ok, text}
    else
      :not_found    -> :not_found

      # catch & return any errors
      {:error, reason} -> {:error, reason}
    end
  end
end
