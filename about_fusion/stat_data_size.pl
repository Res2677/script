open FQ,$ARGV[0],or die $!;
$cnt = 0;
while(<FQ>)
{
	#chomp;
	$line = <FQ>;
	chomp $line;
	$cnt = $cnt + length($line);
	#print "$cnt\n";
}
$size = $cnt/3000000000;
print sprintf("%.2f X\n", $size);
