# GWAS of prescription data

# I made this bed file - it is a combination of the files in the geno2.bed/bim/fam files and the SZ_50k_ids2.txt file
# It only contains 50000 individuals - including all individuals diagnosed with SZ
# /home/caroline/dsmwpred/caroline/data/UKBB_SZ/sz_geno2.bed
#_______________________________________________________________________________________________________________________________________________________________________________________


Please perform two GWAS using only people in prescription data - 200k

I have made the file prescription.txt in
/home/doug/snpher/faststorage/biobank/newphens
this contains field 42039

I thought it might be useful for finding out which individuals were in the prescription data
 222104 individuals have values 1 or more
 280383 individuals have value NA
Does this mean the prescrption data searched for only 222104 individuals (or maybe it searched for more, but some had no records)???

Maybe the paper below will give some advice. However, it should not make a big difference (ie, whether you find an exact list of who was included in the prescription data, or just use your own list)


gwas 1
cases are those who received antipsychotic medication 11k
controls are all others (those who have not received antipsychotic medication) - 189k

gwas 2
the phenotype is number of antipsyhotic medications received (eg number of tablets / number unique)


#_______________________________________________________________________________________________________________________________________________________________________________________

/home/caroline/dsmwpred/caroline/projects/prescriptions/antipsychotics_geno2.txt

# This file contains all individuals who have been prescribed antipsychotic medication that also exist in the geno2.bed/bim/fam files
# There are multiple rows for each individual - one for each prescription

/home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts2.txt
# This file contains the overlap of individuals in the geno2.bed/bim/fam files and the prescription data. This contains all medication.

#_______________________________________________________________________________________________________________________________________________________________________________________

# I need a new phenotype file that contains only one row for each individual - 1 if they have been prescribed antipsychotic medication, 0 if they have not

conda activate caroline # Activate conda environment in GenomeDK
R # Open R in conda environment

# Load the data into R
library(data.table)
antipsychotics_geno2 <- fread("/home/caroline/dsmwpred/caroline/projects/prescriptions/antipsychotics_geno2.txt")

gp_scripts2 <- fread("/home/caroline/dsmwpred/caroline/data/UKBB_SZ/gp_scripts2.txt")


# Check head of data
head(antipsychotics_geno2)
head(gp_scripts2)

colnames(gp_scripts2) <- colnames(antipsychotics_geno2)

# I want to find only the unique individuals in the antipsychotics_geno2 file
anti_individuals <- unique(antipsychotics_geno2$eid)

# I want all the individuals in the gp_scripts2 file
gp_individuals <- unique(gp_scripts2$eid)

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
# 158893  11845 


# Now I want to write this data frame to a new file
write.table(pheno, file = "/home/caroline/dsmwpred/caroline/projects/prescriptions/antipsychotics.pheno", 
            sep = "\t", col.names = TRUE, row.names = FALSE)

#_______________________________________________________________________________________________________________________________________________________________________________________

# Now I want to make a pheno file with the number of prescriptions of antipsychotics for each individual

anti_prescriptions <- table(antipsychotics_geno2$eid)

# I want to find only the unique individuals in the antipsychotics_geno2 file
anti_individuals <- unique(antipsychotics_geno2$eid)

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
pheno[pheno$pheno > 1]

# Now I want to write this data frame to a new file
write.table(pheno, file = "/home/caroline/dsmwpred/caroline/projects/prescriptions/n_antipsychotics.pheno", 
            sep = "\t", col.names = TRUE, row.names = FALSE)

#_______________________________________________________________________________________________________________________________________________________________________________________

#!/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 4
#SBATCH --time 4:00:00
#SBATCH --mem 32g

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --linear /home/caroline/dsmwpred/caroline/projects/prescriptions/prescription_GWAS/antipsychotics_binary \
 --bfile /home/caroline/dsmwpred/data/ukbb/geno2 \
 --pheno /home/caroline/dsmwpred/caroline/phenotypes/antipsychotics.pheno \
 --covar /home/caroline/dsmwpred/data/ukbb/geno.sex.townsend.age.pcs 

#!/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 4
#SBATCH --time 4:00:00
#SBATCH --mem 32g
/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --logistic /home/caroline/dsmwpred/caroline/projects/prescriptions/prescription_GWAS/antipsychotics_binary_logistic \
 --bfile /home/caroline/dsmwpred/data/ukbb/geno2 \
 --pheno /home/caroline/dsmwpred/caroline/phenotypes/antipsychotics.pheno \
 --covar /home/caroline/dsmwpred/data/ukbb/geno.sex.townsend.age.pcs \
 --score-test YES

sbatch path/path/shellfile.sh

for i in /home/caroline/dsmwpred/caroline/projects/prescriptions/scripts/*; do sbatch $i; done
squeue | grep caroline


--logistic <outfile>

../../ldak5.XXX \
--linear female.height.test \
--pheno ./female.height.test \
--bfile ../../../data/ukbb/geno3 \
--covar ../../doug/agesextownpcs.covar 



#_______________________________________________________________________________________________________________________________________________________________________________________
# GWAS of number of antipsychotic prescriptions

#!/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 4
#SBATCH --time 4:00:00
#SBATCH --mem 32g

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --linear /home/caroline/dsmwpred/caroline/projects/prescriptions/prescription_GWAS/n_antipsychotics \
 --bfile /home/caroline/dsmwpred/data/ukbb/geno2 \
 --pheno /home/caroline/dsmwpred/caroline/projects/prescriptions/n_antipsychotics.pheno \
 --covar /home/caroline/dsmwpred/data/ukbb/geno.sex.townsend.age.pcs 

