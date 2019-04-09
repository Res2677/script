use Getopt::Long；
GetOptions(
	"gtf=s" => \$gtf,
	"cnr=s" => \$cnr,
	"log=i" => \$log
);

open IN,$gtf,or die $!;
while(<IN>)
{
	chomp;
	next if (/##/);
        @a = split/\t/,$_;
        if ($a[2]=~/gene/ and $a[8]=~/gene_name "(\S+)";/){$gene = $1;$cc{$gene}{$a[0]}{$a[3]} = $a[4];}
}
open CNR,$cnr,or die $!;
while(<CNR>)
{
	chomp;
	
}
