# Genetic correlation plots
# Updated May 29th

# Load libraries
library(qqman)
library(ggplot2)
library(tidyr)
library(data.table)
library(dplyr)

# Load the data 
# Directory where files are located
SZ <- "/Users/caroline/Documents/Local_LDAK/Downloads/sz_genetic_correlation"
BP <- "/Users/caroline/Documents/Local_LDAK/Downloads/BP_genetic_correlation"
MDD <- "/Users/caroline/Documents/Local_LDAK/Downloads/MDD_genetic_correlation"
height <- "/Users/caroline/Documents/Local_LDAK/Downloads/height_genetic_correlation"


# List of all files in the folder
SZ_file_list <- list.files(path = SZ, full.names = TRUE)
BP_file_list <- list.files(path = BP, full.names = TRUE)
MDD_file_list <- list.files(path = MDD, full.names = TRUE)
height_file_list <- list.files(path = height, full.names = TRUE)

############
# Data storage

# Initialize an empty lists to store your datasets
SZ_list <- list()
BP_list <- list()
MDD_list <- list()
height_list <- list()

######
# SZ
for (file_path in SZ_file_list) {
  # Extract the filename without extension
  file_name <- basename(file_path)
  file_name <- gsub("\\.cors$", "", file_name)  # Remove .assoc extension
  
  # Load the file into R
  data <- fread(file_path)
  # Assign the filename as the dataset name
  SZ_list[[file_name]] <- data
}

######
# BP
for (file_path in BP_file_list) {
  # Extract the filename without extension
  file_name <- basename(file_path)
  file_name <- gsub("\\.cors$", "", file_name)  # Remove .assoc extension
  
  # Load the file into R
  data <- fread(file_path)
  
  # Assign the filename as the dataset name
  BP_list[[file_name]] <- data
}

######
# MDD
for (file_path in MDD_file_list) {
  # Extract the filename without extension
  file_name <- basename(file_path)
  file_name <- gsub("\\.cors$", "", file_name)  # Remove .assoc extension
  
  # Load the file into R
  data <- fread(file_path)
  
  # Assign the filename as the dataset name
  MDD_list[[file_name]] <- data
}

######
# Height
for (file_path in height_file_list) {
  # Extract the filename without extension
  file_name <- basename(file_path)
  file_name <- gsub("\\.cors$", "", file_name)  # Remove .assoc extension
  
  # Load the file into R
  data <- fread(file_path)
  
  # Assign the filename as the dataset name
  height_list[[file_name]] <- data
}


######
# Make a data frame

df <- data.frame(
  phenotype = factor(sub("\\..*", "", names(SZ_list[]))),
  correlation = unlist(lapply(SZ_list, function(x) x$Value[4])),
  SD = unlist(lapply(SZ_list, function(x) x$SD[4])))
df$trait <- "SZ"

df <- df[-c(1,2,7), ] # Remove extra phenotypes

df_bp <- data.frame(
  phenotype = factor(sub("\\..*", "", names(BP_list[]))),
  correlation = unlist(lapply(BP_list, function(x) x$Value[4])),
  SD = unlist(lapply(BP_list, function(x) x$SD[4])))
df_bp$trait <- "BP"
df_bp <- df_bp[-c(1,2,7), ] # Remove extra phenotypes

df_md <- data.frame(
  phenotype = factor(sub("\\..*", "", names(MDD_list[]))),
  correlation = unlist(lapply(MDD_list, function(x) x$Value[4])),
  SD = unlist(lapply(MDD_list, function(x) x$SD[4])))
df_md$trait <- "MDD"
df_md <- df_md[-c(1,2,7), ] # Remove extra phenotypes

df_height <- data.frame(
  phenotype = factor(sub("\\..*", "", names(height_list[]))),
  correlation = unlist(lapply(height_list, function(x) x$Value[4])),
  SD = unlist(lapply(height_list, function(x) x$SD[4])))
df_height$trait <- "Height"
df_height <- df_height[-c(1,2,7), ] # Remove extra phenotypes

data <- rbind(df, df_bp, df_md, df_height)
data$conf <- data$SD*2

head(data)
data$z <- ((0-data$correlation)/data$SD)
data$pval <- 2*pnorm(abs(data$z), lower.tail = F)

data$sig <- data$pval < 0.05
data$sig2 <- data$pval < 0.01
data$sig3 <- data$pval < 0.001

data$names <- rev(c("Vitamin D", "Psychosis age", 
                "Winter birth", "Insomnia", "Height", "Handedness", 
                "Smoking", "Cannabis"))

data <- data %>%
  mutate(names = factor(names, levels = rev(c("Vitamin D", "Psychosis age", 
                                              "Winter birth", "Insomnia", "Handedness", 
                                              "Smoking", "Cannabis", "Height"))))
data <- data %>%
  mutate(trait = factor(trait, levels = c("SZ", "BP", "MDD", "Height")))


p <- ggplot(data, aes(correlation, names))
p <- p +
  geom_point() +
  geom_errorbarh(aes(xmax = correlation + conf, xmin = correlation - conf, height = .1)) +
  xlim(-.7, .7) + 
  geom_vline(xintercept = 0, linetype = "dashed", color = "red") +
  geom_text(aes(label = ifelse(sig3, "***", ifelse(sig2, "**", ifelse(sig, "*", ""))),
                x = correlation, y = names), vjust = -0.5, hjust = 0) +
  labs(x = "Correlation", y = NULL) + theme_bw()

p + facet_wrap(~trait, ncol = 4)


