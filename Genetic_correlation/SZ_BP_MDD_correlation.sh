# I also want to do a genetic correlation between SZ and BP and SZ and MDD

for file in /home/caroline/dsmwpred/caroline/projects/new_pheno/prescription/*.summaries; do
filename=$(basename -- "$file")

PGCBP_summary="/home/caroline/dsmwpred/caroline/data/PGC_BP/PGC_BP.txt"
tag_file="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/tagging_HumDef.tagging"

# Create a new shell script file in each directory
touch "/home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/BP/${filename}_BP_prescription_cor.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred 
#SBATCH -c 4
#SBATCH --time 4:00:00 
#SBATCH --mem 32g
#SBATCH -o /home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/BP/logs/log-%j

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --sum-cors /home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results/BP/${filename}_BP_cor \
 --summary ${PGCBP_summary} \
 --summary2 ${file} \
 --tagfile ${tag_file} \
 --allow-ambiguous YES

" >  "/home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/BP/${filename}_BP_prescription_cor.sh"

done


# Submit the jobs
for i in /home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/BP/*.sh; do sbatch $i; done
squeue | grep caroline