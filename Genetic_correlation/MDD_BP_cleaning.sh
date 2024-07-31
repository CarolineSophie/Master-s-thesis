# BP
awk 'NR==FNR{a[$2]=$9; b[$2]=$1":"$3; next} FNR==1{print $0, "OR", "Predictor"; next} $1 in a{print $0, a[$1], b[$1]}' /home/caroline/dsmwpred/caroline/data/PGC_BP/daner_bip_pgc3_nm_noukbiobank /home/caroline/dsmwpred/caroline/data/PGC_BP/daner_bip_pgc3_nm_noukbiobank.geno3.ldak > /home/caroline/dsmwpred/caroline/data/PGC_BP/BP_merged.txt
awk 'NR==1 { $1 = "rsID" } 1' /home/caroline/dsmwpred/caroline/data/PGC_BP/BP_merged.txt > /home/caroline/dsmwpred/caroline/data/PGC_BP/PGC_BP.txt


# MDD
awk 'NR==FNR{a[$2]=$9; b[$2]=$1":"$3; next} FNR==1{print $0, "OR", "Predictor"; next} $1 in a{print $0, a[$1], b[$1]}' /home/caroline/dsmwpred/caroline/data/PGC_MDD/daner_pgc_mdd_meta_w2_no23andMe_rmUKBB /home/caroline/dsmwpred/caroline/data/PGC_MDD/daner_pgc_mdd_meta_w2_no23andMe_rmUKBB.geno3.ldak > /home/caroline/dsmwpred/caroline/data/PGC_MDD/MDD_merged.txt
awk 'NR==1 { $1 = "rsID" } 1' /home/caroline/dsmwpred/caroline/data/PGC_MDD/MDD_merged.txt > /home/caroline/dsmwpred/caroline/data/PGC_MDD/PGC_MDD.txt






awk 'NR==FNR{a[$2]=$9; b[$2]=$1":"$3; next} FNR==1{print $0, "OR", "Combined_Column"; next} $1 in a{print $0, a[$1], b[$1]}' /home/caroline/dsmwpred/caroline/data/PGC_MDD/daner_pgc_mdd_meta_w2_no23andMe_rmUKBB /home/caroline/dsmwpred/caroline/data/PGC_MDD/daner_pgc_mdd_meta_w2_no23andMe_rmUKBB.geno3.ldak > /home/caroline/dsmwpred/caroline/data/PGC_MDD/merged.txt