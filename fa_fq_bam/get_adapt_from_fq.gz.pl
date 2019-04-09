use Data::Dumper;
use Getopt::Long;
open IN,"gunzip -c $ARGV[0]|",or die $!;
$i =0;
while($i <1000)
{
	$id = <IN>;
	#print "$id\n";
	@ss =split/ /,$id;
	$seq = <IN>;
	#print "$ss[0]\n";
	<IN>;
	<IN>;
	if ($seq=~/$ARGV[1]/){$i++;$hash1{$ss[0]}=$seq;}
	#if ($i == 50){last;}
}
print Dumper \%hash1;
open IN,"gunzip -c $ARGV[2]|",or die $!;
$i =0;
while($i <1000)
{
        $id = <IN>;
	@ss =split/ /,$id;
        $seq = <IN>;
        <IN>;
        <IN>;
        if ($seq=~/$ARGV[3]/){$i++;$hash2{$ss[0]}=$seq;}
}
print Dumper \%hash2;
$c =0;
open OUT1,">$ARGV[4].1.fasta",or die $!;
open OUT2,">$ARGV[4].2.fasta",or die $!;
foreach $ss (keys %hash1)
{
	if (exists $hash2{$ss}){$c ++;print OUT1 ">$ss\n$hash1{$ss}";print OUT2 ">$ss\n$hash2{$ss}";}
}
