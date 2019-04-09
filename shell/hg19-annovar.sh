#!/bin/bash
echo "$1";
perl /public/home/hangjf/software/annovar/table_annovar.pl $1 /public/home/hangjf/software/annovar/humandb/ -buildver hg19 -out $2 -remove -protocol refGene,cytoBand,exac03,avsnp147,dbnsfp30a -operation g,r,f,f,f -nastring . -vcfinput;
