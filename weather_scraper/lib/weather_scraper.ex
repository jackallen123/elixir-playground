defmodule WeatherScraper do
  @moduledoc """

  A simple module to fetch weather.com's homepage and extract footer text
  """

  @url "https://weather.com"

  @doc """
  Fetches weather.com's homepage

  returns `{:ok, html}` or `{:error, reason}`
  """
  @spec fetch_homepage() :: {:ok, String.t()} | {:error, any()}
  def fetch_homepage do
    case HTTPoison.get(@url, [], follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, {:unexpected_status, code}}

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
    |> Floki.parse_document!()
    |> Floki.find("div.Footer--attribution--FK8dr span")
    |> case do
      [{_, _, [text]}] -> {:ok, String.trim(text)}
      _                -> :not_found
    end
  end

  @doc """
  fetch + extract in one call
  """
  @spec fetch_and_extract() :: {:ok, String.t()} | {:error, any()} | :not_found
  def fetch_and_extract do
    with {:ok, html} <- fetch_homepage(),
         {:ok, text} <- extract_footer_text(html) do
      {:ok, text}
    else
      :not_found    -> :not_found
      {:error, reason} -> {:error, reason}
    end
  end
end
