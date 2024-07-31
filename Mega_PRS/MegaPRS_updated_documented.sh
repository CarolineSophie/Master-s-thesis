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
cut_file="PGC3_SCZ_european_summary_statistics_cut.tsv" # Name of the new summary statistics file in LDAK format

grep -v "^##" ./PGC_SZ_summary_statistics/${raw_summary_file} > ./PGC_SZ_summary_statistics/${new_summary_file}

awk 'FNR>1' ./PGC_SZ_summary_statistics/${new_summary_file} > ./PGC_SZ_summary_statistics/${new_summary_file}.no_header

cut -f 1,3,4,5,12,13,9,11 ./PGC_SZ_summary_statistics/${new_summary_file}.no_header | \
awk 'BEGIN{OFS="\t"; print "Predictor", "A1", "A2", "NCAS", "NCON", "Direction", "P"} {print $1 ":" $2, $3, $4, $7, $8, $5, $6}' > ./PGC_SZ_summary_statistics/${cut_file}

# rm ./PGC_SZ_summary_statistics/${new_summary_file}.no_header

# The new summary statistics file in LDAK format is now called PGC3_SCZ_european_summary_statistics_cut.tsv
# /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv

# Now add the n column by summing the number of cases and controls (NCAS and NCON).
awk '{print $1, $2, $3, $4, $5, $6, $7, $4+$5}' ./PGC_SZ_summary_statistics/${cut_file} > tmp.txt

awk 'NR==1 {$8="n"}1' tmp.txt > ./PGC_SZ_summary_statistics/European.txt
rm tmp.txt

_________________________________________________________________

# open R to calculate the MAF

conda activate caroline
R

library(dplyr)
library(tidyr)

data <- read.table("/home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/European.txt", header = T)

_________________________________________________________________

/////////////////////////////////////////////////////////////////////
# Filtering the summary statistics data based on available genotype data #
/////////////////////////////////////////////////////////////////////

# The genotype file that I will be using to test the final PRS on does not contain information about all SNPs in the summary statistics file.
# Therefore these can be filtered out before the calculation of the heritability matrix.
# The genotype file that I will be using is the UK Biobank data.

# The genotype file is stored on genomeDK at: /home/caroline/dsmwpred/data/ukbb/geno2.bed/bim/fam
# The summary statistics file is stored on genomeDK at: /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/PGC3_SCZ_european_summary_statistics_cut.tsv

summary_file="/home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/European.txt"
genotype_file="/home/caroline/dsmwpred/data/ukbb/geno2.bim"
filtered_file="/home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/filtered_EUR.txt"

# awk 'NR==FNR{a[$2];next} $1 in a' ${genotype_file} ${summary_file} > ${filtered_file} # This does not add the header from the summary statistics file
(awk 'NR==FNR{a[$2];next} FNR==1 || $1 in a' "$genotype_file" "$summary_file") > "$filtered_file" # With header


# Check the number of lines in each file
echo "Number of lines in $genotype_file: $(wc -l < "$genotype_file")" \
     "Number of lines in $summary_file: $(wc -l < "$summary_file")" \
     "Number of lines in $filtered_file: $(wc -l < "$filtered_file")"

____________________________________________________

/////////////////////////////////////////////////////////////////////
# Removing duplicated from the filtered summary statistics data #
/////////////////////////////////////////////////////////////////////

# Before the calculation of the heritability matrix, we need to remove any potential duplicate SNPs.
# This is done using the command from <https://dougspeed.com/summary-statistics/>.

filtered_file="/home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/filtered_EUR.txt"

awk < ${filtered_file} '{print $1}' | sort | uniq -d | head

mv ${filtered_file} ${filtered_file}.old
awk '!seen[$1]++' ${filtered_file}.old > ${filtered_file}

# Recheck for duplicates
awk < ${filtered_file} '{print $1}' | sort | uniq -d | head


cat ${filtered_file} | wc -l
cat ${filtered_file}.old | wc -l

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
 --bfile /home/caroline/snpher/faststorage/plink1000g/1000G.404EUR.gen #Using 1000G.404EUR as reference panel

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --calc-weights-all /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/sections \
 --bfile /home/caroline/snpher/faststorage/plink1000g/1000G.404EUR.gen

mv /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/sections/weights.short /home/caroline/dsmwpred/caroline/data/bld/bld65

_________________________________________________________________

# Calculate taggings #
_________________________________________________________________

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --calc-tagging /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/bld_filtered.ldak \
 --bfile /home/caroline/snpher/faststorage/plink1000g/1000G.404EUR.gen \
 --ignore-weights YES \
 --power -.25 \
 --window-kb 1000 \
 --annotation-number 65 \
 --annotation-prefix /home/caroline/dsmwpred/caroline/data/bld/bld \
 --save-matrix YES \
 --extract /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/filtered_EUR.txt \
 --max-threads 4

_________________________________________________________________

# Calculate per-predictor heritabilities #
_________________________________________________________________

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --sum-hers /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/bld_filtered.ldak \
 --tagfile /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/bld_filtered.ldak.tagging \
 --summary /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/filtered_EUR.txt \
 --matrix /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/bld_filtered.ldak.matrix \
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
 --bfile /home/caroline/snpher/faststorage/plink1000g/1000G.404EUR.gen \
 --window-kb 1000 \
 --extract /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/filtered_EUR.txt

/////////////////////////////////////////////////////////////////////
# High LD regions #
/////////////////////////////////////////////////////////////////////

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --cut-genes /home/caroline/dsmwpred/caroline/data/highld/highld_1000G.404EUR \
 --bfile /home/caroline/snpher/faststorage/plink1000g/1000G.404EUR.gen \
 --genefile /home/caroline/dsmwpred/caroline/data/highld/highld.txt


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

# First we remove ambigous alleles

awk '!( ($4=="A" && $5=="T") || \
        ($4=="T" && $5=="A") || \
        ($4=="G" && $5=="C") || \
        ($4=="C" && $5=="G")) {print}' /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/filtered_EUR.txt > /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/no_ambig_EUR.txt


# First we need to ensure that there are no inconsistent alleles

awk '{print $1}' /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/bld_filtered.ldak.ind.hers > /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/filtered_extract.txt

head /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/no_ambig_EUR.txt

awk '{print $1}' /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/bld_filtered.ldak.ind.hers > "/home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/col1"
awk '{print $1}' /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/no_ambig_EUR.txt > "/home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/col2"

# Find the overlapping entries
grep -Fxf "/home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/col1" "/home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/col2" > /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/overlap.txt

awk 'NR==FNR {overlap[$1] = $0; next} ($2 in overlap) {print overlap[$2], $5, $6}' /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/overlap.txt /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/pred_cors_sz.cors.bim > /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/overlap_updated.txt
awk 'NR==FNR {overlap[$1] = $0; next} ($1 in overlap) {print overlap[$1], $2, $3}' /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/overlap_updated.txt /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/no_ambig_EUR.txt > /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/overlap_updated_new.txt

# Then select the rows for which the second column is equal to the fourth, and third to the fifth
awk '$3 == $4 && $2 == $5 {print $1}' /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/overlap_updated_new.txt > /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/good_overlap.txt

_________________________________________________________________
# Constructing the PRS model #

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --mega-prs /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/mega_filtered \
 --model mega \
 --ind-hers /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/bld_filtered.ldak.ind.hers \
 --summary /home/caroline/dsmwpred/caroline/data/PGC_SZ_summary_statistics/no_ambig_EUR.txt \
 --cors /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/pred_cors_sz \
 --cv-proportion .1 \
 --high-LD /home/caroline/dsmwpred/caroline/data/highld/highld_1000G.404EUR/genes.predictors.used \
 --window-kb 1000 \
 --extract /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/good_overlap.txt
_________________________________________________________________


/////////////////////////////////////////////////////////////////////
# Calculating the scores for the phenotypes #
/////////////////////////////////////////////////////////////////////

# /home/caroline/dsmwpred/data/ukbb/geno2 is the genotype file (UKBB white brisith individuals)
# /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20.pheno is the phenotype file (F20 schizophrenia)


/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --calc-scores /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/results/F20_SZ \
 --scorefile /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/mega_filtered.effects \
 --bfile /home/caroline/dsmwpred/data/ukbb/geno2 \
 --power 0 \
 --pheno /home/caroline/dsmwpred/caroline/data/UKBB_SZ/F20.pheno

_________________________________________________________________
### Jackknife ###

/home/caroline/dsmwpred/caroline/software/ldak5.2.linux \
 --jackknife /home/caroline/dsmwpred/caroline/projects/MegaPRS_PGCSZ/results/F20_jack \
 --profile /home/caroline/mega_F20.profile \
 --num-blocks 200 \
 --AUC YES
_________________________________________________________________
