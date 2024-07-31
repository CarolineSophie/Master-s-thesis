# I want to compare SZ with the new phenotypes
# All the summary stats for those are saved in the following directory:
        # /home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results

        # I want all the summary files - the ones ending in .summaries

# A loop that creates scripts for the genetic correlation analysis for each of the summary files for the prescription phenotypes

/home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation # Where the scripts will be saved
/home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results # Where the results will be saved




for file in /home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/*.summaries; do
filename=$(basename -- "$file")

PGCSZ_summary="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/PGC_EUR_SZ_geno2.txt"
tag_file="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/tagging_HumDef.tagging"

# Create a new shell script file in each directory
touch "/home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/${filename}_cor.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred 
#SBATCH -c 4
#SBATCH --time 4:00:00 
#SBATCH --mem 32g
#SBATCH -o /home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/logs/log-%j

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --sum-cors /home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results/${filename}_cor \
 --summary ${PGCSZ_summary} \
 --summary2 ${file} \
 --tagfile ${tag_file} \
 --allow-ambiguous YES

" > "/home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/${filename}_cor.sh"

done

# Submit the jobs
for i in /home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/*.sh; do sbatch $i; done
squeue | grep caroline

##############################################################

