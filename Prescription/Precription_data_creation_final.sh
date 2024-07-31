# Data paths
# Raw data files
/home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.old
/home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt
/home/caroline/snpher/faststorage/biobank/newphens/gp_clinical.txt
/home/caroline/snpher/faststorage/biobank/newphens/gp_registrations.txt

____________________________________________________

# The length of the full file is 56201757 (including header)
wc -l /home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt

##################################################################################################

#_______________________________________________________________________________________________________________________________________________________________________________________

# I now want a version of the gp_scripts.txt file that only contains individuals in the geno2.bed/bim/fam files

# I have the UKBB IDs here:
/home/caroline/dsmwpred/caroline/data/UKBB_SZ/ukbb_ids.txt

# I will extract the first column of the gp_scripts_subset.txt file and then compare it to the ukbb_ids.txt file
awk '{print $1}' /home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt > /home/caroline/dsmwpred/caroline/data/prescription/gp_scripts_ids.txt

# I check it:
wc -l /home/caroline/dsmwpred/caroline/data/prescription/gp_scripts_ids.txt # All good - 56201757
head /home/caroline/dsmwpred/caroline/data/prescription/gp_scripts_ids.txt # All good

# Now I find the overlap between the two files
awk 'NR==FNR {a[$1];next} ($1 in a)' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/ukbb_ids.txt /home/caroline/dsmwpred/caroline/data/prescription/gp_scripts_ids.txt > /home/caroline/dsmwpred/caroline/data/prescription/gp_scripts_ids2.txt

/home/caroline/dsmwpred/caroline/data/prescription/gp_scripts_ids2.txt # This is the new IDs file
# Check the new file: 
wc -l /home/caroline/dsmwpred/caroline/data/prescription/gp_scripts_ids2.txt # 44910330

# I want a version of gp_script.txt (all columns) that only contain individuals in the gp_scripts_ids2.txt file
awk 'NR==FNR {ids[$1]; next} $1 in ids' /home/caroline/dsmwpred/caroline/data/prescription/gp_scripts_ids2.txt /home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt > /home/caroline/dsmwpred/caroline/data/prescription/gp_geno.txt

# Check
/home/caroline/dsmwpred/caroline/data/prescription/gp_geno.txt
wc -l /home/caroline/dsmwpred/caroline/data/prescription/gp_geno.txt # 44910330
head /home/caroline/dsmwpred/caroline/data/prescription/gp_geno.txt # All good

# Add the header
head -n 1 /home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt | cat - /home/caroline/dsmwpred/caroline/data/prescription/gp_geno.txt > temp
mv temp /home/caroline/dsmwpred/caroline/data/prescription/gp_geno.txt
rm temp

# Check
wc -l /home/caroline/dsmwpred/caroline/data/prescription/gp_geno.txt # 44910331
head /home/caroline/dsmwpred/caroline/data/prescription/gp_geno.txt # All good
#________________________________________________________________________________________________________________________________________________________________________________________
____________________________________________________
### Get information about the data files ###
____________________________________________________


# number of unique individuals
cut -f 1 /home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt | sort | uniq | wc -l # 222001
cut -f 1 /home/caroline/dsmwpred/caroline/data/prescription/gp_geno.txt | sort | uniq | wc -l # 177413
cut -f 1 /home/caroline/dsmwpred/caroline/data/UKBB_SZ/ukbb_ids.txt | sort | uniq | wc -l # 392214

____________________________________________________
### R ###
### Make sure the new prescription file has the right format ###
____________________________________________________
conda activate caroline # Activate conda environment in GenomeDK

R # Open R in conda environment

# Load the data into R
library(data.table)
raw <- fread("/home/caroline/snpher/faststorage/biobank/newphens/gp_scripts.txt")
ids <- fread("/home/caroline/dsmwpred/caroline/data/prescription/gp_scripts_ids2.txt")
data <- fread("/home/caroline/dsmwpred/caroline/data/prescription/gp_geno.txt")

# Check the data
length(raw$eid) # 56201756
length(unique(raw$eid)) # 222000
length(ids$V1) # 44910330 
length(data$eid) # 44910330
length(unique(data$eid)) # 177412 
____________________________________________________
### Creating prescription data sets ###
____________________________________________________

antipsychotic_drugs <- c("Acetophenazine",
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

first_generation <- c("Acetophenazine",
                      "Benperidol",
                      "Blonanserin",
                      "Bromperidol",
                      "Butaperazine",
                      "Chlorproethazine",
                      "Chlorpromazine",
                      "Chlorprothixene",
                      "Clocapramine",
                      "Clopenthixol",
                      "Clotiapine",
                      "Cyamemazine",
                      "Dixyrazine",
                      "Droperidol",
                      "Fluanisone",
                      "Flupenthixol",
                      "Flupentixol",
                      "Fluphenazine",
                      "Fluspirilene",
                      "Haloperidol",
                      "Levomepromazine",
                      "Loxapine",
                      "Melperone",
                      "Molindone",
                      "Moperone",
                      "Mosapramine ",
                      "Nemonapride",
                      "Oxypertine",
                      "Penfluridol ",
                      "Perazine",
                      "Periciazine",
                      "Perphenazine",
                      "Phenothiazine",
                      "Pimozide",
                      "Pipamperone",
                      "Piperacetazine",
                      "Pipoptiazine",
                      "Prochlorperazine",
                      "Promazine",
                      "Propericiazine",
                      "Sulforidazine",
                      "Sulpiride",
                      "Sultopride",
                      "Thiopropazate",
                      "Thioproperazine",
                      "Thiothixene",
                      "Thioridazine",
                      "Tiapride",
                      "Timiperone",
                      "Trifluoperazine",
                      "Trifluperidol",
                      "Triflupromazine",
                      "Zuclopenthixol")

second_generation <- c("Asenapine",
                       "Clozapine",
                       "Olanzapine",
                       "Quetiapine",
                       "Zotepine ",
                       "Amisulpride",
                       "Aripiprazole",
                       "Brexpiprazole",
                       "Cariprazine",
                       "Iloperidone",
                       "Lumateperone",
                       "Lurasidone",
                       "Paliperidone",
                       "Perospirone",
                       "Pimavanserin",
                       "Risperidone",
                       "Sertindole",
                       "Ziprasidone ")


#Benzo (diaze- or thiaze-) pines
Benzo <- c("Asenapine", "Clozapine", "Olanzapine", "Quetiapine", "Zotepine") 

# Filter rows based on conditions
condition1 <- grepl("^04\\.02|^0402", data$bnf_code) # Any line that starts with 04.02 or 0402 in the bnf_code column
condition2 <- grepl(paste(antipsychotic_drugs, collapse = "|"), data$drug_name, ignore.case = TRUE) # Any line that contains any of the medication names in the drug_name column

# Length of conditions
length(which(condition1 == TRUE))
# [1] 263444
length(which(condition2 == TRUE))
# [1] 183504

# Combine conditions into a new data frame
filtered_data <- data[condition1 | condition2 ,] # Any line that meets either condition1 or condition2

dim(filtered_data) # Check dimensions of the new data frame
# [1] 306413      8

length(unique(filtered_data$eid))
# [1] 30723
# There are 30723 unique individuals in the filtered data - each with antispychotic medication

# Write the result to a new file
write.table(filtered_data, file = "/home/caroline/dsmwpred/caroline/projects/prescription_2/data/antipsychotic_prescription.txt", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

#_______________________________________________________________________________________________________________________________________________________________________________________
# Now I only want 1st or 2nd generation antipsychotics

# Filter rows based on condition
condition_first <- grepl(paste(first_generation, collapse = "|"), data$drug_name, ignore.case = TRUE) # Any line that contains any of the medication names in the drug_name column
condition_second <- grepl(paste(second_generation, collapse = "|"), data$drug_name, ignore.case = TRUE) # Any line that contains any of the medication names in the drug_name column
condition_benzo <- grepl(paste(Benzo, collapse = "|"), data$drug_name, ignore.case = TRUE) # Any line that contains any of the medication names in the drug_name column

# Length of condition
length(which(condition_first == TRUE))
# 106297
length(which(condition_second == TRUE))
# 77207
length(which(condition_benzo == TRUE))
# 52332


# Combine condition into a new data frame
first_data <- data[condition_first, ] # Any line that meets the condition
second_data <- data[condition_second, ] # Any line that meets the condition
benzo_data <- data[condition_benzo, ] # Any line that meets the condition

# Check dimensions of the new data frame
dim(first_data)
dim(second_data)
dim(benzo_data)

# Check number of unique individuals
length(unique(first_data$eid))
# 26612
length(unique(second_data$eid))
# 1525
length(unique(benzo_data$eid))
# 1115

# Write the result to a new file
write.table(first_data, file = "/home/caroline/dsmwpred/caroline/projects/prescription_2/data/first_gen_antipsychotics.txt", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

write.table(second_data, file = "/home/caroline/dsmwpred/caroline/projects/prescription_2/data/second_gen_antipsychotics.txt",
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

write.table(benzo_data, file = "/home/caroline/dsmwpred/caroline/projects/prescription_2/data/benzo_antipsychotics.txt",
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

#_______________________________________________________________________________________________________________________________________________________________________________________

# I want to check whether any individuals have been prescribed both first and second generation antipsychotics
# I will use the first_data and second_data files

# Load the data into R
first_data <- fread("/home/caroline/dsmwpred/caroline/data/prescription/first_gen_antipsychotics.txt")

second_data <- fread("/home/caroline/dsmwpred/caroline/data/prescription/second_gen_antipsychotics.txt")

# I want to find the unique individuals in the first_data file
first_individuals <- unique(first_data$eid)

# I want to find the unique individuals in the second_data file
second_individuals <- unique(second_data$eid)

# I want to find the individuals that are in both the first_data and second_data files
both_individuals <- intersect(first_individuals, second_individuals)

# Write new files with only the individuals that are in both the first_data and second_data files
both_gens <- data[data$eid %in% both_individuals, ]
length(unique(both_gens$eid)) # 619

write.table(both_gens, file = "/home/caroline/dsmwpred/caroline/projects/prescription_2/data/both_generations_antipsychotics.txt", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

#_______________________________________________________________________________________________________________________________________________________________________________________

##################################################################################################


# This file is the file that contains all individuals who have been prescribed antipsychotic medication
/home/caroline/dsmwpred/caroline/data/prescription/antipsychotic_prescription.txt

# This file contains the overlap of individuals in the geno2.bed/bim/fam files and the prescription data. This contains all medication.
/home/caroline/dsmwpred/caroline/data/prescription/gp_geno.txt

# Read in the files
anti_prescription <- fread("/home/caroline/dsmwpred/caroline/projects/prescription_2/data/antipsychotic_prescription.txt")
gp_scripts2 <- fread("/home/caroline/dsmwpred/caroline/data/prescription/gp_geno.txt")


# I need a new phenotype file that contains only one row for each individual - 1 if they have been prescribed antipsychotic medication, 0 if they have not

# Check head of data
head(anti_prescription)
head(gp_scripts2)

colnames(gp_scripts2) == colnames(anti_prescription) # TRUE

all(anti_prescription$eid %in% gp_scripts2$eid)

not_included_ids <- anti_prescription$eid[!anti_prescription$eid %in% gp_scripts2$eid]
not_included_ids <- unique(not_included_ids)
not_included_ids
length(not_included_ids) # 1168

which(gp_scripts2$eid == 6005078)

# I want to find only the unique individuals in the anti_prescription file
anti_individuals <- unique(anti_prescription$eid)

# I want all the individuals in the gp_scripts2 file
gp_individuals <- unique(gp_scripts2$eid)

# Check
length(anti_individuals)
# 30723
length(gp_individuals)
# 177412


# Now I want to create a new data frame with the binary phenotype for each individual (antipsychotic medication prescribed = 1, no antipsychotic medication prescribed = 0)
# I will use the gp_individuals file as a template

# A phenotype file needs to have 2 columns - "FID" and "IID"
# I copy the first column from the gp_individuals file and call it "FID"
# I copy the second column from the gp_individuals file and call it "IID"
# I will fill the "FID" column with the values from the gp_individuals file
# I will fill the "IID" column with the values from the gp_individuals file
pheno <- data.frame(FID = gp_individuals, IID = gp_individuals)

# I now want to add a phenotype column to this data frame that contains 0s and 1s
# I will create a new column called "pheno" and fill it with 0s
pheno$pheno <- 0

# Now I want to find the individuals in the pheno file that are also in the anti_individuals file
# I want to change the pheno column to 1 for these individuals
pheno[pheno$FID %in% anti_individuals, "pheno"] <- 1

# Check the number of 1s and 0s in the pheno column
table(pheno$pheno)
#     0      1 
# 146689  30723 


# Now I want to write this data frame to a new file
write.table(pheno, file = "//home/caroline/dsmwpred/caroline/projects/prescription_2/data/antipsychotics.pheno", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

#_______________________________________________________________________________________________________________________________________________________________________________________

# Now I want to make a pheno file with the number of prescriptions of antipsychotics for each individual

anti_prescriptions <- table(anti_prescription$eid)

# I want to find only the unique individuals in the antipsychotics_geno2 file
anti_individuals <- unique(anti_prescription$eid)

# I want all the individuals in the gp_scripts2 file
gp_individuals <- unique(gp_scripts2$eid)

pheno <- data.frame(FID = gp_individuals, IID = gp_individuals)

# I now want to add a phenotype column to this data frame that contains 0s and 1s
# I will create a new column called "pheno" and fill it with 0s
pheno$pheno <- 0

# Now I want to find the individuals in the pheno file that are also in the anti_individuals file
# I want to change the pheno column to the number of prescriptions for these individuals
pheno[pheno$FID %in% anti_individuals, "pheno"] <- anti_prescriptions


# I want to find phenotypes that are greater than 1 to check that this worked
pheno[pheno$pheno > 1,]

# Now I want to write this data frame to a new file
write.table(pheno, file = "/home/caroline/dsmwpred/caroline/projects/prescription_2/data/n_antipsychotics.pheno", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)



#_______________________________________________________________________________________________________________________________________________________________________________________


#_______________________________________________________________________________________________________________________________________________________________________________________
# Code for clozapine prescriptions
# Binary phenotype: 1 for a prescription of clozapine, 0 for no prescription of clozapine

# I want to make a phenotype file with the binary phenotype for clozapine prescriptions

pheno <- data.frame(FID = gp_individuals, IID = gp_individuals)
pheno$pheno <- 0

# I want to identify the individuals in the antipsychotics_prescription_geno2.txt file that have a clozapine prescription

cloz <- grepl("Clozapine|clozapine", data$drug_name)
# Length of condition
length(which(cloz == TRUE))

# Combine condition into a new data frame
cloz_data <- data[cloz, ]

pheno[pheno$FID %in% cloz_data$eid, "pheno"] <- 1

pheno[pheno$pheno == 1,] # Check that this worked

# Now I want to write this data frame to a new file
write.table(pheno, file = "/home/caroline/dsmwpred/caroline/projects/prescription_2/data/clozapine.pheno", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

#_______________________________________________________________________________________________________________________________________________________________________________________



# Code for generations of antipsychotics
# Binary phenotype: 1 for a prescription of first generation antipsychotics, 0 for no prescription of first generation antipsychotics
# Binary phenotype: 1 for a prescription of second generation antipsychotics, 0 for no prescription of second generation antipsychotics

pheno <- data.frame(FID = gp_individuals, IID = gp_individuals)
pheno$pheno <- 0

# All individuals from first_data file that are also in the pheno file
pheno[pheno$FID %in% first_data$eid, "pheno"] <- 1

# Write to file
write.table(pheno, file = "/home/caroline/dsmwpred/caroline/projects/prescription_2/data/first_gen.pheno", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)


# All individuals from second_data file that are also in the pheno file
pheno <- data.frame(FID = gp_individuals, IID = gp_individuals)
pheno$pheno <- 0

# All individuals from second_data file that are also in the pheno file
pheno[pheno$FID %in% second_data$eid, "pheno"] <- 1

# Write to file
write.table(pheno, file = "/home/caroline/dsmwpred/caroline/projects/prescription_2/data/second_gen.pheno", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)


# Benzo antipsychotics
pheno <- data.frame(FID = gp_individuals, IID = gp_individuals)
pheno$pheno <- 0

# All individuals from benzo_data file that are also in the pheno file
pheno[pheno$FID %in% benzo_data$eid, "pheno"] <- 1

# Write to file
write.table(pheno, file = "/home/caroline/dsmwpred/caroline/projects/prescription_2/data/benzo.pheno", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

#_______________________________________________________________________________________________________________________________________________________________________________________


##################################################################################################
# Running the GWAS #
##################################################################################################

# Linear regression
for file in /home/caroline/dsmwpred/caroline/projects/prescription_2/data/*.pheno; do
filename=$(basename -- "$file")
# Create a new shell script file in each directory
touch "/home/caroline/dsmwpred/caroline/projects/prescription_2/scripts/${filename}_linear.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred 
#SBATCH -c 4
#SBATCH --time 4:00:00 
#SBATCH --mem 32g

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
--linear /home/caroline/dsmwpred/caroline/projects/prescription_2/GWAS/${filename}_linear \
--bfile /home/caroline/dsmwpred/data/ukbb/geno2 \
--pheno ${file} \
--covar /home/caroline/dsmwpred/data/ukbb/geno.sex.townsend.age.pcs 
" > "/home/caroline/dsmwpred/caroline/projects/prescription_2/scripts/${filename}_linear.sh"

done

# Make for binary/logistic
for file in /home/caroline/dsmwpred/caroline/projects/prescription_2/data/*.pheno; do
filename=$(basename -- "$file")
# Create a new shell script file in each directory
touch "/home/caroline/dsmwpred/caroline/projects/prescription_2/scripts/${filename}_logistic.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred 
#SBATCH -c 4
#SBATCH --time 4:00:00 
#SBATCH --mem 32g

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
--logistic /home/caroline/dsmwpred/caroline/projects/prescription_2/GWAS/${filename}_logistic \
--bfile /home/caroline/dsmwpred/data/ukbb/geno2 \
--pheno ${file} \
--covar /home/caroline/dsmwpred/data/ukbb/geno.sex.townsend.age.pcs \
--score-test YES
" > "/home/caroline/dsmwpred/caroline/projects/prescription_2/scripts/${filename}_logistic.sh"

done


# Remove the logistic script for the number of antipsychotics since it is not a binary phenotype
rm /home/caroline/dsmwpred/caroline/projects/prescription_2/scripts/n_antipsychotics.pheno_logistic.sh


# Submit the jobs
for i in /home/caroline/dsmwpred/caroline/projects/prescription_2/scripts/*; do sbatch $i; done
squeue | grep caroline


("Acetophenazine",
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
            "Sulpiride",
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
            "Haloperidol",
            "Trifluperidol",
            "Triflupromazine",
            "Ziprasidone ",
            "Zotepine ",
            "Zuclopenthixol")