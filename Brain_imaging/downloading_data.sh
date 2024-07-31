# This file is for downloading the data from the Oxford Brain Imaging Genetics Server - BIG40
https://open.win.ox.ac.uk/ukbiobank/big40/

# This is the directoy where the data is saved:
# /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data

# I want to download the following file numbers:

# 0005 Volume of grey matter (normalised for head size)
# 0006 Volume of grey matter
# 0007 Volume of white matter (normalised for head size)
# 0008 Volume of white matter
# 0009 Volume of brain, grey+white matter (normalised for head size)
# 0010 Volume of brain, grey+white matter
# 0003 Volume of ventricular cerebrospinal fluid (normalised for head size)
# 0004 Volume of ventricular cerebrospinal fluid
# 0019 Volume of hippocampus (left)
# 0020 Volume of hippocampus (right)
# 0042 Volume of grey matter in Superior Temporal Gyrus, anterior division (left)
# 0043 Volume of grey matter in Superior Temporal Gyrus, anterior division (right)
# 0044 Volume of grey matter in Superior Temporal Gyrus, posterior division (left)
# 0045 Volume of grey matter in Superior Temporal Gyrus, posterior division (right)

# I want to automate it a bit and write a script for each file
for i in 0005 0006 0007 0008 0009 0010 0003 0004 0019 0020 0042 0043 0044 0045; do
touch "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/download/${i}.sh"
# Add content to the script
echo "#"'!'"/bin/bash
#SBATCH --account dsmwpred 
#SBATCH -c 4
#SBATCH --time 4:00:00 
#SBATCH --mem 32g

wget https://open.win.ox.ac.uk/ukbiobank/big40/release2/stats33k/${i}.txt.gz -P /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k_raw

wget https://open.win.ox.ac.uk/ukbiobank/big40/release2/stats_disco_sexwise/${i}.txt.gz -P /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex_raw

" > "/home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/download/${i}.sh"

done

# submit the jobs
for i in /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/download/*.sh; do
sbatch $i
done

# check queue
squeue -u caroline
squeue | grep caroline


############################################################################################################
wget https://open.win.ox.ac.uk/ukbiobank/big40/release2/stats33k/0005.txt.gz -P /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k_raw

# I also wan the sex-specific files

wget https://open.win.ox.ac.uk/ukbiobank/big40/release2/stats_disco_sexwise/0005.txt.gz -P /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex_raw
############################################################################################################


# I want to unzip all the files
for i in /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/33k_raw/*.gz; do
gunzip $i
done

for i in /home/caroline/dsmwpred/caroline/projects/brain_imaging_data/data/22k_sex_raw/*.gz; do
gunzip $i
done