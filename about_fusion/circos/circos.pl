`perl deal_cnv_cns.pl /public/home/hangjf/Project/Glioma_201808/cnvkit/Golima_C.cns`;

`samtools depth /public/home/hangjf/cancer-changhai/result/STAR-Fusion-GRCh8/process/ZF012/ZF012-N/std.STAR.bam >/public/home/hangjf/cancer-changhai/result/STAR-Fusion-GRCh8/bam_stat/ZF012.N.depth`
`perl /public/home/hangjf/script/about_fusion/circos/deal_depth.pl /public/home/hangjf/cancer-changhai/result/STAR-Fusion-GRCh8/bam_stat/ZF013.N.depth > /public/home/hangjf/cancer-changhai/CIRCOS/depth/ZF013.N.depth.txt`

`python /public/home/hangjf/script/about_fusion/circos/deal_fusion.py --txt /public/home/hangjf/cancer-changhai/result/STAR-Fusion-GRCh8/filter_fusion/DNA/MERGE_ZF014-N.fusion.xls --gout /public/home/hangjf/cancer-changhai/CIRCOS/depth/ZF014.N.gene.txt --lout /public/home/hangjf/cancer-changhai/CIRCOS/depth/ZF014.N.link.txt`

`perl /public/home/hangjf/script/about_fusion/circos/circos/deal_cnv_cns.pl /public/home/hangjf/cancer-changhai/CNVKIT/ZF014/ZF014_C.cns >/public/home/hangjf/cancer-changhai/CIRCOS/depth/ZF014.CNV.txt`


