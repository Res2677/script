use Data::Dumper;
open FASTA,$ARGV[0],or die $!;
$/=">";
$a = 0;$g = 0;$c = 0;$t = 0;
$A = 0;$G = 0;$C = 0;$T = 0;
$N = 0;$total = 0;$known = 0;
$chromsome = $ARGV[1];
print "$chromsome\n";
while(<FASTA>)
{
	chomp;
	#if (/$chromsome/){
	@line = split /\n/,$_;
	$chr = $line[0];
	if ($chr =~/$chromsome/){
	delete $line[0];
	print "$chr\n";
	foreach $line(@line)
	{
		@base = split//,$line;
		foreach $base (@base)
		{
			#print "$base\n";
			if ($base=~/a/){$a ++;$known ++;}
			elsif ($base=~/A/){$A ++;$known ++;}
			elsif ($base=~/t/){$t ++;$known ++;}
			elsif ($base=~/T/){$T ++;$known ++;}
			elsif ($base=~/c/){$c ++;$known ++;}
			elsif ($base=~/C/){$C ++;$known ++;}
			elsif ($base=~/g/){$g ++;$known ++;}
			elsif ($base=~/G/){$G ++;$known ++;}
			elsif ($base=~/N/){$N ++;}
			else {$hash{$base} ++;$known ++;}
			$total ++ ;
		}
	}}
}
$Aa = $A + $a;$Tt = $T + $t;$Gg = $G + $g;$Cc = $C + $c;
$ATGC = $A + $T + $G + $C;$atgc = $a + $t + $g + $c;
$Aa_pre = sprintf("%.2f",($Aa/$total)*100);
$Tt_pre = sprintf("%.2f",($Tt/$total)*100);
$Gg_pre = sprintf("%.2f",($Gg/$total)*100);
$Cc_pre = sprintf("%.2f",($Cc/$total)*100);
$ATGC_pre = sprintf("%.2f",($ATGC/$total)*100);
$atgc_pre = sprintf("%.2f",($atgc/$total)*100);
$N_pre = sprintf("%.2f",($N/$total)*100);
print "A/a:\t$Aa  ($Aa_pre%)\nT/t:\t$Tt  ($Tt_pre%)\nG/g:\t$Gg  ($Gg_pre%)\nC/c:\t$Cc  ($Cc_pre%)\n";
print "ATGC:\t$ATGC  ($ATGC_pre%)\natgc:\t$atgc  ($atgc_pre%)\n";
print "N:\t$N  ($N_pre%)\n";
foreach $ba (keys %hash)
{
	print "$ba:\t$hash{$ba}\n";
}
print "known:\t$known\n";
print "all:\t$total\n";
