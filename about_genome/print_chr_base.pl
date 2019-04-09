use Data::Dumper;
print "e.g\nperl print_pos_base.pl /public/ALL_DATA/references/hg19/chrM.fa 6191-6411\n";
open IN,$ARGV[0],or die $!;
$name = $ARGV[1];
$/=">";
while(<IN>)
{
	chomp;
	@ss = split/\n/;
	$seq_name = $ss[0];
	shift @ss;
	if ($seq_name=~/$name/)
	{
		print ">$seq_name\n";
		foreach $kk (@ss)
		{
			print "$kk\n";
		}
	}
}
