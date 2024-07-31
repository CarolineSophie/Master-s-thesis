
/home/caroline/dsmwpred/data/ukbb/geno.sex.townsend.age.pcs # The covariates file (these are only cleaned invividuals)


# I want to find the number of males and females in the Ukbb data

#################
###    SEX    ###
#################
# check 3rd column of the file
awk '{print $3}' /home/caroline/dsmwpred/data/ukbb/geno.sex.townsend.age.pcs

# Copy the 1st and the 3rd column to a new file called sex
awk '{print $1,$3}' /home/caroline/dsmwpred/data/ukbb/geno.sex.townsend.age.pcs > /home/caroline/dsmwpred/caroline/data/sex.pheno
# 0 is female
# 1 is male

# I want to make a male file and a female file
awk '$2 == 1' /home/caroline/dsmwpred/caroline/data/sex.pheno > /home/caroline/dsmwpred/caroline/data/males.txt
awk '$2 == 0' /home/caroline/dsmwpred/caroline/data/sex.pheno > /home/caroline/dsmwpred/caroline/data/females.txt

#################
###    AGE    ###
#################

# make age file 5th column
awk '{print $1,$5}' /home/caroline/dsmwpred/data/ukbb/geno.sex.townsend.age.pcs > /home/caroline/dsmwpred/caroline/data/age.pheno

###########################################
### SZ male/female ratio in clean data  ###
###########################################

# I want an overlapping file between my sz patients and the cleaned geno file
/home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20.pheno

awk 'NR==FNR{a[$1];next} $1 in a' /home/caroline/dsmwpred/caroline/data/sex.pheno /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20.pheno > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20_geno.pheno

awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20_geno.pheno | wc -l # 704 individuals with SZ in the cleaned data

# Make a subset only with patients column 3 equal to 1
awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20_geno.pheno > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20_geno_only.pheno

# The file contains all SZ patients in the UKBB (cleaned geno file)
# I want to check how many are men, and how many are women

# Overlap between females and SZ
awk 'NR==FNR{a[$1];next} $1 in a' /home/caroline/dsmwpred/caroline/data/females.txt /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20_geno_only.pheno | wc -l # 259
# Overlap between males and SZ
awk 'NR==FNR{a[$1];next} $1 in a' /home/caroline/dsmwpred/caroline/data/males.txt /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20_geno_only.pheno | wc -l # 445


###########################################
### SZ/BP comorbidity in clean data     ###
###########################################

# Overlap with the BP patients and the geno file
/home/caroline/dsmwpred/caroline/data/UKBB_BP/F31.pheno

awk 'NR==FNR{a[$1];next} $1 in a' /home/caroline/dsmwpred/caroline/data/sex.pheno /home/caroline/dsmwpred/caroline/data/UKBB_BP/F31.pheno > /home/caroline/dsmwpred/caroline/data/UKBB_BP/F31_geno.pheno
awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_BP/F31.pheno | wc -l # 1808
awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_BP/F31_geno.pheno | wc -l # 1319

# Save the clem BP individuals
awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_BP/F31_geno.pheno > /home/caroline/dsmwpred/caroline/data/UKBB_BP/F31_geno_only.pheno

# Overlap between BP and SZ cleaned individuals
awk 'NR==FNR{a[$1];next} $1 in a' /home/caroline/dsmwpred/caroline/data/UKBB_BP/F31_geno_only.pheno /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20_geno_only.pheno | wc -l # 127

###########################################
### SZ/MDD comorbidity in clean data    ###
###########################################

# Overlap with the MDD patients and the geno file
/home/caroline/dsmwpred/caroline/data/UKBB_Depression/F32.pheno

awk 'NR==FNR{a[$1];next} $1 in a' /home/caroline/dsmwpred/caroline/data/sex.pheno /home/caroline/dsmwpred/caroline/data/UKBB_Depression/F32.pheno > /home/caroline/dsmwpred/caroline/data/UKBB_Depression/F32_geno.pheno
awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_Depression/F32.pheno | wc -l # 27778
awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_Depression/F32_geno.pheno | wc -l # 21559

# Save the clean MDD individuals
awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_Depression/F32_geno.pheno > /home/caroline/dsmwpred/caroline/data/UKBB_Depression/F32_geno_only.pheno

# Overlap between MDD and SZ cleaned individuals
awk 'NR==FNR{a[$1];next} $1 in a' /home/caroline/dsmwpred/caroline/data/UKBB_Depression/F32_geno_only.pheno /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20_geno_only.pheno | wc -l # 270


































#########################################################################################
# Script to get the UKBB Schizophrenia data

# Following ICD10 codes are used to define schizophrenia:

# F20 Schizophrenia
# F20.0 Paranoid schizophrenia
# F20.1 Hebephrenic schizophrenia
# F20.2 Catatonic schizophrenia
# F20.3 Undifferentiated schizophrenia
# F20.4 Postschizophrenic depression
# F20.5 Residual schizophrenia
# F20.6 Simple schizophrenia
# F20.8 Other schizophrenia
# F20.9 Schizophrenia, unspecified

# I want to create a file for each individual classification, and then a file for all schizophrenia

# File path to the raw data /home/caroline/snpher/faststorage/biobank/newphens/icd.txt
# File path to where data should be stored /home/caroline/dsmwpred/caroline/data

# Create disrectory for data
mkdir /home/caroline/dsmwpred/caroline/data/UKBB_SZ

_______________________________________________________________
awk '{print $1,$1}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20.ids

ICD_F20=("F20" "F200" "F201" "F202" "F203" "F204" "F205" "F206" "F208" "F209")

awk -v codes="${ICD_F20[*]}" 'BEGIN {split(codes, arr, " ")} {
    found = 0;  # Initialize found as 0
    for (i = 1; i <= length(arr); i++) {
        if (index($0, arr[i]) > 0) {
            found = 1;  # Set found to 1 if any code is found
            break;  # No need to continue checking if a code is already found
        }
    }
    print found;  # Print 0 or 1
}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20.tmp

paste /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20.ids /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20.tmp > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20.pheno

awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20.pheno | wc -l

rm /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20.ids
rm /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20.tmp
________________________________________________________________________


# Bipolar disorder

# Create directory for data
#mkdir /home/caroline/dsmwpred/caroline/data/UKBB_BP

awk '{print $1,$1}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_BP/F31.ids

ICD_F31=("F31" "F310" "F311" "F312" "F313" "F314" "F415" "F316" "F317" "F318" "F319")

awk -v codes="${ICD_F31[*]}" 'BEGIN {split(codes, arr, " ")} {
    found = 0;  # Initialize found as 0
    for (i = 1; i <= length(arr); i++) {
        if (index($0, arr[i]) > 0) {
            found = 1;  # Set found to 1 if any code is found
            break;  # No need to continue checking if a code is already found
        }
    }
    print found;  # Print 0 or 1
}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_BP/F31.tmp

paste /home/caroline/dsmwpred/caroline/data/UKBB_BP/F31.ids /home/caroline/dsmwpred/caroline/data/UKBB_BP/F31.tmp > /home/caroline/dsmwpred/caroline/data/UKBB_BP/F31.pheno

awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_BP/F31.pheno | wc -l

rm /home/caroline/dsmwpred/caroline/data/UKBB_BP/F31.ids
rm /home/caroline/dsmwpred/caroline/data/UKBB_BP/F31.tmp

# 1808 individuals with bipolar disorder
____________________________________________________________________

# Depressive episode

# Create directory for data
#mkdir /home/caroline/dsmwpred/caroline/data/UKBB_Depression

awk '{print $1,$1}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_Depression/F32.ids

ICD_F32=("F32" "F320" "F321" "F322" "F323" "F328" "F329")

awk -v codes="${ICD_F32[*]}" 'BEGIN {split(codes, arr, " ")} {
    found = 0;  # Initialize found as 0
    for (i = 1; i <= length(arr); i++) {
        if (index($0, arr[i]) > 0) {
            found = 1;  # Set found to 1 if any code is found
            break;  # No need to continue checking if a code is already found
        }
    }
    print found;  # Print 0 or 1
}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_Depression/F32.tmp

paste /home/caroline/dsmwpred/caroline/data/UKBB_Depression/F32.ids /home/caroline/dsmwpred/caroline/data/UKBB_Depression/F32.tmp > /home/caroline/dsmwpred/caroline/data/UKBB_Depression/F32.pheno

awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_Depression/F32.pheno | wc -l

rm /home/caroline/dsmwpred/caroline/data/UKBB_Depression/F32.ids
rm /home/caroline/dsmwpred/caroline/data/UKBB_Depression/F32.tmp

# 27778 individuals with depressive episode
