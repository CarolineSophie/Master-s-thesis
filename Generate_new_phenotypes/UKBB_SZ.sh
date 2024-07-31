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

_______________________________________________________________

# Individual schizophrenia codes
# Codes for schizophrenia

# ICD_F200=("F200")
awk < /home/caroline/snpher/faststorage/biobank/newphens/icd.txt '{status=0;for(j=2;j<=NF;j++){if($j=="F200"){status=1;}};print $1, $1, status}' > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F200.pheno
awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F200.pheno | wc -l
awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F200.pheno # Check which rows are cases
awk '$3 == 1 {print NR, $0}' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F200.pheno # Check which rows are cases with row number

# ICD_F201=("F201")
awk < /home/caroline/snpher/faststorage/biobank/newphens/icd.txt '{status=0;for(j=2;j<=NF;j++){if($j=="F201"){status=1;}};print $1, $1, status}' > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F201.pheno
awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F201.pheno | wc -l

# ICD_F202=("F202")
awk < /home/caroline/snpher/faststorage/biobank/newphens/icd.txt '{status=0;for(j=2;j<=NF;j++){if($j=="F202"){status=1;}};print $1, $1, status}' > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F202.pheno
awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F202.pheno | wc -l

# ICD_F203=("F203")
awk < /home/caroline/snpher/faststorage/biobank/newphens/icd.txt '{status=0;for(j=2;j<=NF;j++){if($j=="F203"){status=1;}};print $1, $1, status}' > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F203.pheno
awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F203.pheno | wc -l

# ICD_F204=("F204")
awk < /home/caroline/snpher/faststorage/biobank/newphens/icd.txt '{status=0;for(j=2;j<=NF;j++){if($j=="F204"){status=1;}};print $1, $1, status}' > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F204.pheno
awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F204.pheno | wc -l

# ICD_F205=("F205")
awk < /home/caroline/snpher/faststorage/biobank/newphens/icd.txt '{status=0;for(j=2;j<=NF;j++){if($j=="F205"){status=1;}};print $1, $1, status}' > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F205.pheno
awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F205.pheno | wc -l

# ICD_F206=("F206")
awk < /home/caroline/snpher/faststorage/biobank/newphens/icd.txt '{status=0;for(j=2;j<=NF;j++){if($j=="F206"){status=1;}};print $1, $1, status}' > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F206.pheno
awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F206.pheno | wc -l

# ICD_F208=("F208")
awk < /home/caroline/snpher/faststorage/biobank/newphens/icd.txt '{status=0;for(j=2;j<=NF;j++){if($j=="F208"){status=1;}};print $1, $1, status}' > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F208.pheno
awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F208.pheno | wc -l

# ICD_F209=("F209")
awk < /home/caroline/snpher/faststorage/biobank/newphens/icd.txt '{status=0;for(j=2;j<=NF;j++){if($j=="F209"){status=1;}};print $1, $1, status}' > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F209.pheno
awk '$3 == 1' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F209.pheno | wc -l
