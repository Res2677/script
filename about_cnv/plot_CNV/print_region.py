import argparse
import linecache

parser = argparse.ArgumentParser(description='manual to this script')
parser.add_argument('--chro', type = str, default = 'None')
parser.add_argument('--start', type = int,default = None)
parser.add_argument('--end', type = int,default = None)
parser.add_argument('--cnr', type = str,default = 'None')
parser.add_argument('--ref', type = str,default = 'None')
parser.add_argument('--prefix', type = str,default = 'gene')
parser.add_argument('--gene',type =str,default = 'None')
parser.add_argument('--color',type =str,default = 'None')
parser.add_argument('--progress_path',type =str,default= '.')
#option_dict = {}
args = parser.parse_args()
cfg = args.chro

re = []
fg = []
ocnr = open(args.prefix + '.cnr','w')
oreg = open(args.prefix + '.reg','w')

cnrfile = open(args.cnr).readlines()
length = len(cnrfile)
for i in range(length):
  line = linecache.getline(args.cnr,i)
  a = line.split('\t')
  if (a[0] == args.chro):
    if (int(a[1]) >= args.start and int(a[1]) <= args.end):
      re.append(i)

reffile = open(args.ref).readlines()
length = len(reffile)
for i in range(length):
  line = linecache.getline(args.ref,i)
  a = line.split('\t')
  if (len(a) > 2):
    if (a[1] == args.chro and a[0] == args.gene):
      if (int(a[2]) >= args.start and int(a[2]) <= args.end):
        oreg.write(line)
        #fg.append(i)

#print min(re)
#print max(re)
for i in range(min(re)-20,max(re)+20):
  ocnr.write(linecache.getline(args.cnr,i))

rscript = open(args.prefix + '.R','w')
kk = '''
library(ggplot2)
library(RColorBrewer)
cols<-brewer.pal(n=4,name="Set1")

pdf("'''+ args.gene + '''.cnv.pdf",8,8)
tt <- data.frame(read.table("''' + args.prefix + '''.reg"))
scatter <- data.frame(read.table("''' + args.prefix + '''.cnr"))
interval <- max(scatter$V2) -min(scatter$V2)
leftlab <- min(scatter$V2)+(50000 - (min(scatter$V2)%%50000))
rightlab <- max(scatter$V2) - (max(scatter$V2)%%50000)
xlabat <- seq(leftlab,rightlab,50000)
xlab <- paste(seq(leftlab/1000000,rightlab/1000000,0.05),"M")
ylab <- seq(-10,10,5)
xmin <- (max(scatter$V2) + min(scatter$V2))/2

plot(scatter$V2,scatter$V5,ylab="",xlab="",cex.lab=1.5,yaxt="n",xaxt="n",axes=F,main="",col = alpha("''' + args.color +'''", 0.7), cex =1.3,pch=19,ylim = c(-14,13),xlim = c(min(scatter$V2)-interval/10,max(scatter$V2)+(interval/10)*4))
k <- seq(1,length(tt[tt$V5=="intron",]$V3),1)
for (i in k)
{
        segments(tt[tt$V5=="intron",]$V3[i],-11,tt[tt$V5=="intron",]$V4[i],-11,lwd=2,col="lightblue3")
}
k <- seq(1,length(tt[tt$V5=="exon",]$V3),1)
for (i in k)
{
        segments(tt[tt$V5=="exon",]$V3[i],-11,tt[tt$V5=="exon",]$V4[i],-11,lwd=5,col="steelblue")
}

segments(min(scatter$V2)-interval/10,-13,min(scatter$V2)-interval/10,10,lwd=2,col="grey40")
segments(max(scatter$V2)+interval/10,-13,max(scatter$V2)+interval/10,10,lwd=2,col="grey40")
segments(min(scatter$V2)-interval/10,-10,max(scatter$V2)+interval/10,-10,lwd=2,col="grey40")
segments(min(scatter$V2)-interval/10,-13,max(scatter$V2)+interval/10,-13,lwd=2,col="grey40")
segments(min(scatter$V2)-interval/10,0,max(scatter$V2)+interval/10,0,lwd=1.1,col="grey70",lty=2)
axis(1,col="grey40",col.axis="grey40",pos=-13,lwd=2,at=xlabat,labels=xlab)
axis(2,col="grey40",col.axis="grey40",pos=min(scatter$V2)-interval/10,lwd=2,at=ylab,labels=ylab)
text(xmin,-12,labels="''' + args.gene + '''")
par(new=T)
par(mar=c(6,6,6,10),xpd=TRUE)
points(max(scatter$V2)+(interval/10)*2,0,col = alpha(cols[4], 0.7), cex =1.3,pch=19)
segments(max(scatter$V2)+(interval/10)*2,-11,max(scatter$V2)+(interval/10)*2.5,-11,lwd=2,col="lightblue3")
segments(max(scatter$V2)+(interval/10)*2,-12,max(scatter$V2)+(interval/10)*2.5,-12,lwd=5,col="steelblue")
text(max(scatter$V2)+(interval/10)*3.5,0,labels="log2(CNV)")
text(max(scatter$V2)+(interval/10)*3.5,-11,labels="intron")
text(max(scatter$V2)+(interval/10)*3.5,-12,labels="exon")
mtext(side=2,"values of log2(CNV)",line=3,cex=1.3)
mtext(side=3,paste("CNV of ''' + args.gene + ''' (","''' + args.chro + ''':",''' + str(args.start)  +''',"-",''' + str(args.end) +''',")",sep=""),line=1,cex=1.3)
mtext(side=1,"Position in chromosome",line=2,cex=1.3)
dev.off()
'''
rscript.write(kk)
