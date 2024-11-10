# Load necessary libraries
library(RColorBrewer)
library(viridis)
library(ggplot2)

# Generate a color palette for gene expression
gene_expression_palette <- viridis(100, option = "magma")  # Options: "magma", "plasma", "inferno", "cividis"

# Preview the palette
scales::show_col(gene_expression_palette)

# Generate a color palette for pathways
pathway_palette <- brewer.pal(8, "Set2")  # Adjust the number and name to suit your data

# Preview the palette
scales::show_col(pathway_palette)


# Create mock gene expression data
set.seed(123)
genes <- paste0("Gene", 1:10)
samples <- paste0("Sample", 1:5)
expression_data <- matrix(runif(50, min = 0, max = 10), nrow = 10, dimnames = list(genes, samples))

# Convert to a data frame for ggplot2
expression_df <- as.data.frame(as.table(expression_data))
colnames(expression_df) <- c("Gene", "Sample", "Expression")

# Plot heatmap using a custom color scale
ggplot(expression_df, aes(x = Sample, y = Gene, fill = Expression)) +
  geom_tile() +
  scale_fill_gradientn(colors = gene_expression_palette) +
  theme_minimal() +
  labs(title = "Gene Expression Heatmap", x = "Sample", y = "Gene", fill = "Expression Level")

# Create mock categorical data for pathways
pathway_data <- data.frame(
  Gene = rep(paste0("Gene", 1:8), each = 2),
  Pathway = rep(c("Pathway_A", "Pathway_B", "Pathway_C", "Pathway_D"), each = 4)
)

# Plot pathways with custom colors
ggplot(pathway_data, aes(x = Pathway, y = Gene, fill = Pathway)) +
  geom_tile(color = "white", size = 0.5) +
  scale_fill_manual(values = pathway_palette) +
  theme_minimal() +
  labs(title = "Pathway Assignment", x = "Pathway", y = "Gene")
