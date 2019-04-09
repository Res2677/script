for i in `awk '{print $1}' list`
	do 
	if [[ "$i" =~ ">" ]] 
	then
		echo $i;GROUP=$i;
	else 
		grep $i std.Chimeric.out.sam|grep -v '='|awk '{print ">"$1"\n"$10}'
	fi
	done
