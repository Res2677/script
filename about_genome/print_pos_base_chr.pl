use Data::Dumper;
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

if (&arr_len(@pos) == 2){$end_pos = $pos[1];}
$/=">";
$cnt =0;
$dcnt =0;
while(<IN>)
{
	chomp;
	@ss = split/\n/;
	$seq_name = $ss[0];
	if ($seq_name =~/$chrosome/)
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
					#$ee = $dcnt % 70;
					$nn = uc($b);
					print "$nn";
				}
			}
        	}
			
	}
	}
}

