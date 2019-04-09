@file = @ARGV;
foreach $file (@file)
{
	open IN,"$file",or die $!;
	while(<IN>)
	{
		chomp;
		@a =split/\t/,$_;
		print Dumper \@a;
		$hash{$a[0]}{$a[1]}{$a[2]} = 1;
		$hash1{$file}{$a[0]}{$a[1]}{$a[2]} = 1;
	}
	close IN;
}

$m1=0;$m2=0;$m3=0;$m12=0;$m13=0;$m23=0;$m123=0;
foreach $jj (keys %hash)
{
	#print "$jj\n";
	foreach $ii (keys %{$hash{$jj}})
	{
		foreach $kk (keys %{$hash{$jj}{$ii}})
		{
			if (exists $hash1{$file[0]}{$jj}{$ii}{$kk} and !exists $hash1{$file[1]}{$jj}{$ii}{$kk} and !exists $hash1{$file[2]}{$jj}{$ii}{$kk}){$m1 ++;}
			if (!exists $hash1{$file[0]}{$jj}{$ii}{$kk} and exists $hash1{$file[1]}{$jj}{$ii}{$kk} and !exists $hash1{$file[2]}{$jj}{$ii}{$kk}){$m2 ++;}
			if (!exists $hash1{$file[0]}{$jj}{$ii}{$kk} and !exists $hash1{$file[1]}{$jj}{$ii}{$kk} and exists $hash1{$file[2]}{$jj}{$ii}{$kk}){$m3 ++;}
			if (exists $hash1{$file[0]}{$jj}{$ii}{$kk} and exists $hash1{$file[1]}{$jj}{$ii}{$kk} and !exists $hash1{$file[2]}{$jj}{$ii}{$kk}){$m12 ++;}
			if (exists $hash1{$file[0]}{$jj}{$ii}{$kk} and !exists $hash1{$file[1]}{$jj}{$ii}{$kk} and exists $hash1{$file[2]}{$jj}{$ii}{$kk}){$m13 ++;}
			if (!exists $hash1{$file[0]}{$jj}{$ii}{$kk} and exists $hash1{$file[1]}{$jj}{$ii}{$kk} and exists $hash1{$file[2]}{$jj}{$ii}{$kk}){$m23 ++;}
			if (exists $hash1{$file[0]}{$jj}{$ii}{$kk} and exists $hash1{$file[1]}{$jj}{$ii}{$kk} and exists $hash1{$file[2]}{$jj}{$ii}{$kk}){$m123 ++;}
		}
	}
}
print "file1:$m1\nfile2:$m2\nfile3:$m3\nfile12:$m12\nfile13:$m13\nfile23:$m23\nfile123:$m123\n";
