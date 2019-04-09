open IN,"/public/home/hangjf/data/database/cancer/VARIANTION.txt",or die $!;
while(<IN>)
{
	chomp;
	@a = split /\t/,$_;
	if ($a[2] =~/EXON (\S+) MUTATION/) {$va = "exon$1";}
	elsif ($a[2] =~/\(c.(\S+)(\S+)>(\S+)\)/) {$va = "c.$2$1$3";}
	elsif ($a[2] eq "MUTATION") {$va = $a[0];}
	else {$va = $a[2];}
	$h1{$a[0]}{$va}=$a[2];
	$h2{$a[0]}{$va}=$a[3];
	$h3{$a[0]}{$va}=$a[5];
	$h4{$a[0]}{$va}=$a[8];
	$h5{$a[0]}{$va}=$a[9];
}
print "gene\tvariant\tdisease\tdrugs\tclinical significance\tevidence statement\trs\n";
open IN1,"$ARGV[0]",or die $!;
while(<IN1>)
{
	chomp;
	if (/exonic/)
	{
		@a = split /\t/,$_;
		foreach $gene (keys %h1)
		{
			if ($gene eq $a[6] or $gene eq ";$a[6]" or $gene eq "$a[6];")
			{
				foreach $variant (keys %{$h1{$gene}})
				{
					if ($_=~/$variant/){print "$gene\t$h1{$gene}{$variant}\t$h2{$gene}{$variant}\t$h3{$gene}{$variant}\t$h4{$gene}{$variant}\t$h5{$gene}{$variant}\t$a[19]\n";}
				}
			}
		}
	}
}
