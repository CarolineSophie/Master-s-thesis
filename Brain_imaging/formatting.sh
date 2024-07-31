# This file is created april 26

# It is for the formatting of the summary statistics files downloaded from Oxford Brain Imaging Genetics Server - BIG40
# https://open.win.ox.ac.uk/ukbiobank/big40/

# https://open.win.ox.ac.uk/ukbiobank/big40/pheweb33k/  (33k subjects (discovery+replication pooled))

# This is the directoy where the data is saved:
# /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data

# First I want to create a preditor column with chromosome and position
# This is the first and the second columns

raw_dir="/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k_raw"
output_dir="/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k"

#################################
# For testing the code
head -n 10 "${raw_dir}"/0003.txt > "${output_dir}"/0003.txt

# Remove the 0 in the chr column if the first digit is a 0
awk '{$1 = ($1 ~ /^0/) ? substr($1, 2) : $1; print}' "${output_dir}"/0003.txt > "${output_dir}"/0003_1.txt

# Combine the chr and pos columns
awk 'NR == 1 {print $0, "predictor"; next} {print $0, $1 ":" $3}' "${output_dir}"/0003_1.txt > "${output_dir}"/0003_2.txt

# Add and n column
awk 'NR == 1 {print $0, "n"; next} {print $0, "33224"}' "${output_dir}"/0003_2.txt > "${output_dir}"/0003_3.txt
# 22.138 + 11.086 = 33.224

# I need to fix the p column
awk 'NR == 1 {print $0, "p"; next} {print $0, 10^-$8}' "${output_dir}"/0003_3.txt > "${output_dir}"/0003_fix.txt
# If s= -log10(p), then p = 10^-s

# Remove temporary files
rm "${output_dir}"/0003_1.txt
rm "${output_dir}"/0003_2.txt
rm "${output_dir}"/0003_3.txt
#################################

# Now I want to do it for all the files

# Warning - this takes quite a bit of time....
raw_dir="/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k_raw"
output_dir="/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k"

for file in "${raw_dir}"/*.txt; do
    filename=$(basename -- "$file")
    filename="${filename%.*}"
    echo "Processing ${filename}"
    awk '{$1 = ($1 ~ /^0/) ? substr($1, 2) : $1; print}' "${raw_dir}"/"${filename}".txt > "${output_dir}"/"${filename}"_1.txt
    awk 'NR == 1 {print $0, "predictor"; next} {print $0, $1 ":" $3}' "${output_dir}"/"${filename}"_1.txt > "${output_dir}"/"${filename}"_2.txt
    awk 'NR == 1 {print $0, "n"; next} {print $0, "33224"}' "${output_dir}"/"${filename}"_2.txt > "${output_dir}"/"${filename}"_3.txt
    awk 'NR == 1 {print $0, "p"; next} {print $0, 10^-$8}' "${output_dir}"/"${filename}"_3.txt > "${output_dir}"/"${filename}"_4.txt
    awk 'NR == 1 {$1="Chr"; $2="rsid"; $3="Pos"; $4="A1"; $5="A2"; $6="Direction"; $7="SE"; $8="pval(-log10)"; $9="Predictor"; $10="N"; $11="P"} 1' "${output_dir}"/"${filename}"_4.txt > "${output_dir}"/"${filename}_correct.txt"
    rm "${output_dir}"/"${filename}"_1.txt
    rm "${output_dir}"/"${filename}"_2.txt
    rm "${output_dir}"/"${filename}"_3.txt
    rm "${output_dir}"/"${filename}"_4.txt
done

######################################################################################################
# I need to remove duplicates and lines with multiple alleles

for file in "${output_dir}"/*.txt; do
    filename=$(basename -- "$file")
    filename="${filename%.*}"
    echo "Processing ${filename}"
    awk < "${output_dir}"/"${filename}".txt '(NR==1 || (length($4)+length($5)==2)){print $0}' > "${output_dir}"/"${filename}"_1.txt
    mv "${output_dir}"/"${filename}".txt "${output_dir}"/"${filename}".txt.old
    awk '!seen[$9]++' "${output_dir}"/"${filename}"_1.txt > "${output_dir}"/"${filename}".txt
    rm "${output_dir}"/"${filename}"_1.txt
done

######################################################################################################

###################################
# Sex specific #
###################################

# Directory for the raw sex specific files:
# /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex_raw

# Formatted files should be saved in:
# /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex

raw_dir="/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex_raw"
output_dir="/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex"

# For testing the code
head -n 10 "${raw_dir}"/0003.txt > "${output_dir}"/0003.txt

# Remove the 0 in the chr column if the first digit is a 0
awk '{$1 = ($1 ~ /^0/) ? substr($1, 2) : $1; print}' "${output_dir}"/0003.txt > "${output_dir}"/0003_1.txt

# Combine the chr and pos columns
awk 'NR == 1 {print $0, "predictor"; next} {print $0, $1 ":" $3}' "${output_dir}"/0003_1.txt > "${output_dir}"/0003_2.txt

# Add and n column
awk 'NR == 1 {print $0, "n"; next} {print $0, "22138"}' "${output_dir}"/0003_2.txt > "${output_dir}"/0003_3.txt

# Make seperate male and female files

# Male files - I want columns: 1, 2, 3, 4, 5, 7, 9, 11, 12, 13
awk '{print $1, $2, $3, $4, $5, $7, $9, $11, $13, $14}' "${output_dir}"/0003_3.txt > "${output_dir}"/0003_m.txt
# Fix the p column
awk 'NR == 1 {print $0, "p"; next} {print $0, 10^-$6}' "${output_dir}"/0003_m.txt > "${output_dir}"/0003_m_fix.txt
# rename the header for LDAK format: chr, rsid, pos, a1, a2, -Log10p, beta, se, predictor, n, p
awk 'NR == 1 {$1="chr"; $2="rsid"; $3="pos"; $4="a1"; $5="a2"; $6="-Log10p"; $7="beta"; $8="se"; $9="predictor"; $10="n"; $11="p"} 1' "${output_dir}"/0003_m_fix.txt > "${output_dir}"/0003_male.txt


# Female files - I want columns: 1, 2, 3, 4, 5, 6, 8, 10, 12, 13
awk '{print $1, $2, $3, $4, $5, $6, $8, $10, $13, $14}' "${output_dir}"/0003_3.txt > "${output_dir}"/0003_f.txt
# Fix the p column
awk 'NR == 1 {print $0, "p"; next} {print $0, 10^-$6}' "${output_dir}"/0003_f.txt > "${output_dir}"/0003_f_fix.txt
# rename the header for LDAK format: chr, rsid, pos, a1, a2, -Log10p, beta, se, predictor, n, p
awk 'NR == 1 {$1="chr"; $2="rsid"; $3="pos"; $4="a1"; $5="a2"; $6="-Log10p"; $7="beta"; $8="se"; $9="predictor"; $10="n"; $11="p"} 1' "${output_dir}"/0003_f_fix.txt > "${output_dir}"/0003_female.txt


# remove temporary files
rm "${output_dir}"/0003_1.txt
rm "${output_dir}"/0003_2.txt
rm "${output_dir}"/0003_3.txt
rm "${output_dir}"/0003_f.txt
rm "${output_dir}"/0003_f_fix.txt
rm "${output_dir}"/0003_m.txt
rm "${output_dir}"/0003_m_fix.txt

#################################

# Now I want to do it for all the files

raw_dir="/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex_raw"
output_dir="/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex"

for file in "${raw_dir}"/*.txt; do
    filename=$(basename -- "$file")
    filename="${filename%.*}"
    echo "Processing ${filename}"
    awk '{$1 = ($1 ~ /^0/) ? substr($1, 2) : $1; print}' "${raw_dir}"/"${filename}".txt > "${output_dir}"/"${filename}"_1.txt
    awk 'NR == 1 {print $0, "predictor"; next} {print $0, $1 ":" $3}' "${output_dir}"/"${filename}"_1.txt > "${output_dir}"/"${filename}"_2.txt
    awk 'NR == 1 {print $0, "n"; next} {print $0, "22138"}' "${output_dir}"/"${filename}"_2.txt > "${output_dir}"/"${filename}"_3.txt
    # Male files
    awk '{print $1, $2, $3, $4, $5, $7, $9, $11, $13, $14}' "${output_dir}"/"${filename}"_3.txt > "${output_dir}"/"${filename}"_m.txt
    awk 'NR == 1 {print $0, "p"; next} {print $0, 10^-$6}' "${output_dir}"/"${filename}"_m.txt > "${output_dir}"/"${filename}"_m_fix.txt
    awk 'NR == 1 {$1="Chr"; $2="rsid"; $3="Pos"; $4="A1"; $5="A2"; $6="-Log10p"; $7="Direction"; $8="SE"; $9="Predictor"; $10="N"; $11="P"} 1' "${output_dir}"/"${filename}"_m_fix.txt > "${output_dir}"/"${filename}_male.txt"
    # Female files
    awk '{print $1, $2, $3, $4, $5, $6, $8, $10, $13, $14}' "${output_dir}"/"${filename}"_3.txt > "${output_dir}"/"${filename}"_f.txt
    awk 'NR == 1 {print $0, "p"; next} {print $0, 10^-$6}' "${output_dir}"/"${filename}"_f.txt > "${output_dir}"/"${filename}"_f_fix.txt
    awk 'NR == 1 {$1="Chr"; $2="rsid"; $3="Pos"; $4="A1"; $5="A2"; $6="-Log10p"; $7="Direction"; $8="SE"; $9="Predictor"; $10="N"; $11="P"} 1' "${output_dir}"/"${filename}"_f_fix.txt > "${output_dir}"/"${filename}_female.txt"
    rm "${output_dir}"/"${filename}"_1.txt
    rm "${output_dir}"/"${filename}"_2.txt
    rm "${output_dir}"/"${filename}"_3.txt
    rm "${output_dir}"/"${filename}"_f.txt
    rm "${output_dir}"/"${filename}"_f_fix.txt
    rm "${output_dir}"/"${filename}"_m.txt
    rm "${output_dir}"/"${filename}"_m_fix.txt
done

######################################################################################################

# I want to check the length of the files
for file in "${output_dir}"/*.txt; do
    filename=$(basename -- "$file")
    filename="${filename%.*}"
    echo "Processing ${filename}"
    echo "Number of lines in ${filename}: $(wc -l < "${output_dir}"/"${filename}".txt)"
done


##### 
# I need to rename the headers for all files

# output_dir="/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex"

# for file in "${output_dir}"/*.txt; do
#     filename=$(basename -- "$file")
#     filename="${filename%.*}"
#     echo "Processing ${filename}"
#     awk 'NR == 1 {$1="Chr"; $2="rsid"; $3="Pos"; $4="A1"; $5="A2"; $6="-Log10p"; $7="Direction"; $8="SE"; $9="Predictor"; $10="N"; $11="P"} 1' "${output_dir}"/"${filename}".txt > "${output_dir}"/"${filename}_correct.txt"
# done

#################################
# Removing lines with multiple alleles
output_dir="/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex"

for file in "${output_dir}"/*.txt; do
    filename=$(basename -- "$file")
    filename="${filename%.*}"
    echo "Processing ${filename}"
    awk < "${output_dir}"/"${filename}".txt '(NR==1 || (length($4)+length($5)==2)){print $0}' > "${output_dir}"/"${filename}"_1.txt
    mv "${output_dir}"/"${filename}".txt "${output_dir}"/"${filename}".txt.old
    awk '!seen[$9]++' "${output_dir}"/"${filename}"_1.txt > "${output_dir}"/"${filename}".txt
    rm "${output_dir}"/"${filename}"_1.txt
done


#######################################################################################
awk < filename '(NR==1 || (length($4)+lenght($5)==2)){print $0}' > newfilename

awk < /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k/0003_fix_correct.txt '(NR==1 || (length($4)+length($5)==2)){print $0}' > /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k/0003_fix_correct1.txt

#################################

# Removing duplicates

awk < /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k/0003_fix_correct1.txt '{print $9}' | sort | uniq -d | head

This time, there are duplicates. While we could rename predictors to avoid duplicates, it is easier to simply remove all except one copy using this (magic) awk command (I don't fully understand how it works!)

mv /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k/0003_fix_correct1.txt /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k/0003_fix_correct1.txt.old
awk '!seen[$9]++' /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k/0003_fix_correct1.txt.old > /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k/0003_fix_correct1.txt



# Leyi's code
Rscript /home/caroline/dsmwpred/zly/RA/proj1_testprs_finngen_ukbb/code/ss_to_ldak_format.R --inputFile /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k_raw/0003.txt  --outputFile /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k/0003.txt  --bfile /home/caroline/dsmwpred/data/ukbb/geno2 --N 33224  

#################

Volume of grey matter (normalised for head size)
Volume of grey matter
Volume of white matter (normalised for head size)
Volume of white matter
Volume of brain, grey+white matter (normalised for head size)
Volume of brain, grey+white matter
Volume of ventricular cerebrospinal fluid (normalised for head size)
Volume of ventricular cerebrospinal fluid
Volume of hippocampus (left)
Volume of hippocampus (right)
Volume of grey matter in Superior Temporal Gyrus, anterior division (left)
Volume of grey matter in Superior Temporal Gyrus, anterior division (right)
Volume of grey matter in Superior Temporal Gyrus, posterior division (left)
Volume of grey matter in Superior Temporal Gyrus, posterior division (right)


#################################################
# Notes
##################################################
# I need to rename the headers for all files
output_dir="/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k"

for file in "${output_dir}"/*.txt; do
    filename=$(basename -- "$file")
    filename="${filename%.*}"
    echo "Processing ${filename}"
    awk 'NR == 1 {$1="Chr"; $2="rsid"; $3="Pos"; $4="A1"; $5="A2"; $6="Direction"; $7="SE"; $8="pval(-log10)"; $9="Predictor"; $10="N"; $11="P"} 1' "${output_dir}"/"${filename}".txt > "${output_dir}"/"${filename}_correct.txt"
done

#rm /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k/*correct.txt
#rm /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex/*correct.txt
#################
