use Data::Dumper;
#print "e.g\nperl print_pos_base.pl /public/ALL_DATA/references/hg19/chrM.fa chr5 6191-6411\n";
sub arr_len
{
	my $cnt =0;
	foreach $pp (@_){$cnt ++;}
	return $cnt;
}

$chrosome = $ARGV[1];
open IN,$ARGV[0],or die $!;
@pos = split/-/,$ARGV[2];
$start_pos = $pos[0];

open RE,"/public/home/hangjf/data/database/hg38/ALL.gene.exon_intron.re.txt",or die $!;
while(<RE>)
{
	
}

if (&arr_len(@pos) == 2){$end_pos = $pos[1];}
$/=">";
$cnt =0;
$dcnt =0;
#print "\nPOS $ARGV[2]:\n";
while(<IN>)
{
	chomp;
	@ss = split/\n/;
	$seq_name = $ss[0];
	if ($seq_name eq $chrosome)
	{
	$cnt =0;
	shift @ss;
	foreach $base (@ss)
	{
        	@seq = split//,$base;
        	foreach $b (@seq)
        	{
			$cnt ++;
			if (&arr_len(@pos) == 1)
			{
				if ($cnt == $start_pos)
                		{
					$nn = uc($b);
                        		print "$nn";
                		}
			}
			if (&arr_len(@pos) == 2)
			{
				if ($cnt >= $start_pos and $cnt <= $end_pos)
				{
					$dcnt ++;
					$ee = $dcnt % 70;
					$nn = uc($b);
					print "$nn";
					#if ($ee == 0){print "\n";}
				}
			}
			#$ee = $cnt % 70;
			#print "$ee\n";
			#if ($ee == 0){print "\n";}
        	}
			
	}
	}
}

