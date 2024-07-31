############################################################
# Explore prescription counts and correlation with PRS
############################################################
library(dplyr)
library(data.table)
library(ggplot2)
library(patchwork)

# Load the prescription counts
counts <- read.delim("/Users/caroline/Documents/Local_LDAK/Plots/prescription_discovery/data/counts.txt", sep = "\t", header = T)

# Load the duration data
duration <- read.delim("/Users/caroline/Documents/Local_LDAK/Plots/prescription_discovery/data/duration.txt", sep = "\t", header = T)

# Load the patient data
patients <- read.delim("/Users/caroline/Documents/Local_LDAK/Plots/prescription_discovery/data/patients.txt", sep = "\t", header = T)

# Load the PRS profile
profile <- read.delim("/Users/caroline/Documents/Local_LDAK/Plots/prescription_discovery/data/test.mega_edit_2.profile", header = T, sep = "\t")

# Extract observations from the PRS profile that are also in the prescription counts
SZ_anti_PRS <- profile[profile$ID1 %in% counts$ID, ] # 218 individuals with SZ overlapping in both files

# Extract observations from the PRS profile that are also in the duration data
SZ_anti_duration <- profile[profile$ID1 %in% duration$eid, ] # 218 individuals with SZ overlapping in both files


###################
# Boxplot for distinct drugs vs PRS (including sample size)
###################

sample_size <- merge(SZ_anti_PRS, counts, by.x = "ID1", by.y = "ID") %>%
  group_by(distinct_drugs) %>%
  summarise(sample_size = n())

# Create combined labels with original labels and sample sizes
combined_labels4 <- paste0(levels(factor(counts$distinct_drugs)), "\n", "n=", sample_size$sample_size)

# Plotting

p4 <- ggplot(data = merge(SZ_anti_PRS, counts, by.x = "ID1", by.y = "ID"), 
       aes(x = as.factor(distinct_drugs), y = Profile_1)) +
  geom_boxplot() +
  scale_x_discrete(labels = combined_labels4) +  # Add combined labels with sample sizes below x-axis labels
  ylab("PRS") +
  xlab("Distinct Prescriptions") +
  theme(axis.text = element_text(size = 12), axis.title = element_text(size = 14)) +
  ggtitle("D. Distinct Prescriptions vs PRS") +
  theme(plot.title = element_text(size = 16, face = "bold")) +
  theme_bw()


###################
# Boxplot for total prescriptions vs PRS
###################
sample_size <- merge(SZ_anti_PRS, counts, by.x = "ID1", by.y = "ID") %>%
  group_by(total_prescriptions) %>%
  summarise(sample_size = n())

# Create combined labels with original labels and sample sizes
combined_labels3 <- paste0(levels(factor(counts$total_prescriptions)), "\n", "n=", sample_size$sample_size)

# Plotting
p3 <- ggplot(data = merge(SZ_anti_PRS, counts, by.x = "ID1", by.y = "ID"), 
       aes(x = as.factor(total_prescriptions), y = Profile_1)) +
  geom_boxplot() +
  scale_x_discrete(labels = combined_labels3) +  # Add combined labels with sample sizes below x-axis labels
  ylab("PRS") +
  xlab("Total Prescriptions") +
  theme(axis.text = element_text(size = 12), axis.title = element_text(size = 14)) +
  ggtitle("C. Total Prescriptions vs PRS") +
  theme(plot.title = element_text(size = 16, face = "bold")) +
  theme_bw()


###################
# Boxplot for Clozapine prescribed vs PRS
###################
sample_size <- merge(SZ_anti_PRS, counts, by.x = "ID1", by.y = "ID") %>%
  group_by(Clozapine_prescribed) %>%
  summarise(sample_size = n())

# Create combined labels with original labels and sample sizes
combined_labels2 <- paste0(levels(factor(counts$Clozapine_prescribed)), "\n", "n=", sample_size$sample_size)

# Plotting
p2 <- ggplot(data = merge(SZ_anti_PRS, counts, by.x = "ID1", by.y = "ID"), 
       aes(x = as.factor(Clozapine_prescribed), y = Profile_1)) +
  geom_boxplot() +
  scale_x_discrete(labels = combined_labels2) +  # Add combined labels with sample sizes below x-axis labels
  ylab("PRS") +
  xlab("Clozapine Prescribed") +
  theme(axis.text = element_text(size = 12), axis.title = element_text(size = 14)) +
  ggtitle("B. Clozapine Prescribed vs PRS") +
  theme(plot.title = element_text(size = 16, face = "bold")) +
  theme_bw()

######################################
# Duration of prescription vs PRS

# Load the duration data
SZ_anti_duration <- profile[profile$ID1 %in% duration$eid, ] # 218 individuals with SZ overlapping in both files

plot(duration$duration, SZ_anti_duration$Profile_1)


data <- data.frame(duration = duration$duration, Profile_1 = SZ_anti_duration$Profile_1)

# Plotting
ggplot(data, aes(x = Profile_1, y = duration)) +
  geom_point() +  # Add points
  labs(x = "Duration", y = "Profile_1") +   # Labels for x and y axes
  theme_bw()

############################################
# Patients with prescription data vs PRS
############################################

SZ_PRS_anti_patients <- profile[profile$ID1 %in% patients$ID, ] # 218 individuals with SZ overlapping in both files

# I want a boxplot with PRS on the y-axis and a binary variable on the x-axis indicating whether the individual has prescription data available or not.

# Number of samples for each group
sample_counts <- merge(SZ_PRS_anti_patients, patients, by.x = "ID1", by.y = "ID") %>%
  group_by(prescription) %>%
  summarise(N = n())

# Merged labels with original labels and sample sizes
combined_labels1 <- paste0(levels(factor(patients$prescription)), "\n", "n=", sample_counts$N)

# Plotting
p1 <- ggplot(data = merge(SZ_PRS_anti_patients, patients, by.x = "ID1", by.y = "ID"), 
       aes(x = as.factor(prescription), y = Profile_1)) +
  geom_boxplot() +
  scale_x_discrete(labels = combined_labels1) +  # Add combined labels with sample sizes below x-axis labels
  ylab("PRS") +
  xlab("Prescription of antipsychotics") +
  theme(axis.text = element_text(size = 12), axis.title = element_text(size = 14)) +
  ggtitle("A. Antipsychotics Prescription vs PRS") +
  theme(plot.title = element_text(size = 16, face = "bold")) +
  theme_bw()

patch <- p1 + p2 + plot_layout(axis_titles = "collect")
patch2 <- p3 + p4 + plot_layout(ncol = 1)
patch / (p3 + p4 + plot_layout(ncol = 1))

patch / p3 / p4

patch + (p3 / p4) + plot_layout(ncol = 1)

patch / (p3 + plot_layout(ncol = 1, heights = c(2,1))) / (p4 + plot_layout(ncol = 1, heights = c(2,1)))

##########################################################################################################





###################################
# Other tests
###################################
# Prescription vs PRS
sz_pre <- merge(SZ_PRS_anti_patients, patients, by.x = "ID1", by.y = "ID")
prescription_PRS <- sz_pre$Profile_1[which(sz_pre$prescription == 1)]
no_prescription_PRS <- sz_pre$Profile_1[which(sz_pre$prescription == 0)]
t.test(prescription_PRS, no_prescription_PRS)

# Duration
SZ_anti_duration <- profile[profile$ID1 %in% duration$eid, ] # 218 individuals with SZ overlapping in both files
data <- data.frame(duration = duration$duration, Profile_1 = SZ_anti_duration$Profile_1)

# Check normal distribution
shapiro.test(data$duration) # not normal (p < 0.05)
shapiro.test(data$Profile_1) # normal (p > 0.05)

# Visual inspection of normality
hist(data$duration)


# Data not normal, use Spearman correlation
cor.test(data$Profile_1, data$duration, method = "spearman")

model <- glm(data$duration ~ data$Profile_1)
summary(model)

# Plot the models regression line on the scatter plot

ggplot(data, aes(x = Profile_1, y = duration)) +
  geom_point() +  # Add points
  geom_line(aes(y = predict(model, data)), color = "red") +  # Add regression line
  labs(x = "PRS Schizophrenia", y = "Duration [Days]") +
  theme_bw()

#####################
# Clozapine
SZ_anti_PRS <- profile[profile$ID1 %in% counts$ID, ] # 218 individuals with SZ overlapping in both files

data <- merge(SZ_anti_PRS, counts, by.x = "ID1", by.y = "ID")
t.test(data$Profile_1 ~ data$Clozapine_prescribed)

#####################
# Prescription counts

SZ_anti_PRS <- profile[profile$ID1 %in% counts$ID, ] # 218 individuals with SZ overlapping in both files

data <- merge(SZ_anti_PRS, counts, by.x = "ID1", by.y = "ID")
summary(data)

cor.test(data$Profile_1, data$total_prescriptions, method = "pearson")
cor.test(data$Profile_1, data$distinct_drugs, method = "pearson")
one.way <- aov(Profile_1 ~ total_prescriptions, data = data)
summary(one.way)
