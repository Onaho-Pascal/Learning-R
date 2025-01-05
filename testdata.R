library(readxl)

application_data <- read_excel("C:/Users/user/Documents/Test Data.xlsx", sheet = "Applications")
View(application_data)

library(ggplot2)


ggplot(application_data, aes(x = Applications, y = Admissions)) +
  geom_point()
library(reshape2)

heatmap_data <- dcast(application_data, Discipline ~ Year, value.var = "Applications")
heatmap_matrix <- as.matrix(heatmap_data[,-1])

heatmap(heatmap_matrix, Rowv = NA, Colv = NA, col = heat.colors(256), scale = "column", 
        margins = c(5,10), xlab = "Year", ylab = "Discipline", main = "Student Applications Heatmap")



# Melt the data for ggplot2
# library(reshape2)
melted_data <- melt(application_data, id.vars = c("Discipline", "Year"), measure.vars = "Applications")

# Create heatmap
# Melt the data for ggplot2
library(reshape2)
library(ggplot2)

# Reshape the data
melted_data <- melt(data, id.vars = c("Discipline", "Year"), measure.vars = "Applications")

# Create heatmap with adjustments
ggplot(melted_data, aes(x = Year, y = Discipline, fill = value)) +
  geom_tile(color = "white") +  # Adds a white border around tiles for separation
  scale_fill_gradient(low = "white", high = "blue") +
  labs(title = "Student Applications Heatmap", x = "Year", y = "Discipline") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 6),  # Rotate x-axis labels
    axis.text.y = element_text(size = 6),                         # Adjust y-axis text size
    plot.title = element_text(size = 8, face = "bold"),           # Title size and style
    legend.title = element_text(size = 12),                        # Legend title size
    legend.text = element_text(size = 10)                          # Legend text size
  )

