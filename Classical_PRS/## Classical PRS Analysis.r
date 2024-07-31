## Classical PRS Analysis

# Set the working directory to the parent folder of the 'results' folder
setwd("~/Documents/Local_LDAK/projects/PRS_try")

# Create a list of file paths for the .assoc files in the four folders
file_paths <- list(
  binary_1000 = list.files("results/binary_1000", pattern = "\\.assoc$", full.names = TRUE),
  binary_2000 = list.files("results/binary_2000", pattern = "\\.assoc$", full.names = TRUE),
  quantitative_1000 = list.files("results/quantitative_1000", pattern = "\\.assoc$", full.names = TRUE),
  quantitative_2000 = list.files("results/quantitative_2000", pattern = "\\.assoc$", full.names = TRUE)
)

# Import the data sets using the file paths
binary_1000_data <- read.table(file_paths$binary_1000, header = T)
binary_2000_data <- read.table(file_paths$binary_2000, header = TRUE)
quantitative_1000_data <- read.table(file_paths$quantitative_1000, header = TRUE)
quantitative_2000_data <- read.table(file_paths$quantitative_2000, header = TRUE)


# Manhattan plots using the qqman package
library(qqman)

# Create a list of data frames
data_list <- list(
  binary_1000_data,
  binary_2000_data,
  quantitative_1000_data,
  quantitative_2000_data
)

# Create a list of plot titles
title_list <- c(
  "Manhattan Plot - Binary 1000 Data",
  "Manhattan Plot - Binary 2000 Data",
  "Manhattan Plot - Quantitative 1000 Data",
  "Manhattan Plot - Quantitative 2000 Data"
)

# Create a loop to generate the Manhattan plots
for (i in 1:length(data_list)) {
  # Set the y-axis limits
  ylim <- c(0, 1+max(-log10(data_list[[i]]$Wald_P), na.rm = TRUE))
  
  # Create the Manhattan plot before clumping
  manhattan(
    data_list[[i]],
    chr = "Chromosome",
    bp = "Basepair",
    p = "Wald_P",
    snp = "Predictor",
    main = title_list[i],
    ylim = ylim
  )
}


# Manhattan after clumping
# Color the SNPs that are still considered after clumping for each p-value cut-off value

# Create a list of p-value cut-off values
p_list <- c(1,0.1,0.01,0.001,0.0001,0.00001,5e-8)

# Create a list of colors
color_list <- c("black", "red", "green", "blue", "purple", "orange", "yellow")

# Create a list of plot titles
title_list <- c(
  "Manhattan Plot - Binary 1000 Data",
  "Manhattan Plot - Binary 2000 Data",
  "Manhattan Plot - Quantitative 1000 Data",
  "Manhattan Plot - Quantitative 2000 Data"
)

# Create a loop to generate the Manhattan plots
for (i in 1:length(data_list)) {
  # Set the y-axis limits
  ylim <- c(0, 1+max(-log10(data_list[[i]]$Wald_P), na.rm = TRUE))
  
  # Create the Manhattan plot before clumping
  manhattan(
    data_list[[i]],
    chr = "Chromosome",
    bp = "Basepair",
    p = "Wald_P",
    snp = "Predictor",
    main = title_list[i],
    ylim = ylim
  )
  
  # Create a loop to color the SNPs that are still considered after clumping for each p-value cut-off value
  for (j in 1:length(p_list)) {
    # Create a data frame of the SNPs that are still considered after clumping for each p-value cut-off value
    clumped_data <- data_list[[i]][data_list[[i]]$Wald_P < p_list[j], ]
    
    # Add the SNPs to the Manhattan plot
    points(
      -log10(clumped_data$Wald_P) ~ clumped_data$Basepair,
      col = color_list[j],
      pch = 20
    )
  }
}

