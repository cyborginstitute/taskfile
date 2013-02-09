#
# Publication system
#

include makefile.docs

publish: $(BUILDDIR)/publish
	$(MAKE) -j2 $(BUILDDIR)/publish/taskfile.pdf $(BUILDDIR)/publish/taskfile.epub

$(BUILDDIR)/dirhtml:dirhtml
$(BUILDDIR)/latex/taskfile.tex:latex
$(BUILDDIR)/epub/TaskfileATasklistCompiler.epub:epub
$(BUILDDIR)/latex/taskfile.pdf:$(BUILDDIR)/latex/taskfile.tex
$(BUILDDIR)/publish/taskfile.epub:$(BUILDDIR)/epub/TaskfileATasklistCompiler.epub
	cp $< $@
$(BUILDDIR)/publish:$(BUILDDIR)/dirhtml
	mkdir -p $@
	cp -R $</* $@
	touch $@
$(BUILDDIR)/publish/taskfile.pdf:$(BUILDDIR)/latex/taskfile.pdf
	cp $< $@
