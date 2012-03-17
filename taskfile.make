######################################################################
#
# Taskfile.make
#
######################################################################

MAKEFLAGS += -j4

#
# Location, output, and control. Customize these variables for your distribution
#

SOURCE = ~/wiki
CACHE = .git/tasklist-build
OUTPUT_FILE_NAME = todo
EXTENSION = mdwn
OUTPUT = $(SOURCE)/$(OUTPUT_FILENAME).$(EXTENSION)
EXTRA_OUTPUT_DIR = $(SOURCE)/$(OUTPUT_FILENANE)
PROJECTS_OUTPUT = $(SOURCE)/projects.$(EXTENSION)
PROJECTS_MAKECONTEXT = ~/projects/

#
# Modify these variables to control the search patterns and filtered outputs.
#

KEYWORDS = ^TODO|^DEV|^FIXME|^WRITE|^EDIT|^FUTURE|^FROZEN|WORK

FUTURE_FILTER = future
FUTURE_KEYWORDS = FUTURE|FROZEN|ONGOING
FUTURE_OUTPUT = $(EXTRA_OUTPUT_DIR)/$(FUTURE_FILTER).$(EXTENSION)

WORK_FILTER = work
WORK_OUTPUT = $(SOURCE)/$(WORK_FILTER)/$(OUTPUT_FILE_NAME).$(EXTENSION)

#
# Variables and functions you won't have to change or modify
#

OUTPUT ?= $(SOURCE)/$(OUTPUT_FILE_NAME).$(EXTENSION)
EXTRA_OUTPUT_DIR ?= $(SOURCE)/$(OUTPUT_FILE_NAME)

SOURCES := $(shell find $(SOURCE) -name "*$(EXTENSION)" -not \( -name ".\#*" \) | grep -v "$(OUTPUT_FILE_NAME)")
SOURCEDIR := $(shell find $(SOURCE) -type d -not \( -name ".*" -prune \) -not \( -name "$(OUTPUT_FILE_NAME)" \))

CACHE_DIRS = $(subst $(SOURCE),$(CACHE),$(SOURCEDIR))
CACHE_INDEX_FILES = $(subst $(SOURCE),$(CACHE),$(subst .$(EXTENSION),.$(OUTPUT_FILE_NAME),$(wildcard $(SOURCES)/*.$(EXTENSION))))
CLEAN_UP_DELETED_FILES := for item in `find $(CACHE)/ -name "*$(OUTPUT_FILE_NAME)"` ; do temp=`echo $$item | sed -e "s/$(OUTPUT_FILE_NAME)/$(EXTENSION)/" -e "s@$(CACHE)@$(SOURCE)@"` ; if [[ ! -f "$$temp" ]] ; then echo "rm $$item" ; rm $$item ; fi ; done

.PHONY: clean-output clean-cache clean-all clean help todo test all

#
# Helpful output interface targets for testing and CLI use.
#

help:
        @echo "Ikiwiki Tasklist Compilation Interface"
        @echo "   "
        @echo "Targets:"
        @echo "   tasklist	-- (default) built's tasklist in '$(OUTPUT)'."
        @echo "   todo		-- prints the '$(OUTPUT)' list."
#        @echo "   todo-future	-- prints all FUTURE/FROZEN items ('$(FUTURE_OUTPUT)')."
#        @echo "   todo-work	-- prints all items containing '$(WORK_FILTER)' ('$(WORK_OUTPUT)')."
        @echo "Cleaning:"
        @echo "   clean		-- remove all output files and forces a minor rebuild (also clean-output)"
        @echo "   clean-cache	-- removes the '$(CACHE)' folder and forces a full rebuild"
        @echo "   clean-all	-- runs both 'clean-cache' and 'clean-output'"

todo:$(OUTPUT)
        @cat $(OUTPUT)

# todo-work:$(WORK_OUTPUT)
#         @cat $(WORK_OUTPUT)
# todo-future:$(FUTURE_OUTPUT)
#         @cat $(FUTURE_OUTPUT)

#
# The actual tasklist building targets and functions. only run "make tasklist"
#
# must run 'make setup' to create $(CACHE) $(CACHE_DIRS) $(EXTRA_OUTPUT_DIR) $(SOURCEDIR)


.DEFAULT_GOAL := tasklist

tasklist: $(SOURCES) $(CACHE)/.setup $(CACHE_INDEX_FILES) $(CACHE)/$(OUTPUT_FILE_NAME).list $(OUTPUT) # $(PROJECTS_OUTPUT) $(FUTURE_OUTPUT) $(WORK_OUTPUT)

setup:
        make $(CACHE)/.setup
$(CACHE)/.setup:
        mkdir -p $(CACHE) $(CACHE_DIRS) $(EXTRA_OUTPUT_DIR)
        touch $(EXTRA_OUTPUT_DIR)/tmpl.$(WORK_FILTER) $(EXTRA_OUTPUT_DIR)/tmpl.$(FUTURE_FILTER) $(CACHE)/.setup
$(CACHE)/%.$(OUTPUT_FILE_NAME):$(SOURCE)/%.$(EXTENSION)
	@echo "Caching: $<"
	@grep -E "($(KEYWORDS)).*" $< >$@ || exit 0
$(CACHE)/$(OUTPUT_FILE_NAME).list:$(CACHE_INDEX_FILES)
        rm -f $@
        grep "" $(CACHE)/* -R >$@
        sed -i -r -e "s@^$(CACHE)/(.*).$(OUTPUT_FILE_NAME):(.*)@- \2: [[\1]]@g" -e "s@\[$(CACHE)\/@[@g" -e "s/(- )+/- /" $@
$(OUTPUT):$(CACHE)/$(OUTPUT_FILE_NAME).list $(PROJECTS_OUTPUT)
        cp $(EXTRA_OUTPUT_DIR)/tmpl.$(OUTPUT_FILE_NAME) $@
        sed -r -e "/$(FUTURE_FILTER)/d" -e "/$(FUTURE_KEYWORDS)/d" -e "/$(WORK_FILTER)/d" $< | sort -u >> $@
# $(PROJECTS_OUTPUT):
#	make -j4 -C $(PROJECTS_MAKECONTEXT)
# $(FUTURE_OUTPUT):$(OUTPUT)
#       cp $(EXTRA_OUTPUT_DIR)/tmpl.$(FUTURE_FILTER) $@
#       grep -E "^- ($(FUTURE_KEYWORDS)).*" $(CACHE)/$(OUTPUT_FILE_NAME).list | sort -u >> $@
#       sed -i -r -e "/$(WORK_FILTER)/d" -e "s/(- )+/- /" $@
# $(WORK_OUTPUT):$(OUTPUT)
#       cp $(EXTRA_OUTPUT_DIR)/tmpl.$(WORK_FILTER) $@
#       grep "$(WORK_FILTER)" $(CACHE)/$(OUTPUT_FILE_NAME).list | sort -u >> $@
#       sed -i -r -e "s@\[$(WORK_FILTER)/@[@g" -e "s/(- )+/- /" $@


#
# Cleanup and removal targets.
#
clean:
        $(CLEAN_UP_DELETED_FILES)
        -rm -f $(OUTPUT) $(FUTURE_OUTPUT) $(WORK_OUTPUT) $(PROJECTS_OUTPUT) $(CACHE)/$(OUTPUT_FILE_NAME).list
        make -s setup
clean-output:
        -rm -f $(OUTPUT) $(FUTURE_OUTPUT) $(WORK_OUTPUT) $(PROJECTS_OUTPUT) $(CACHE)/$(OUTPUT_FILE_NAME).list
        make -s setup
clean-setup:
        -rm -f $(CACHE)/.setup
clean-cache:
        -rm -rf $(CACHE)
        make -s setup
clean-dirty:
        rm -rf $(CACHE)
clean-all:
        -rm -rf $(CACHE) $(OUTPUT) $(FUTURE_OUTPUT) $(PROJECTS_OUTPUT) $(WORK_OUTPUT) $(CACHE)/$(OUTPUT_FILE_NAME).list
