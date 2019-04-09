import subprocess
#returnCode = subprocess.call('adb devices')
#print returnCode
import os
import re
import argparse
import linecache
from itertools import islice
parser = argparse.ArgumentParser(description='manual to this script')
#parser.add_argument('--source', type = str, default = None)
parser.add_argument('--ccnv', type = str, default = None)
parser.add_argument('--ncnv', type = str, default = None)
parser.add_argument('--depth', type = str, default = None)
parser.add_argument('--out', type = str, default = None)
parser.add_argument('--gene', type = str, default = None)
parser.add_argument('--link', type = str, default = None)
args = parser.parse_args()

#conf
#circos_out = open('circos/circos.conf','w')
#bands_out = open('circos/bands.conf','w')
#ideogram_label_out = open ('ideogram.label.conf','w')
#ticks_out = open('circos/ticks.conf','w')

#data
def path_deal(k):
  path = k.split('/')
  m = "/".join(path)
  if path[-1] != '':
    m = m +'/'
  return m

outdir = path_deal(args.out)
os.chdir(outdir)
#f.circos.conf = outdir + 'cirocs.conf'
#f.bands.conf = outdir + 'bands.conf'
#f.ideogram.label.conf = outdir + 'ideogram.label.conf'
#f.ticks.conf = outdir + 'ticks.conf'

circos_text = '''
# MINIMUM CIRCOS N.IGURATION
#
# The 'hello world' Circos tutorial. Only required
# configuration elements are included.
#
# Common optional elements are commented out.

# Defines unit length for ideogram and tick spacing, referenced
# using "u" prefix, e.g. 10u
#chromosomes_units           = 1000000

# Show all chromosomes in karyotype file. By default, this is
# true. If you want to explicitly specify which chromosomes
# to draw, set this to 'no' and use the 'chromosomes' parameter.
# chromosomes_display_default = yes

# Chromosome name, size and color definition
karyotype = data/karyotype/karyotype.human.hg38.txt

<ideogram>

<spacing>
# spacing between ideograms
default = 0.005r
break   = 0.5r
</spacing>

# ideogram position, thickness and fill
chromosomes_units           = 1000000
chromosomes_display_default = no
radius           = 0.7r
thickness        = 100p
fill             = yes

<<include ideogram.label.conf>>
<<include bands.conf>>

</ideogram>



<links>

radius = 0.34r
crest  = 0.5
bezier_radius        = 0.1r
bezier_radius_purity = 0.75

<link>
z            = 30
color        = 131,139,131
thickness    = 6
file         = '''+ args.link + '\n' + '''bezier_radius_purity = 0.4
crest        = 2
</link>

</links>
# image size, background color, angular position
# of first ideogram, transparency levels, output
# file and directory
#
# it is best to include these parameters from etc/image.conf
# and override any using param* syntax
#
# e.g.
# <image>
# <<include etc/image.conf>>
# radius* = 500
# </image>
<image>
<<include etc/image.conf>> # included from Circos distribution
</image>

<plots>

#dims(ideogram,radius) + 175p
type       = text
color      = black
label_font = default
label_size = 20p

<plot>
file = '''+ args.gene + '\n' + '''r1   = 1r + 400p
r0   = 1r + 20p

show_links     = yes
link_dims      = 10p,10p,10p,10p,10p
link_thickness = 2p
link_color     = dgrey
orientation = in
</plot>

<plot>
type = histogram
file = '''+ args.depth + '\n' + '''r1   = 0.7r
r0   = 0.6r
fill_color = 205,155,155
extend_bin = no
<rules>
</rules>
#<<include backgrounds.conf>>
</plot>

<plot>
type = histogram
file = ''' + args.depth + '\n' + '''r1   = 0.8r
r0   = 0.7r
fill_color = 79,148,205
extend_bin = no
orientation = in
<rules>
</rules>
#<<include backgrounds.conf>>
</plot>

<plot>
type             = scatter
stroke_thickness = 0.7
file             = '''+ args.ccnv + '\n' + '''fill_color       = dgrey
stroke_color     = dgrey
glyph            = circle
glyph_size       = 7
max   = 10
min   = -10
r1    = 0.58r
r0    = 0.35r
</plot>

<plot>
type             = scatter
stroke_thickness = 0.7
file             = '''+ args.ncnv + '\n' + '''fill_color       = red
stroke_color     = red
glyph            = circle
glyph_size       = 7
max   =  100000
min   = -100000
r1    = 0.58r
r0    = 0.35r
</plot>

</plots>
# RGB/HSV color definitions, color lists, location of fonts,
# fill patterns
<<include etc/colors_fonts_patterns.conf>> # included from Circos distribution

# debugging, I/O an dother system parameters
<<include etc/housekeeping.conf>> # included from Circos distribution

# <ticks> blocks to define ticks, tick labels and grids
#
# requires that chromosomes_units be defined
#
# <<include ticks.conf>>
data_out_of_range* = trim

'''

bands_text = '''
# optional

show_bands            = yes
fill_bands            = yes
band_transparency     = 1
'''

ideogram_label_text = '''
# optional

show_label       = yes
label_radius     = dims(ideogram,radius) + 0.075r
label_size       = 36
label_parallel   = yes
'''

ticks_text = '''
# ticks are optional

show_ticks          = yes
show_tick_labels    = yes

<ticks>
radius           = dims(ideogram,radius_outer)
multiplier       = 1e-6
color            = black
thickness        = 2p
size             = 15p

<tick>
spacing        = 20u
show_label     = yes
label_size     = 20p
label_offset   = 10p
format         = %d
</tick>

<tick>
spacing        = 5u
color          = grey
size           = 10p
</tick>

<tick>
spacing        = 10u
show_label     = yes
label_size     = 24p
</tick>

</ticks>
'''
os.popen('mkdir -p '+ outdir)
circos_conf = open(outdir + 'circos.conf','w')
bands_conf = open(outdir + 'bands.conf','w')
ideogram_label_conf = open(outdir + 'ideogram.label.conf','w')
ticks_conf = open(outdir + 'ticks.conf','w')

circos_conf.write(circos_text)
bands_conf.write(bands_text)
ideogram_label_conf.write(ideogram_label_text)
ticks_conf.write(ticks_text)

#write configure
#circos_cmd = 'cd ' + outdir + ';/public/home/hangjf/software/circos-0.69-6/bin/circos -conf ' + outdir + 'circos.conf'
#print circos_cmd
#os.system(circos_cmd)
#pipe = subprocess.Popen(circos_cmd,shell=True,stdout=subprocess.PIPE).stdout
#print pipe.read()
#print k
