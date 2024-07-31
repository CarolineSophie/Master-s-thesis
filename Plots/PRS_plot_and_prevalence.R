prs <- read.table("~/Documents/Local_LDAK/Downloads/PRS/test.mega_edit_2.profile", header=T)

prs$Phenotype <- as.factor(prs$Phenotype)
levels(prs$Phenotype)

prs$Profile_1 <- as.numeric(prs$Profile_1)
subset_prs <- subset(prs, !is.na(Phenotype))

library(ggplot2)
# install.packages("devtools")
library(devtools)
# install_github("thomasp85/patchwork")
library(patchwork)

quantiles <- quantile(subset_prs$Profile_1, probs = seq(0, 1, 0.10))

quantiles_1_5 <- quantile(subset_prs$Profile_1, probs = c(0.01, 0.05, 0.95, 0.99))

# Create a density plot
p <- ggplot(subset_prs, aes(x = Profile_1, color = Phenotype, fill = Phenotype)) +
  xlab("PRS Schizophrenia") +
  ylab("Density") +
  scale_color_manual(values = c("0" = "#276FBF", "1" = "#183059")) +
  scale_fill_manual(values = c("0" = "#276FBF", "1" = "#183059")) +
  geom_density(alpha = 0.5, size = .5) 


# Add quantile lines
p + geom_vline(xintercept = quantiles_1_5, color = "black", linetype="dashed")

# Add labels to the quantile lines
p1 <- p + geom_vline(xintercept = quantiles_1_5, color = "black", linetype="dashed") +
  annotate("text", x = quantiles_1_5, y = 1.15, label = names(quantiles_1_5), vjust = -.5, angle=90) +
  theme_bw() +
  ggtitle("A.")



# For the quantiles I want to calculate the number of cases in each quantile

for (i in 1:length(quantiles)) {
  quantile <- subset_prs[subset_prs$Profile_1 <= quantiles[i], ]
  case_count <- sum(quantile$Phenotype == 1)
  print(quantiles[i])
  print(case_count)
}

# I want the difference in mean between the two phenotypes
mean(subset_prs[subset_prs$Phenotype == 1, ]$Profile_1) - mean(subset_prs[subset_prs$Phenotype == 0, ]$Profile_1)

# I want to check for significance of the difference in means between the two phenotypes using a one-sided t-test
t.test(subset_prs[subset_prs$Phenotype == 1, ]$Profile_1, subset_prs[subset_prs$Phenotype == 0, ]$Profile_1, alternative = "greater")



# I want to calculate the prevalence of cases in the following bins:
# 0-1%, 1-5%, 5-10%, 10-20%, 20-30%, 30-40%, 40-50%, 50-60%, 60-70%, 70-80%, 80-90%, 90-95%, 95-99%, 99-100%

quantiles <- quantile(subset_prs$Profile_1, probs = seq(0, 1, 0.01))

for (i in 1:(length(quantiles) - 1)) {
  quantile <- subset_prs[subset_prs$Profile_1 >= quantiles[i] & subset_prs$Profile_1 < quantiles[i + 1], ]
  case_count <- sum(quantile$Phenotype == 1)
  print(paste(quantiles[i], quantiles[i + 1], case_count))
}

# make table with data
quantile_table <- data.frame(quantile_start = quantiles[1:(length(quantiles) - 1)], quantile_end = quantiles[2:length(quantiles)], case_count = NA)
# fill in the case counts
for (i in 1:(length(quantiles) - 1)) {
  quantile <- subset_prs[subset_prs$Profile_1 >= quantiles[i] & subset_prs$Profile_1 < quantiles[i + 1], ]
  case_count <- sum(quantile$Phenotype == 1)
  quantile_table$case_count[i] <- case_count
}
# make new table with the desired bins
bins <- quantile(subset_prs$Profile_1, probs = c(0, 0.01, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.95, 0.99, 1))
bin_table <- data.frame(bin_start = bins[1:(length(bins) - 1)], bin_end = bins[2:length(bins)], case_count = NA)
# fill in the case counts
for (i in 1:(length(bins) - 1)) {
  quantile <- subset_prs[subset_prs$Profile_1 >= bins[i] & subset_prs$Profile_1 < bins[i + 1], ]
  case_count <- sum(quantile$Phenotype == 1)
  bin_table$case_count[i] <- case_count
}

# calculate number of individuals in each bin
bin_table$individual_count <- sapply(1:(nrow(bin_table)), function(i) {
  quantile <- subset_prs[subset_prs$Profile_1 >= bin_table$bin_start[i] & subset_prs$Profile_1 < bin_table$bin_end[i], ]
  nrow(quantile)
})

# calculate prevalence percentage of cases in each bin
bin_table$prevalence <- bin_table$case_count / bin_table$individual_count * 100

bin_labels <- c("0-1%", "1-5%", "5-10%", "10-20%", "20-30%", "30-40%", "40-50%", "50-60%", "60-70%", "70-80%", "80-90%", "90-95%", "95-99%", "99-100%")
bin_label_order <- c("0-1%", "1-5%", "5-10%", "10-20%", "20-30%", "30-40%", "40-50%", "50-60%", "60-70%", "70-80%", "80-90%", "90-95%", "95-99%", "99-100%")
bin_labels <- factor(bin_labels, levels = bin_label_order)
# add a column for the bin labels
bin_table$bin_label <- bin_labels
class(bin_table$bin_label)

# I want a strata plot to show the prevalence of cases in each bin
# I want the strata to be the quantile bins, and I want these to be on the x-axis
p2 <- ggplot(bin_table, aes(x = bin_label, y = prevalence)) +
  geom_point() +
  xlab("Strata for Schizophrenia PRS") +
  ylab("Prevalence of SZ cases (%)") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("B.")

p1 + p2 + plot_layout(ncol=2,widths=c(1.3,1.7))

