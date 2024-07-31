# This is the file for the genetic correlation for the brain imaging data

# I want to compare SZ with the new 33k imaging phenotypes
# All the summary stats for those are saved in the following directory:
        # //home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k

        # I want all the summary files - the ones ending in .txt

# A loop that creates scripts for the genetic correlation analysis for each of the summary files for the imaging phenotypes

/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts # Where the scripts will be saved
/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/results # Where the results will be saved



# SZ __________________________________________________________________________________________
for file in /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k/*correct.txt; do
filename=$(basename -- "$file")

PGCSZ_summary="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/PGC_EUR_SZ_geno2.txt"
tag_file="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/tagging_HumDef.tagging"

# Create a new shell script file in each directory
touch "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/${filename}_SZ.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred 
#SBATCH -c 4
#SBATCH --time 4:00:00 
#SBATCH --mem 32g
#SBATCH -o /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/logs/log-%j

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
--sum-cors /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/results/33k_SZ/${filename}_SZ_cor \
--summary ${PGCSZ_summary} \
--summary2 ${file} \
--tagfile ${tag_file} \
--allow-ambiguous YES \
--check-sums NO

" > "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/${filename}_SZ.sh"

done
#________________________________________________________________________________________

# MDD __________________________________________________________________________________________
for file in /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k/*correct.txt; do
filename=$(basename -- "$file")

PGCMDD_summary="/home/caroline/dsmwpred/caroline/data/PGC_MDD/PGC_MDD.txt"
tag_file="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/tagging_HumDef.tagging"

# Create a new shell script file in each directory
touch "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/${filename}_MDD.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 4
#SBATCH --time 4:00:00
#SBATCH --mem 32g
#SBATCH -o /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/logs/log-%j

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
--sum-cors /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/results/33k_MDD/${filename}_MDD_cor \
--summary ${PGCMDD_summary} \
--summary2 ${file} \
--tagfile ${tag_file} \
--allow-ambiguous YES \
--check-sums NO

" > "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/${filename}_MDD.sh"

done
#________________________________________________________________________________________

# BP __________________________________________________________________________________________
for file in /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k/*correct.txt; do
filename=$(basename -- "$file")

PGCBP_summary="/home/caroline/dsmwpred/caroline/data/PGC_BP/PGC_BP.txt"
tag_file="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/tagging_HumDef.tagging"

# Create a new shell script file in each directory
touch "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/${filename}_BP.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 4
#SBATCH --time 4:00:00
#SBATCH --mem 32g
#SBATCH -o /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/logs/log-%j

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
--sum-cors /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/results/33k_BP/${filename}_BP_cor \
--summary ${PGCBP_summary} \
--summary2 ${file} \
--tagfile ${tag_file} \
--allow-ambiguous YES \
--check-sums NO

" > "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/${filename}_BP.sh"

done
#________________________________________________________________________________________

# Height __________________________________________________________________________________________
for file in /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k/*correct.txt; do
filename=$(basename -- "$file")

height="/home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/height.pheno.summaries"
tag_file="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/tagging_HumDef.tagging"

# Create a new shell script file in each directory
touch "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/${filename}_height.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 4
#SBATCH --time 4:00:00
#SBATCH --mem 32g
#SBATCH -o /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/logs/log-%j

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
--sum-cors /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/results/33k_height/${filename}_height_cor \
--summary ${height} \
--summary2 ${file} \
--tagfile ${tag_file} \
--allow-ambiguous YES \
--check-sums NO

" > "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/${filename}_height.sh"

done
#________________________________________________________________________________________


# I also want it for the sex-specific files
# The files are located in the following directory:
# /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex

# SZ __________________________________________________________________________________________
for file in /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex/*.txt; do
filename=$(basename -- "$file")

PGCSZ_summary="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/PGC_EUR_SZ_geno2.txt"
tag_file="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/tagging_HumDef.tagging"

# Create a new shell script file in each directory
touch "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/sex/${filename}_SZ_sex.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 4
#SBATCH --time 4:00:00
#SBATCH --mem 32g
#SBATCH -o /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/logs/log-%j

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
--sum-cors /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/results/22k_sex_SZ/${filename}_sex_SZ_cor \
--summary ${PGCSZ_summary} \
--summary2 ${file} \
--tagfile ${tag_file} \
--allow-ambiguous YES \
--check-sums NO

" > "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/sex/${filename}_SZ_sex.sh"

done
#________________________________________________________________________________________

# MDD __________________________________________________________________________________________
for file in /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex/*.txt; do
filename=$(basename -- "$file")

PGCMDD_summary="/home/caroline/dsmwpred/caroline/data/PGC_MDD/PGC_MDD.txt"
tag_file="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/tagging_HumDef.tagging"

# Create a new shell script file in each directory
touch "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/sex/${filename}_MDD_sex.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 4
#SBATCH --time 4:00:00
#SBATCH --mem 32g
#SBATCH -o /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/logs/log-%j

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
--sum-cors /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/results/22k_sex_MDD/${filename}_MDD_sex_cor \
--summary ${PGCMDD_summary} \
--summary2 ${file} \
--tagfile ${tag_file} \
--allow-ambiguous YES \
--check-sums NO

" > "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/sex/${filename}_MDD_sex.sh"

done
#________________________________________________________________________________________

# BP __________________________________________________________________________________________
for file in /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex/*.txt; do
filename=$(basename -- "$file")

PGCBP_summary="/home/caroline/dsmwpred/caroline/data/PGC_BP/PGC_BP.txt"
tag_file="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/tagging_HumDef.tagging"

# Create a new shell script file in each directory
touch "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/sex/${filename}_BP_sex.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 4
#SBATCH --time 4:00:00
#SBATCH --mem 32g
#SBATCH -o /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/logs/log-%j

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
--sum-cors /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/results/22k_sex_BP/${filename}_BP_sex_cor \
--summary ${PGCBP_summary} \
--summary2 ${file} \
--tagfile ${tag_file} \
--allow-ambiguous YES \
--check-sums NO

" > "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/sex/${filename}_BP_sex.sh"

done
#________________________________________________________________________________________

# Height __________________________________________________________________________________________
for file in /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex/*.txt; do
filename=$(basename -- "$file")

height="/home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/height.pheno.summaries"
tag_file="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/tagging_HumDef.tagging"

# Create a new shell script file in each directory
touch "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/sex/${filename}_height_sex.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 4
#SBATCH --time 4:00:00
#SBATCH --mem 32g
#SBATCH -o /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/logs/log-%j

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
--sum-cors /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/results/22k_sex_height/${filename}_height_sex_cor \
--summary ${height} \
--summary2 ${file} \
--tagfile ${tag_file} \
--allow-ambiguous YES \
--check-sums NO

" > "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/sex/${filename}_height_sex.sh"

done
#________________________________________________________________________________________



# Submit the jobs
for i in /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/*.sh; do sbatch $i; done
squeue | grep caroline

# Submit sex specific the jobs
for i in /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/scripts/sex/*.sh; do sbatch $i; done
squeue | grep caroline

##############################################################

# Downloading the results
find /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/results \
 -name "*.cors" \
 -exec cp {} /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/results/download \;
 
###############################################################################

# Test
/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --sum-cors /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex/0003_female_correct.txt \
 --summary /home/caroline/dsmwpred/caroline/data/PGC_BP/PGC_BP.txt \
 --summary2 /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k/0003_correct.txt \
 --tagfile /home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/tagging_HumDef.tagging \
 --allow-ambiguous YES \
 --check-sums NO

