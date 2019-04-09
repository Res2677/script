open BAM,"samtools view $ARGV[0]|",or die $!;
while(<BAM>)
{
	chomp;
	@a =split /\t/,$_;
	#$a[0] =~s/\//_/g;
	print ">$a[0]\n$a[9]\n";
}
