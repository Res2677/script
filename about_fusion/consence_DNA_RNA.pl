$dna_file=$ARGV[0];
$dna_col= $ARGV[1];
$rna_file=$ARGV[2];
$rna_col=$ARGV[3];

open DNA,"$dna_file",or die $!;
while(<DNA>)
{
	chomp;
	@a = split/\t/,$_;
	push @DNAfusion,$a[$dna_col-1];
}
close DNA;
open RNA,"$rna_file",or die $!;
while(<RNA>)
{
	chomp;
	@b = split/\t/,$_;
	foreach $ff (@DNAfusion)
	{
		#print "$ff\t$b[$rna_col-1]\n";
		if ($b[$rna_col-1] eq $ff )
		{
			print "$b[$rna_col-1]\n";
		}
	}
}
