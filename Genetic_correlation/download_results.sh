# This files downloads the results from the genetic correlation analysis


# SZ correlation
find /home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results \
 -name "*.cors" \
 -exec cp {} /home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results/download \;


 cp /home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results/*.cors /home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results/download

# MDD correlation
find /home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results/MDD \
 -name "*.cors" \
 -exec cp {} /home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results/MDD/download \;

# BP correlation
find /home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results/BP \
 -name "*.cors" \
 -exec cp {} /home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results/BP/download \;

# Height correlation
find /home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results/height \
 -name "*.cors" \
 -exec cp {} /home/caroline/dsmwpred/caroline/projects/new_pheno/genetic_correlation_results/height/download \;

#################################################################################################################

# The new prescription genetic correlation analysis

find /home/caroline/dsmwpred/caroline/projects/prescription_2/genetic_correlation/results \
 -name "*.cors" \
 -exec cp {} /home/caroline/dsmwpred/caroline/projects/prescription_2/genetic_correlation/results/download \;

################

# The new prescription GWAS

find /home/caroline/dsmwpred/caroline/projects/prescription_2/GWAS \
 -name "*.assoc" \
 -exec cp {} /home/caroline/dsmwpred/caroline/projects/prescription_2/GWAS/download \;
