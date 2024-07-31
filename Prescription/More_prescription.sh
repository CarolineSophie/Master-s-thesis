____________________________________________________

# I want a version of gp_scripts that only contain individuals in the geno2 file
# I want to use the geno2 file to extract the individuals

awk '{print $1}' /home/caroline/dsmwpred/data/ukbb/geno2.fam > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/ukbb_ids.txt
awk '{print $1}' /home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts_ids.txt
awk 'NR==FNR{a[$1];next} ($1 in a)' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/ukbb_ids.txt /home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts_ids.txt > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts_ids2.txt

# I want a version of gp_script (all columns) that only contain individuals in the gp_scripts_ids2.txt file

awk 'NR==FNR {ids[$1]; next} $1 in ids' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts_ids2.txt /home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts2.txt

____________________________________________________
### R ###
____________________________________________________
conda activate caroline # Activate conda environment in GenomeDK

R # Open R in conda environment

# Load the extracted data into R
library(data.table)
data <- read.table("/home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts2.txt", 
                    sep = "\t", header = FALSE, fill = TRUE, na.strings = "")


pres <- fread("/home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt")
data <- fread("/home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts2.txt")

, 
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
# [1] 126764
length(which(condition2 == TRUE))
# [1] 48011

# Combine conditions into a new data frame
filtered_data <- data[condition1 | condition2, ] # Any line that meets either condition1 or condition2

dim(filtered_data) # Check dimensions of the new data frame
# [1] 134340     8

length(unique(filtered_data$eid))
# [1] 11845
# There are 11845 unique individuals in the filtered data - each with antispychotic medication

# Write the result to a new file
write.table(filtered_data, file = "/home/caroline/dsmwpred/caroline/projects/prescriptions/antipsychotics_geno2.txt", 
            sep = "\t", col.names = TRUE, row.names = FALSE)
____________________________________________________________


cut -f 1 /home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt | sort | uniq > /home/caroline/dsmwpred/caroline/projects/prescriptions/shell_output.txt
