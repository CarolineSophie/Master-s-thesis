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

_______________________________________________________________
# Epilepsy

# Create directory for data
#mkdir /home/caroline/dsmwpred/caroline/data/UKBB_Epilepsy

awk '{print $1,$1}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_Epilepsy/G40.ids

ICD_G40=("G40" "G400" "G401" "G402" "G403" "G404" "G405" "G406" "G407" "G408" "G409")

awk -v codes="${ICD_G40[*]}" 'BEGIN {split(codes, arr, " ")} {
    found = 0;  # Initialize found as 0
    for (i = 1; i <= length(arr); i++) {
        if (index($0, arr[i]) > 0) {
            found = 1;  # Set found to 1 if any code is found
            break;  # No need to continue checking if a code is already found
        }
    }
    print found;  # Print 0 or 1
}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_Epilepsy/G40.tmp

paste /home/caroline/dsmwpred/caroline/data/UKBB_Epilepsy/G40.ids /home/caroline/dsmwpred/caroline/data/UKBB_Epilepsy/G40.tmp > /home/caroline/dsmwpred/caroline/data/UKBB_Epilepsy/G40.pheno

awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_Epilepsy/G40.pheno | wc -l

rm /home/caroline/dsmwpred/caroline/data/UKBB_Epilepsy/G40.ids
rm /home/caroline/dsmwpred/caroline/data/UKBB_Epilepsy/G40.tmp

# 6552 individuals with epilepsy

_______________________________________________________________
# Schizoaffective disorder

# Create directory for data
#mkdir /home/caroline/dsmwpred/caroline/data/UKBB_Schizoaffective

awk '{print $1,$1}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_Schizoaffective/F25.ids

ICD_F25=("F25" "F250" "F251" "F252" "F258" "F259")

awk -v codes="${ICD_F25[*]}" 'BEGIN {split(codes, arr, " ")} {
    found = 0;  # Initialize found as 0
    for (i = 1; i <= length(arr); i++) {
        if (index($0, arr[i]) > 0) {
            found = 1;  # Set found to 1 if any code is found
            break;  # No need to continue checking if a code is already found
        }
    }
    print found;  # Print 0 or 1
}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_Schizoaffective/F25.tmp

paste /home/caroline/dsmwpred/caroline/data/UKBB_Schizoaffective/F25.ids /home/caroline/dsmwpred/caroline/data/UKBB_Schizoaffective/F25.tmp > /home/caroline/dsmwpred/caroline/data/UKBB_Schizoaffective/F25.pheno

awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_Schizoaffective/F25.pheno | wc -l

rm /home/caroline/dsmwpred/caroline/data/UKBB_Schizoaffective/F25.ids
rm /home/caroline/dsmwpred/caroline/data/UKBB_Schizoaffective/F25.tmp

# 270 individuals with schizoaffective disorder

_______________________________________________________________
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

_______________________________________________________________
# Crohn's disease

# Create directory for data
#mkdir /home/caroline/dsmwpred/caroline/data/UKBB_Crohns

awk '{print $1,$1}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_Crohns/K50.ids

ICD_K50=("K50" "K500" "K501" "K508" "K509")

awk -v codes="${ICD_K50[*]}" 'BEGIN {split(codes, arr, " ")} {
    found = 0;  # Initialize found as 0
    for (i = 1; i <= length(arr); i++) {
        if (index($0, arr[i]) > 0) {
            found = 1;  # Set found to 1 if any code is found
            break;  # No need to continue checking if a code is already found
        }
    }
    print found;  # Print 0 or 1
}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_Crohns/K50.tmp

paste /home/caroline/dsmwpred/caroline/data/UKBB_Crohns/K50.ids /home/caroline/dsmwpred/caroline/data/UKBB_Crohns/K50.tmp > /home/caroline/dsmwpred/caroline/data/UKBB_Crohns/K50.pheno

awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_Crohns/K50.pheno | wc -l

rm /home/caroline/dsmwpred/caroline/data/UKBB_Crohns/K50.ids
rm /home/caroline/dsmwpred/caroline/data/UKBB_Crohns/K50.tmp

# 2826 individuals with Crohn's disease

_______________________________________________________________
# Ulcerative colitis

# Create directory for data
#mkdir /home/caroline/dsmwpred/caroline/data/UKBB_UlcerativeColitis

awk '{print $1,$1}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_UlcerativeColitis/K51.ids

ICD_K51=("K51" "K510" "K511" "K512" "K513" "K514" "K515" "K518" "K519")

awk -v codes="${ICD_K51[*]}" 'BEGIN {split(codes, arr, " ")} {
    found = 0;  # Initialize found as 0
    for (i = 1; i <= length(arr); i++) {
        if (index($0, arr[i]) > 0) {
            found = 1;  # Set found to 1 if any code is found
            break;  # No need to continue checking if a code is already found
        }
    }
    print found;  # Print 0 or 1
}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_UlcerativeColitis/K51.tmp

paste /home/caroline/dsmwpred/caroline/data/UKBB_UlcerativeColitis/K51.ids /home/caroline/dsmwpred/caroline/data/UKBB_UlcerativeColitis/K51.tmp > /home/caroline/dsmwpred/caroline/data/UKBB_UlcerativeColitis/K51.pheno

awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_UlcerativeColitis/K51.pheno | wc -l

rm /home/caroline/dsmwpred/caroline/data/UKBB_UlcerativeColitis/K51.ids
rm /home/caroline/dsmwpred/caroline/data/UKBB_UlcerativeColitis/K51.tmp

# 5187 individuals with ulcerative colitis

_______________________________________________________________
# Diabetes

# Create directory for data
#mkdir /home/caroline/dsmwpred/caroline/data/UKBB_Diabetes

awk '{print $1,$1}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_Diabetes/E10.ids

ICD_E10=("E10" "E100" "E101" "E102" "E103" "E104" "E105" "E106" "E107" "E108" "E109")

awk -v codes="${ICD_E10[*]}" 'BEGIN {split(codes, arr, " ")} {
    found = 0;  # Initialize found as 0
    for (i = 1; i <= length(arr); i++) {
        if (index($0, arr[i]) > 0) {
            found = 1;  # Set found to 1 if any code is found
            break;  # No need to continue checking if a code is already found
        }
    }
    print found;  # Print 0 or 1
}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_Diabetes/E10.tmp

paste /home/caroline/dsmwpred/caroline/data/UKBB_Diabetes/E10.ids /home/caroline/dsmwpred/caroline/data/UKBB_Diabetes/E10.tmp > /home/caroline/dsmwpred/caroline/data/UKBB_Diabetes/E10.pheno

awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_Diabetes/E10.pheno | wc -l

rm /home/caroline/dsmwpred/caroline/data/UKBB_Diabetes/E10.ids
rm /home/caroline/dsmwpred/caroline/data/UKBB_Diabetes/E10.tmp

# 4785 individuals with diabetes E10


awk '{print $1,$1}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_Diabetes/E11.ids

ICD_E11=("E11" "E110" "E111" "E112" "E113" "E114" "E115" "E116" "E117" "E118" "E119")

awk -v codes="${ICD_E11[*]}" 'BEGIN {split(codes, arr, " ")} {
    found = 0;  # Initialize found as 0
    for (i = 1; i <= length(arr); i++) {
        if (index($0, arr[i]) > 0) {
            found = 1;  # Set found to 1 if any code is found
            break;  # No need to continue checking if a code is already found
        }
    }
    print found;  # Print 0 or 1
}' /home/caroline/snpher/faststorage/biobank/newphens/icd.txt > /home/caroline/dsmwpred/caroline/data/UKBB_Diabetes/E11.tmp

paste /home/caroline/dsmwpred/caroline/data/UKBB_Diabetes/E11.ids /home/caroline/dsmwpred/caroline/data/UKBB_Diabetes/E11.tmp > /home/caroline/dsmwpred/caroline/data/UKBB_Diabetes/E11.pheno

awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_Diabetes/E11.pheno | wc -l

rm /home/caroline/dsmwpred/caroline/data/UKBB_Diabetes/E11.ids
rm /home/caroline/dsmwpred/caroline/data/UKBB_Diabetes/E11.tmp

# 38751 individuals with diabetes E11




