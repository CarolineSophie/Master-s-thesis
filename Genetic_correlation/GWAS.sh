psychage "/home/caroline/dsmwpred/caroline/projects/new_pheno/psychage.pheno"
handed "/home/caroline/dsmwpred/caroline/projects/new_pheno/handed.pheno"
month "/home/caroline/dsmwpred/caroline/projects/new_pheno/month.pheno"
insomnia_cont "/home/caroline/dsmwpred/caroline/projects/new_pheno/insomnia_cont.pheno"
insomnia_bin "/home/caroline/dsmwpred/caroline/projects/new_pheno/insomnia_bin.pheno"
ever_smoked "/home/caroline/dsmwpred/caroline/projects/new_pheno/ever_smoked.pheno"
cannabis "/home/caroline/dsmwpred/caroline/projects/new_pheno/cannabis.pheno"
cannabis_hu "/home/caroline/dsmwpred/caroline/projects/new_pheno/cannabis_hu.pheno"
awake "/home/caroline/dsmwpred/caroline/projects/new_pheno/awake_init.txt"
vitamin_d "/home/caroline/dsmwpred/caroline/projects/new_pheno/vitamin_d_init.txt"

# Copy awake and vitamin D files to make .pheno
cp /home/caroline/dsmwpred/caroline/projects/new_pheno/awake_init.txt /home/caroline/dsmwpred/caroline/projects/new_pheno/awake.pheno
cp /home/caroline/dsmwpred/caroline/projects/new_pheno/vitamin_d_init.txt /home/caroline/dsmwpred/caroline/projects/new_pheno/vitamin_d.pheno

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