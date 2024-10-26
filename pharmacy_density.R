import::from(
  "dplyr", "arrange", "everything", "first", "group_by", "last", "summarize"
)
import::from("ggplot2", .all = TRUE)
import::from("magrittr", "%>%")
import::from("readr", "read_csv")
import::from("tidyr", "pivot_longer")

district_counts_data_path <- "pharmacies-all-clean.csv"

district_counts <- read_csv(district_counts_data_path, show_col_types = FALSE) %>%
  pivot_longer(-district, names_to = "year", values_to = "count")

counts_by_time_plot <- ggplot(
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

ggsave(
  plot = counts_by_time_plot, filename = "counts_by_time.pdf",
  width = 9
)

period_change <- district_counts %>%
  arrange(year) %>%
  group_by(district) %>%
  summarize(
    relative_change = (last(count) / first(count)) - 1,
    absolute_change = last(count) - first(count)
  )

period_change_plot <- ggplot(
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

ggsave(
  plot = period_change_plot, filename = "change_over_time.pdf",
  width = 9
)
