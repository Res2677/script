use Data::Dumper;
open TSV,$ARGV[0],or die $!;
<TSV>;
while(<TSV>)
{
	chomp;
	@a =split/\t/,$_;
	@gene = split/--/,$a[0];
	#print "$a[8]";
	@reads_id = split/,/,$a[8];
	#print Dumper \@reads_id;
	foreach $gene (@gene)
	{
		#print "$gene\n";
		push @{$hash_gene{$a[0]}{$gene}},@reads_id;
	}
	push @all_reads_id,@reads_id;
}

print Dumper \@all_reads_id;
#print Dumper \%hash_gene;
$rnaref = $ARGV[1];
$fastq1 = $ARGV[2];
$fastq2 = $ARGV[3];
#$sam = $ARGV[2];
#$out = $ARGV[3];
open FASTQ1,$fastq1,or die $!;
while (<FASTQ1>)
{
	chomp;
	$R1_l2 = <FASTQ1>;
	<FASTQ1>;
	<FASTQ1>;
	foreach $id (@all_reads_id)
	{
		#print "$id\n";
		if (/$id/){print "$_\n";shift @all_reads_id;#print Dumper \@all_reads_id;
		last;}
	}
}

foreach $kk (keys %hash_gene)
{
	foreach $ll (keys %{$hash_gene{$kk}})
	{
		open OUT,">$out/$kk.$ll.fasta",or die $!;
		open RNAREF,$rnaref,or die $!;
		$/=">";
		while (<RNAREF>)
		{
			chomp;
			if (/$ll/)
			{
				print OUT ">$_";
				#$pp = $_;
				last;
			}
		}
		close RNAREF;
		foreach $read_id (@{$hash_gene{$kk}{$ll}})
		{
			print "$read_id\n";
			print ">$read_id\n$hash_read_id1{$read_id}>$read_id\n$hash_read_id2{$read_id}";
		}
		close OUT;
	}
}
