use Data::Dumper;
use Getopt::Long;
GetOptions(
	"sample:s" => \$sample,
	"gene:s" => \$genefile,
	"help|h:s" => \$help
);
if(!$sample || !$genefile || $help)
{
	die <<USAGE;
==================================================================================
Options:
this script be used to select gene info from vcf.
	sample	file include sample,type,path
	gene	file include gene
	help	help info
e.g
perl $0 -sample **.txt -gene **.txt
USAGE
}
open SAMPLE,"$sample",or die $!;
while(<SAMPLE>)
{
	chomp;
	@bb = split/\t/,$_;
	$m{$bb[0]} = $bb[1];
}
open GENE,"$genefile",or die $!;
while(<GENE>)
{
	chomp;
	push @gene,$_;
}
#print Dumper \@gene;
#print Dumper \%m;
foreach $sample (keys %m)
{
	open IN,"/public/home/hangjf/cancer-changhai/Normal_vcf/hg38_vcf/$sample.hg38_multianno.txt",or die $!;
	while(<IN>)
	{
		chomp;
		next if(/#/);
		@a = split/\t/,$_;
		if(grep /^$a[6]$/, @gene or grep /^$a[6];/, @gene or grep /;$a[6]$/, @gene)
		{	
			$hash{$a[1]}{$a[2]}{$a[3]}{$a[4]}{$sample} = $_;
		}
	}
}
foreach $start (sort {$a <=> $b} keys %hash)
{
	foreach $end (sort {$a <=> $b} keys %{$hash{$start}})
	{
		foreach $pp (keys %{$hash{$start}{$end}})
		{
			foreach $kk (keys %{$hash{$start}{$end}{$pp}})
			{
				foreach $sample (keys %{$hash{$start}{$end}{$pp}{$kk}})
				{
					print "$sample\t$m{$sample}\t$hash{$start}{$end}{$pp}{$kk}{$sample}\n";
				}
			}
		}
	}
}
