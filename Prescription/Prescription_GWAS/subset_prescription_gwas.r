library(qqman)
library(ggplot2)
library(tidyr)

# Load all the data in the /Users/caroline/Documents/Local_LDAK/projects/Prescription GWAS/Subset_prescription folder

antipsychotics <- read.table("/Users/caroline/Documents/Local_LDAK/projects/Prescription GWAS/Subset_prescription/antipsychotics_subset.pheno_bin.assoc", header = TRUE)
first_gen <- read.table("/Users/caroline/Documents/Local_LDAK/projects/Prescription GWAS/Subset_prescription/first_gen_subset.pheno_bin.assoc", header = TRUE)
second_gen <- read.table("/Users/caroline/Documents/Local_LDAK/projects/Prescription GWAS/Subset_prescription/second_gen_subset.pheno_bin.assoc", header = TRUE)
n_antipsychotics <- read.table("/Users/caroline/Documents/Local_LDAK/projects/Prescription GWAS/Subset_prescription/n_antipsychotics_subset.pheno.assoc", header = TRUE)


antipsychotics_spa <- read.table("/Users/caroline/Documents/Local_LDAK/projects/Prescription GWAS/subset_SPA/antipsychotics_subset.pheno_bin_spa.assoc", header = TRUE)
first_gen_spa <- read.table("/Users/caroline/Documents/Local_LDAK/projects/Prescription GWAS/subset_SPA/first_gen_subset.pheno_bin_spa.assoc", header = TRUE)
second_gen_spa <- read.table("/Users/caroline/Documents/Local_LDAK/projects/Prescription GWAS/subset_SPA/second_gen_subset.pheno_bin_spa.assoc", header = TRUE)
n_antipsychotics_spa <- read.table("/Users/caroline/Documents/Local_LDAK/projects/Prescription GWAS/subset_SPA/n_antipsychotics_subset.pheno_spa.assoc", header = TRUE)




# Tibble all of the data sets
antipsychotics <- tibble(antipsychotics)
first_gen <- tibble(first_gen)
second_gen <- tibble(second_gen)
n_antipsychotics <- tibble(n_antipsychotics)

antipsychotics_spa <- tibble(antipsychotics_spa)
first_gen_spa <- tibble(first_gen_spa)
second_gen_spa <- tibble(second_gen_spa)
n_antipsychotics_spa <- tibble(n_antipsychotics_spa)

# Make a table for presenting
knitr::kable(antipsychotics[1:20,])
knitr::kable(first_gen[1:20,])
knitr::kable(second_gen[1:20,])
knitr::kable(n_antipsychotics[1:20,])

# Make manhattan plots

# Antipsychotics
manhattan(antipsychotics, chr = "Chromosome", bp = "Basepair", p = "Score_P", snp = "Predictor", main = "Prescription of antipsychotics or not")
manhattan(antipsychotics_spa, chr = "Chromosome", bp = "Basepair", p = "Score_P", snp = "Predictor", main = "Prescription of antipsychotics or not SPA")

# First generation
manhattan(first_gen, chr = "Chromosome", bp = "Basepair", p = "Score_P", snp = "Predictor", main = "Prescription of first generation antipsychotics or not")
manhattan(first_gen_spa, chr = "Chromosome", bp = "Basepair", p = "Score_P", snp = "Predictor", main = "Prescription of first generation antipsychotics or not SPA")

# Second generation
manhattan(second_gen, chr = "Chromosome", bp = "Basepair", p = "Score_P", snp = "Predictor", main = "Prescription of second generation antipsychotics or not")
manhattan(second_gen_spa, chr = "Chromosome", bp = "Basepair", p = "Score_P", snp = "Predictor", main = "Prescription of second generation antipsychotics or not SPA")

# Number of antipsychotics
manhattan(n_antipsychotics, chr = "Chromosome", bp = "Basepair", p = "Wald_P", snp = "Predictor", main = "Number of antipsychotics prescribed")
manhattan(n_antipsychotics_spa, chr = "Chromosome", bp = "Basepair", p = "Wald_P", snp = "Predictor", main = "Number of antipsychotics prescribed SPA")

# Pval check
# I want all p-values less than 5e-8
p_antipsychotics <- which(antipsychotics$Score_P < 5e-8)
p_first_gen <- which(first_gen$Score_P < 5e-8)
p_second_gen <- which(second_gen$Score_P < 5e-8)
p_n_antipsychotics <- which(n_antipsychotics$Wald_P < 5e-8)

# Make qq plots
qq(antipsychotics$Score_P, main = "Prescription of antipsychotics or not")
qq(first_gen$Score_P, main = "Prescription of first generation antipsychotics or not")
qq(second_gen$Score_P, main = "Prescription of second generation antipsychotics or not")
qq(n_antipsychotics$Wald_P, main = "Number of antipsychotics prescribed")


# plots.dir.path <- list.files(tempdir(), pattern="rs-graphics", full.names = TRUE)
# plots.png.paths <- list.files(plots.dir.path, pattern=".png", full.names = TRUE)
# file.copy(from=plots.png.paths, to="/Users/caroline/Documents/Local_LDAK/Plots/subset")
