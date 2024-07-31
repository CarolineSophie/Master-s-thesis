# File paths for all the phenotypes used in the genetic correlation analysis

# First psychotic episode code 20461
/home/caroline/snpher/faststorage/biobank/newphens/psychage.txt

# Handedness code 1707
/home/caroline/snpher/faststorage/biobank/phenotypes/handed.txt

# Vitamin D deficiency
/home/caroline/snpher/faststorage/biobank/newphens/biomarkerphens/marker58.pheno

# Month of birth 8
/home/caroline/snpher/faststorage/biobank/newphens/month.txt

# Sleep variables 1200
# Insomnia
/home/caroline/snpher/faststorage/biobank/phenotypes/insomnia.txt

# Awake (phenotype from 1-3, with 1 being never/rarely and 3 being usually/always)
/home/caroline/snpher/faststorage/biobank/phenotypes/awake.clean

# Ever smoked (cigarettes) 20160
/home/caroline/snpher/faststorage/biobank/phenotypes/ever.txt

# Ever used cannabis code 20453
/home/caroline/snpher/faststorage/biobank/newphens/cannabis.txt

# Location code 22704 and XXXX
# East
/home/caroline/snpher/faststorage/biobank/newphens/east.txt
# North
/home/caroline/snpher/faststorage/biobank/newphens/north.txt


############################################################################################################
# Copy thee files to the correct directory

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

# First psychotic episode
cp /home/caroline/snpher/faststorage/biobank/newphens/psychage.txt "$destination_dir/$psychage"
# Handedness
cp /home/caroline/snpher/faststorage/biobank/phenotypes/handed.txt "$destination_dir/$handed"
# Vitamin D deficiency
cp /home/caroline/snpher/faststorage/biobank/newphens/biomarkerphens/marker58.pheno "$destination_dir/$vitamin_d"
# Month of birth
cp /home/caroline/snpher/faststorage/biobank/newphens/month.txt "$destination_dir/$month"
# Insomnia
cp /home/caroline/snpher/faststorage/biobank/phenotypes/insomnia.txt "$destination_dir/$insomnia"
# Awake
cp /home/caroline/snpher/faststorage/biobank/phenotypes/awake.clean "$destination_dir/$awake"
# Ever smoked (cigarettes)
cp /home/caroline/snpher/faststorage/biobank/phenotypes/ever.txt "$destination_dir/$ever_smoked"
# Ever used cannabis
cp /home/caroline/snpher/faststorage/biobank/newphens/cannabis.txt "$destination_dir/$cannabis"
# East
cp /home/caroline/snpher/faststorage/biobank/newphens/east.txt "$destination_dir/$east"
# North
cp /home/caroline/snpher/faststorage/biobank/newphens/north.txt "$destination_dir/$north"
