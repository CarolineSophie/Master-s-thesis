# Now I want to create a manhattan plot for each phenotypee from the GWAS.

# Load R
conda activate caroline
R

# Load the data.table library
library(data.table)

# Load all the .assoc data files
psychage <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/psychage.pheno.assoc")
handed <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/handed.pheno.assoc")
vitamin_d <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/vitamin_d.pheno.assoc")
month <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/month.pheno.assoc")
insomnia_cont <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/insomnia_cont.pheno.assoc")
insomnia_bin <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/insomnia_bin.pheno.assoc")
ever_smoked <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/ever_smoked.pheno.assoc")
cannabis <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/cannabis.pheno.assoc")
cannabis_hu <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/cannabis_hu.pheno.assoc")
awake <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/GWAS_results/awake.pheno.assoc")

# Load the necessary libraries
library(ggplot2)
# install.packages("qqman")
library(qqman)


# Psychage
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/manhattan/psychage.png')
manhattan(
    psychage,
    chr = "Chromosome",
    bp = "Basepair",
    p = "Wald_P",
    snp = "Predictor",
    main = "Psychage",
    col = c("blue4", "lightblue"),
    genomewideline = TRUE,
    cex.axis = 1.2,
    cex.main = 1.5,
    cex.lab = 1.2
)
dev.off()

# Handed
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/manhattan/handed.png')
manhattan(
    handed,
    chr = "Chromosome",
    bp = "Basepair",
    p = "Wald_P",
    snp = "Predictor",
    main = "Handed",
    col = c("blue4", "lightblue"),
    genomewideline = TRUE,
    cex.axis = 1.2,
    cex.main = 1.5,
    cex.lab = 1.2
)
dev.off()

# Vitamin D
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/manhattan/vitamin_d.png')
manhattan(
    vitamin_d,
    chr = "Chromosome",
    bp = "Basepair",
    p = "Wald_P",
    snp = "Predictor",
    main = "Vitamin D",
    col = c("blue4", "lightblue"),
    genomewideline = TRUE,
    cex.axis = 1.2,
    cex.main = 1.5,
    cex.lab = 1.2
)
dev.off()

# Month
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/manhattan/month.png')
manhattan(
    month,
    chr = "Chromosome",
    bp = "Basepair",
    p = "Wald_P",
    snp = "Predictor",
    main = "Month",
    col = c("blue4", "lightblue"),
    genomewideline = TRUE,
    cex.axis = 1.2,
    cex.main = 1.5,
    cex.lab = 1.2
)
dev.off()

# Insomnia Cont
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/manhattan/insomnia_cont.png')
manhattan(
    insomnia_cont,
    chr = "Chromosome",
    bp = "Basepair",
    p = "Wald_P",
    snp = "Predictor",
    main = "Insomnia Cont",
    col = c("blue4", "lightblue"),
    genomewideline = TRUE,
    cex.axis = 1.2,
    cex.main = 1.5,
    cex.lab = 1.2
)
dev.off()

# Insomnia Bin
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/manhattan/insomnia_bin.png')
manhattan(
    insomnia_bin,
    chr = "Chromosome",
    bp = "Basepair",
    p = "Wald_P",
    snp = "Predictor",
    main = "Insomnia Bin",
    col = c("blue4", "lightblue"),
    genomewideline = TRUE,
    cex.axis = 1.2,
    cex.main = 1.5,
    cex.lab = 1.2
)
dev.off()

# Ever Smoked
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/manhattan/ever_smoked.png')
manhattan(
    ever_smoked,
    chr = "Chromosome",
    bp = "Basepair",
    p = "Wald_P",
    snp = "Predictor",
    main = "Ever Smoked",
    col = c("blue4", "lightblue"),
    genomewideline = TRUE,
    cex.axis = 1.2,
    cex.main = 1.5,
    cex.lab = 1.2
)
dev.off()

# Cannabis
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/manhattan/cannabis.png')
manhattan(
    cannabis,
    chr = "Chromosome",
    bp = "Basepair",
    p = "Wald_P",
    snp = "Predictor",
    main = "Cannabis",
    col = c("blue4", "lightblue"),
    genomewideline = TRUE,
    cex.axis = 1.2,
    cex.main = 1.5,
    cex.lab = 1.2
)
dev.off()

# Cannabis HU
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/manhattan/cannabis_hu.png')
manhattan(
    cannabis_hu,
    chr = "Chromosome",
    bp = "Basepair",
    p = "Wald_P",
    snp = "Predictor",
    main = "Cannabis HU",
    col = c("blue4", "lightblue"),
    genomewideline = TRUE,
    cex.axis = 1.2,
    cex.main = 1.5,
    cex.lab = 1.2
)
dev.off()

# Awake
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/manhattan/awake.png')
manhattan(
    awake,
    chr = "Chromosome",
    bp = "Basepair",
    p = "Wald_P",
    snp = "Predictor",
    main = "Awake",
    col = c("blue4", "lightblue"),
    genomewideline = TRUE,
    cex.axis = 1.2,
    cex.main = 1.5,
    cex.lab = 1.2
)
dev.off()