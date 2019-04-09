#######
PATH=/public/home/hangjf/Project/Gastric_20181023/control
FQ1=/public/home/hangjf/Project/Gastric_20181023/data/control.r1.fastq 
FQ2=/public/home/hangjf/Project/Gastric_20181023/data/control.r2.fastq
SAMPLE=Gastric.control
########bwa
bwa mem /public/home/hangjf/data/database/GRCh38.d1.vd1.fa $FQ1 $FQ2 -t 20|samtools view -bS >$PATH/bwa/control.bam
samtools sort -@ 20 $PATH/bwa/control.bam
samtools index $PATH/bwa/control.sort.bam

########CNV

python /public/home/hangjf/test/cnvkit/script/run.py --conf /public/home/hangjf/Project/Gastric_20181023/cnvkit/control/cnvkit.conf

########fusion
STAR-Fusion --genome_lib_dir /public/home/hangjf/data/database/STAR/GRCh38_v27_CTAT_lib_Feb092018/ctat_genome_lib_build_dir --left_fq $FQ1 --right_fq $FQ2 --output_dir $PATH/fusion --CPU 16 --limitSjdbInsertNsj 3129044

perl creat_all_fasta_bam_STAR_tsv.pl -t $PATH/fusion/star-fusion.fusion_predictions.tsv -bam $PATH/fusion/std.STAR.bam -s $SAMPLE -o $PATH/fusion/fasta
perl /public/home/hangjf/script/about_fusion/merge.fusion.fasta.pl $PATH/fasta/$SAMPLE >$PATH/fusion/fasta/$SAMPLE\.merge.fasta

blat /public/home/hangjf/data/database/STAR/GRCh38_gencode_v26_CTAT_lib_July192017/ref_genome.fa $PATH/fusion/fasta/$SAMPLE\.merge.fasta $PATH/fusion/fasta/$SAMPLE\.psl

python /public/home/hangjf/script/about_fusion/STAR_fusion_check/check_blat.py --psl $PATH/fusion/fasta/$SAMPLE\.psl --fa $PATH/fusion/fasta/$SAMPLE\.merge.fasta --out $PATH/fusion/fasta/$SAMPLE\.fusion.xls

#########circos
samtools depth $PATH/bwa/control.sort.bam >$PATH/fusion/$SAMPLE\.depth
perl /public/home/hangjf/script/about_fusion/circos/deal_depth.pl $PATH/$SAMPLE\.depth >$PATH/fusion/$SAMPLE\.depth.txt
rm $PATH/fusion/$SAMPLE\.depth

perl /public/home/hangjf/script/about_fusion/circos/circos/deal_cnv_cns.pl $PATH/cnvkit/$SAMPLE\_C.cnr >$PATH/cnvkit/$SAMPLE\_C.cnv.txt
python /public/home/hangjf/script/about_fusion/circos/deal_fusion.py --txt $PATH/fusion/fasta/$SAMPLE\.fusion.xls --gout $PATH/fusion/fasta/$SAMPLE\.fusion.gene.txt --lout $PATH/fusion/fasta/$SAMPLE\.fusion.link.txt

#mkdir -p /public/home/hangjf/Project/Gastric_20181023/circos/control
python /public/home/hangjf/script/about_fusion/circos/circos/circos.conf.py --ccnv $PATH/cnvkit/$SAMPLE\_C.cnv.txt --ncnv $PATH/cnvkit/$SAMPLE\_C.cnv.txt --depth $PATH/fusion/$SAMPLE\.depth.txt --gene $PATH/fusion/fasta/$SAMPLE\.fusion.gene.txt --link $PATH/fusion/fasta/$SAMPLE\.fusion.link.txt --out $PATH/circos
/public/home/hangjf/software/circos-0.69-6/bin/circos -conf $PATH/circos/circos.conf
