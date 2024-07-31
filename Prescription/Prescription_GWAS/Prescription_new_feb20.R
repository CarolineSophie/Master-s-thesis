library(qqman)
library(ggplot2)
library(tidyr)

# Load all the data in the /Users/caroline/Documents/Local_LDAK/projects/Prescription GWAS/new folder


antipsychotics <- read.table("/Users/caroline/Documents/Local_LDAK/projects/Prescription GWAS/new/antipsychotics.pheno_bin_spa.assoc", header = TRUE)
first_gen <- read.table("/Users/caroline/Documents/Local_LDAK/projects/Prescription GWAS/new/first_gen.pheno_bin_spa.assoc", header = TRUE)
second_gen <- read.table("/Users/caroline/Documents/Local_LDAK/projects/Prescription GWAS/new/second_gen.pheno_bin_spa.assoc", header = TRUE)
clozapine <- read.table("/Users/caroline/Documents/Local_LDAK/projects/Prescription GWAS/new/clozapine.pheno_bin_spa.assoc", header = TRUE)
n_antipsychotics <- read.table("/Users/caroline/Documents/Local_LDAK/projects/Prescription GWAS/new/n_antipsychotics.pheno_spa.assoc", header = TRUE)





# Tibble all of the data sets
antipsychotics <- tibble(antipsychotics)
first_gen <- tibble(first_gen)
second_gen <- tibble(second_gen)
clozapine <- tibble(clozapine)
n_antipsychotics <- tibble(n_antipsychotics)



# Make manhattan plots

# Antipsychotics
manhattan(antipsychotics, chr = "Chromosome", bp = "Basepair", p = "Score_P", snp = "Predictor", main = "Prescription of antipsychotics or not")

# First generation
manhattan(first_gen, chr = "Chromosome", bp = "Basepair", p = "Score_P", snp = "Predictor", main = "Prescription of first generation antipsychotics or not")

# Second generation
manhattan(second_gen, chr = "Chromosome", bp = "Basepair", p = "Score_P", snp = "Predictor", main = "Prescription of second generation antipsychotics or not")

# Clozapine
manhattan(clozapine, chr = "Chromosome", bp = "Basepair", p = "Score_P", snp = "Predictor", main = "Prescription of clozapine or not")

# Number of antipsychotics
manhattan(n_antipsychotics, chr = "Chromosome", bp = "Basepair", p = "Wald_P", snp = "Predictor", main = "Number of antipsychotics prescribed")

# Pval check
# I want all p-values less than 5e-8
p_antipsychotics <- which(antipsychotics$Score_P < 5e-8)
p_first_gen <- which(first_gen$Score_P < 5e-8)
p_second_gen <- which(second_gen$Score_P < 5e-8)
p_clozapine <- which(clozapine$Score_P < 5e-8)
p_n_antipsychotics <- which(n_antipsychotics$Wald_P < 5e-8)

p_ls <- list(p_antipsychotics, p_first_gen, p_second_gen, p_clozapine, p_n_antipsychotics)
p_ls


l <- rep(0, 5)
for(i in 1:length(p_ls)){
  l[i] <- length(p_ls[[i]])
}
l

# Make qq plots
qq(antipsychotics$Score_P, main = "Prescription of antipsychotics or not")
qq(first_gen$Score_P, main = "Prescription of first generation antipsychotics or not")
qq(second_gen$Score_P, main = "Prescription of second generation antipsychotics or not")
qq(clozapine$Score_P, main = "Prescription of clozapine or not")
qq(n_antipsychotics$Wald_P, main = "Number of antipsychotics prescribed")

# plots.dir.path <- list.files(tempdir(), pattern="rs-graphics", full.names = TRUE)
# plots.png.paths <- list.files(plots.dir.path, pattern=".png", full.names = TRUE)
# file.copy(from=plots.png.paths, to="/Users/caroline/Documents/Local_LDAK/Plots/prescription_gwas")
