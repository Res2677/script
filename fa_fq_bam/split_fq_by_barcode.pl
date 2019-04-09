use Data::Dumper;
use Getopt::Long;
GetOptions(
	"-fq:s" => \$fq,
	"-gz:s" => \$gz,
	"-o:s" => \$outdir,
	"-help|?" => \$help
);

if(!defined $fq || defined $help){
	die << "USEGE";
options:
	-fq	fastq file
	-gz	if fastq.gz,add it
	-o	outdir 
	-help	message for help
e.g.:
perl $0 -fq R1.fastq.gz,R2.fastq.gz -gz -o .
USEGE
}
$outdir = ".";
system("mkdir -p $outdir/result");

@file = split/,/,$fq;
foreach $file (@file)
{
	@name = split/\//,$file;
	$file_n = $name[-1];
	$hash_file_n{$file} = $file_n;
}
#print Dumper \%hash_file_n;
my %hash_fn;
open OUT,">sss.txt",or die $!;
foreach $file (@file)
{
	if (defined $gz)
	{
		open IN,"gunzip -c $file|",or die $!;
		while(<IN>)
        	{
		chomp;
                @index = split/:/,$_;
                $file_name = $index[-1]."-".$hash_file_n{$file};
		$file_name=~s/.gz//g;
                #print "$file_name\n";
                if (!exists $hash_fn{$file_name})
		{
			close OUT;
			$hash_fn{$file_name} = 1;
			open OUT,">$outdir/result/$file_name",or die $!;
		}
		$line2 = <IN>;
                $line3 = <IN>;
                $line4 = <IN>;
		print OUT"$_\n$line2$line3$line4";
        	}
	}
	else
	{
		open IN,$file,or die $!;
		while(<IN>)
		{
		@index = split/:/,$_;
		$file_name = s/fq|gz//g,$index[-1].$hash_file_n{$file};
		print $file_name;
		print <IN>;
		print <IN>;
		print <IN>;
		}
	}
}
