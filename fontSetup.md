# Font Setup

============

## Installing Open Sans

1. Find your texmf directory: `kpsewhich -var-value TEXMFHOME`
2. Copy the font files from the fonts directory in the repository to your texmf folder.
3. Run `mktexlsr` to refresh the file name database and make TEX aware of the new files.
4. Run `updmap --enable Map=opensans.map` to make Dvips, dvipdf and pdfTEX aware of the new fonts.