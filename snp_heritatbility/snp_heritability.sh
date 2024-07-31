
PGCSZ_summary="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/PGC_EUR_SZ_geno2.txt"
PGCBP_summary="/home/caroline/dsmwpred/caroline/data/PGC_BP/PGC_BP.txt"
PGCMDD_summary="/home/caroline/dsmwpred/caroline/data/PGC_MDD/PGC_MDD.txt"
height="/home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/height.pheno.summaries"

tag_file="/home/caroline/dsmwpred/caroline/projects/prescriptions/genetic_correlation/data/tagging_HumDef.tagging"

touch "/home/caroline/dsmwpred/caroline/projects/genetic_correlation/scripts/snpher.sh"
        # Add content to the script
        echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred
#SBATCH -c 4
#SBATCH --time 4:00:00
#SBATCH --mem 32g
#SBATCH -o /home/caroline/dsmwpred/caroline/projects/genetic_correlation/out/log-%j

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --sum-hers /home/caroline/dsmwpred/caroline/projects/genetic_correlation/results/snpher/SZ_snpher \
 --summary ${PGCSZ_summary} \
 --tagfile ${tag_file} \
 --allow-ambiguous YES \
 --check-sums NO \
 --prevalence 0.01 \
 --ascertainment 0.40

 /home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --sum-hers /home/caroline/dsmwpred/caroline/projects/genetic_correlation/results/snpher/BP_snpher \
 --summary ${PGCBP_summary} \
 --tagfile ${tag_file} \
 --allow-ambiguous YES \
 --check-sums NO \
 --prevalence 0.01 \
 --ascertainment 0.10

  /home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --sum-hers /home/caroline/dsmwpred/caroline/projects/genetic_correlation/results/snpher/MDD_snpher \
 --summary ${PGCMDD_summary} \
 --tagfile ${tag_file} \
 --allow-ambiguous YES \
 --check-sums NO \
 --prevalence 0.15 \
 --ascertainment 0.30

  /home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --sum-hers /home/caroline/dsmwpred/caroline/projects/genetic_correlation/results/snpher/height_snpher \
 --summary ${height} \
 --tagfile ${tag_file} \
 --allow-ambiguous YES \
 --check-sums NO 

" > "/home/caroline/dsmwpred/caroline/projects/genetic_correlation/scripts/snpher.sh"

# Submit the jobs
sbatch /home/caroline/dsmwpred/caroline/projects/genetic_correlation/scripts/snpher.sh
squeue | grep caroline

