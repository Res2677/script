use Data::Dumper;
$cnt =0;
open DEP,$ARGV[0],or die $!;
while(<DEP>)
{
	chomp;
	@a =split/\t/,$_;
	$cnt ++;
	if ($cnt == 1) {$start =$a[1];$chr = $a[0];}
	if ($cnt != 1000000 and $chr eq $a[0]){$total = $total + $a[2];}
	elsif ($cnt == 1000000 or $chr ne $a[0] or eof(DEP))
	{
		$end=$a[1];
		$dep = $total/100000000;
		$hash{$chr}{$start}{$end} = $dep;
		$li = $chr;$li=~s/chr/hs/g;
		print "$li\t$start\t$end\t$dep\n";
		$cnt=0;$total=0;
	}
}
#print "hsM\t100\t16000\t10\n";
