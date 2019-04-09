open SAMPLE,"/public/home/hangjf/cancer-changhai/Normal_vcf/sample",or die $!;
while(<SAMPLE>)
{
	chomp;
	@bb = split/\t/,$_;
	$m{$bb[0]} = $bb[1];
}
open GENE,"/public/home/hangjf/cancer-changhai/18variant/kkk.gene",or die $!;
while(<GENE>)
{
	chomp;
	push @gene,$_;
}

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
			if ($a[5]=~/exonic/)
                        {
                                if ($a[8] eq "frameshift deletion" ||$a[8] eq "frameshift insertion" ||$a[8] eq "nonsynonymous SNV"||$a[8] eq "stopgain"||$a[8] eq "stoploss")
                                {
					$hash{$a[1]}{$a[2]}{$a[3]}{$a[4]}{$sample} = $_;
				}
			}
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
