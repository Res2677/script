use Data::Dumper;
use Getopt::Long;
my ($fasta,$mop,$outdir,$help);
GetOptions(
	"fa:s" => \$fasta,
	"overlap:i" => \$mop,
	"dis=s" => \$mydis,
	"o:s" => \$outdir,
	"h|?" => \$help
);

if (!defined $fasta || defined $help){
	die << "USAGE";
	description: cluster
	usage: perl $0 [options]
options:
	-fa
	-overlap
e.g.:
perl $0 -fa *.fasta -overlap 15
USAGE
}
open FA,$fasta,or die $!;
$/=">";
<FA>;
$proseed=<FA>;
@qpro = split/\n/,$proseed;
$seed = $qpro[1];
sub get_seg{
	my $start = $_[0];
	my $end = $_[1];
	my @seq = @{$_[2]};
	my $seg = "";
	if ($start > $end){return "";}
	elsif($start > $end){return $seq[0];}
	else
	{
		foreach $pos ($start-1..$end-1)
		{
			$seg = $seg.$seq[$pos];
		}
		#print "$seg\n";
		return $seg;
	}
}

sub judge{
	my $a = $_[0];
	my $b = $_[1];
	my $extract = $_[2];
	@aa = split //,$a;
	@bb = split //,$b;
	my $len = @aa;
	my $miss_num =0;
	my $match_num =0;
	foreach $pos (0..$extract-1)
	{
		if ($aa[$pos] eq $bb[$pos])
		{
			$match_num ++;
		}
		else
		{
			$miss_num ++;
		}
	}
	$ratio = $match_num/$extract;
	return $ratio;
}

while(<FA>)
{
	chomp;
	@read = split/\n/,$_;
	@seed = split//,$seed;
	$seed_len = @seed;
	@this = split//,$read[1];
	$this_len = @this;
	my @langer;
	my @shorter;
	if ($seed_len >= $this_len){$longer_len = $seed_len;$shorter_len = $this_len;push @langer,@seed;push @shorter,@this;}
	else {$longer_len = $this_len;$shorter_len = $seed_len;push @langer,@this;push @shorter,@seed;}
	$all_len = $longer_len + $shorter_len;
	$miss_cnt = 0;
	foreach $len ($mop..$all_len-$mop)
	{
		if ($len < $shorter_len)
		{
			$longer_seg = get_seg(1,$len,\@langer);
			$shorter_seg = get_seg($shorter_len-$len+1,$shorter_len,\@shorter);
			$longer = get_seg(1,$longer_len,\@langer);
			$shorter = get_seg(1,$shorter_len,\@shorter);
			$up_seg = get_seg(1,$shorter_len-$len,\@shorter);
			$down_seg = get_seg($len+1,$longer_len,\@langer);
			%hh,$dis = judge($longer_seg,$shorter_seg,$len);
			if ($dis >= $mydis)
			{
				$seed = $up_seg.$longer_seg.$down_seg;
				#print "longer:$longer_seg\nshort :$shorter_seg\nlonger:$longer\nshort :$shorter\nlen = shorter_len\n$len = $shorter_len\ndis:$dis\nconsenuce:$longer_seg\nnext_seed:$seed\nup:$up_seg\ndown:$down_seg\n\n";
			}
		}
		if ($len == $shorter_len and $len != $longer_len)
		{
			$longer_seg = get_seg(1,$len,\@langer);
			$shorter_seg = get_seg(1,$shorter_len,\@shorter);
			$longer = get_seg(1,$longer_len,\@langer);
			$shorter = get_seg(1,$shorter_len,\@shorter);
			$up_seg = get_seg(1,$shorter_len-$len,\@shorter);
			$down_seg = get_seg($len+1,$longer_len,\@langer);
			%hh,$dis = judge($longer_seg,$shorter_seg,$len);
			if ($dis >= $mydis)
			{
				$seed = $longer_seg.$down_seg;
				#print "longer:$longer_seg\nshort :$shorter_seg\nlonger:$longer\nshort :$shorter\nlen = shorter_len\n$len = $shorter_len\ndis:$dis\nconsenuce:$longer_seg\nnext_seed:$seed\nup:$up_seg\ndown:$down_seg\n\n";
			}
		}
		if ($len > $shorter_len and $len < $longer_len)
		{
			$longer_seg = get_seg($len-$shorter_len+1,$len,\@langer);
			$shorter_seg = get_seg(1,$shorter_len,\@shorter);
			$longer = get_seg(1,$longer_len,\@langer);
			$shorter = get_seg(1,$shorter_len,\@shorter);
			$up_seg = get_seg(1,$len-$shorter_len,\@langer);
			$down_seg = get_seg($len+1,$longer_len,\@langer);
			%hh,$dis = judge($longer_seg,$shorter_seg,$shorter_len);
			if ($dis >= $mydis)
			{
				$seed = $up_seg.$longer_seg.$down_seg;
				#print "longer:$longer_seg\nshort :$shorter_seg\nlonger:$longer\nshort :$shorter\nlen = shorter_len\n$len = $shorter_len\ndis:$dis\nconsenuce:$longer_seg\nnext_seed:$seed\nup:$up_seg\ndown:$down_seg\n\n";
			}
		}
		if ($len == $longer_len and $len == $shorter_len)
		{
			$longer_seg = get_seg($len-$shorter_len+1,$longer_len,\@langer);
			$shorter_seg = get_seg(1,$shorter_len,\@shorter);
			$longer = get_seg(1,$longer_len,\@langer);
			$shorter = get_seg(1,$shorter_len,\@shorter);
			$up_seg = get_seg(1,$len-$shorter_len,\@langer);
			$down_seg = get_seg($shorter_len+1,$shorter_len,\@shorter);
			%hh,$dis = judge($longer_seg,$shorter_seg,$shorter_len);
			if ($dis >= $mydis)
			{
				$seed = $up_seg.$longer_seg;
				#print "longer:$longer_seg\nshort :$shorter_seg\nlonger:$longer\nshort :$shorter\nlen = shorter_len\n$len = $shorter_len\ndis:$dis\nconsenuce:$longer_seg\nnext_seed:$seed\nup:$up_seg\ndown:$down_seg\n\n";
			}
		}
		if ($len == $longer_len and $len != $shorter_len)
		{
			$longer_seg = get_seg($len-$shorter_len+1,$longer_len,\@langer);
			$shorter_seg = get_seg(1,$shorter_len,\@shorter);
			$longer = get_seg(1,$longer_len,\@langer);
			$shorter = get_seg(1,$shorter_len,\@shorter);
			$up_seg = get_seg(1,$len-$shorter_len,\@langer);
			$down_seg = get_seg($shorter_len+1,$shorter_len,\@shorter);
			%hh,$dis = judge($longer_seg,$shorter_seg,$shorter_len);
			if ($dis >= $mydis)
			{
				$seed = $up_seg.$longer_seg;
				#print "longer:$longer_seg\nshort :$shorter_seg\nlonger:$longer\nshort :$shorter\nlen = shorter_len\n$len = $shorter_len\ndis:$dis\nconsenuce:$longer_seg\nnext_seed:$seed\nup:$up_seg\ndown:$down_seg\n\n";
			}
		}

		if ($len > $longer_len)
		{
			$longer_seg = get_seg($len-$shorter_len+1,$longer_len,\@langer);
			$shorter_seg = get_seg(1,$shorter_len+$longer_len-$len,\@shorter);
			$longer = get_seg(1,$longer_len,\@langer);
			$shorter = get_seg(1,$shorter_len,\@shorter);
			#print "$longer_seg\n$shorter_seg\n\n";
			$up_seg = get_seg(1,$len-$shorter_len,\@langer);
			$down_seg = get_seg($shorter_len+$longer_len-$len+1,$shorter_len,\@shorter);
			%hh,$dis = judge($longer_seg,$shorter_seg,$len-$shorter_len);
			if ($dis >= $mydis)
			{
				$seed = $up_seg.$longer_seg.$down_seg;
				#print "longer:$longer_seg\nshort :$shorter_seg\nlonger:$longer\nshort :$shorter\nlen = shorter_len\n$len = $shorter_len\ndis:$dis\nconsenuce:$longer_seg\nnext_seed:$seed\nup:$up_seg\ndown:$down_seg\n\n";
			}
		}
	}
}
print "$seed\n";
