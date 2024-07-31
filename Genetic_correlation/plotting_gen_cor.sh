

find /home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results \
 -name "*.cors" \
 -exec cp {} /home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/download_genetic_correlation \;




# This script is used to plot the genetic correlation between the phenotypes of interest

# The files needed for this is in the

library(qqman)
library(ggplot2)
library(tidyr)
library(data.table)


# Set the directory where your files are located
folder_path <- "/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/prescription_correlation"
folder_2_path <- "/home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results"

# Get a list of all files in the folder
file_list <- list.files(path = folder_path, full.names = TRUE)
file_list_2 <- list.files(path = folder_2_path, full.names = TRUE)

# Initialize an empty list to store your datasets
dataset_list <- list()

# Loop through each file
for (file_path in file_list) {
    # Extract the filename without extension
    file_name <- basename(file_path)
    file_name <- gsub("\\.cors$", "", file_name)  # Remove .assoc extension
    
    # Load the file into R
    data <- fread(file_path)
    
    # Assign the filename as the dataset name
    dataset_list[[file_name]] <- data
}

df_anti_log <- fread("/Users/caroline/Documents/Local_LDAK/projects/Genetic_correlation/download_genetic_correlation/antipsychotics.pheno_logistic.summaries_cor.cors")

df_first_log <- fread("/Users/caroline/Documents/Local_LDAK/projects/Genetic_correlation/download_genetic_correlation/first_gen.pheno_logistic.summaries_cor.cors")

head(df_anti_log)
head(df_first_log)


names(dataset_list)

df <- data.frame(
  phenotype = factor(sub("\\..*", "", names(dataset_list[]))),
  correlation = c(dataset_list[[1]]$Value[4], dataset_list[[2]]$Value[4], dataset_list[[3]]$Value[4], dataset_list[[4]]$Value[4], dataset_list[[5]]$Value[4]),
  SD = c(dataset_list[[1]]$SD[4], dataset_list[[2]]$SD[4], dataset_list[[3]]$SD[4], dataset_list[[4]]$SD[4], dataset_list[[5]]$SD[4])
)

p <- ggplot(df, aes(correlation, phenotype))
p +
  geom_point() +
  geom_errorbarh(aes(xmax = correlation + SD, xmin = correlation - SD, height = .1)) +
  xlim(-.1, 1.6) + 
  geom_vline(xintercept = 0, linetype = "dashed", color = "red")


