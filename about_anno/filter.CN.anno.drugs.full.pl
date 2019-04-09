open IN,"/public/home/hangjf/data/database/cancer/01-Mar-2018-ClinicalEvidenceSummaries.tsv",or die $!;
while(<IN>)
{
	chomp;
	@a = split /\t/,$_;
	if ($a[2] =~/EXON (\S+) MUTATION/) {$va = "exon$1";}
	elsif ($a[2] =~/\(c.(\S+)(\S+)>(\S+)\)/) {$va = "c.$2$1$3";}
	elsif ($a[2] eq "MUTATION") {$va = $a[0];}
	else {$va = $a[2];}
	$hash{$a[0]}{$va}=$_;
}
print "gene\tentrez_id\tvariant\tdisease doid\tdrugs\tevidence_type\tevidence_direction\tevidence_level\tclinical_significance\tevidence_statement\tpubmed_id\tcitation\trating\tevidence_status\tevidence_id\tvariant_id\tgene_id chromosome\tstart\tstop\treference_bases\tvariant_bases\trepresentative_transcript\tchromosome2\tstart2\tstop2\trepresentative_transcript2\tensembl_version\treference_build\tvariant_summary\tvariant_origin\tlast_review_date\tevidence_civic_url\tvariant_civic_url\tgene_civic_url\tChr\tStart\tEnd\tRef\tAlt\tFunc.refGene\tGene.refGene\tGeneDetail.refGene\tExonicFunc.refGene\tAAChange.refGene\tcytoBand\tExAC_ALL\tExAC_AFR\tExAC_AMR\tExAC_EAS\tExAC_FIN\tExAC_NFE\tExAC_OTH\tExAC_SAS\tavsnp147\tSIFT_score\tSIFT_pred\tPolyphen2_HDIV_score\tPolyphen2_HDIV_pred\tPolyphen2_HVAR_score\tPolyphen2_HVAR_pred\tLRT_score\tLRT_pred\tMutationTaster_score\tMutationTaster_pred\tMutationAssessor_score\tMutationAssessor_pred\tFATHMM_score\tFATHMM_pred\tPROVEAN_score\tPROVEAN_pred\tVEST3_score\tCADD_raw\tCADD_phred\tDANN_score\tfathmm-MKL_coding_score\tfathmm-MKL_coding_pred\tMetaSVM_score\tMetaSVM_pred\tMetaLR_score\tMetaLR_pred\tintegrated_fitCons_score\tintegrated_confidence_value\tGERP++_RS\tphyloP7way_vertebrate\tphyloP20way_mammalian\tphastCons7way_vertebrate\tphastCons20way_mammalian\tSiPhy_29way_logOdds\tOtherinfo\n";
open IN1,"$ARGV[0]",or die $!;
while(<IN1>)
{
	chomp;
	if (/exonic/)
	{
		@a = split /\t/,$_;
		foreach $gene (keys %hash)
		{
			if ($gene eq $a[8] or $gene eq ";$a[8]" or $gene eq "$a[8];")
			{
				foreach $vairant (keys %{$hash{$gene}})
				{
					if ($_=~/$vairant/){print "$hash{$gene}{$vairant}\t$_\n";}
				}
			}
		}
	}
}
