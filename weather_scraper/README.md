# WeatherScraper

1. Created a new Mix project & escript entrypoint
```bash
$ mix new weather_scraper --module WeatherScraper
$ cd weather_scraper
```

2. Edited `mix.exs` to add dependencies & enable escript
```bash
$ mix deps.get
$ mix compile
```

3. Implemented scraping logic into `/lib/weather_scraper` and testing logic into `test/weather_scraper_test`

4. Used mix to compile & test after making changes
```bash
$ mix compile
$ mix test
```

5. To test without going to live site
```bash
$ mix compile
$ mix test --exclude integration
```
