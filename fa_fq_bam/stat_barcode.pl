use Data::Dumper;
use Getopt::Long;
use FindBin '$Bin';
GetOptions(
	"p:s" => \$pathfile,
        "adaptor:s" => \$adaptor,
        "o=s"  => \$outdir,
        "help|?" => \$help
);

if (!defined $pathfile || !defined $adaptor ||defined $help) {
        die << "USAGE";
        description: cluster
        usage: perl $0 [options]
options:
	
	-p <file>     a txt that list path for fq.gz like this:
			/public/ALL_DATA/changhai_hospital/two/20160523_Xten/WGC079027-DNANTEA1I160058-A01_combined_R1.fastq.gz
			/public/ALL_DATA/changhai_hospital/two/20160523_Xten/WGC079027-DNANTEA1I160058-A01_combined_R2.fastq.gz
			/public/ALL_DATA/changhai_hospital/two/20160523_Xten/WGC079027-DNANTEA1I160059-B01_combined_R1.fastq.gz
			/public/ALL_DATA/changhai_hospital/two/20160523_Xten/WGC079027-DNANTEA1I160059-B01_combined_R2.fastq.gz
	-adaptor      adaptor seq
	-o	      outdir
e.g.:
perl $0 -p /public/home/hangjf/cancer-changhai/R1-sample-path.txt -adaptor AGATCGGAAGAGCACACGTC -o .
USAGE
}

$outdir = ".";
if($outdir != "."){
`mkdir -p $outdir`;
}
open Q,$pathfile,or die $!;
while(<Q>)
{
	chomp;
	push @path,$_;
}
close Q;
foreach $path(@path)
{
	open IN,"gunzip -c $path|",or die $!;
	$i =0;
	while($i<10)
	{
		$index = <IN>;
		<IN>;
		<IN>;
		<IN>;
		@aa = split/:/,$index;
		$bar = $aa[-1];
		$i ++;
		if (!exists $hash{$path}{$bar}){
			$hash{$path}{$bar} = 1;
		}else{
			$hash{$path}{$bar} ++;
		}
	}
	#print Dumper \%hash;
}

foreach $pp (keys %hash)
{
	$max = 0;
	$b ='SS';
	foreach $bar (keys %{$hash{$pp}})
	{
		#print "$hash{$pp}{$bar}";
		if ($hash{$pp}{$bar} >$max){$max = $hash{$pp}{$bar};$b = $bar;}
	}
	push @{$hash_bar{$b}},$pp;
}
$c =0;
foreach $bar (keys %hash_bar)
{	
	$c ++;
	print "$bar";
	foreach $ss (@{$hash_bar{$bar}})
	{
		print "$ss\t";
	}
	print "\n";
}
print "barcode number:  $c\n";
