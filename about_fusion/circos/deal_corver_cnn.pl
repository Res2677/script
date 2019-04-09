open CNN,"$ARGV[0]",or die $!;
<CNN>;
while(<CNN>)
{
	chomp;
	@a =split/\t/,$_;
	$a[0]=~s/chr/hs/g;
	print "$a[0]\t$a[1]\t$a[2]\t$a[4]\n";
}
print "hsM\t100\t16000\t10\n";
