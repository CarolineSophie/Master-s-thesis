# Prescription results
find /home/caroline/dsmwpred/caroline/projects/prescriptions/prescription_GWAS/new \
 -name "*.summaries" \
 -exec cp {} /home/caroline/dsmwpred/caroline/projects/new_pheno/prescription \;

# In the folder /home/caroline/dsmwpred/caroline/projects/new_pheno/prescription I want to remove all files ending in SPA.summaries
find /home/caroline/dsmwpred/caroline/projects/new_pheno/prescription \
 -name "*SPA.summaries" \
 -exec rm {} \;

# I want to rename /home/caroline/dsmwpred/caroline/projects/new_pheno/prescription/n_antipsychotics.pheno_linear.summaries to /home/caroline/dsmwpred/caroline/projects/new_pheno/prescription/n_antipsychotics.pheno.summaries
mv /home/caroline/dsmwpred/caroline/projects/new_pheno/prescription/n_antipsychotics.pheno_linear.summaries /home/caroline/dsmwpred/caroline/projects/new_pheno/prescription/n_antipsychotics.pheno.summaries

 # I want to remove all files ending in linear.summaries
find /home/caroline/dsmwpred/caroline/projects/new_pheno/prescription \
    -name "*linear.summaries" \
    -exec rm {} \;