/home/caroline/snpher/faststorage/biobank/phenotypes/height.txt

# Copy thee files to the correct directory

# Define the destination directory
destination_dir="/home/caroline/dsmwpred/caroline/projects/new_pheno"
 
 height="height_init.txt"

# Height
cp /home/caroline/snpher/faststorage/biobank/phenotypes/height.txt "$destination_dir/$height"

# Define the destination directory
destination_dir="/home/caroline/dsmwpred/caroline/projects/new_pheno"

height="height_init.txt"

awk '{print $1, $1, $2}' "$destination_dir/$height" | awk 'NR>1' > "$destination_dir/height.txt"

cp /home/caroline/dsmwpred/caroline/projects/new_pheno/height.txt /home/caroline/dsmwpred/caroline/projects/new_pheno/height.pheno

# Define the destination directory
destination_dir="/home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results"


for file in /home/caroline/dsmwpred/caroline/projects/new_pheno/*.pheno; do
filename=$(basename -- "$file")
# Create a new shell script file in each directory
touch "/home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/${filename}_GWAS.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred 
#SBATCH -c 4
#SBATCH --time 4:00:00 
#SBATCH --mem 32g

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
--linear ${destination_dir}/${filename} \
--bfile /home/caroline/dsmwpred/data/ukbb/geno2 \
--pheno ${file} \
--covar /home/caroline/dsmwpred/data/ukbb/geno.sex.townsend.age.pcs 
" > "/home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/${filename}_GWAS.sh"

done

# Submit the jobs
for i in /home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/*_GWAS.sh; do
    sbatch "$i"
done
squeue | grep caroline


################################################################
projects/More_phenotypes_for_genetic_correlation/genetic_corerlation.sh

# I want to compare SZ with the new phenotypes
# All the summary stats for those are saved in the following directory:
        # /home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results

        # I want all the summary files - the ones ending in .summaries

# A loop that creates scripts for the genetic correlation analysis for each of the summary files for the prescription phenotypes

/home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation # Where the scripts will be saved
/home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results # Where the results will be saved




for file in /home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/*.summaries; do
filename=$(basename -- "$file")

height="/home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/height.pheno.summaries"
tag_file="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/tagging_HumDef.tagging"

# Create a new shell script file in each directory
touch "/home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/height/${filename}_height_cor.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred 
#SBATCH -c 4
#SBATCH --time 4:00:00 
#SBATCH --mem 32g
#SBATCH -o /home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/height/logs/log-%j

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --sum-cors /home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results/height/${filename}_height_cor \
 --summary ${height} \
 --summary2 ${file} \
 --tagfile ${tag_file} \
 --allow-ambiguous YES

" > "/home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/height/${filename}_height_cor.sh"

done

################################################################
# I also want it for the prescription phenotypes

for file in /home/caroline/dsmwpred/caroline/projects/new_pheno/prescription/*.summaries; do
filename=$(basename -- "$file")

height="/home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/height.pheno.summaries"
tag_file="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/tagging_HumDef.tagging"

# Create a new shell script file in each directory
touch "/home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/height/${filename}_height_prescription_cor.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred 
#SBATCH -c 4
#SBATCH --time 4:00:00 
#SBATCH --mem 32g
#SBATCH -o /home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/height/logs/log-%j

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --sum-cors /home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results/height/${filename}_height_cor \
 --summary ${height} \
 --summary2 ${file} \
 --tagfile ${tag_file} \
 --allow-ambiguous YES

" >  "/home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/height/${filename}_height_prescription_cor.sh"

done

# Submit the jobs
for i in /home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/height/*; do sbatch $i; done
squeue | grep caroline