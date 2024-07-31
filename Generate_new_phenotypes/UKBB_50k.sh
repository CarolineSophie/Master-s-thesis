# Goal:
    # To create a genotype file with 50k individuals from the cleaned UK biobank data geno2.bed/bim/fam
    # Geno file stored: /home/caroline/dsmwpred/data/ukbb/geno2.bed

    # The new 50k data file should include all individuals from the geno2.bed file diagnosed with SZ, and then a random selection of individuals from the geno2 files
    # The SZ individuals are stored in the file /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20.pheno


# First step is to extract the SZ individuals from the F20.pheno file
awk '$3 == 1 {print $1, $2, $3}' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20.pheno > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20_only.pheno

wc -l /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20_only.pheno
# 1082

# Secondly we want to identify the SZ individuals in the geno2 file

awk '{print $1}' /home/caroline/dsmwpred/data/ukbb/geno2.fam > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/ukbb_ids.txt
awk '{print $1}' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20_only.pheno > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/sz_ids.txt
awk 'NR==FNR{a[$1];next} ($1 in a)' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/sz_ids.txt /home/caroline/dsmwpred/caroline/data/UKBB_SZ/ukbb_ids.txt > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/sz_ids2.txt

rm /home/caroline/dsmwpred/caroline/data/UKBB_SZ/sz_ids.txt

# I now want to use these ids to create a file with the SZ individuals from the geno2 file and then a random selection of individuals from the geno2 file
# First I need to create a file with the random selection of individuals

# I create a file without the SZ individuals
awk 'NR==FNR{a[$1];next} !($1 in a)' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/sz_ids2.txt /home/caroline/dsmwpred/caroline/data/UKBB_SZ/ukbb_ids.txt > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/ukbb_ids2.txt

# I want to know how many individuals I should choose at random from the ukbb_ids2.txt file

SZ_length=$(wc -l < /home/caroline/dsmwpred/caroline/data/UKBB_SZ/sz_ids2.txt)
n_individuals=$((50000 - SZ_length))

echo "The number of individuals to choose at random is: $n_individuals"

# I now want to choose n_individuals at random from the ukbb_ids2.txt file
shuf /home/caroline/dsmwpred/caroline/data/UKBB_SZ/ukbb_ids2.txt | head -n $n_individuals > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/random_rows.txt

# Then I want to combine the random_rows.txt file with the sz_ids2.txt file
cat /home/caroline/dsmwpred/caroline/data/UKBB_SZ/sz_ids2.txt /home/caroline/dsmwpred/caroline/data/UKBB_SZ/random_rows.txt > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/SZ_50k_ids.txt

# Remove the files that are no longer needed
rm /home/caroline/dsmwpred/caroline/data/UKBB_SZ/sz_ids2.txt
rm /home/caroline/dsmwpred/caroline/data/UKBB_SZ/random_rows.txt
rm /home/caroline/dsmwpred/caroline/data/UKBB_SZ/ukbb_ids2.txt
rm /home/caroline/dsmwpred/caroline/data/UKBB_SZ/ukbb_ids.txt


# Now I want to use the SZ_50k_ids.txt file to create a genotype file with the selected 50k individuals
# First I duplicate the id column in the /home/caroline/dsmwpred/caroline/data/UKBB_SZ/SZ_50k_ids.txt file
awk '{print $1,$1}' /home/caroline/dsmwpred/caroline/data/UKBB_SZ/SZ_50k_ids.txt > /home/caroline/dsmwpred/caroline/data/UKBB_SZ/SZ_50k_ids2.txt

# Then I use the SZ_50k_ids2.txt file to create the genotype file
# I use the LDAK command --make-bed to create the genotype file
# I keep only the individuals in the SZ_50k_ids2.txt file using the --keep command
/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
    --make-bed /home/caroline/dsmwpred/caroline/data/UKBB_SZ/sz_geno2 \
    --bfile /home/caroline/dsmwpred/data/ukbb/geno2 \
    --keep /home/caroline/dsmwpred/caroline/data/UKBB_SZ/SZ_50k_ids2.txt 

