/////////////////////////////////////////////////////////////////////
# Formatting the summary statistics data #
/////////////////////////////////////////////////////////////////////

# Summary statistics data from the PGC GWAS on schizophrenia. Downloaded from: https://figshare.com/articles/dataset/scz2022/19426775

# Data path for storage on genomeDK
#/home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_wave3.european.autosome.public.v3.vcf.tsv --> This is only the european individuals 

##genomeReference="GRCh37"
# The number of variants used is 7659767
# 14 columns

____________________________________________________
cd /home/caroline/dsmwpred/caroline/data/

raw_summary_file="PGC3_SCZ_wave3.european.autosome.public.v3.vcf.tsv" # The raw downloaded summary statistics file
new_summary_file="PGC3_SCZ_european_summary_statistics.tsv" # Name of the new summary statistics file

grep -v "^##" ./PGC_SZ_summary_statistics/${raw_summary_file} > ./PGC_SZ_summary_statistics/${new_summary_file}

# Open R to do the pre-processing of the summary statistics file

conda activate caroline
R

library(dplyr)
library(tidyr)

data <- read.table("/home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics.tsv", header = T)

data$N <- data$NCAS + data$NCON # Add a column with the total number of individuals
data$Predictor <- paste0(data$CHROM, ":", data$POS) # Add a column with the predictor name in LDAK format
data$MAF <- (data$FCAS*data$NCAS + data$FCON*data$NCON)/(data$N) # Add a column with the MAF
data$Direction <- data$BETA # Add a column with the direction of the effect
colnames(data)[11] <- "P" # Rename the PVAL column to P

write.table(data, file = "/home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC_EUR_SZ.txt", sep = "\t", row.names = FALSE, quote = FALSE)
# PGC_EUR_SZ.txt 
# This is the new summary statistics file in LDAK format
# It contains the information from the original summary statistics file, but with the following columns added:
# N, Predictor, MAF, Direction

____________________________________________________________

/////////////////////////////////////////////////////////////////////
# Filtering the summary statistics data based on available genotype data #
/////////////////////////////////////////////////////////////////////

# The genotype file that I will be using to test the final PRS on does not contain information about all SNPs in the summary statistics file.
# Therefore these can be filtered out before the calculation of the heritability matrix.
# The genotype file that I will be using is the UK Biobank data.

# The genotype file is stored on genomeDK at: /home/caroline/dsmwpred/data/ukbb/geno2.bed/bim/fam
# The summary statistics file is stored on genomeDK at: /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC_EUR_SZ.txt

summary_file="/home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC_EUR_SZ.txt"
genotype_file="/home/caroline/dsmwpred/data/ukbb/geno2.bim"
filtered_file="/home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC_EUR_SZ_geno2.txt"


# awk 'NR==FNR{a[$2];next} $1 in a' ${genotype_file} ${summary_file} > ${filtered_file} # This does not add the header from the summary statistics file
(awk 'NR==FNR{a[$2];next} FNR==1 || $16 in a' "$genotype_file" "$summary_file") > "$filtered_file" # With header


# Check the number of lines in each file
echo "Number of lines in $genotype_file: $(wc -l < "$genotype_file")" \
     "Number of lines in $summary_file: $(wc -l < "$summary_file")" \
     "Number of lines in $filtered_file: $(wc -l < "$filtered_file")"

____________________________________________________

# Calculate the MAFs for the genotype file
# This is done using the --calc-stats command in LDAK

# Results are saved in the file geno_stats.stats

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --calc-stats /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/geno_stats \
 --bfile /home/caroline/dsmwpred/data/ukbb/geno2


/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --calc-stats /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/1000G_stats \
 --bfile /home/caroline/snpher/faststorage/plink1000g/1000G.404EUR.gen

____________________________________________________

R

geno_stats <- read.table('/home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/geno_stats.stats', header = T)
sum_stats <- read.table('/home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC_EUR_SZ_geno2.txt', header = T)
g1000_stats <- read.table('/home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/1000G_stats.stats', header = T)

# sum_stats$MAF_new = pmin(sum_stats$MAF, 1 - sum_stats$MAF)
# sum_stats[sum_stats$MAF_new < 0.01] # Check if there are any SNPs with MAF < 0.01

common <- intersect(geno_stats$Predictor, sum_stats$Predictor)
common <- intersect(common, g1000_stats$Predictor)

colnames(sum_stats) = paste0(colnames(sum_stats), "_sum")
colnames(g1000_stats) = paste0(colnames(g1000_stats), "_g1000")

all = cbind(geno_stats[match(common, geno_stats$Predictor),],sum_stats[match(common, sum_stats$Predictor_sum),], g1000_stats[match(common, g1000_stats$Predictor_g1000),])


# Split the plotting window into 2 rows and 3 columns
par(mfrow=c(1,3))
# Plot the new summary stats MAFs against the MAFs from the genotype file and the 1000G reference panel
plot(all$MAF_sum, all$A1_Mean_g1000)
plot(all$MAF_sum, all$A1_Mean)
plot(all$A1_Mean_g1000, all$A1_Mean)

dev.off()

q()

/////////////////////////////////////////////////////////////////////
# Removing duplicated from the filtered summary statistics data #
/////////////////////////////////////////////////////////////////////

# Before the calculation of the heritability matrix, we need to remove any potential duplicate SNPs.
# This is done using the command from <https://dougspeed.com/summary-statistics/>.

filtered_file="/home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC_EUR_SZ_geno2.txt"

awk < ${filtered_file} '{print $16}' | sort | uniq -d | head

mv ${filtered_file} ${filtered_file}.old
awk '!seen[$16]++' ${filtered_file}.old > ${filtered_file}

# Recheck for duplicates
awk < ${filtered_file} '{print $16}' | sort | uniq -d | head


cat ${filtered_file} | wc -l
cat ${filtered_file}.old | wc -l
