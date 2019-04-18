library(karyoploteR)
library(regioneR)
pdf("C://Users//admin//Desktop//Variation in Whole Genome.pdf",12,6)
somatic.mutations <- read.table(file="C://Users//admin//Desktop//CN.shenmama.anno.exonic.SNP.txt", header=FALSE, sep="\t", stringsAsFactors=FALSE)
somatic.mutations <- setNames(somatic.mutations, c("chr", "start", "end", "ref", "alt"))

#somatic.mutations <- split(somatic.mutations, somatic.mutations$sample)
sm <- somatic.mutations
sm.gr <- toGRanges(sm[,c("chr", "start", "end", "ref", "alt")])
seqlevelsStyle(sm.gr) <- "UCSC"
#kp <- plotKaryotype(plot.type=4)
#kpPlotRainfall(kp, data = sm.gr)
#kp <- plotKaryotype(plot.type=4)

col.table <- c("A>C"="#7FC97F", "A>G"="#A3B9B0", "A>T"="#C8B1C7","C>A"="#EDBB99","C>G"="#FDD58C","C>T"= "#FEF997","G>A"= "#9BB5A4",
 "G>C"= "#4763AB","G>T"="#B2258F","T>A"="#E31864","T>C"="#C74C28","T>G"="#995F37",other="#666666")
variant.colors <- getVariantsColors(sm.gr$ref, sm.gr$alt,col.table)

#kp <- plotKaryotype(plot.type=4)
pp <- getDefaultPlotParams(plot.type = 4)

pp$data1inmargin <- 0
pp$bottommargin <- 20

par(mfrow = c(1,1))
kp <- plotKaryotype(plot.type=4, ideogram.plotter = NULL,
                    labels.plotter = NULL, plot.params = pp)
kpAddCytobandsAsLine(kp)
kpAddChromosomeNames(kp, srt=45)
kpAddMainTitle(kp, main="Variation in Whole Genome", cex=1.2)
kpPlotRainfall(kp, data = sm.gr, col=variant.colors, r0=0, r1=0.7)
kpAxis(kp, ymax = 7, tick.pos = 1:7, r0=0, r1=0.7)
kpAddLabels(kp, labels = c("Distance between mutations (log10)"), srt=90, pos=1, label.margin = 0.04, r0=0, r1=0.7)

par(new=T)
points(0.1,0.9, pch = 19, col = "#7FC97F",cex=2)
text(0.14,0.9,labels="A>C",bty = "n",col="black",cex=1.4)
points(0.2,0.9, pch = 19, col = "#A3B9B0",cex=2)
text(0.24,0.9,labels="A>G",bty = "n",col="black",cex=1.4)
points(0.3,0.9, pch = 19, col = "#C8B1C7",cex=2)
text(0.34,0.9,labels="A>T",bty = "n",col="black",cex=1.4)
points(0.4,0.9, pch = 19, col = "#EDBB99",cex=2)
text(0.44,0.9,labels="C>A",bty = "n",col="black",cex=1.4)
points(0.5,0.9, pch = 19, col = "#FDD58C",cex=2)
text(0.54,0.9,labels="C>G",bty = "n",col="black",cex=1.4)
points(0.6,0.9, pch = 19, col = "#FEF997",cex=2)
text(0.64,0.9,labels="C>T",bty = "n",col="black",cex=1.4)
points(0.7,0.9, pch = 19, col = "#9BB5A4",cex=2)
text(0.74,0.9,labels="G>A",bty = "n",col="black",cex=1.4)
points(0.1,0.8, pch = 19, col = "#4763AB",cex=2)
text(0.14,0.8,labels="G>C",bty = "n",col="black",cex=1.4)
points(0.2,0.8, pch = 19, col = "#B2258F",cex=2)
text(0.24,0.8,labels="G>T",bty = "n",col="black",cex=1.4)
points(0.3,0.8, pch = 19, col = "#E31864",cex=2)
text(0.34,0.8,labels="T>A",bty = "n",col="black",cex=1.4)
points(0.4,0.8, pch = 19, col = "#C74C28",cex=2)
text(0.44,0.8,labels="T>C",bty = "n",col="black",cex=1.4)
points(0.5,0.8, pch = 19, col = "#995F37",cex=2)
text(0.54,0.8,labels="T>G",bty = "n",col="black",cex=1.4)
points(0.6,0.8, pch = 19, col = "#666666",cex=2)
text(0.64,0.8,labels="other",bty = "n",col="black",cex=1.4)

dev.off()
#kpPlotDensity(kp, data = sm.gr, r0=0.72, r1=1)
#kpAddLabels(kp, labels = c("Density"), srt=90, pos=1, label.margin = 0.04, r0=0.71, r1=1)
