use Data::Dumper;
$tsv1 = $ARGV[0];
$sam1 = $ARGV[1];
$tsv2 = $ARGV[2];
$sam2 = $ARGV[3];
$sample = $ARGV[4];
$out = $ARGV[5];
open TSV1,$tsv1,or die $!;
<TSV1>;
while(<TSV1>)
{
	chomp;
	@a =split/\t/,$_;
	$a[8]=~s/,/|/g;
	$hash1_gene{$a[0]} = $a[8];
}
open TSV2,$tsv2,or die $!;
<TSV2>;
while(<TSV2>)
{
        chomp;
        @a =split/\t/,$_;
        $a[8]=~s/,/|/g;
        $hash2_gene{$a[0]} = $a[8];
}

foreach $kk (keys %hash1_gene)
{
	$fasta = `grep -E \'$hash1_gene{$kk}\' $sam1|grep -v \'=\'|awk \'{print \">\"\$1\"\\n\"\$10}\'`;
	@pp = split/>/,$fasta;
	my %hash1_len;
	foreach $dd (@pp)
	{
		@oo = split /\n/,$dd;
		$len = length($oo[1]);
		$hash1_len{$len} = $dd;
	}
	foreach $ww (sort keys %hash1_len){
	$enen = $hash1_len{$ww};
	}
	@mmm1 = split/\n/,$enen;
	$hash1kk{$kk}{$mmm1[0]} = $mmm1[1];
}

foreach $kk (keys %hash2_gene)
{
        $fasta = `grep -E \'$hash2_gene{$kk}\' $sam2|grep -v \'=\'|awk \'{print \">\"\$1\"\\n\"\$10}\'`;
        @pp = split/>/,$fasta;
        my %hash2_len;
	foreach $dd (@pp)
        {
                @oo = split /\n/,$dd;
                $len = length($oo[1]);
                $hash2_len{$len} = $dd;
        }
        foreach $ww (sort keys %hash2_len){
        $enen = $hash2_len{$ww};
        }
        @mmm2 = split/\n/,$enen;
	$hash2kk{$kk}{$mmm2[0]} = $mmm2[1];
}

open OUT,">$out",or die $!;
print OUT "Translocation\nsample\tfusion\tConconsensus read ID\tRead sequence\tUpstream Postion\tBreakpoint in left, Func.refGene\tLeft sequence\tDownstream Postion\tBreakpoint in right, Func.refGene\tRight sequence\n";
foreach $kk (keys %hash1kk)
{
	foreach $cc (keys %{$hash1kk{$kk}})
	{
		print OUT "$sample-C\t$kk\t$cc\t$hash1kk{$kk}{$cc}\n";
	}
}
foreach $kk (keys %hash2kk)
{
        foreach $cc (keys %{$hash2kk{$kk}})
        {
                print OUT "$sample-N\t$kk\t$cc\t$hash2kk{$kk}{$cc}\n";
        }
}
=cut
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
		if (/$id/)
		{
			print "$_\n";
			shift @all_reads_id;#print Dumper \@all_reads_id;
			last;
		}
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
