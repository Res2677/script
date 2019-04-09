use Data::Dumper;
print "e.g\nperl print_pos_base.pl /public/ALL_DATA/references/hg19/chrM.fa 6191-6411\n";
sub arr_len
{
	my $cnt =0;
	foreach $pp (@_){$cnt ++;}
	return $cnt;
}

open IN,$ARGV[0],or die $!;
@pos = split/-/,$ARGV[1];
$start_pos = $pos[0];
#print "$start_pos\n";
if (&arr_len(@pos) == 2){$end_pos = $pos[1];}
$/=">";
$cnt =0;
print "\nPOS $ARGV[1]:\n";
while(<IN>)
{
	@ss = split/\n/;
	$seq_name = $ss[0];
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
                        		print "$b";
                		}
			}
			if (&arr_len(@pos) == 2)
			{
				if ($cnt >= $start_pos and $cnt <= $end_pos)
				{
					print "$b";
				}
			}
        	}
	}
}
print "\n";
