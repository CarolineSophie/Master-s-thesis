# This file is meant for the creation of new phenotypes in relation to the prescription data
# Especially in relation to the antipsychotic medication for schizophrenia treatment.


# Load the data into R
anti_prescriptions <- read.table("/home/caroline/dsmwpred/caroline/projects/prescriptions/antipsychotics_prescription_geno2.txt", 
    sep = "\t", header = TRUE, fill = TRUE, na.strings = "")

first_gen <- read.table("/home/caroline/dsmwpred/caroline/projects/prescriptions/first_gen_antipsychotics_geno2.txt", 
    sep = "\t", header = TRUE, fill = TRUE, na.strings = "")

second_gen <- read.table("/home/caroline/dsmwpred/caroline/projects/prescriptions/second_gen_antipsychotics_geno2.txt", 
    sep = "\t", header = TRUE, fill = TRUE, na.strings = "")

both_gens <- read.table("/home/caroline/dsmwpred/caroline/projects/prescriptions/both_gens_antipsychotics_geno2.txt",
    sep = "\t", header = TRUE, fill = TRUE, na.strings = "")

all_prescriptions <- read.table("/home/caroline/dsmwpred/caroline/data/geno2_prescriptions.txt", 
    sep = "\t", header = TRUE, fill = TRUE, na.strings = "")
#_______________________________________________________________________________________________________________________________________________________________________________________ # nolint
# This is the code for the binary phenotype of antipsychotic medication prescribed or not prescribed

# Check head of data
head(anti_prescriptions)
head(first_gen)
head(second_gen)
head(both_gens)
head(all_prescriptions)



# I want to find only the unique individuals in the antipsychotics_prescription_geno2.txt file
anti_individuals <- unique(anti_prescriptions$eid)

# I want all the individuals in the geno2_prescriptions.txt file
gp_individuals <- unique(all_prescriptions$eid)

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
#    0      1 
# 141603  27837 

# Now I want to write this data frame to a new file
write.table(pheno, file = "/home/caroline/dsmwpred/caroline/projects/prescriptions/antipsychotics.pheno", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

#_______________________________________________________________________________________________________________________________________________________________________________________

# I want a new phenotype with the number of antipsychotic drugs prescribed
# I will use the antipsychotics_prescription_geno2.txt file

# The code for the total number of antipsychotic prescriptions
anti_pres <- table(anti_prescriptions$eid)

col1 <- anti_prescriptions$eid
new <- table(col1)
uniq <- unique(col1)

# I want to find only the unique individuals in the anti_prescriptions file
anti_individuals <- unique(anti_prescriptions$eid)

# I want all the individuals in the gp_scripts2 file
gp_individuals <- unique(all_prescriptions$eid)

pheno <- data.frame(FID = gp_individuals, IID = gp_individuals)

# I now want to add a phenotype column to this data frame that contains 0s and 1s
# I will create a new column called "pheno" and fill it with 0s
pheno$pheno <- 0

# Now I want to find the individuals in the pheno file that are also in the anti_individuals file
# I want to change the pheno column to the number of prescriptions for these individuals

pheno[pheno$FID %in% anti_individuals, "pheno"] <- anti_pres

# I want to find phenotypes that are greater than 1 to check that this worked
pheno[pheno$pheno > 1]

# Now I want to write this data frame to a new file
write.table(pheno, file = "/home/caroline/dsmwpred/caroline/projects/prescriptions/total_number_antipsychotics.pheno", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

#_______________________________________________________________________________________________________________________________________________________________________________________


#_______________________________________________________________________________________________________________________________________________________________________________________
# Code for clozapine prescriptions
# Binary phenotype: 1 for a prescription of clozapine, 0 for no prescription of clozapine

# I want to make a phenotype file with the binary phenotype for clozapine prescriptions
# I will use the antipsychotics_prescription_geno2.txt file
gp_individuals <- unique(all_prescriptions$eid)

pheno <- data.frame(FID = gp_individuals, IID = gp_individuals)
pheno$pheno <- 0

# I want to identify the individuals in the antipsychotics_prescription_geno2.txt file that have a clozapine prescription
# If the anti_prescriptions$drug_name column contains "Clozapine" or "clozapine", I want to change the pheno column to 1 for these individuals
pheno[pheno$FID %in% anti_prescriptions[grepl("Clozapine|clozapine", anti_prescriptions$drug_name), "eid"], "pheno"] <- 1

pheno[pheno$pheno == 1,] # Check that this worked

# Now I want to write this data frame to a new file
write.table(pheno, file = "/home/caroline/dsmwpred/caroline/projects/prescriptions/clozapine.pheno", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)

#_______________________________________________________________________________________________________________________________________________________________________________________

# Code for generations of antipsychotics
# Binary phenotype: 1 for a prescription of first generation antipsychotics, 0 for no prescription of first generation antipsychotics
# Binary phenotype: 1 for a prescription of second generation antipsychotics, 0 for no prescription of second generation antipsychotics

gp_individuals <- unique(all_prescriptions$eid)

pheno <- data.frame(FID = gp_individuals, IID = gp_individuals)
pheno$pheno <- 0

# All individuals from first_gen file that are also in the pheno file
pheno[pheno$FID %in% first_gen$eid, "pheno"] <- 1

# Write to file
write.table(pheno, file = "/home/caroline/dsmwpred/caroline/projects/prescriptions/first_gen.pheno", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)


# All individuals from second_gen file that are also in the pheno file
pheno <- data.frame(FID = gp_individuals, IID = gp_individuals)
pheno$pheno <- 0

# All individuals from second_gen file that are also in the pheno file
pheno[pheno$FID %in% second_gen$eid, "pheno"] <- 1

# Write to file
write.table(pheno, file = "/home/caroline/dsmwpred/caroline/projects/prescriptions/second_gen.pheno", 
            sep = "\t", col.names = TRUE, row.names = FALSE, quote = FALSE)























# Conventional/first generation drugs:
Chlorpromazine
Thioridazine
Trifluoperazine
Fluphenazine
Perphenazine
Loxapine
Molindone
Thiothixene
Haloperidol
Pimozide
(https://www.msdmanuals.com/professional/psychiatric-disorders/schizophrenia-and-related-disorders/antipsychotic-drugs) #tables


Phenothiazine

Flupentixol
Haloperidol
Pimozide
Periciazine
Perphenazine
Prochlorperazine
Zuclopenthixol
Chlorprothixene
Levomepromazine
Melperone
Pipamperone
Sulpiride
(https://pro.medicin.dk/Laegemiddelgrupper/Grupper/237000)

# Atypical/second generation drugs:
Aripiprazole
Asenapine
Brexpiprazole
Cariprazine
Clozapine
Iloperidone
Lumateperone
Lurasidone
Olanzapine
Paliperidone
Pimavanserin
Quetiapine
Risperidone
Ziprasidone
(https://www.msdmanuals.com/professional/psychiatric-disorders/schizophrenia-and-related-disorders/antipsychotic-drugs) #tables

Brexpiprazole
Cariprazine
Risperidone
Paliperidone
Olanzapine
Asenapine
Sertindole
Aripiprazole
Lurasidone
Ziprasidone
Quetiapine
Clozapine
Amisulpride
(https://pro.medicin.dk/Laegemiddelgrupper/Grupper/237000)
