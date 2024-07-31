/////////////////////////////////////////////////////////////////////
# Formatting the summary statistics data #
/////////////////////////////////////////////////////////////////////

# Data path
#/home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_wave3.european.autosome.public.v3.vcf.tsv

##genomeReference="GRCh37"
# The number of variants used is 7659767
# 14 columns

____________________________________________________
cd /home/caroline/dsmwpred/caroline/data/

old_summary_file="PGC3_SCZ_wave3.european.autosome.public.v3.vcf.tsv"
new_summary_file="PGC3_SCZ_european_summary_statistics.tsv"
cut_file="PGC3_SCZ_european_summary_statistics_cut.tsv"

grep -v "^##" ./PGC_SZ_summary_statistics/${old_summary_file} > ./PGC_SZ_summary_statistics/${new_summary_file}

awk 'FNR>1' ./PGC_SZ_summary_statistics/${new_summary_file} > ./PGC_SZ_summary_statistics/${new_summary_file}.no_header

cut -f 1,3,4,5,14,9,11 ./PGC_SZ_summary_statistics/${new_summary_file}.no_header | \
awk 'BEGIN{OFS="\t"; print "Predictor", "A1", "A2", "n", "Direction", "P"} {print $1 ":" $2, $3, $4, $7, $5, $6}' > ./PGC_SZ_summary_statistics/${cut_file}

# rm ./PGC_SZ_summary_statistics/${new_summary_file}.no_header

# The new summary statistics file in LDAK format is now called PGC3_SCZ_european_summary_statistics_cut.tsv
# /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv
____________________________________________________


/////////////////////////////////////////////////////////////////////
# Per-predictor heritabilities #
/////////////////////////////////////////////////////////////////////
# Genetic data is needed for the calculation of the tagging file and heritability matrix.
# Summary statistics are needed for the calculation of the per-predictor heritabilities.

# When using summary statistics these should be in a format that can be read by LDAK.
# We will also need a well-matched reference panel to calculate the tagging file.

_________________________________________________________________

# Weigths #
_________________________________________________________________
cd 

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --cut-weights /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/sections \
 --bfile /home/caroline/snpher/faststorage/plink1000g/1000G.404EUR

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --calc-weights-all /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/sections \
 --bfile /home/caroline/snpher/faststorage/plink1000g/1000G.404EUR

mv /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/sections/weights.short /home/caroline/dsmwpred/caroline/data/bld/bld65

_________________________________________________________________

# Calculate taggings #
_________________________________________________________________

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --calc-tagging /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/bld.ldak \
 --bfile /home/caroline/snpher/faststorage/plink1000g/1000G.404EUR \
 --ignore-weights YES \
 --power -.25 \
 --window-cm 1 \
 --annotation-number 65 \
 --annotation-prefix /home/caroline/dsmwpred/caroline/data/bld/bld \
 --save-matrix YES \
 --extract /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv \
 --max-threads 4



_________________________________________________________________

# Removing duplicates #
_________________________________________________________________
# Before the calculation of the heritability matrix, we need to remove duplicate SNPs.
# This is done using the command from <https://dougspeed.com/summary-statistics/>.

awk < /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv '{print $1}' | sort | uniq -d | head

mv /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv.old
awk '!seen[$1]++' /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv.old > /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv

# Recheck for duplicates
awk < /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv '{print $1}' | sort | uniq -d | head


cat /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv | wc -l
cat /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv.old | wc -l
_________________________________________________________________

# Calculate per-predictor heritabilities #
_________________________________________________________________

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --sum-hers /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/bld.ldak \
 --tagfile /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/bld.ldak.tagging \
 --summary /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv \
 --matrix /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/bld.ldak.matrix \
 --check-sums NO 


/////////////////////////////////////////////////////////////////////
# Calculate predictor-predictor correlations #
/////////////////////////////////////////////////////////////////////

# Calculate predictor-predictor correlations 
_________________________________________________________________

# Main argument is --calc-cors
# Requires --bfile, --window-cm or --window-kb
# --keep and/or --remove can be used to select a subset of samples
# --extract and/or exclude can be used to select a subset of SNPs

# Outfiles are <outfile>.cors.bin and <outfile>.cors.root and <outfile>.cors.bim and <outfile>.cors.noise
# <outfile>.cors.bin is a binary file containing the correlations (binary file format)
# <outfile>.cors.root is a text file containing the correlations (text file format)
# <outfile>.cors.bim is a text file containing the SNP information (text file format)
# <outfile>.cors.noise is a text file containing values used by LDAK to generate the Pseudo Summaries

_________________________________________________________________

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --calc-cors /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/pred_cors_sz \
 --bfile /home/caroline/snpher/faststorage/plink1000g/1000G.404EUR \
 --window-kb 1000 \
 --extract /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv

/////////////////////////////////////////////////////////////////////
# Construct the prediction model #
/////////////////////////////////////////////////////////////////////

# Construct the prediction model using MegaPRS
_________________________________________________________________

# Main argument is --mega-prs
# Requires --model
# --ind-hers to specify the per-predictor heritabilities
# --summary to specify the summary statistics
# --cors to specify the predictor-predictor correlations
# --cv-proportion to specify the proportion of samples to be used for cross-validation
# --high-LD or --check_high-LD to specify whether to check for high LD
# --window-cm or --window-kb 
# --keep and/or --remove can be used to select a subset of samples
# --extract and/or exclude can be used to select a subset of SNPs

_________________________________________________________________

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --mega-prs /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/mega \
 --model mega \
 --ind-hers /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/bld.ldak.ind.hers \
 --summary /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv \
 --cors /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/pred_cors_sz \
 --cv-proportion .1 \
 --check-high-LD NO \
 --window-kb 1000 \
 --allow-ambiguous YES \
 --extract /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/bld.ldak.ind.hers
_________________________________________________________________



awk '{print $1}' /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/bld.ldak.ind.hers > /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/extract.txt

head /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv 

awk '{print $1}' /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/bld.ldak.ind.hers > "/home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/col1"
awk '{print $1}' /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv > "/home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/col2"

# Find the overlapping entries
grep -Fxf "/home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/col1" "/home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/col2" > /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/overlap.txt

awk 'NR==FNR {overlap[$1] = $0; next} ($2 in overlap) {print overlap[$2], $5, $6}' /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/overlap.txt /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/pred_cors_sz.cors.bim > /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/overlap_updated.txt
awk 'NR==FNR {overlap[$1] = $0; next} ($1 in overlap) {print overlap[$1], $2, $3}' /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/overlap_updated.txt /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv > /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/overlap_updated_new.txt

# Then select the rows for which the second column is equal tothe fourth, and third to the fifth
awk '$3 == $4 && $2 == $5 {print $1}' /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/overlap_updated_new.txt > /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/good_overlap.txt

#awk 'NR==FNR {overlap[$1] = $0; next} ($1 in overlap) {print overlap[$1], $5, $6}' /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/overlap.txt /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv > /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/overlap_updated_summary.txt

/home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/pred_cors_sz.cors.bim
/home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv



/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --mega-prs /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/mega \
 --model mega \
 --ind-hers /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/bld.ldak.ind.hers \
 --summary /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv \
 --cors /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/pred_cors_sz \
 --cv-proportion .1 \
 --check-high-LD NO \
 --window-kb 1000 \
 --allow-ambiguous YES \
 --extract /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/good_overlap.txt


_________________________________________________________________

/home/caroline/dsmwpred/data/ukbb/geno

/home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20.pheno


/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --calc-scores mega_F20 \
 --scorefile /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/mega.effects \
 --bfile /home/caroline/dsmwpred/data/ukbb/geno2 \
 --power 0 \
 --pheno /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20.pheno



_________________________________________________________________
### Jackknife ###

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --jackknife mega_F20_jack \
 --profile /home/caroline/mega_F20.profile \
 --num-blocks 200 \
 --AUC YES
_________________________________________________________________




### In R ###
prs <- read.table("/home/caroline/mega_F20.profile", header=T)

prs$Phenotype <- as.factor(prs$Phenotype)
levels(prs$Phenotype)

prs$Profile_1 <- as.numeric(prs$Profile_1)

library(ggplot2)
# Basic density
p <- ggplot(prs, aes(x=Profile_1)) + 
  geom_density()
p

# Add mean line
p+ geom_vline(aes(xintercept=mean(Profile_1)),
            color="blue", linetype="dashed", size=1)

# Change density plot line colors by groups
ggplot(prs, aes(x=Profile_1, color=Phenotype)) +
  geom_density()

_________________________________________________________________
