# Data path
/home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt
/home/caroline/snpher/faststorage/biobank/newphens/gp_clinical.txt
/home/caroline/snpher/faststorage/biobank/newphens/gp_registrations.txt

# Get SZ case individuals from the PRS file

# Path for the PRS profile file with the individuals 
/home/caroline/mega_F20.profile

awk '$3 == 1' /home/caroline/mega_F20.profile | wc -l
# I have 704 individuals with SZ in UKBB data (white and QCed data from geno2 file)

# Create a new file with only the SZ cases from the profile file
awk 'NR == 1; $3 == 1' /home/caroline/mega_F20.profile > /home/caroline/dsmwpred/caroline/projects/prescriptions/SZ_cases.txt

# Now I want to reduce the gp_scripts file to only include the individuals in the SZ_cases.txt file
awk 'FNR==NR {ids[$1]; next} $1 in ids' /home/caroline/dsmwpred/caroline/projects/prescriptions/SZ_cases.txt /home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt > /home/caroline/dsmwpred/caroline/projects/prescriptions/extracted_data.txt


# Want to make sure I have the data from all cases so I am counting the number of unique individuals (based on ID) in the extracted data file
cut -f 1 /home/caroline/dsmwpred/caroline/projects/prescriptions/extracted_data.txt | sort | uniq | wc -l
# 283 individuals

____________________________________________________
# For comparison I want to check the other files also:

cut -f 1 /home/caroline/dsmwpred/caroline/projects/prescriptions/SZ_cases.txt | sort | uniq | wc -l
# 704 occurrences of individuals in the SZ_cases.txt file (705 including the header)

cut -f 1 /home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt | sort | uniq | wc -l
# 222065 individuals - so not all idividuals have prescription data (222066 including the header)

cut -f 1 /home/caroline/mega_F20.profile | sort | uniq | wc -l
# 392214 individuals (392215 including the header)
____________________________________________________


# Now I want a list of all medications that are prescribed to the individuals in the SZ_cases.txt file
cut -f 7 /home/caroline/dsmwpred/caroline/projects/prescription_2/extracted_data.txt | sort | uniq | wc -l
# 3353 unique medications
cut -f 7 /home/caroline/dsmwpred/caroline/projects/prescription_2/extracted_data.txt | sort | uniq > /home/caroline/dsmwpred/caroline/projects/prescription_2/medications.txt


____________________________________________________
awk -F'\t' '$5 ~ /^(04\.02|0402)/' /home/caroline/dsmwpred/caroline/projects/prescription_2/extracted_data.txt > /home/caroline/dsmwpred/caroline/projects/prescription_2/sz_antipsychotics.txt
# I am using this line of code to extract the SZ antipsychotics from the extracted_data.txt file

cut -f 1 /home/caroline/dsmwpred/caroline/projects/prescription_2/sz_antipsychotics.txt | sort | uniq | wc -l
# 196 individuals are lefr with antipsychotics (197 including the header)

cut -f 7 /home/caroline/dsmwpred/caroline/projects/prescription_2/sz_antipsychotics.txt | sort | uniq > /home/caroline/dsmwpred/caroline/projects/prescription_2/sz_antipsychotics_names.txt


# This individual is weird
# 1123427	


____________________________________________________
### R ###
____________________________________________________
conda activate caroline # Activate conda environment in GenomeDK

R # Open R in conda environment

# Load the extracted data into R
data <- read.table("/home/caroline/dsmwpred/caroline/projects/prescriptions/extracted_data.txt", 
                    sep = "\t", header = FALSE, fill = TRUE, na.strings = "")
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
# [1] 21329

# Combine conditions into a new data frame
filtered_data <- data[condition1 | condition2, ] # Any line that meets either condition1 or condition2

dim(filtered_data) # Check dimensions of the new data frame
# [1] 30582     8

# Write the result to a new file
write.table(filtered_data, file = "/home/caroline/dsmwpred/caroline/projects/prescriptions/sz_filtered.txt", 
            sep = "\t", col.names = TRUE, row.names = FALSE)


# Load the filtered data into R
data <- read.table("/home/caroline/dsmwpred/caroline/projects/prescriptions/sz_filtered.txt", 
                    sep = "\t", header = TRUE, fill = TRUE, na.strings = "")

# Check head of data
head(data)

unique(counts$ID)[!((unique(counts$ID)) %in% (unique(cleaned_data$ID)))]
[1] 2363309 2591046
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
write.table(cleaned_data, file = "/home/caroline/dsmwpred/caroline/projects/prescriptions/cleaned_data.txt", sep = "\t", row.names = FALSE)

# Load the cleaned data
cleaned_data <- read.delim("/home/caroline/dsmwpred/caroline/projects/prescriptions/cleaned_data.txt", sep ="\t", header = T)
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
    Clozapine_prescribed = max(clozapine_prescribed)  # Take the max value (1 if any prescription is Clozapine, 0 otherwise)
  )
# Print the result
prescription_counts

# Write the result to a new text file
write.table(prescription_counts, file = "/home/caroline/dsmwpred/caroline/projects/prescriptions/counts.txt", sep = "\t", row.names = FALSE)

____________________________________________________________

############################################################
# Explore prescription counts and correlation with PRS
############################################################
____________________________________________________________

# Load the prescription counts
counts <- read.delim("/home/caroline/dsmwpred/caroline/projects/prescriptions/counts.txt", sep = "\t", header = T)

# Load the PRS profile
profile <- read.delim("/home/caroline/test.mega_edit_2.profile", header = T, sep = "\t")
# Extract observations from the PRS profile that are also in the prescription counts
SZ_PRS <- profile[profile$ID1 %in% counts$ID, ] # 216 individuals with SZ overlapping in both files


library(ggplot2)

png('total_prescription_may8.png')
plot(counts$total_prescriptions, SZ_PRS$Profile_1)
dev.off()

png('distinct_drugs_may8.png')
plot(counts$distinct_drugs, SZ_PRS$Profile_1)
dev.off()

boxplot(SZ_PRS$Profile_1 ~ counts$Clozapine_prescribed, ylab = "PRS")

png('Clozapine_prescribed_may8.png')
ggplot(data = merge(SZ_PRS, counts, by.x = "ID1", by.y = "ID"), 
       aes(x = as.factor(Clozapine_prescribed), y = Profile_1)) +
  geom_boxplot() +
  ylab("PRS") +
  xlab("Clozapine Prescribed") +
  theme(axis.text = element_text(size = 12), axis.title = element_text(size = 14)) +
  ggtitle("Clozapine Prescribed vs PRS") +
  theme(plot.title = element_text(size = 16, face = "bold"))
dev.off()

png('distinct_drugs_may8.png')
ggplot(data = merge(SZ_PRS, counts, by.x = "ID1", by.y = "ID"), 
       aes(x = as.factor(distinct_drugs), y = Profile_1)) +
  geom_boxplot() +
  ylab("PRS") +
  xlab("Distinct Prescriptions") +
  theme(axis.text = element_text(size = 12), axis.title = element_text(size = 14)) +
  ggtitle("Distinct Prescriptions vs PRS") +
  theme(plot.title = element_text(size = 16, face = "bold"))
dev.off()

png('total_prescription_may8.png')
ggplot(data = merge(SZ_PRS, counts, by.x = "ID1", by.y = "ID"), 
       aes(x = as.factor(total_prescriptions), y = Profile_1)) +
  geom_boxplot() +
  ylab("PRS") +
  xlab("Total Prescriptions") +
  theme(axis.text = element_text(size = 12), axis.title = element_text(size = 14)) +
  ggtitle("Total Prescriptions vs PRS") +
  theme(plot.title = element_text(size = 16, face = "bold"))
dev.off()



boxplot(SZ_PRS$Profile_1 ~ counts$Clozapine_prescribed, ylab = "PRS")
____________________________________________________

# Find individuals with the most prescriptions
prescription_counts %>%
  filter(total_prescriptions == max(total_prescriptions))
  #       ID total_prescriptions
  #  <int>               <int>
# 1 4275176                  22

# Write the result to a new text file
write.table(prescription_counts, file = "/home/caroline/dsmwpred/caroline/projects/prescriptions/counts.txt", sep = "\t", row.names = FALSE)

# Load the prescription counts
counts <- read.delim("/home/caroline/dsmwpred/caroline/projects/prescriptions/counts.txt", sep = "\t", header = T)
# Load the PRS profile
profile <- read.delim("/home/caroline/mega_F20.profile", header = T, sep = "\t")


# Extract observations from the PRS profile that are also in the prescription counts
SZ_PRS <- profile[profile$ID1 %in% counts$ID, ]

cor(SZ_PRS$ID1, counts$total_prescriptions)
# [1] -0.05422968

cor.test(SZ_PRS$Profile_1, counts$total_prescriptions)
cor.test(SZ_PRS$Profile_1, counts$total_prescriptions, method = "spearman")

cor.test(SZ_PRS$Profile_1, counts$distinct_drugs)
cor.test(SZ_PRS$Profile_1, counts$distinct_drugs, method = "spearman")

cor.test(SZ_PRS$Profile_1, counts$Clozapine_prescribed)
cor.test(counts$distinct_drugs, counts$Clozapine_prescribed)
cor.test(counts$total_prescriptions, counts$Clozapine_prescribed)



cor.test(SZ_PRS$Profile_1, counts$Clozapine_prescribed, method = "spearman")






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


