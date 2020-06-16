from PIL.Image import open as imgopen
import sys, os
try:
    inname = sys.argv[1]
    name, ext = os.path.splitext(inname)
    outname = name + '.pgm'
except:
    print("usage: python img2pgm.py <image-file-name>")
    exit(0)
imgopen(inname).convert('L').save(outname)
print("input:%s    output:%s" % (inname, outname))
