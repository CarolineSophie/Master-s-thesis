# Some of the data sets are not in the right format for LDAK.

# The data sets that are not in the right format are the following:
# - psychage
# - handed
# - month
# - insomnia
# - ever_smoked
# - cannabis
# - east
# - north

# The data sets that are in the right format are the following:
# - vitamin_d
# - awake

############################################################################################################

# Define the destination directory
destination_dir="/home/caroline/dsmwpred/caroline/projects/new_pheno"

psychage="psychage_init.txt"
handed="handed_init.txt"
vitamin_d="vitamin_d_init.txt"
month="month_init.txt"
insomnia="insomnia_init.txt"
awake="awake_init.txt"
ever_smoked="ever_smoked_init.txt"
cannabis="cannabis_init.txt"
east="east_init.txt"
north="north_init.txt"

# Initial step is to remove header from files
# Copy the eid column so it repeats twice

awk '{print $1, $1, $2}' "$destination_dir/$psychage" | awk 'NR>1' > "$destination_dir/psychage.txt"
awk '{print $1, $1, $2}' "$destination_dir/$handed" | awk 'NR>1' > "$destination_dir/handed.txt"
awk '{print $1, $1, $2}' "$destination_dir/$month" | awk 'NR>1' > "$destination_dir/month.txt"
awk '{print $1, $1, $2}' "$destination_dir/$insomnia" | awk 'NR>1' > "$destination_dir/insomnia.txt"
awk '{print $1, $1, $2}' "$destination_dir/$ever_smoked" | awk 'NR>1' > "$destination_dir/ever_smoked.txt"
awk '{print $1, $1, $2}' "$destination_dir/$cannabis" | awk 'NR>1' > "$destination_dir/cannabis.txt"
#awk '{print $1, $1, $2}' "$destination_dir/$east" | awk 'NR>1' > "$destination_dir/east.txt"
#awk '{print $1, $1, $2}' "$destination_dir/$north" | awk 'NR>1' > "$destination_dir/north.txt"



# Now the data should be made to fit what we are interested in
# Each phenotype will have a new format

conda activate caroline # Activate conda environment in GenomeDK
R # Open R in conda environment

# Load the data into R using fread
library(data.table)
psychage <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/psychage.txt")
handed <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/handed.txt")
# vitamin_d <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/vitamin_d.txt")
month <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/month.txt")
insomnia <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/insomnia.txt")
# awake <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/awake.txt")
ever_smoked <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/ever_smoked.txt")
cannabis <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/cannabis.txt")

### Psychage ###

# -999 changed to 0
# -818 to NA
# -121 to NA

# I want to change all the -999 values to 0
psychage$V3[psychage$V3 == -999] <- 0
# I want to change all the -818 values to NA
psychage$V3[psychage$V3 == -818] <- NA
# I want to change all the -121 values to NA
psychage$V3[psychage$V3 == -121] <- NA

### Handed ###

# 1 Right: 0
# 2 + 3 Left or mixed: 1
# -3 become NA

# I want to change all the 1 values to 0
handed$V3[handed$V3 == 1] <- 0
# I want to change all the 2 and 3 values to 1
handed$V3[handed$V3 == 2] <- 1
handed$V3[handed$V3 == 3] <- 1
# I want to change all the -3 values to NA
handed$V3[handed$V3 == -3] <- NA

### Month ###

# Dec, Jan, Feb: 1 (for winter birth)
# Rest: 0 (non-winter birth)

# I want to change all the 12, 1, 2 values to 1
month$V3[month$V3 == 12] <- 1
month$V3[month$V3 == 1] <- 1
month$V3[month$V3 == 2] <- 1
# I want to change all the other values to 0
month$V3[month$V3 != 1] <- 0

### Insomnia ###

# For insomnia I want to make both a binary and a continuous phenotype

# First I make a copy of the data frame
insomnia_bin <- insomnia # Binary
insomnia_cont <- insomnia # Continuous

# Binary:
# Cases (3 usually): 1
# Controls (1 and 2): 0
# -3: NA

# I want to change all the 1 and 2 values to 0
insomnia_bin$V3[insomnia_bin$V3 == 1] <- 0
insomnia_bin$V3[insomnia_bin$V3 == 2] <- 0

# I want to change all the 3 values to 1
insomnia_bin$V3[insomnia_bin$V3 == 3] <- 1

# I want to change all the -3 values to NA
insomnia_bin$V3[insomnia_bin$V3 == -3] <- NA

# Continuous:
# 123
# -3: NA

# I want to change all the -3 values to NA
insomnia_cont$V3[insomnia_cont$V3 == -3] <- NA

### Ever smoked ###
# Is good as it is
# 1 is yes
# 0 is no

### Cannabis ###

# I want to make two different binary phenotypes for cannabis


# First I make a copy of the data frame
cannabis_hu <- cannabis # Heavy use
cannabis <- cannabis # Use

# User (more than 11):

# 3 and 4: 1
# Rest: 0
# -818: NA

# I want to change all the 3 and 4 values to 1
cannabis$V3[cannabis$V3 == 3] <- 1
cannabis$V3[cannabis$V3 == 4] <- 1
# I want to change all the other values to 0
cannabis$V3[cannabis$V3 != 1] <- 0
# I want to change all the -818 values to NA
cannabis$V3[cannabis$V3 == -818] <- NA

# Heavy use (more than 100):

# 4 (case): 1
# Rest (control): 0
# -818: NA

# I want to change all the 4 values to 1
cannabis_hu$V3[cannabis_hu$V3 == 4] <- 1
# I want to change all the other values to 0
cannabis_hu$V3[cannabis_hu$V3 != 1] <- 0
# I want to change all the -818 values to NA
cannabis_hu$V3[cannabis_hu$V3 == -818] <- NA


# Now I want to write the data frames to new files

write.table(psychage, file = "/home/caroline/dsmwpred/caroline/projects/new_pheno/psychage.pheno", 
            sep = "\t", col.names = FALSE, row.names = FALSE, quote = FALSE)

write.table(handed, file = "/home/caroline/dsmwpred/caroline/projects/new_pheno/handed.pheno",
            sep = "\t", col.names = FALSE, row.names = FALSE, quote = FALSE)

write.table(month, file = "/home/caroline/dsmwpred/caroline/projects/new_pheno/month.pheno",
            sep = "\t", col.names = FALSE, row.names = FALSE, quote = FALSE)

write.table(insomnia_cont, file = "/home/caroline/dsmwpred/caroline/projects/new_pheno/insomnia_cont.pheno",
            sep = "\t", col.names = FALSE, row.names = FALSE, quote = FALSE)

write.table(insomnia_bin, file = "/home/caroline/dsmwpred/caroline/projects/new_pheno/insomnia_bin.pheno",
            sep = "\t", col.names = FALSE, row.names = FALSE, quote = FALSE)

write.table(ever_smoked, file = "/home/caroline/dsmwpred/caroline/projects/new_pheno/ever_smoked.pheno",
            sep = "\t", col.names = FALSE, row.names = FALSE, quote = FALSE)

write.table(cannabis, file = "/home/caroline/dsmwpred/caroline/projects/new_pheno/cannabis.pheno",
            sep = "\t", col.names = FALSE, row.names = FALSE, quote = FALSE)

write.table(cannabis_hu, file = "/home/caroline/dsmwpred/caroline/projects/new_pheno/cannabis_hu.pheno",
            sep = "\t", col.names = FALSE, row.names = FALSE, quote = FALSE)


############################################################################################################

# Now I want to load all the new phenotypes to check them
psychage <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/psychage.pheno")
handed <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/handed.pheno")
month <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/month.pheno")
insomnia_cont <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/insomnia_cont.pheno")
insomnia_bin <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/insomnia_bin.pheno")
ever_smoked <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/ever_smoked.pheno")
cannabis <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/cannabis.pheno")
cannabis_hu <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/cannabis_hu.pheno")
awake <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/awake_init.txt")
vitamin_d <- fread("/home/caroline/dsmwpred/caroline/projects/new_pheno/vitamin_d_init.txt")

# Plot data distributions
library(ggplot2)

# Psychage
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/psychage.png')
ggplot(psychage, aes(x = V3)) + geom_histogram(binwidth = 1) + ggtitle("Psychage")
dev.off()

# Handed
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/handed.png')
ggplot(handed, aes(x = V3)) + geom_histogram(binwidth = 1) + ggtitle("Handed")
dev.off()

# Month
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/month.png')
ggplot(month, aes(x = V3)) + geom_histogram(binwidth = 1) + ggtitle("Month")
dev.off()

# Insomnia_cont
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/insomnia_cont.png')
ggplot(insomnia_cont, aes(x = V3)) + geom_histogram(binwidth = 1) + ggtitle("Insomnia_cont")
dev.off()

# Insomnia_bin
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/insomnia_bin.png')
ggplot(insomnia_bin, aes(x = V3)) + geom_histogram(binwidth = 1) + ggtitle("Insomnia_bin")
dev.off()

# Ever_smoked
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/ever_smoked.png')
ggplot(ever_smoked, aes(x = V3)) + geom_histogram(binwidth = 1) + ggtitle("Ever_smoked")
dev.off()

# Cannabis
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/cannabis.png')
ggplot(cannabis, aes(x = V3)) + geom_histogram(binwidth = 1) + ggtitle("Cannabis")
dev.off()

# Cannabis_hu
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/cannabis_hu.png')
ggplot(cannabis_hu, aes(x = V3)) + geom_histogram(binwidth = 1) + ggtitle("Cannabis_hu")
dev.off()

# Awake
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/awake.png')
ggplot(awake, aes(x = V3)) + geom_histogram(binwidth = 1) + ggtitle("Awake")
dev.off()

# Vitamin_d
png('/home/caroline/dsmwpred/caroline/projects/new_pheno/plots/vitamin_d.png')
ggplot(vitamin_d, aes(x = V3)) + geom_histogram(binwidth = 1) + ggtitle("Vitamin_d")
dev.off()


q()


############################################################################################################

I want to check all the phenotypes for n cases and controls

# all the phenotypes not in r
# psychage, handed, month, insomnia_cont, insomnia_bin, ever_smoked, cannabis, cannabis_hu, awake, vitamin_d

/home/caroline/dsmwpred/caroline/projects/new_pheno/awake.pheno
/home/caroline/dsmwpred/caroline/projects/new_pheno/cannabis.pheno
/home/caroline/dsmwpred/caroline/projects/new_pheno/cannabis_hu.pheno
/home/caroline/dsmwpred/caroline/projects/new_pheno/ever_smoked.pheno
/home/caroline/dsmwpred/caroline/projects/new_pheno/handed.pheno
/home/caroline/dsmwpred/caroline/projects/new_pheno/insomnia_bin.pheno
/home/caroline/dsmwpred/caroline/projects/new_pheno/insomnia_cont.pheno
/home/caroline/dsmwpred/caroline/projects/new_pheno/month.pheno
/home/caroline/dsmwpred/caroline/projects/new_pheno/psychage.pheno
/home/caroline/dsmwpred/caroline/projects/new_pheno/vitamin_d.pheno

# I want to check the number of cases and controls for all the phenotypes
# First I want to check only individuals with genotype data

# Overlap with /home/caroline/dsmwpred/data/ukbb/geno2 and not 0 or NA
# I want to check the number of cases and controls for all the phenotypes
# First I want to check only individuals with genotype data

# Awake overlap between /home/caroline/dsmwpred/data/ukbb/geno2.fam and /home/caroline/dsmwpred/caroline/projects/new_pheno/awake.pheno
awk 'FNR==NR{a[$1];next} $1 in a && ($3 != 0 && $3 != "NA")' /home/caroline/dsmwpred/data/ukbb/geno2.fam /home/caroline/dsmwpred/caroline/projects/new_pheno/awake.pheno | wc -l
# I want to find all 0 or NA values
awk 'FNR==NR{a[$1];next} $1 in a && ($3 == 0 || $3 == "NA")' /home/caroline/dsmwpred/data/ukbb/geno2.fam /home/caroline/dsmwpred/caroline/projects/new_pheno/awake.pheno

# cannabis overlap between /home/caroline/dsmwpred/data/ukbb/geno2.fam and /home/caroline/dsmwpred/caroline/projects/new_pheno/cannabis.pheno
awk 'FNR==NR{a[$1];next} $1 in a && ($3 != 0 && $3 != "NA")' /home/caroline/dsmwpred/data/ukbb/geno2.fam /home/caroline/dsmwpred/caroline/projects/new_pheno/cannabis.pheno | wc -l
# I want to find all 0 or NA values
awk 'FNR==NR{a[$1];next} $1 in a && ($3 == 0 || $3 == "NA")' /home/caroline/dsmwpred/data/ukbb/geno2.fam /home/caroline/dsmwpred/caroline/projects/new_pheno/cannabis.pheno | wc -l

#ever_smoked overlap between /home/caroline/dsmwpred/data/ukbb/geno2.fam and /home/caroline/dsmwpred/caroline/projects/new_pheno/ever_smoked.pheno
awk 'FNR==NR{a[$1];next} $1 in a && ($3 != 0 && $3 != "NA")' /home/caroline/dsmwpred/data/ukbb/geno2.fam /home/caroline/dsmwpred/caroline/projects/new_pheno/ever_smoked.pheno | wc -l

# handed overlap between /home/caroline/dsmwpred/data/ukbb/geno2.fam and /home/caroline/dsmwpred/caroline/projects/new_pheno/handed.pheno
awk 'FNR==NR{a[$1];next} $1 in a && ($3 != 0 && $3 != "NA")' /home/caroline/dsmwpred/data/ukbb/geno2.fam /home/caroline/dsmwpred/caroline/projects/new_pheno/handed.pheno | wc -l

# Insomnia_cont overlap between /home/caroline/dsmwpred/data/ukbb/geno2.fam and /home/caroline/dsmwpred/caroline/projects/new_pheno/insomnia_cont.pheno
awk 'FNR==NR{a[$1];next} $1 in a && ($3 != 0 && $3 != "NA")' /home/caroline/dsmwpred/data/ukbb/geno2.fam /home/caroline/dsmwpred/caroline/projects/new_pheno/insomnia_cont.pheno | wc -l

# month overlap between /home/caroline/dsmwpred/data/ukbb/geno2.fam and /home/caroline/dsmwpred/caroline/projects/new_pheno/month.pheno
awk 'FNR==NR{a[$1];next} $1 in a && ($3 != 0 && $3 != "NA")' /home/caroline/dsmwpred/data/ukbb/geno2.fam /home/caroline/dsmwpred/caroline/projects/new_pheno/month.pheno | wc -l

# vitamin_d overlap between /home/caroline/dsmwpred/data/ukbb/geno2.fam and /home/caroline/dsmwpred/caroline/projects/new_pheno/vitamin_d.pheno
awk 'FNR==NR{a[$1];next} $1 in a && ($3 != 0 && $3 != "NA")' /home/caroline/dsmwpred/data/ukbb/geno2.fam /home/caroline/dsmwpred/caroline/projects/new_pheno/vitamin_d.pheno | wc -l


# psychage overlap between /home/caroline/dsmwpred/data/ukbb/geno2.fam and /home/caroline/dsmwpred/caroline/projects/new_pheno/psychage.pheno
awk 'FNR==NR{a[$1];next} $1 in a && ($3 != 0 && $3 != "NA")' /home/caroline/dsmwpred/data/ukbb/geno2.fam /home/caroline/dsmwpred/caroline/projects/new_pheno/psychage.pheno | wc -l
# I want to find all 0 or NA values
awk 'FNR==NR{a[$1];next} $1 in a && ($3 == 0 || $3 == "NA")' /home/caroline/dsmwpred/data/ukbb/geno2.fam /home/caroline/dsmwpred/caroline/projects/new_pheno/psychage.pheno | wc -l