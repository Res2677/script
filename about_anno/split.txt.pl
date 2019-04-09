$line = 0;
$part = 1;
$cnt =1;
$str="";
$dd = $ARGV[0].".part.".$cnt;
open OUT,">$dd",or die $!;
open IN,$ARGV[0],or die $!;
while(<IN>)
{
	if(/#/){$head = $_;print OUT "$_\n";last;}
}

while(<IN>)
{
	chomp;
	$line ++;
	if ($line == 800000){
		#$cnt ++;
		@a = split/\t/,$_;
		$last = $a[8];
		print "$last\n";
	}
	if($line >800000)
	{
		@a = split/\t/,$_;
		if($a[8] !~ /$last/ and $last !~/$a[8]/)
		{
			close OUT;
			$cnt ++;
			print "$line\n";
			$line = 0;
			$dd = $ARGV[0].".part.".$cnt;
			open OUT,">$dd",or die $!;
			print OUT "$head\n";
		}
	}
	print OUT "$_\n";
}
