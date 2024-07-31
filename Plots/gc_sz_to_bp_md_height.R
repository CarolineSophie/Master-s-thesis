
library(ggplot2)
library(dplyr)
library(data.table)

# Set the directory where your files are located
SZ <- "/Users/caroline/Documents/Local_LDAK/Downloads/download_SZ_PGC_correlation"

# Get a list of all files in the folder
SZ_file_list <- list.files(path = SZ, full.names = TRUE)

# Initialize an empty list to store your datasets
SZ_list <- list()

# Loop through each file
for (file_path in SZ_file_list) {
  # Extract the filename without extension
  file_name <- basename(file_path)
  file_name <- gsub("\\.cors$", "", file_name)  # Remove .assoc extension
  
  # Load the file into R
  data <- fread(file_path)
  
  # Assign the filename as the dataset name
  SZ_list[[file_name]] <- data
}


names(SZ_list)

df <- data.frame(
  phenotype = factor(sub("\\..*", "", names(SZ_list[]))),
  correlation = unlist(lapply(SZ_list, function(x) x$Value[4])),
  SD = unlist(lapply(SZ_list, function(x) x$SD[4])))

new_data <- df[-3, ]
new_data$conf <- new_data$SD*2




new_data$z <- ((0-new_data$correlation)/new_data$SD)
new_data$pval <- 2*pnorm(abs(new_data$z), lower.tail = F)

new_data$sig <- new_data$pval < 0.05
new_data$sig2 <- new_data$pval < 0.01
new_data$sig3 <- new_data$pval < 0.001
new_data$names <- c("Height", "Bipolar Disorder", "Major Depressive Disorder")

new_data <- new_data %>%
  mutate(names = factor(names, levels = c("Height", "Major Depressive Disorder", "Bipolar Disorder")))

p <- ggplot(new_data, aes(correlation, names)) +
  geom_point() +
  geom_errorbarh(aes(xmax = correlation + conf, xmin = correlation - conf, height = .1)) +
  xlim(-.5, 1) + 
  geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
  ggtitle("Genetic correlation - Schizophrenia") +  # Updated title
  geom_text(aes(label = ifelse(sig3, "***", ifelse(sig2, "**", ifelse(sig, "*", ""))),
                x = correlation, y = names), vjust = .8, hjust = -1) +
  labs(x = "Correlation", y = NULL) + theme_bw()

p

