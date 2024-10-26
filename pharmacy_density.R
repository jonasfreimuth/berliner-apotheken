import::from(
  "dplyr", "arrange", "everything", "first", "group_by", "last", "summarize"
)
import::from("ggplot2", .all = TRUE)
import::from("magrittr", "%>%")
import::from("purrr", "iwalk")
import::from("readr", "read_csv")
import::from("tidyr", "pivot_longer")

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
    theme(legend.position = "bottom")
}

gen_period_change_plot <- function(period_change) {
  ggplot(
    period_change,
    aes(x = district, y = relative_change, fill = relative_change)
  ) +
    geom_col() +
    scale_fill_viridis_c(option = "rocket") +
    labs(
      x = "District",
      y = "Relative Change"
    ) +
    theme_minimal() +
    theme(
      legend.position = "none",
      axis.text.x = element_text(angle = 50, hjust = 1)
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

  iwalk(
    plots,
    \(plot, name) {
      ggsave(plot = plot, filename = paste0(name, ".pdf"), width = 9)
    }
  )
}

generate_plots()
