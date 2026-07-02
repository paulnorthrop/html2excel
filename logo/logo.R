library(hexSticker)
library(ggplot2)
library(showtext)

icon_data <- data.frame(
  x = c(1, 2, 3, 1, 2, 3, 1, 2, 3),
  y = c(1, 1, 1, 2, 2, 2, 3, 3, 3)
)

p <- ggplot(icon_data, aes(x, y)) +
  geom_tile(fill = "white", color = "#107C41", linewidth = 0.5, alpha = 0.8) +
  annotate("text", x = 2, y = 2, label = "</>",
           color = "#E34F26", size = 18, fontface = "bold", family = "sans") +
  theme_void() +
  theme(panel.background = element_rect(fill = "transparent", colour = NA))

sticker(
  subplot = p,
  package = "html2excel",
  p_size = 18,
  p_color = "#FFFFFF",
  p_y = 1.4,
  s_x = 1.0, s_y = 0.85,
  s_width = 1.3, s_height = 0.7,
  h_fill = "#1A1A1A",
  h_color = "#107C41",
  h_size = 1.8,
  filename = "man/figures/html2excel_logo.png"
)
