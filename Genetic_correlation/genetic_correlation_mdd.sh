/home/caroline/dsmwpred/caroline/data/PGC_BP/daner_bip_pgc3_nm_noukbiobank

# I want to compare SZ with the new phenotypes
# All the summary stats for those are saved in the following directory:
        # /home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results

        # I want all the summary files - the ones ending in .summaries

# A loop that creates scripts for the genetic correlation analysis for each of the summary files for the prescription phenotypes

/home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/BP # Where the scripts will be saved
/home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results/BP # Where the results will be saved




for file in /home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/*.summaries; do
filename=$(basename -- "$file")

PGCMDD_summary="/home/caroline/dsmwpred/caroline/data/PGC_MDD/PGC_MDD.txt"
tag_file="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/tagging_HumDef.tagging"

# Create a new shell script file in each directory
touch "/home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/${filename}_MDDcor.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred 
#SBATCH -c 4
#SBATCH --time 4:00:00 
#SBATCH --mem 32g
#SBATCH -o /home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/MDD/logs/log-%j

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --sum-cors /home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results/MDD/${filename}_MDDcor \
 --summary ${PGCMDD_summary} \
 --summary2 ${file} \
 --tagfile ${tag_file} \
 --allow-ambiguous YES \
 --check-sums NO

" > "/home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/MDD/${filename}_MDDcor.sh"

done


#################################################
# I also want it for the prescription phenotypes

for file in /home/caroline/dsmwpred/caroline/projects/new_pheno/prescription/*.summaries; do
filename=$(basename -- "$file")

PGCMDD_summary="/home/caroline/dsmwpred/caroline/data/PGC_MDD/PGC_MDD.txt"
tag_file="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/tagging_HumDef.tagging"

# Create a new shell script file in each directory
touch "/home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/MDD/${filename}_MDD_prescription_cor.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred 
#SBATCH -c 4
#SBATCH --time 4:00:00 
#SBATCH --mem 32g
#SBATCH -o /home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/MDD/logs/log-%j

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --sum-cors /home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results/MDD/${filename}_MDD_cor \
 --summary ${PGCMDD_summary} \
 --summary2 ${file} \
 --tagfile ${tag_file} \
 --allow-ambiguous YES \
 --check-sums NO

" >  "/home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/MDD/${filename}_MDD_prescription_cor.sh"

done

# Submit the jobs
for i in /home/caroline/dsmwpred/caroline/projects/new_pheno/scripts/genetic_correlation/MDD/*.sh; do sbatch $i; done
squeue | grep caroline