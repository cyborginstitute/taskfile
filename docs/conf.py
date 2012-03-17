# -*- coding: utf-8 -*-
#
# This file is execfile()d with the current directory set to its containing dir.

import sys, os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), ".ext")))

# -- General configuration -----------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be extensions
# coming with Sphinx (named 'sphinx.ext.*') or your custom ones.
extensions = ['sphinx.ext.todo', "make_domain"]

# Add any paths that contain templates here, relative to this directory.
templates_path = ['.templates']

# The suffix of source filenames.
source_suffix = '.rst'

# The master toctree document.
master_doc = 'index'

# General information about the project.
project = u'Taskfile: A Tasklist Compiler'
copyright = u'2012, Sam Kleinman'

version = '0.1'
release = ''

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
exclude_patterns = []

# The name of the Pygments (syntax highlighting) style to use.
pygments_style = 'sphinx'
add_function_parentheses = False

# -- Options for HTML output ---------------------------------------------------

html_theme = 'cyborg'
html_theme_path = ['themes']

# The name for this set of Sphinx documents.  If None, it defaults to
# "<project> v<release> documentation".
#html_title = None
# A shorter title for the navigation bar.  Default is the same as html_title.
#html_short_title = None
# The name of an image file (relative to this directory) to place at the top
# of the sidebar.
#html_logo = None
# The name of an image file (within the static path) to use as favicon of the
# docs.  This file should be a Windows icon file (.ico) being 16x16 or 32x32
# pixels large.
#html_favicon = None

html_static_path = ['source/.static']
html_use_smartypants = True

# If false, no module index is generated.
#html_domain_indices = True
# If false, no index is generated.
#html_use_index = True
# If true, the index is split into individual pages for each letter.
#html_split_index = False
# If true, links to the reST sources are added to the pages.
#html_show_sourcelink = True
# If true, "Created using Sphinx" is shown in the HTML footer. Default is True.
#html_show_sphinx = True
# If true, "(C) Copyright ..." is shown in the HTML footer. Default is True.
#html_show_copyright = True

# Output file base name for HTML help builder.
htmlhelp_basename = 'cyborg-institute'

# -- Options for LaTeX output --------------------------------------------------

# The paper size ('letter' or 'a4').
#latex_paper_size = 'letter'

# The font size ('10pt', '11pt' or '12pt').
#latex_font_size = '10pt'

# Grouping the document tree into LaTeX files. List of tuples
# (source start file, target name, title, author, documentclass [howto/manual]).
latex_documents = [
  ('index', 'taskfile.tex', u'Taskfile: A Tasklist Compiler',
   u'Sam Kleinman', 'howto'),
]

# The name of an image file (relative to this directory) to place at the top of the title page.
#latex_logo = None

# -- Options for manual page output --------------------------------------------

# One entry per manual page. List of tuples
# (source start file, name, description, authors, manual section).
man_pages = [
  ('index', 'Taskfile', u'Taskfile: A Tasklist Compiler',
   [u'Sam Kleinman'], 1)
]

# -- Options for Epub output ---------------------------------------------------

# Bibliographic Dublin Core info.
epub_title = u'The Cyborg Institute'
epub_author = u'Sam Kleinman'
epub_publisher = u'Sam Kleinman'
epub_copyright = u'2011, Sam Kleinman'

# The depth of the table of contents in toc.ncx.
#epub_tocdepth = 3
# Allow duplicate toc entries.
#epub_tocdup = True

# Example configuration for intersphinx: refer to the Python standard library.
intersphinx_mapping = {'http://docs.python.org/': None}
