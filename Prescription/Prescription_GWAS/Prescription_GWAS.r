
# load the summary statistics for schizophrenia for the european ancestry
pgc_sz <- read.table("/home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/European.txt", head = TRUE)

# Load the summary statistics for the prescription GWAS
sz_prescription <- read.table("/home/caroline/dsmwpred/caroline/projects/prescriptions/prescription_GWAS/n_antipsychotics.assoc", head = TRUE)

# Print information about the genome-wide significant SNPs for comparison with the summary stats for SZ
sz_prescription[which(sz_prescription$Wald_P < 5e-08), ]

# Is there overlap with the PGC SZ GWAS?
#        Chromosome   Predictor  Basepair A1 A2 Wald_Stat     Wald_P  Effect      SD Effect_Liability
# 331092          8 8:141376981 141376981  C  T    5.4605 4.7486e-08 1.13230 0.20736               NA
# 368628         10 10:29017361  29017361  A  T    5.4562 4.8638e-08 0.96484 0.17683               NA
# 424811         12  12:5994447   5994447  A  G    5.9569 2.5708e-09 0.70279 0.11798               NA
# 482002         14 14:54188200  54188200  G  T    6.1301 8.7824e-10 0.88574 0.14449               NA
# 545258         17 17:35569330  35569330  G  A    5.6839 1.3166e-08 0.91266 0.16057               NA
# 546322         17 17:40010070  40010070  A  G    5.4826 4.1913e-08 0.77118 0.14066               NA
#        SD_Liability  A1_Mean      MAF
# 331092           NA 0.021893 0.010947
# 368628           NA 0.030503 0.015251
# 424811           NA 0.069334 0.034667
# 482002           NA 0.045854 0.022927
# 545258           NA 0.036881 0.018441
# 546322           NA 0.048208 0.024104

# These are the SNPs that are genome-wide significant for the prescription GWAS

# I want the predictor for these SNPs
sz_prescription[which(sz_prescription$Wald_P < 5e-08), 2]

# I want to check if these SNPs are in the PGC SZ GWAS
pgc_sz$Predictor %in% sz_prescription[which(sz_prescription$Wald_P < 5e-08), 2]





# I want to check if these SNPs are in the PGC SZ GWAS
pgc_sz[which(pgc_sz$Predictor %in% sz_prescription[which(sz_prescription$Wald_P < 5e-08), 2]), ]

# I now want to check if these SNPs are also genome-wide significant in the PGC SZ GWAS
pgc_sz[which(pgc_sz$Predictor %in% sz_prescription[which(sz_prescription$Wald_P < 5e-08), 2]), 7]

which(pgc_sz[which(pgc_sz$Predictor %in% sz_prescription[which(sz_prescription$Wald_P < 5e-08), 2]), 7] < 5e-08)


###############################################################################

# Load the data files

# Antipsychotics
antipsychotics_logistic <- read.table("~/Downloads/antipsychotics_binary_logistic.assoc", head = TRUE, fill = TRUE, na.strings = "")





antipsychotics_linear <- read.table("~/Downloads/antipsychotics_binary.assoc", head = TRUE, fill = TRUE, na.strings = "")

# Clozapine
clozapine_logistic <- read.table("~/Downloads/clozapine_logistic.assoc", head = TRUE, fill = TRUE, na.strings = "")
clozapine_linear <- read.table("~/Downloads/clozapine.linear.assoc", head = TRUE, fill = TRUE, na.strings = "")

# First generation antipsychotics
first_gen_logistic <- read.table("~/Downloads/first_gen_logistic.assoc", head = TRUE, fill = TRUE, na.strings = "")
first_gen_linear <- read.table("~/Downloads/first_gen.linear.assoc", head = TRUE, fill = TRUE, na.strings = "")

# Second generation antipsychotics
second_gen_logistic <- read.table("~/Downloads/second_gen_logistic.assoc", head = TRUE, fill = TRUE, na.strings = "")
second_gen_linear <- read.table("~/Downloads/second_gen.linear.assoc", head = TRUE, fill = TRUE)

# Number of antipsychotics
n_antipsychotics <- read.table("~/Downloads/n_antipsychotics.assoc", head = TRUE, fill = TRUE, na.strings = "")


# Load the phenotype files

antipsychotics_pheno <- read.table("~/Downloads/antipsychotics.pheno", head = TRUE, fill = TRUE, na.strings = "")
clozapine_pheno <- read.table("~/Downloads/clozapine.pheno", head = TRUE, fill = TRUE, na.strings = "")
first_gen_pheno <- read.table("~/Downloads/first_gen.pheno", head = TRUE, fill = TRUE, na.strings = "")
second_gen_pheno <- read.table("~/Downloads/second_gen.pheno", head = TRUE, fill = TRUE, na.strings = "")
n_antipsychotics_pheno <- read.table("~/Downloads/n_antipsychotics.pheno", head = TRUE, fill = TRUE, na.strings = "")


# Plot histograms of the phenotypes
hist(antipsychotics_pheno$pheno)
hist(clozapine_pheno$pheno)
hist(first_gen_pheno$pheno)
hist(second_gen_pheno$pheno)
hist(n_antipsychotics_pheno$pheno)

# Find values which isnt 0 or 1
which(antipsychotics_pheno$pheno != 0 & antipsychotics_pheno$pheno != 1)
which(clozapine_pheno$pheno != 0 & clozapine_pheno$pheno != 1)
which(first_gen_pheno$pheno != 0 & first_gen_pheno$pheno != 1)
which(second_gen_pheno$pheno != 0 & second_gen_pheno$pheno != 1)

# remove these values
antipsychotics_pheno <- antipsychotics_pheno[-which(antipsychotics_pheno$pheno != 0 & antipsychotics_pheno$pheno != 1), ]
clozapine_pheno <- clozapine_pheno[-which(clozapine_pheno$pheno != 0 & clozapine_pheno$pheno != 1), ]
first_gen_pheno <- first_gen_pheno[-which(first_gen_pheno$pheno != 0 & first_gen_pheno$pheno != 1), ]
second_gen_pheno <- second_gen_pheno[-which(second_gen_pheno$pheno != 0 & second_gen_pheno$pheno != 1), ]


# make data numeric
antipsychotics_linear$Chromosome <- as.numeric(antipsychotics_linear$Chromosome)
antipsychotics_linear$Basepair <- as.numeric(antipsychotics_linear$Basepair)
antipsychotics_linear$Wald_Stat <- as.numeric(antipsychotics_linear$Wald_Stat)
antipsychotics_linear$Wald_P <- as.numeric(antipsychotics_linear$Wald_P)
antipsychotics_linear$Effect <- as.numeric(antipsychotics_linear$Effect)
antipsychotics_linear$SD <- as.numeric(antipsychotics_linear$SD)
antipsychotics_linear$Effect_Liability <- as.numeric(antipsychotics_linear$Effect_Liability)
antipsychotics_linear$SD_Liability <- as.numeric(antipsychotics_linear$SD_Liability)
antipsychotics_linear$A1_Mean <- as.numeric(antipsychotics_linear$A1_Mean)
antipsychotics_linear$MAF <- as.numeric(antipsychotics_linear$MAF)

antipsychotics_logistic$Chromosome <- as.numeric(antipsychotics_logistic$Chromosome)
antipsychotics_logistic$Basepair <- as.numeric(antipsychotics_logistic$Basepair)
antipsychotics_logistic$Predictor <- as.numeric(antipsychotics_logistic$Predictor)
antipsychotics_logistic$Score_Stat <- as.numeric(antipsychotics_logistic$Score_Stat)
antipsychotics_logistic$Score_P <- as.numeric(antipsychotics_logistic$Score_P)
antipsychotics_logistic$Effect <- as.numeric(antipsychotics_logistic$Effect)
antipsychotics_logistic$SD <- as.numeric(antipsychotics_logistic$SD)
antipsychotics_logistic$Effect_Liability <- as.numeric(antipsychotics_logistic$Effect_Liability)
antipsychotics_logistic$SD_Liability <- as.numeric(antipsychotics_logistic$SD_Liability)
antipsychotics_logistic$A1_Mean <- as.numeric(antipsychotics_logistic$A1_Mean)
antipsychotics_logistic$MAF <- as.numeric(antipsychotics_logistic$MAF)

clozapine_linear$Chromosome <- as.numeric(clozapine_linear$Chromosome)
clozapine_linear$Basepair <- as.numeric(clozapine_linear$Basepair)
clozapine_linear$Wald_Stat <- as.numeric(clozapine_linear$Wald_Stat)
clozapine_linear$Wald_P <- as.numeric(clozapine_linear$Wald_P)
clozapine_linear$Effect <- as.numeric(clozapine_linear$Effect)
clozapine_linear$SD <- as.numeric(clozapine_linear$SD)
clozapine_linear$Effect_Liability <- as.numeric(clozapine_linear$Effect_Liability)
clozapine_linear$SD_Liability <- as.numeric(clozapine_linear$SD_Liability)
clozapine_linear$A1_Mean <- as.numeric(clozapine_linear$A1_Mean)
clozapine_linear$MAF <- as.numeric(clozapine_linear$MAF)

clozapine_logistic$Chromosome <- as.numeric(clozapine_logistic$Chromosome)
clozapine_logistic$Basepair <- as.numeric(clozapine_logistic$Basepair)
clozapine_logistic$Score_Stat <- as.numeric(clozapine_logistic$Score_Stat)
clozapine_logistic$Score_P <- as.numeric(clozapine_logistic$Score_P)
clozapine_logistic$Effect <- as.numeric(clozapine_logistic$Effect)
clozapine_logistic$SD <- as.numeric(clozapine_logistic$SD)
clozapine_logistic$Effect_Liability <- as.numeric(clozapine_logistic$Effect_Liability)
clozapine_logistic$SD_Liability <- as.numeric(clozapine_logistic$SD_Liability)
clozapine_logistic$A1_Mean <- as.numeric(clozapine_logistic$A1_Mean)
clozapine_logistic$MAF <- as.numeric(clozapine_logistic$MAF)

first_gen_linear$Chromosome <- as.numeric(first_gen_linear$Chromosome)
first_gen_linear$Basepair <- as.numeric(first_gen_linear$Basepair)
first_gen_linear$Wald_Stat <- as.numeric(first_gen_linear$Wald_Stat)
first_gen_linear$Wald_P <- as.numeric(first_gen_linear$Wald_P)
first_gen_linear$Effect <- as.numeric(first_gen_linear$Effect)
first_gen_linear$SD <- as.numeric(first_gen_linear$SD)
first_gen_linear$Effect_Liability <- as.numeric(first_gen_linear$Effect_Liability)
first_gen_linear$SD_Liability <- as.numeric(first_gen_linear$SD_Liability)
first_gen_linear$A1_Mean <- as.numeric(first_gen_linear$A1_Mean)
first_gen_linear$MAF <- as.numeric(first_gen_linear$MAF)

first_gen_logistic$Chromosome <- as.numeric(first_gen_logistic$Chromosome)
first_gen_logistic$Basepair <- as.numeric(first_gen_logistic$Basepair)
first_gen_logistic$Score_Stat <- as.numeric(first_gen_logistic$Score_Stat)
first_gen_logistic$Score_P <- as.numeric(first_gen_logistic$Score_P)
first_gen_logistic$Effect <- as.numeric(first_gen_logistic$Effect)
first_gen_logistic$SD <- as.numeric(first_gen_logistic$SD)
first_gen_logistic$Effect_Liability <- as.numeric(first_gen_logistic$Effect_Liability)
first_gen_logistic$SD_Liability <- as.numeric(first_gen_logistic$SD_Liability)
first_gen_logistic$A1_Mean <- as.numeric(first_gen_logistic$A1_Mean)
first_gen_logistic$MAF <- as.numeric(first_gen_logistic$MAF)

second_gen_linear$Chromosome <- as.numeric(second_gen_linear$Chromosome)
second_gen_linear$Basepair <- as.numeric(second_gen_linear$Basepair)
second_gen_linear$Wald_Stat <- as.numeric(second_gen_linear$Wald_Stat)
second_gen_linear$Wald_P <- as.numeric(second_gen_linear$Wald_P)
second_gen_linear$Effect <- as.numeric(second_gen_linear$Effect)
second_gen_linear$SD <- as.numeric(second_gen_linear$SD)
second_gen_linear$Effect_Liability <- as.numeric(second_gen_linear$Effect_Liability)
second_gen_linear$SD_Liability <- as.numeric(second_gen_linear$SD_Liability)
second_gen_linear$A1_Mean <- as.numeric(second_gen_linear$A1_Mean)
second_gen_linear$MAF <- as.numeric(second_gen_linear$MAF)

second_gen_logistic$Chromosome <- as.numeric(second_gen_logistic$Chromosome)
second_gen_logistic$Basepair <- as.numeric(second_gen_logistic$Basepair)
second_gen_logistic$Score_Stat <- as.numeric(second_gen_logistic$Score_Stat)
second_gen_logistic$Score_P <- as.numeric(second_gen_logistic$Score_P)
second_gen_logistic$Effect <- as.numeric(second_gen_logistic$Effect)
second_gen_logistic$SD <- as.numeric(second_gen_logistic$SD)
second_gen_logistic$Effect_Liability <- as.numeric(second_gen_logistic$Effect_Liability)
second_gen_logistic$SD_Liability <- as.numeric(second_gen_logistic$SD_Liability)
second_gen_logistic$A1_Mean <- as.numeric(second_gen_logistic$A1_Mean)
second_gen_logistic$MAF <- as.numeric(second_gen_logistic$MAF)

n_antipsychotics$Chromosome <- as.numeric(n_antipsychotics$Chromosome)
n_antipsychotics$Basepair <- as.numeric(n_antipsychotics$Basepair)
n_antipsychotics$Wald_Stat <- as.numeric(n_antipsychotics$Wald_Stat)
n_antipsychotics$Wald_P <- as.numeric(n_antipsychotics$Wald_P)
n_antipsychotics$Effect <- as.numeric(n_antipsychotics$Effect)
n_antipsychotics$SD <- as.numeric(n_antipsychotics$SD)
n_antipsychotics$Effect_Liability <- as.numeric(n_antipsychotics$Effect_Liability)
n_antipsychotics$SD_Liability <- as.numeric(n_antipsychotics$SD_Liability)
n_antipsychotics$A1_Mean <- as.numeric(n_antipsychotics$A1_Mean)
n_antipsychotics$MAF <- as.numeric(n_antipsychotics$MAF)


Wald_P <- as.numeric(antipsychotics_linear$Wald_P)

# Plot manhattan plots

# Antipsychotics
manhattan(antipsychotics_linear, chr = "Chromosome", bp = "Basepair", p = "Wald_P", snp = "Predictor", 
            main = "Antipsychotic Prescription - Linear")

manhattan(antipsychotics_logistic, chr = "Chromosome", bp = "Basepair", p = "Score_P", snp = "Predictor",
            main = "Antipsychotic Prescription - Logistic")

# Clozapine
manhattan(clozapine_linear, chr = "Chromosome", bp = "Basepair", p = "Wald_P", snp = "Predictor", 
            main = "Clozapine Prescription - Linear")

manhattan(clozapine_logistic, chr = "Chromosome", bp = "Basepair", p = "Score_P", snp = "Predictor",
            main = "Clozapine Prescription - Logistic")

# First generation antipsychotics
manhattan(first_gen_linear, chr = "Chromosome", bp = "Basepair", p = "Wald_P", snp = "Predictor", 
            main = "First Generation Antipsychotic Prescription - Linear")

manhattan(first_gen_logistic, chr = "Chromosome", bp = "Basepair", p = "Score_P", snp = "Predictor",
            main = "First Generation Antipsychotic Prescription - Logistic")

# Second generation antipsychotics
manhattan(second_gen_linear, chr = "Chromosome", bp = "Basepair", p = "Wald_P", snp = "Predictor", 
            main = "Second Generation Antipsychotic Prescription - Linear")

manhattan(second_gen_logistic, chr = "Chromosome", bp = "Basepair", p = "Score_P", snp = "Predictor",
            main = "Second Generation Antipsychotic Prescription - Logistic")   

# Number of antipsychotics
manhattan(n_antipsychotics, chr = "Chromosome", bp = "Basepair", p = "Wald_P", snp = "Predictor",
            main = "Number of Antipsychotics Prescribed")
















