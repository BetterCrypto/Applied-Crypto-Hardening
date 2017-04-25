# -*- coding: utf-8 -*-
#
# Applied Crypto Hardening build configuration file
# This file is execfile()d with the current directory set to its
# containing dir.
#

import sys
import os
import time

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#sys.path.insert(0, os.path.abspath('.'))

##################################################################################


_authors = u'''Wolfgang Breyha, David Durvaux, Tobias Dussa, L. Aaron Kaplan, Florian\
      Mendel, Christian Mock, Manuel Koschuch, Adi Kriegisch, Ulrich Pöschl,\
      Ramin Sabet, Berg San, Ralf Schlatterbeck, Thomas Schreck, Alexander\
      Würstlein, Aaron Zauner, Pepi Zawodsky '''
_affiliations = u'''University of Vienna, CERT.be, KIT-CERT, CERT.at, A-SIT/IAIK, coretec.at,\
FH Campus Wien, VRVis, MilCERT Austria, A-Trust, Runtux.com,\
Friedrich-Alexander University Erlangen-Nuremberg, azet.org, maclemon.at'''

# EDH+CAMELLIA:EDH+aRSA:EECDH+aRSA+AESGCM:EECDH+aRSA+SHA384:EECDH+aRSA+SHA256:EECDH:+CAMELLIA256:+AES256:+CAMELLIA128:+AES128:+SSLv3:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!DSS:!RC4:!SEED:!IDEA:!ECDSA:kEDH:CAMELLIA256-SHA:AES256-SHA:CAMELLIA128-SHA:AES128-SHA
  # new version based on the discussions on the mailing list:
  # Changes:
  # 2014/07/07  - order by cipher strenght and not by HMAC lenght
  #             - also see the discussion on http://lists.cert.at/pipermail/ach/2014-June/001454.html
  #             The idea was to remove AES256 and CAMMELIA 256 and also SHA384


rst_prolog = r"""
.. role:: raw-latex(raw)
   :format: latex
..
"""

rst_epilog = ur"""
.. |cipherStringB| replace:: EDH+CAMELLIA:EDH+aRSA:EECDH+aRSA+AESGCM:EECDH+aRSA+SHA256:EECDH:+CAMELLIA128:+AES128:+SSLv3:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!DSS:!RC4:!SEED:!IDEA:!ECDSA:kEDH:CAMELLIA128-SHA:AES128-SHA
.. |authors| replace:: """ + _authors + """
.. |affiliations| replace:: """ + _affiliations + """
"""


################################################################################

# -- General configuration ------------------------------------------------
needs_sphinx = '1.5'

extensions = [
    'sphinx.ext.todo',
    # 'sphinx.ext.mathjax',
    # 'sphinx.ext.jsmath',
    'sphinx.ext.imgmath',
    'sphinx.ext.viewcode',
    'sphinx.ext.githubpages',
    'sphinxcontrib.bibtex',
    'sphinxcontrib.tikz',
    'sphinxcontrib.inlinesyntaxhighlight',
]

templates_path = ['_templates']
source_suffix = '.rst'
#source_encoding = 'utf-8-sig'
master_doc = 'index'
project = u'Applied Crypto Hardening'
copyright = u'2013-%s, Bettercrypto.org' % time.strftime('%Y')
author = u'Bettercrypto.org'

default_role = "index"
version = u''
release = u''
language = None
exclude_patterns = []
pygments_style = 'sphinx'
todo_include_todos = True
tikz_latex_preamble = ""
tikz_tikzlibraries = "shapes,arrows"
html_theme = 'haiku'
# html_theme_path = []

html_title = "Applied Crypto Hardening"
# html_short_title = None

html_logo = 'img/signet200.png'
# html_favicon = None
# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

# Add any extra paths that contain custom files (such as robots.txt or
# .htaccess) here, relative to this directory. These files are copied
# directly to the root of the documentation.
#
# html_extra_path = []

# If not None, a 'Last updated on:' timestamp is inserted at every page
# bottom, using the given strftime format.
# The empty string is equivalent to '%b %d, %Y'.
#
# html_last_updated_fmt = None

# If true, SmartyPants will be used to convert quotes and dashes to
# typographically correct entities.
#
# html_use_smartypants = True

# Custom sidebar templates, maps document names to template names.
#
html_sidebars = {
    '**': ['globaltoc.html', 'relations.html', 'searchbox.html'],
}

# Additional templates that should be rendered to pages, maps page names to
# template names.
#
# html_additional_pages = {}

# If false, no module index is generated.
#
html_domain_indices = False

# If false, no index is generated.
#
# html_use_index = True

# If true, the index is split into individual pages for each letter.
#
# html_split_index = False

# If true, links to the reST sources are added to the pages.
#
html_show_sourcelink = False

# If true, "Created using Sphinx" is shown in the HTML footer. Default is True.
#
html_show_sphinx = False

# If true, "(C) Copyright ..." is shown in the HTML footer. Default is True.
#
# html_show_copyright = True

# If true, an OpenSearch description file will be output, and all pages will
# contain a <link> tag referring to it.  The value of this option must be the
# base URL from which the finished HTML is served.
#
# html_use_opensearch = ''

# This is the file name suffix for HTML files (e.g. ".xhtml").
# html_file_suffix = None

# Language to be used for generating the HTML full-text search index.
# Sphinx supports the following languages:
#   'da', 'de', 'en', 'es', 'fi', 'fr', 'hu', 'it', 'ja'
#   'nl', 'no', 'pt', 'ro', 'ru', 'sv', 'tr', 'zh'
#
# html_search_language = 'en'

# A dictionary with options for the search language support, empty by default.
# 'ja' uses this config value.
# 'zh' user can custom change `jieba` dictionary path.
#
# html_search_options = {'type': 'default'}

# The name of a javascript file (relative to the configuration directory) that
# implements a search results scorer. If empty, the default will be used.
#
# html_search_scorer = 'scorer.js'

# Output file base name for HTML help builder.
htmlhelp_basename = 'AppliedCryptoHardening'

imgmath_image_format = 'svg'

# -- Options for LaTeX output ---------------------------------------------

# # undocumented
latex_engine = 'lualatex'       #

latex_elements = {
     'papersize': 'a4paper',
     'pointsize': '10pt',
    'geometry':'',
     'preamble': r"""
\usepackage{ach}
% bug?
\let\tablecontinued\sphinxtablecontinued
\subject{\sphinxlogo}
\usepackage{tikz}""" + tikz_latex_preamble + r"""
\usetikzlibrary{""" + tikz_tikzlibraries + r"""}

""",
    'passoptionstopackages': ur'''
\RequirePackage{etoolbox}
\PassOptionsToPackage{usenames,dvipsnames,svgnames,table}{xcolor}
\PreventPackageFromLoading{fancyhdr,parskip}
\makeatletter
\newcommand*\pseudoTitleformat[6]{\relax}
\PreventPackageFromLoading[%
    \csgdef{ver@titlesec.sty}{3000/01/01}
    \global\let\titleformat\pseudoTitleformat
]{titlesec}
\makeatother
''',
    'fontpkg': r'''
\pdfmapfile{=SourceCodePro.map}
\pdfmapfile{=opensans.map}
\usepackage[scaled=.9]{sourcecodepro}
%\usepackage[defaultsans]{opensans}
% \usepackage[default]{opensans}
     \usepackage[default]{sourcesanspro}
\usepackage[final,babel=true]{microtype}[2011/08/18]
\DisableLigatures{encoding = T1, family = tt* }
''',
    'fncychap': '',
    'printindex':  ur'\footnotesize\raggedright\printindex',
    'sphinxsetup': r'HeaderFamily=\bfseries,',
    'maketitle': ur'''
\begin{titlepage}
  \begin{center}
    %\includegraphics[scale=0.5]{img/logo}
    \includegraphics[scale=0.5]{logo}
    \vspace{45pt}
    \HorRule
    \medskip
    {\fontsize{35}{36} \bfseries Applied Crypto Hardening\par}
    \bigskip
  \end{center}
  \begin{flushleft}
    {\large \color{intersectgreen}
''' + _authors + ur'''
      \par}
    \bigskip
    (''' + _affiliations + ur''')
  \end{flushleft}
  \medskip
  \HorRule
  \begin{center}
    \today
  \end{center}
\end{titlepage}
'''    
}

# Grouping the document tree into LaTeX files. List of tuples
# (source start file, target name, title,
#  author, documentclass [howto, manual, or own class]).
latex_documents = [
  # (master_doc, 'applied-crypto-hardening.tex', u'Applied Crypto Hardening',  u'Bettercrypto.org', 'scrbook'),
  (master_doc, 'applied-crypto-hardening.tex', u'', u'', 'scrreprt', True),
]

# The name of an image file (relative to this directory) to place at the top of
# the title page.
#
latex_logo = 'img/logo.pdf'

# For "manual" documents, if this is true, then toplevel headings are parts,
# not chapters.
#
# latex_use_parts = False

# If true, show page references after internal links.
#
# latex_show_pagerefs = False

# If true, show URL addresses after external links.
#
latex_show_urls = 'footnote'

# Documents to append as an appendix to all manuals.
#
# latex_appendices = []

# It false, will not define \strong, \code, 	itleref, \crossref ... but only
# \sphinxstrong, ..., \sphinxtitleref, ... To help avoid clash with user added
# packages.
#
latex_keep_old_macro_names = False

# If false, no module index is generated.
#
latex_domain_indices = True

# copy all over
latex_additional_files = filter(os.path.isfile, map(lambda x: '_latex/' + x, os.listdir('_latex')) + [latex_logo])


# -- Options for manual page output ---------------------------------------

# One entry per manual page. List of tuples
# (source start file, name, description, authors, manual section).
man_pages = []

# If true, show URL addresses after external links.
#
# man_show_urls = False


# -- Options for Texinfo output -------------------------------------------

# Grouping the document tree into Texinfo files. List of tuples
# (source start file, target name, title, author,
#  dir menu entry, description, category)
texinfo_documents = []

# Documents to append as an appendix to all manuals.
#
# texinfo_appendices = []

# If false, no module index is generated.
#
# texinfo_domain_indices = True

# How to display URL addresses: 'footnote', 'no', or 'inline'.
#
# texinfo_show_urls = 'footnote'

# If true, do not generate a @detailmenu in the "Top" node's menu.
#
# texinfo_no_detailmenu = False


# -- Options for Epub output ----------------------------------------------

# Bibliographic Dublin Core info.
epub_title = project
epub_author = author
epub_publisher = author
epub_copyright = copyright


# The basename for the epub file. It defaults to the project name.
# epub_basename = u'Applied Crypto Hardening'

# The HTML theme for the epub output. Since the default themes are not
# optimized for small screen space, using the same theme for HTML and epub
# output is usually not wise. This defaults to 'epub', a theme designed to save
# visual space.
#
# epub_theme = 'epub'

# The language of the text. It defaults to the language option
# or 'en' if the language is not set.
#
# epub_language = ''

# The scheme of the identifier. Typical schemes are ISBN or URL.
# epub_scheme = ''

# The unique identifier of the text. This can be a ISBN number
# or the project homepage.
#
# epub_identifier = ''

# A unique identification for the text.
#
# epub_uid = ''

# A tuple containing the cover image and cover page html template filenames.
#
# epub_cover = ()

# A sequence of (type, uri, title) tuples for the guide element of content.opf.
#
# epub_guide = ()

# HTML files that should be inserted before the pages created by sphinx.
# The format is a list of tuples containing the path and title.
#
# epub_pre_files = []

# HTML files that should be inserted after the pages created by sphinx.
# The format is a list of tuples containing the path and title.
#
# epub_post_files = []

# A list of files that should not be packed into the epub file.
epub_exclude_files = ['search.html']

# The depth of the table of contents in toc.ncx.
#
# epub_tocdepth = 3

# Allow duplicate toc entries.
#
# epub_tocdup = True

# Choose between 'default' and 'includehidden'.
#
# epub_tocscope = 'default'

# Fix unsupported image types using the Pillow.
#
# epub_fix_images = False

# Scale large images.
#
# epub_max_image_width = 0

# How to display URL addresses: 'footnote', 'no', or 'inline'.
#
# epub_show_urls = 'inline'

# If false, no index is generated.
#
# epub_use_index = True
