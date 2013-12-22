# Font Setup
============

To use the proper font for PDF rendering you need install the necessary typefaces into your TeX distribution.


## Installing Open Sans

1. Find your texmf directory: `kpsewhich -var-value TEXMFHOME`
2. Copy the font folders from the `fonts/opensans` directory in the repository to the respective folders your texmf folder. Be careful not to replace any existing contents in there.
3. Run `mktexlsr` to refresh the file name database and make TEX aware of the new files. (You _may_ need `sudo` here.)
4. Run `updmap --enable Map=opensans.map` to make `Dvips`, `dvipdf` and `pdfTEX` aware of the new fonts.


Now you can use `make pdf` to render a PDF using the new fonts.


--------------------------------------------------------------------------------
### Resulting `texmf` directory structure

This what your `texmf` folder structure should look like now.

	├── doc
	│   └── fonts
	│       └── opensans
	├── fonts
	│   ├── afm
	│   │   └── public
	│   │       └── opensans
	│   ├── enc
	│   │   └── dvips
	│   │       └── opensans
	│   ├── map
	│   │   └── dvips
	│   │       └── opensans
	│   ├── tfm
	│   │   └── public
	│   │       └── opensans
	│   ├── truetype
	│   │   └── public
	│   │       └── opensans
	│   ├── type1
	│   │   └── public
	│   │       └── opensans
	│   └── vf
	│       └── public
	│           └── opensans
	├── source
	│   └── fonts
	│       └── opensans
	└── tex
	    └── latex
	        └── opensans