$dir = $ARGV[0];
$file = `ls $dir`;
@file = split/\n/,$file;
foreach $f (@file)
{
	@name = split/\./,$f;
	#print "$name[0]\n";
	open IN,"$dir/$f",or die $!;
	<IN>;
	while(<IN>)
	{
		chomp;
		@a = split/\t/,$_;
		@gene = split/--/,$a[0];
		#print "$gene[0]\t$gene[1]\n";
		$hash1{$name[0]}{$a[0]} = 1;
		$hash2{$a[0]}{$name[0]} = 1;
		$hash_g1{$name[0]}{$gene[0]} = 1;
		$hash_g1{$name[0]}{$gene[1]} = 1;
		$hash_g2{$gene[0]}{$name[0]} = 1;
		$hash_g2{$gene[1]}{$name[0]} = 1;
	}
}

use Data::Dumper;
#print Dumper \%hash_g2;
foreach $jj (keys %hash_g2)
{
	$ccnt =0;
	$ncnt = 0;
	print "$jj\t";
	foreach $sample (keys %{$hash_g2{$jj}})
	{
		if ($sample=~/-N/){$ncnt ++;}
		else {$ccnt ++;}
	}
	print "N:$ncnt\tC:$ccnt\n";
}
