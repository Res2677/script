open IN,$ARGV[0],or die $!;
while(<IN>)
{
	chomp;
	next if ($_=~/^#/);
	@a = split/\t/,$_;
	
}
