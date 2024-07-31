# Data paths
# Raw data files
/home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt
/home/caroline/snpher/faststorage/biobank/newphens/gp_clinical.txt
/home/caroline/snpher/faststorage/biobank/newphens/gp_registrations.txt

____________________________________________________

# I want a version of gp_scripts that only contain individuals in the geno2 file
# I want to use the geno2 file to extract the individuals

awk '{print $1}' /home/caroline/dsmwpred/data/ukbb/geno2.fam > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/ukbb_ids.txt
# Both files checked length - they match 392214
awk '{print $1}' /home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts_ids.txt
# Length check 54044764 and 54044765
awk 'NR==FNR{a[$1];next} ($1 in a)' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/ukbb_ids.txt /home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts_ids.txt > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts_ids2.txt
# Length of the output file 43175244

# I want a version of gp_script (all columns) that only contain individuals in the gp_scripts_ids2.txt file

awk 'NR==FNR {ids[$1]; next} $1 in ids' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts_ids2.txt /home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts2.txt
# Length of the output file 43175244 but without a header

# I want to add a header to the file /home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts2.txt
head -n 1 /home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt | cat - /home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts2.txt > temp
mv temp /home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts2.txt
rm temp

head /home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts2.txt
# Length 43175245 now including header
____________________________________________________
### Get information about the data files ###
____________________________________________________

# length of the files
wc -l /home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt
wc -l /home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts2.txt

# number of unique individuals
cut -f 1 /home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt | sort | uniq | wc -l # 213778
cut -f 1 /home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts2.txt | sort | uniq | wc -l # 170739
cut -f 1 /home/caroline/dsmwpred/caroline/data/UKBB_SZ/ukbb_ids.txt | sort | uniq | wc -l # 392214

____________________________________________________
### R ###
### Make sure the new prescription file has the right format ###
____________________________________________________
conda activate caroline # Activate conda environment in GenomeDK

R # Open R in conda environment

# Load the extracted data into R
data <- read.table("/home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts2.txt", 
                    sep = "\t", header = TRUE, fill = TRUE, na.strings = "")
length(data$eid)
# 20885423

ukbb_ids <- read.table("/home/caroline/dsmwpred/caroline/data/UKBB_SZ/ukbb_ids.txt", 
                    sep = "\t", header = FALSE, fill = TRUE, na.strings = "")
length(ukbb_ids$V1)
# 392214

gp_script <- read.table("/home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt", 
                    sep = "\t", header = TRUE, fill = TRUE, na.strings = "")
length(gp_script$eid)
# 26385110

gp_script_ids <- read.table("/home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts_ids.txt", 
                    sep = "\t", header = TRUE, fill = TRUE, na.strings = "")
length(gp_script_ids$eid)
# 54044764

# # Check head of data
# head(data)

# # Give header names
# colnames(data) <- c("eid", "data_provider", "issue_date", "read_2", "bnf_code", "dmd_code", "drug_name", "quantity")
# head(data)

# write.table(data, file = "/home/caroline/dsmwpred/caroline/data/geno2_prescriptions.txt", 
#             sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

____________________________________________________


____________________________________________________
### R ###
### Creating prescription data sets ###
____________________________________________________

# Check capilaization of the drug names - does it matter or not??


antipsychotic_drugs <- c("Amisulpride", "Aripiprazole", "Asenapine", "Brexpiprazole", "Cariprazine", "Chlorpromazine", 
                        "Chlorprothixene", "Clozapine", "Flupentixol", "Fluphenazine", "Haloperidol", "Iloperidone", 
                        "Levomepromazine", "Loxapine", "Lumateperone", "Lurasidone", "Melperone", "Molindone", 
                        "Olanzapine", "Paliperidone", "Periciazine", "Perphenazine", "Phenothiazine", "Pimavanserin", 
                        "Pimozide", "Pipamperone", "Prochlorperazine", "Quetiapine", "Risperidone", "Sertindole", 
                        "Sulpiride", "Thioridazine", "Thiothixene", "Trifluoperazine", "Ziprasidone", "Zuclopenthixol")

first_generation <- c("Chlorpromazine", "Chlorprothixene", "Flupentixol", "Fluphenazine", "Haloperidol", "Levomepromazine", 
                      "Loxapine", "Melperone", "Molindone", "Periciazine", "Perphenazine", "Phenothiazine", "Pimozide", 
                      "Pipamperone", "Prochlorperazine", "Sulpiride", "Thioridazine", "Thiothixene", "Trifluoperazine", 
                      "Zuclopenthixol")

second_generation <- c("Amisulpride", "Aripiprazole", "Asenapine", "Brexpiprazole", "Cariprazine", "Clozapine", 
                       "Iloperidone", "Lumateperone", "Lurasidone", "Olanzapine", "Paliperidone", "Pimavanserin", 
                       "Quetiapine", "Risperidone", "Sertindole", "Ziprasidone")


# Start by loading the data into R

data <- read.table("/home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts2.txt", 
                    sep = "\t", header = TRUE, fill = TRUE, na.strings = "")

length(data$eid) #20885423
length(unique(data$eid)) #82353

#data <- read.table("/home/caroline/dsmwpred/caroline/data/geno2_prescriptions.txt", 
                    #sep = "\t", header = TRUE, fill = TRUE, na.strings = "")

head(data) # Check the head of the data

# View the end of the data
tail(data) # This is problematic...



# Filter rows based on conditions
condition1 <- grepl("^04\\.02|^0402", data$bnf_code) # Any line that starts with 04.02 or 0402 in the bnf_code column
condition2 <- grepl(paste(antipsychotic_drugs, collapse = "|"), data$drug_name) # Any line that contains any of the medication names in the drug_name column

# Length of conditions
length(which(condition1 == TRUE))
# [1] 252533
length(which(condition2 == TRUE))
# [1] 161555

# Combine conditions into a new data frame
filtered_data <- data[condition1 | condition2, ] # Any line that meets either condition1 or condition2

dim(filtered_data) # Check dimensions of the new data frame
# [1] 281313      8

length(unique(filtered_data$eid))
# [1] 27836
# There are 27836 unique individuals in the filtered data - each with antispychotic medication

# Write the result to a new file
write.table(filtered_data, file = "/home/caroline/dsmwpred/caroline/projects/prescriptions/antipsychotics_prescription_geno2.txt", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

#_______________________________________________________________________________________________________________________________________________________________________________________
# Now I only want 1st or 2nd generation antipsychotics

# Filter rows based on condition
condition_first <- grepl(paste(first_generation, collapse = "|"), data$drug_name) # Any line that contains any of the medication names in the drug_name column
condition_second <- grepl(paste(second_generation, collapse = "|"), data$drug_name) # Any line that contains any of the medication names in the drug_name column

# Length of condition
length(which(condition_first == TRUE))
# 91910
length(which(condition_second == TRUE))
# 69647


# Combine condition into a new data frame
first_data <- data[condition_first, ] # Any line that meets the condition
second_data <- data[condition_second, ] # Any line that meets the condition

# Check dimensions of the new data frame
dim(first_data)
dim(second_data)

# Check number of unique individuals
length(unique(first_data$eid))
# 23795
length(unique(second_data$eid))
# 1448

# Write the result to a new file
write.table(first_data, file = "/home/caroline/dsmwpred/caroline/projects/prescriptions/first_gen_antipsychotics_geno2.txt", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

write.table(second_data, file = "/home/caroline/dsmwpred/caroline/projects/prescriptions/second_gen_antipsychotics_geno2.txt",
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

#_______________________________________________________________________________________________________________________________________________________________________________________

# I want to check whether any individuals have been prescribed both first and second generation antipsychotics
# I will use the first_data and second_data files

# Load the data into R
first_data <- read.table("/home/caroline/dsmwpred/caroline/projects/prescriptions/first_gen_antipsychotics_geno2.txt", 
                    sep = "\t", header = TRUE, fill = TRUE, na.strings = "")

second_data <- read.table("/home/caroline/dsmwpred/caroline/projects/prescriptions/second_gen_antipsychotics_geno2.txt",
                    sep = "\t", header = TRUE, fill = TRUE, na.strings = "")

# I want to find the unique individuals in the first_data file
first_individuals <- unique(first_data$eid)

# I want to find the unique individuals in the second_data file
second_individuals <- unique(second_data$eid)

# I want to find the individuals that are in both the first_data and second_data files
both_individuals <- intersect(first_individuals, second_individuals)

# Write new files with only the individuals that are in both the first_data and second_data files
both_gens <- data[data$eid %in% both_individuals, ]
length(unique(both_gens$eid))

write.table(both_gens, file = "/home/caroline/dsmwpred/caroline/projects/prescriptions/both_gens_antipsychotics_geno2.txt", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

#_______________________________________________________________________________________________________________________________________________________________________________________




























# Define the medication names
antipsychotic_drugs <- c("Amisulpride", "Aripiprazole", "Asenapine", "Brexpiprazole", "Cariprazine", "Chlorpromazine", 
                        "Chlorprothixene", "Clozapine", "Flupentixol", "Fluphenazine", "Haloperidol", "Iloperidone", 
                        "Levomepromazine", "Loxapine", "Lumateperone", "Lurasidone", "Melperone", "Molindone", 
                        "Olanzapine", "Paliperidone", "Periciazine", "Perphenazine", "Phenothiazine", "Pimavanserin", 
                        "Pimozide", "Pipamperone", "Prochlorperazine", "Quetiapine", "Risperidone", "Sertindole", 
                        "Sulpiride", "Thioridazine", "Thiothixene", "Trifluoperazine", "Ziprasidone", "Zuclopenthixol")

# Filter rows based on conditions
condition1 <- grepl("^04\\.02|^0402", data$bnf_code) # Any line that starts with 04.02 or 0402 in the bnf_code column
condition2 <- grepl(paste(antipsychotic_drugs, collapse = "|"), data$drug_name) # Any line that contains any of the medication names in the drug_name column

# Length of conditions
length(which(condition1 == TRUE))
# [1] 252533
length(which(condition2 == TRUE))
# [1] 161555

# Combine conditions into a new data frame
filtered_data <- data[condition1 | condition2, ] # Any line that meets either condition1 or condition2

dim(filtered_data) # Check dimensions of the new data frame
# [1] 281313      8

length(unique(filtered_data$eid))
# [1] 27836
# There are 27836 unique individuals in the filtered data - each with antispychotic medication

# Write the result to a new file
write.table(filtered_data, file = "/home/caroline/dsmwpred/caroline/projects/prescriptions/antipsychotics_prescription_geno2.txt", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)
____________________________________________________________


cut -f 1 /home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt | sort | uniq > /home/caroline/dsmwpred/caroline/projects/prescriptions/shell_output.txt






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
cut -f 7 /home/caroline/dsmwpred/caroline/projects/prescriptions/extracted_data.txt | sort | uniq | wc -l
# 3353 unique medications
cut -f 7 /home/caroline/dsmwpred/caroline/projects/prescriptions/extracted_data.txt | sort | uniq > /home/caroline/dsmwpred/caroline/projects/prescriptions/medications.txt


____________________________________________________
awk -F'\t' '$5 ~ /^(04\.02|0402)/' /home/caroline/dsmwpred/caroline/projects/prescriptions/extracted_data.txt > /home/caroline/dsmwpred/caroline/projects/prescriptions/sz_antipsychotics.txt
# I am using this line of code to extract the SZ antipsychotics from the extracted_data.txt file

cut -f 1 /home/caroline/dsmwpred/caroline/projects/prescriptions/sz_antipsychotics.txt | sort | uniq | wc -l
# 196 individuals are lefr with antipsychotics (197 including the header)

cut -f 7 /home/caroline/dsmwpred/caroline/projects/prescriptions/sz_antipsychotics.txt | sort | uniq > /home/caroline/dsmwpred/caroline/projects/prescriptions/sz_antipsychotics_names.txt


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
medication_names <- c("Amisulpride", "Aripiprazole", "Brexpiprazole", "Cariprazine", "Chlorpromazine", 
                        "Clozapine", "Fluphenazine", "Geodon", "Haloperidol", "Latuda", "Loxapine", 
                        "Lurasidone", "Olanzapine", "Paliperidone", "Perphenazine", "Phenothiazine", 
                        "Pimozide", "Quetiapine", "Risperidone", "Saphris", "Sertindole", "Seroquel", 
                        "Thiothixene", "Trifluoperazine", "Ziprasidone", "Zuclopenthixol")

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
profile <- read.delim("/home/caroline/mega_F20.profile", header = T, sep = "\t")
# Extract observations from the PRS profile that are also in the prescription counts
SZ_PRS <- profile[profile$ID1 %in% counts$ID, ]


library(ggplot2)

png('total_prescription.png')
plot(counts$total_prescriptions, SZ_PRS$Profile_1)
dev.off()

png('distinct_drugs.png')
plot(counts$distinct_drugs, SZ_PRS$Profile_1)
dev.off()

boxplot(SZ_PRS$Profile_1 ~ counts$Clozapine_prescribed, ylab = "PRS")

png('Clozapine_prescribed.png')

ggplot(data = merge(SZ_PRS, counts, by.x = "ID", by.y = "ID1"), 
       aes(x = as.factor(Clozapine_prescribed), y = Profile_1)) +
  geom_boxplot() +
  ylab("PRS") +
  xlab("Clozapine Prescribed")
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


