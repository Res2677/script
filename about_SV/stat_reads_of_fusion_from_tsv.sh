for i in `grep -v 'JunctionReads' star-fusion.fusion_predictions.tsv| awk '{print ">"$1"\n"$9}'`;do OLD_IFS="$IFS";IFS=",";arr=($i);IFS="$OLD_IFS";for s in ${arr[@]}; do echo $s; done; done >list
