open CNS,"$ARGV[0]",or die $!;
<CNS>;
while(<CNS>)
{
	chomp;
	@a =split/\t/,$_;
	$a[0]=~s/chr/hs/g;
	print "$a[0]\t$a[1]\t$a[2]\t$a[4]\n";
}
print "hsM\t100\t16000\t0\n";
