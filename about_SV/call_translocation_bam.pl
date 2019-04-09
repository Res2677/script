open BAM,"samtools view $ARGV[0]|",or die $!;
while(<BAM>)
{
	@data1 = split/\t/,$_;
	$read2_data = <BAM>;
	@data2 = split/\t/,$read2_data;
	if ($data1[0] eq $data2[0])
	{
		if ($data1[2] ne $data2[2])
		{
			print "$_";
			print "$read2_data";
		}
	}
}

