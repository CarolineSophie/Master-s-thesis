____________________________________________________
### R ###
____________________________________________________
conda activate caroline # Activate conda environment in GenomeDK

R # Open R in conda environment

# Load the extracted data into R

library(data.table)
data <- fread("/home/caroline/dsmwpred/caroline/projects/prescription_2/extracted_data.txt")

# Check head of data
head(data)

# Give header names
colnames(data) <- c("eid", "data_provider", "issue_date", "read_2", "bnf_code", "dmd_code", "drug_name", "quantity")

# Define the medication names
medication_names <- antipsychotic_drugs <- c("Acetophenazine",
                         "Amisulpride",
                         "Aripiprazole",
                         "Asenapine",
                         "Benperidol",
                         "Blonanserin",
                         "Brexpiprazole",
                         "Bromperidol",
                         "Butaperazine",
                         "Cariprazine",
                         "Chlorproethazine",
                         "Chlorpromazine",
                         "Chlorprothixene",
                         "Clocapramine",
                         "Clopenthixol",
                         "Clotiapine",
                         "Clozapine",
                         "Cyamemazine",
                         "Dixyrazine",
                         "Droperidol",
                         "Fluanisone",
                         "Flupenthixol",
                         "Flupentixol",
                         "Fluphenazine",
                         "Fluspirilene",
                         "Haloperidol",
                         "Iloperidone",
                         "Levomepromazine",
                         "Loxapine",
                         "Lumateperone",
                         "Lurasidone",
                         "Melperone",
                         "Molindone",
                         "Moperone",
                         "Mosapramine ",
                         "Nemonapride",
                         "Olanzapine",
                         "Oxypertine",
                         "Paliperidone",
                         "Penfluridol ",
                         "Perazine",
                         "Periciazine",
                         "Perospirone",
                         "Perphenazine",
                         "Phenothiazine",
                         "Pimavanserin",
                         "Pimozide",
                         "Pipamperone",
                         "Piperacetazine",
                         "Pipoptiazine",
                         "Prochlorperazine",
                         "Promazine",
                         "Propericiazine",
                         "Quetiapine",
                         "Risperidone",
                         "Sertindole",
                         "Sulforidazine",
                         "Sulpiride",
                         "Sultopride",
                         "Thiopropazate",
                         "Thioproperazine",
                         "Thioridazine",
                         "Thiothixene",
                         "Tiapride",
                         "Timiperone",
                         "Trifluoperazine",
                         "Trifluperidol",
                         "Triflupromazine",
                         "Ziprasidone ",
                         "Zotepine ",
                         "Zuclopenthixol")

# Filter rows based on conditions
condition1 <- grepl("^04\\.02|^0402", data$bnf_code) # Any line that starts with 04.02 or 0402 in the bnf_code column
condition2 <- grepl(paste(medication_names, collapse = "|"), data$drug_name) # Any line that contains any of the medication names in the drug_name column

# Length of conditions
length(which(condition1 == TRUE))
# [1] 26907
length(which(condition2 == TRUE))
# [1] 23868

# Combine conditions into a new data frame
filtered_data <- data[condition1 | condition2, ] # Any line that meets either condition1 or condition2

dim(filtered_data) # Check dimensions of the new data frame
# [1] 30848     8

# Write the result to a new file
write.table(filtered_data, file = "//home/caroline/dsmwpred/caroline/projects/prescription_2/sz_filtered.txt", 
            sep = "\t", col.names = TRUE, row.names = FALSE)


# Load the filtered data into R
data <- fread("/home/caroline/dsmwpred/caroline/projects/prescription_2/sz_filtered.txt")


# Check head of data
head(data)



###############################
# I want a data set that includes all the sz individuals that also have prescription data available. Then I want them to have either 1 for prescription or 0 for no prescription.
###############################
all_sz <- fread("/home/caroline/dsmwpred/caroline/projects/prescription_2/extracted_data.txt")
anti_pre <- fread("/home/caroline/dsmwpred/caroline/projects/prescription_2/sz_filtered.txt")

# all overlaps between the two data sets gets 1, the rest gets 0
# I want to create a new dataset called patients with all ids from all_sz
# Then I want to add a column with 1 for all ids that are in anti_pre and 0 for the rest

# Create a new data frame with the IDs from all_sz
patients <- data.frame(unique(all_sz$V1)) # Create a data frame with the unique IDs from all_sz
colnames(patients) <- "ID" # Rename the column to "ID"

# Add a new column to the data frame indicating whether the ID is in anti_pre
patients$prescription <- as.integer(patients$ID %in% anti_pre$eid)

# Check - count 1 and 0
table(patients$prescription)
dim(patients)

# write the result to a new text file
write.table(patients, file = "/home/caroline/dsmwpred/caroline/projects/prescription_2/patients.txt", sep = "\t", 
                    row.names = FALSE,  quote = FALSE)

____________________________________________________________

############################################################
# Create a column with the name and dosage of the medication
############################################################
____________________________________________________________

df <- data

# Extract the name using grep
df$drug <- regmatches(df$drug_name, regexpr("^[A-Za-z]+(?: [A-Za-z]+)?", df$drug_name)) # This line extracts the name of the medication
# "^[A-Za-z]+(?: [A-Za-z]+)?" is a regular expression that matches any string that starts with one or more letters, followed by an optional space and one or more letters

df$dosage <- sub(".*?(\\d+\\.?\\d*).*", "\\1", df$drug_name) # This line extracts the dosage of the medication
# ".*?(\\d+\\.?\\d*).*" is a regular expression that matches any string that starts with zero or more characters, followed by one or more digits, followed by an optional dot and zero or more digits, followed by zero or more characters

# Convert non-numeric dosages to NA
df$dosage[!grepl("\\d", df$dosage)] <- NA # This line converts non-numeric dosages to NA

# Check results
head(df)
____________________________________________________________

############################################################
# Clean up the data per individual
############################################################
____________________________________________________________

# Convert date strings to Date objects
df$issue_date <- as.Date(df$issue_date, format = "%d/%m/%Y")

# I want to count the difference between the first and last prescription date for each individual
duration <- df %>%
  group_by(eid) %>%
  summarize(
    start = min(issue_date),
    latest = max(issue_date),
    duration = as.numeric(difftime(max(issue_date), min(issue_date), units = "days"))
  )
# Write the result to a new text file
write.table(duration, file = "/home/caroline/dsmwpred/caroline/projects/prescription_2/duration.txt", sep = "\t", row.names = FALSE)



# Group the data by ID and drug
library(dplyr)
cleaned_data <- df %>%
  group_by(eid, drug_name, drug, dosage, bnf_code) %>%
  summarize(
    start = min(issue_date),
    latest = max(issue_date),
    duration = as.numeric(difftime(max(issue_date), min(issue_date), units = "days"))
  ) %>%
  rename(
    ID = eid,
    drug_name = drug_name,
    bnf = bnf_code,
    drug = drug,
    dosage = dosage
  )

# Write the cleaned data to a new text file
write.table(cleaned_data, file = "/home/caroline/dsmwpred/caroline/projects/prescription_2/cleaned_data.txt", sep = "\t", row.names = FALSE)

# Load the cleaned data
cleaned_data <- read.delim("/home/caroline/dsmwpred/caroline/projects/prescription_2/cleaned_data.txt", sep ="\t", header = T)
head(cleaned_data)
____________________________________________________________

############################################################
# Make a new dataset based on the cleaned data with prescription counts for each individual
############################################################
____________________________________________________________

# Load the cleaned data into R
cleaned_data <- read.delim("/home/caroline/dsmwpred/caroline/projects/prescriptions/cleaned_data.txt", sep ="\t", header = T)
head(cleaned_data)

# Add a new column indicating whether Clozapine was prescribed
cleaned_data <- cleaned_data %>%
  mutate(Clozapine_prescribed = as.integer(drug == "Clozapine"))

# Group by ID and count the number of prescriptions, and distinct drugs
prescription_counts <- cleaned_data %>%
  group_by(ID) %>%
  summarize(
    total_prescriptions = n(),
    distinct_drugs = n_distinct(drug),
    Clozapine_prescribed = max(Clozapine_prescribed)  # Take the max value (1 if any prescription is Clozapine, 0 otherwise)
  )
# Print the result
prescription_counts

# Write the result to a new text file
write.table(prescription_counts, file = "/home/caroline/dsmwpred/caroline/projects/prescription_2/counts.txt", sep = "\t", row.names = FALSE)

____________________________________________________________

############################################################
# Explore prescription counts and correlation with PRS
############################################################
____________________________________________________________

# Load the prescription counts
counts <- read.delim("/home/caroline/dsmwpred/caroline/projects/prescription_2/counts.txt", sep = "\t", header = T)

# Load the duration data
duration <- read.delim("/home/caroline/dsmwpred/caroline/projects/prescription_2/duration.txt", sep = "\t", header = T)

# Load the patient data
patients <- read.delim("/home/caroline/dsmwpred/caroline/projects/prescription_2/patients.txt", sep = "\t", header = T)

# Load the PRS profile
profile <- read.delim("/home/caroline/test.mega_edit_2.profile", header = T, sep = "\t")
# Extract observations from the PRS profile that are also in the prescription counts
SZ_anti_PRS <- profile[profile$ID1 %in% counts$ID, ] # 218 individuals with SZ overlapping in both files

# Extract observations from the PRS profile that are also in the duration data
SZ_anti_duration <- profile[profile$ID1 %in% duration$eid, ] # 218 individuals with SZ overlapping in both files

# load libraries
library(dplyr)

###################
# Boxplot for distinct drugs vs PRS (including sample size)
###################
width <- 10  # Width in inches
height <- 6  # Height in inches

sample_size <- merge(SZ_anti_PRS, counts, by.x = "ID1", by.y = "ID") %>%
  group_by(distinct_drugs) %>%
  summarise(sample_size = n())

# Create combined labels with original labels and sample sizes
combined_labels <- paste0(levels(factor(counts$distinct_drugs)), "\n", "n=", sample_size$sample_size)

# Plotting
# Plotting with adjusted dimensions
png('/home/caroline/dsmwpred/caroline/projects/prescription_2/plots/distinct_drugs_may8.png', width = width, height = height, units = "in", res = 300)

ggplot(data = merge(SZ_anti_PRS, counts, by.x = "ID1", by.y = "ID"), 
       aes(x = as.factor(distinct_drugs), y = Profile_1)) +
  geom_boxplot() +
  scale_x_discrete(labels = combined_labels) +  # Add combined labels with sample sizes below x-axis labels
  ylab("PRS") +
  xlab("Distinct Prescriptions") +
  theme(axis.text = element_text(size = 12), axis.title = element_text(size = 14)) +
  ggtitle("Distinct Prescriptions vs PRS") +
  theme(plot.title = element_text(size = 16, face = "bold"))
dev.off()

###################
# Boxplot for total prescriptions vs PRS
###################
sample_size <- merge(SZ_anti_PRS, counts, by.x = "ID1", by.y = "ID") %>%
  group_by(total_prescriptions) %>%
  summarise(sample_size = n())

# Create combined labels with original labels and sample sizes
combined_labels <- paste0(levels(factor(counts$total_prescriptions)), "\n", "n=", sample_size$sample_size)

# Plotting
png('/home/caroline/dsmwpred/caroline/projects/prescription_2/plots/total_prescription_may8.png', width = width, height = height, units = "in", res = 300)
ggplot(data = merge(SZ_anti_PRS, counts, by.x = "ID1", by.y = "ID"), 
       aes(x = as.factor(total_prescriptions), y = Profile_1)) +
  geom_boxplot() +
  scale_x_discrete(labels = combined_labels) +  # Add combined labels with sample sizes below x-axis labels
  ylab("PRS") +
  xlab("Total Prescriptions") +
  theme(axis.text = element_text(size = 12), axis.title = element_text(size = 14)) +
  ggtitle("Total Prescriptions vs PRS") +
  theme(plot.title = element_text(size = 16, face = "bold"))
dev.off()

###################
# Boxplot for Clozapine prescribed vs PRS
###################
sample_size <- merge(SZ_anti_PRS, counts, by.x = "ID1", by.y = "ID") %>%
  group_by(Clozapine_prescribed) %>%
  summarise(sample_size = n())

# Create combined labels with original labels and sample sizes
combined_labels <- paste0(levels(factor(counts$Clozapine_prescribed)), "\n", "n=", sample_size$sample_size)

# Plotting
png('/home/caroline/dsmwpred/caroline/projects/prescription_2/plots/Clozapine_prescribed_may8.png', width = width, height = height, units = "in", res = 300)
ggplot(data = merge(SZ_anti_PRS, counts, by.x = "ID1", by.y = "ID"), 
       aes(x = as.factor(Clozapine_prescribed), y = Profile_1)) +
  geom_boxplot() +
  scale_x_discrete(labels = combined_labels) +  # Add combined labels with sample sizes below x-axis labels
  ylab("PRS") +
  xlab("Clozapine Prescribed") +
  theme(axis.text = element_text(size = 12), axis.title = element_text(size = 14)) +
  ggtitle("Clozapine Prescribed vs PRS") +
  theme(plot.title = element_text(size = 16, face = "bold"))
dev.off()


######################################
# Duration of prescription vs PRS

# Load the duration data
duration <- read.delim("/home/caroline/dsmwpred/caroline/projects/prescription_2/duration.txt", sep = "\t", header = T)
SZ_anti_duration <- profile[profile$ID1 %in% duration$eid, ] # 218 individuals with SZ overlapping in both files

png('/home/caroline/dsmwpred/caroline/projects/prescription_2/plots/duration.png')
plot(duration$duration, SZ_anti_duration$Profile_1)
dev.off()


data <- data.frame(duration = duration$duration, Profile_1 = SZ_anti_duration$Profile_1)

# Plotting
png('/home/caroline/dsmwpred/caroline/projects/prescription_2/plots/duration.png')
ggplot(data, aes(x = Profile_1, y = duration)) +
  geom_point() +  # Add points
  labs(x = "Duration", y = "Profile_1")   # Labels for x and y axes
dev.off()


############################################
# Patients with prescription data vs PRS
############################################

patients <- read.delim("/home/caroline/dsmwpred/caroline/projects/prescription_2/patients.txt", sep = "\t", header = T)

SZ_PRS_anti_patients <- profile[profile$ID1 %in% patients$ID, ] # 218 individuals with SZ overlapping in both files


# I want a boxplot with PRS on the y-axis and a binary variable on the x-axis indicating whether the individual has prescription data available or not.

png('/home/caroline/dsmwpred/caroline/projects/prescription_2/plots/patients.png')

# Number of samples for each group
sample_counts <- merge(SZ_PRS_anti_patients, patients, by.x = "ID1", by.y = "ID") %>%
  group_by(prescription) %>%
  summarise(N = n())

# Merged labels with original labels and sample sizes
combined_labels <- paste0(levels(factor(patients$prescription)), "\n", "n=", sample_counts$N)

# Plotting
ggplot(data = merge(SZ_PRS_anti_patients, patients, by.x = "ID1", by.y = "ID"), 
       aes(x = as.factor(prescription), y = Profile_1)) +
  geom_boxplot() +
  scale_x_discrete(labels = combined_labels) +  # Add combined labels with sample sizes below x-axis labels
  ylab("PRS") +
  xlab("Prescription Data Available") +
  theme(axis.text = element_text(size = 12), axis.title = element_text(size = 14)) +
  ggtitle("Prescription Data Available vs PRS") +
  theme(plot.title = element_text(size = 16, face = "bold"))
dev.off()


##########################################################################################################





###################################
# Other tests
###################################
# Load R on genomeDK

conda activate caroline
R

# Load libraries
library(data.table)
library(dplyr)
library(ggplot2)

# Load data
counts <- read.delim("/home/caroline/dsmwpred/caroline/projects/prescription_2/counts.txt", sep = "\t", header = T)
patients <- read.delim("/home/caroline/dsmwpred/caroline/projects/prescription_2/patients.txt", sep = "\t", header = T)
duration <- read.delim("/home/caroline/dsmwpred/caroline/projects/prescription_2/duration.txt", sep = "\t", header = T)

profile <- read.delim("/home/caroline/test.mega_edit_2.profile", header = T, sep = "\t")

####################
# Duration
SZ_anti_duration <- profile[profile$ID1 %in% duration$eid, ] # 218 individuals with SZ overlapping in both files
data <- data.frame(duration = duration$duration, Profile_1 = SZ_anti_duration$Profile_1)

# Check normal distribution
shapiro.test(data$duration) # not normal (p < 0.05)
shapiro.test(data$Profile_1) # normal (p > 0.05)

# Visual inspection of normality
png('/home/caroline/dsmwpred/caroline/projects/prescription_2/plots/duration_hist.png')
hist(data$duration)
dev.off()

# Data not normal, use Spearman correlation
cor.test(data$Profile_1, data$duration, method = "spearman")

model <- glm(data$duration ~ data$Profile_1)
summary(model)

# Plot the models regression line on the scatter plot
png('/home/caroline/dsmwpred/caroline/projects/prescription_2/plots/duration.png')
ggplot(data, aes(x = Profile_1, y = duration)) +
  geom_point() +  # Add points
  geom_line(aes(y = predict(model, data)), color = "red") +  # Add regression line
  labs(x = "PRS Schizophrenia", y = "Duration [Days]")   # Labels for x and y axes
dev.off()

#####################
# Clozapine
SZ_anti_PRS <- profile[profile$ID1 %in% counts$ID, ] # 218 individuals with SZ overlapping in both files

data <- merge(SZ_anti_PRS, counts, by.x = "ID1", by.y = "ID")
t.test(data$Profile_1 ~ data$Clozapine_prescribed)

#####################
# Prescription counts
library(ggplot2)
library(ggpubr)
library(tidyverse)
library(broom)
library(AICcmodavg)

counts <- read.delim("/home/caroline/dsmwpred/caroline/projects/prescription_2/counts.txt", sep = "\t", header = T)
patients <- read.delim("/home/caroline/dsmwpred/caroline/projects/prescription_2/patients.txt", sep = "\t", header = T)
duration <- read.delim("/home/caroline/dsmwpred/caroline/projects/prescription_2/duration.txt", sep = "\t", header = T)

profile <- read.delim("/home/caroline/test.mega_edit_2.profile", header = T, sep = "\t")
SZ_anti_PRS <- profile[profile$ID1 %in% counts$ID, ] # 218 individuals with SZ overlapping in both files

data <- merge(SZ_anti_PRS, counts, by.x = "ID1", by.y = "ID")
summary(data)

one.way <- aov(Profile_1 ~ total_prescriptions, data = data)

summary(one.way)



#################################




# Extract observations from the PRS profile that are also in the prescription counts
SZ_anti_PRS <- profile[profile$ID1 %in% counts$ID, ]

cor(SZ_anti_PRS$ID1, counts$total_prescriptions)
# [1] -0.05422968

cor.test(SZ_anti_PRS$Profile_1, counts$total_prescriptions)
cor.test(SZ_anti_PRS$Profile_1, counts$total_prescriptions, method = "spearman")

cor.test(SZ_anti_PRS$Profile_1, counts$distinct_drugs)
cor.test(SZ_anti_PRS$Profile_1, counts$distinct_drugs, method = "spearman")

cor.test(SZ_anti_PRS$Profile_1, counts$Clozapine_prescribed)
cor.test(counts$distinct_drugs, counts$Clozapine_prescribed)
cor.test(counts$total_prescriptions, counts$Clozapine_prescribed)



cor.test(SZ_anti_PRS$Profile_1, counts$Clozapine_prescribed, method = "spearman")






____________________________________________________
# Load the cleaned data into R
cleaned_data <- read.delim("/home/caroline/dsmwpred/caroline/projects/prescriptions/cleaned_data.txt", sep ="\t", header = T)
head(cleaned_data)

df <- cleaned_data

# Extract the name using grep
df$drug_name <- regmatches(df$drug, regexpr("^[A-Za-z]+(?: [A-Za-z]+)?", df$drug))

df$dosage <- sub(".*?(\\d+\\.?\\d*).*", "\\1", df$drug)

# Convert non-numeric dosages to NA
df$dosage[!grepl("\\d", df$dosage)] <- NA

# Display the result
print(df)



# found the line that was giving an error
# df[df$drug=="quetiapine starter pack",]

____________________________________________________

index_no_numbers <- grep("^[^0-9]*$", df$drug)


index_starting_with_dot <- grep("^\\.[0-9]+", df$drug)

# Display the index
print(index_starting_with_dot)


regmatches(df$drug, regexpr("\\d+\\.\\d+", df$drug))

index_with_dot_in_digit <- grep("\\d+\\.\\d+", df$drug)

# Display the index
print(index_with_dot_in_digit)

print(df$drug[index_with_dot_in_digit])




index_starting_with_digit_dot <- grep("^\\d\\.", df$drug)

# Display the index
print(index_starting_with_digit_dot)

index_without_digit <- grep("\\D", df$drug, invert = TRUE)
print(df[index_without_digit])


dosage_matches <- regmatches(df$drug, regexpr("\\d+", df$drug))
df$Dosage <- as.numeric(sapply(dosage_matches, function(x) ifelse(length(x) > 0, x, NA)))


# Display the result
print(df)
____________________________________________________


