import::from(
  "dplyr",
  "arrange",
  "everything",
  "first",
  "group_by",
  "last",
  "left_join",
  "summarize"
)
import::from("ggplot2", .all = TRUE)
import::from("magrittr", "%>%")
import::from("purrr", "iwalk")
import::from("readr", "read_csv")
import::from("terra", "vect")
import::from("tidyr", "pivot_longer")
import::from("tidyterra", "geom_spatvector")

load_district_counts <- function(data_path = "pharmacies-all-clean.csv") {
  read_csv(data_path, show_col_types = FALSE) %>%
    pivot_longer(-district, names_to = "year", values_to = "count")
}

gen_counts_by_time_plot <- function(district_counts) {
  ggplot(
    district_counts,
    aes(x = year, y = count, col = district, group = district)
  ) +
    geom_line() +
    geom_point() +
    labs(
      x = "Year",
      y = "N Pharmacies",
      color = "District"
    ) +
    theme_minimal() +
    theme(
      legend.position = "bottom",
      plot.background = element_rect(color = "white")
    )
}

gen_period_change_plot <- function(period_change) {
  ggplot(
    period_change,
    aes(
      x = reorder(district, relative_change),
      y = relative_change, fill = relative_change
    )
  ) +
    geom_col() +
    scale_fill_viridis_c(option = "rocket") +
    labs(
      x = "District",
      y = "Relative Change"
    ) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = -80, hjust = 0),
      legend.position = "none",
      panel.grid = element_blank(),
      plot.background = element_rect(color = "white")
    )
}

download_districts_mapdata <- function(url = "https://tsb-opendata.s3.eu-central-1.amazonaws.com/bezirksgrenzen/bezirksgrenzen.geojson",
                                       destfile = "bezirksgrenzen.geojson") {
  download.file(url, destfile)
}

gen_period_change_map <- function(period_change) {
  districts_mapdata <- "bezirksgrenzen.geojson"

  if (!file.exists(districts_mapdata)) {
    download_districts_mapdata(destfile = districts_mapdata)
  }

  district_map <- vect(districts_mapdata) %>%
    left_join(period_change, by = c("Gemeinde_name" = "district"))

  ggplot() +
    geom_spatvector(
      data = district_map,
      aes(fill = relative_change)
    ) +
    scale_fill_viridis_c(option = "rocket") +
    labs(
      title = "Change in number of pharmacies in Berlin",
      subtitle = "Per district, 2014 - 2023",
      fill = ""
    ) +
    theme_minimal() +
    theme(
      panel.grid = element_blank(),
      axis.text = element_blank(),
      plot.background = element_rect(color = "white")
    )
}

generate_plots <- function(data_path = "pharmacies-all-clean.csv") {
  district_counts <- load_district_counts(data_path)

  plots <- list()

  plots[["counts_by_time_plot"]] <- gen_counts_by_time_plot(district_counts)

  period_change <- district_counts %>%
    arrange(year) %>%
    group_by(district) %>%
    summarize(
      relative_change = (last(count) / first(count)) - 1,
      absolute_change = last(count) - first(count)
    )

  plots[["period_change_plot"]] <- gen_period_change_plot(period_change)
  plots[["period_change_map"]] <- gen_period_change_map(period_change)

  iwalk(
    plots,
    \(plot, name) {
      ggsave(plot = plot, filename = paste0(name, ".png"), width = 9)
    }
  )
}

generate_plots()
