use Data::Dumper;
open IN,"gunzip -c /public/ALL_DATA/raw_data/JWZ/Run2/DFP1960_11.29_combined_R1.fastq.gz|",or die $!;
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
	if ($seq=~/AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC/){$i++;$hash1{$ss[0]}=$seq;}
	#if ($i == 50){last;}
}
print Dumper \%hash1;
open IN,"gunzip -c /public/ALL_DATA/raw_data/JWZ/Run2/DFP1960_11.29_combined_R2.fastq.gz|",or die $!;
$i =0;
while($i <1000)
{
        $id = <IN>;
	@ss =split/ /,$id;
        $seq = <IN>;
        <IN>;
        <IN>;
        if ($seq=~/AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT/){$i++;$hash2{$ss[0]}=$seq;}
}
print Dumper \%hash2;
$c =0;
open OUT1,">11.29-1.fasta",or die $!;
open OUT2,">11.29-2.fasta",or die $!;
foreach $ss (keys %hash1)
{
	if (exists $hash2{$ss}){$c ++;print OUT1 ">$ss\n$hash1{$ss}";print OUT2 ">$ss\n$hash2{$ss}";}
}
