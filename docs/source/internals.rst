==================
Taskfile Internals
==================

EDIT file

.. default-domain:: make

This document provides a detailed account of the internal operation of
the Taskfile makefile. Use this document as a reference to the higher
level discussion of :doc:`Taskfile customization <configuration>`.

Synopsis
--------

Variables
---------

Location and Output Variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. variable:: SOURCE

   Specifies the top level of the file system tree where all files
   that *might* include task items. Consider using a path like
   "``~/wiki``", "``~/deft``", "``~/notes``", "``~/writing``" or
   wherever your working text and project planning files live.

.. variable:: CACHE

   The directory where Taskfile stores it's cached extraction of task
   items from the ``SOURCE`` files.

.. variable:: OUTPUT_FILE_NAME

   Typically this is "``todo``" and represents the name of the file
   where Taskfile writes it output.

   The value of this variable does not include the file extension.

.. variable:: EXTENSION

   Specifies the file extension for the of the files that contain the
   task list. This extension is also added. to the file name of the
   output file, and should not contain a "``.``" character.

   Taskfile can only look for todo items with one extension, while
   this might present as a limitation, it ensures that Taskfile will
   only scan files that might have task items.

.. variable:: OUTPUT

   The full path, including file name, of the file where Taskfile will
   write the tasklist.

   The default value for this variable is
   "``$(SOURCE)/$(OUTPUT_FILENAME).$(EXTENSION)``" and Taskfile will
   set this value if you do not set another value.

.. variable:: EXTRA_OUTPUT_DIR

   The default value for this variable is
   ``$(SOURCE)/$(OUTPUT_FILENANE)``, and unless you set a value to
   this variable it will be overridden with this value.

.. variable:: PROJECTS_OUTPUT

   Defines a target to build for a projects specific.

   Typically a distinct makefile (e.g. a separate Taskfile instance)
   builds these projects specific lists. This and
   :var:`PROJECTS_MAKEFILE` simply provide pointers to the other
   Taskfile instance to provide a centralized user interface.

.. variable:: PROJECTS_MAKECONTEXT

   The path to a "projects" taksfile's directory context. Called as "``make -C
   $(PROJECTS_MAKECONTEXT)``". This line is, however, commented out in
   the distributed version of taskfile.

Patterns and Filters
~~~~~~~~~~~~~~~~~~~~

.. variable:: KEYWORDS

   Defines the search pattern for a ``grep`` command that will find
   the items that Taskfile aggregates as "task items." Taskfile calls
   this grep in the following form, with the :var:`KEYWORDS` variable:

   .. code-block:: sh

      grep -E "($(KEYWORDS)).*"

   The default expression is:

   .. code-block:: none

      ^TODO|^DEV|^FIXME|^WRITE|^EDIT|^FUTURE|^FROZEN|WORK

   Feel free to modify the expression as needed for your cases.

   .. note::

      Taskfile sorts the output of grep when making the Task list,
      which may impact how your organize your Taskfile
      query. Additionally, in most cases, regular expressions that
      anchor the search pattern (i.e. "``^``" for the beginning of the
      line, or "``$``" for the end of the line,) increases the
      performance of most regular expression searches, depending on
      the structure of your search content.

.. variable:: FUTURE_FILTER

   Holds a name for the "future" filter, used to create a secondary
   list of non- or less-actionable items.

   .. note::

      The default distribution of tasklist has no enabled targets that
      build the :var:`FUTURE_FILTER` task lists. If you want to build
      a future task list, you will need to un-comment these
      sections. See the ":doc:`configuration`" and ":doc:`usage`"
      tutorials for more information on this process.

.. variable:: FUTURE_KEYWORDS

   Holds a list of keywords, passed as in ":var:`KEYWORDS`" to
   ``grep``. Used to

   .. note::

      There are no active targets that build the "future" versions of
      the task list, as future task lists require some measure of
      customization. See the ":doc:`configuration`" and ":doc:`usage`"
      tutorials for more information on this process.

      However, task items that use one of these keywords are not
      included in the primary tasklist.

.. variable:: WORK_FILTER

   As :var:`FUTURE_FILTER`, :var:`WORK_FILTER` makes it possible to
   build :term:`tasklists <tasklist>` from work-based tasks. Whereas
   the :target:`$(FUTURE_OUTPUT)` (using :var:`FUTURE_FILTER`) builds
   a separate tasklist, based on a special :term:`keywords <keyword>`,
   :target:`$(WORK_OUTPUT)` using :var:`WORK_FILTER` creates a
   separate tasklist by filtering out some items based on their
   location in :var:`SOURCE`.

   .. note::

      There are no active targets that build "work" tasklists in
      default taskfile, because work tasklists require some measure of
      customization. However, no items in locations that include the
      :var:`WORK_FILTER` term will appear in the primary taskfile.

   .. seealso:: :target:`$(WORK_OUTPUT)`

      Additionally, consider the ":doc:`configuration`" and
      ":doc:`usage`" tutorials for instructions regarding configuring
      the work tasklists.


Project Variables
~~~~~~~~~~~~~~~~~

.. variable:: FUTURE_OUTPUT

   Defines the location for the "future" task list. In the default
   distribution of Tasklist, this variable has a value of:

   .. code-block:: sh

      $(EXTRA_OUTPUT_DIR)/$(FUTURE_FILTER).$(EXTENSION)

   In most cases you will not need or want to modify this value. This
   :term:`variable` expands to a path of "``~/wiki/todo/future.mdwn``"
   given the default configuration.

   .. seealso:: The following variables, for documentation of the
      default value of this :term:`variables <variable>`:

      - :var:`EXTRA_OUTPUT_DIR`
      - :var:`FUTURE_FILTER`
      - :var:`EXTENSION`

      Additionally, consider the commented :target:`$(FUTURE_OUTPUT)`
      target in the default distribution for an idea of the
      :term:`future tasklist's <future list>` implementation.

   .. note::

      There are no active targets that build the "future" versions of
      the task list, as future task lists require some measure of
      customization. See the ":doc:`configuration`" and ":doc:`usage`"
      tutorials for more information on this process.

.. variable:: WORK_OUTPUT

   Defines the location for the file where taskfile writes the
   :term:`work tasklist <work list>`. The default value for this
   variable is as follows:

   .. code-block:: sh

      $(SOURCE)/$(WORK_FILTER)/$(OUTPUT_FILE_NAME).$(EXTENSION)

   In most cases you will not need or want to modify this value. Given
   the default values, this expands to "``~/wiki/work/todo.mdwn``" in
   the default configuration.

   .. seealso:: The following variables, for documentation of the
      default values for these :term:`variables <variable>`:

      - :var:`SOURCE`
      - :var:`WORK_FILTER`
      - :var:`OUTPUT_FILE_NAME`
      - :var:`EXTENSION`

      Additionally, consider the commented :target:`$(WORK_OUTPUT)`
      target in the default distribution for an idea of the
      :term:`work tasklist's <work list>` implementation.

   .. note::

      There are no active targets that build the "future" versions of
      the task list, as future task lists require some measure of
      customization. See the ":doc:`configuration`" and ":doc:`usage`"
      tutorials for more information on this process.

.. variable:: EXTRA_OUTPUT_DIR

   Defines a directory within the :var:`SOURCE` directory that holds.
   various other outputs and dependent. The :target:`$(FUTURE_OUTPUT)`
   builds into this directory, and a number of "template" files are in
   this directory. The :var:`SOURCES` does not include items from this
   directory.

   In the default configuration :var:`EXTRA_OUTPUT_DIR` has the
   following value:

   .. code-block:: sh

      $(SOURCE)/$(OUTPUT_FILENANE)

   If this variable isn't defined in the beginning section of the
   taskfile, Taskfile will provide a default.

.. variable:: NAME

   This :term:`variable` only appers in the projects taskfile. This
   value forms the basis of the projects-specific taskfile output, and
   contributes to several other variables.

.. variable:: OUTPUT_DIR

   This :term:`variable` only appers in the projects taskfile.

Default Variables
~~~~~~~~~~~~~~~~~

Taskfile will supply a default values for the following values, which
are necessary for Taskfile operation, if you do not define custom
values at the beginning of the file.

.. describe:: OUTPUT

   Unless set at the beginning of the file, the value of :var:`OUTPUT`
   is "``$(SOURCE)/$(OUTPUT_FILENAME).$(EXTENSION)``".

   .. seealso:: :var:`OUTPUT` and thehe following variables that
      affect the value of :var:`OUTPUT` in this default configuration:

      - :var:`SOURCE`
      - :var:`OUTPUT_FILENAME`
      - :var:`EXTENSION`

.. describe:: EXTRA_OUTPUT_DIR

   Unless set at the beginning of the file, the value of
   :var:`EXTRA_OUTPUT_DIR` is "``$(SOURCE)/$(OUTPUT_FILENANE)``".

   .. seealso:: :var:`EXTRA_OUTPUT_DIR` and the following variables
      that affect the value of :var:`EXTRA_OUTPUT_DIR` in the default
      configuration:

      - :var:`SOURCE`
      - :var:`OUTPUT_FILENAME`

.. variable:: TMPL_DIR

   The :var:`TMPL_DIR` :term:`variable` only appers in the
   project-specific default taskfile. In the default setting this path
   should match :var:`EXTRA_OUTPUT_DIR` in the main Taskfile.

.. describe:: OUTPUT_FILE_NAME

   Unless set at the beginning of the file, the value of
   :var:`OUTPUT_FILE_NAME` is "``todo``"

   .. seealso:: :var:`EXTRA_OUTPUT_DIR`.

Computed Variables
~~~~~~~~~~~~~~~~~~

The following variables use computed forms to generate lists or
functions which underpin the operation of the targets that produce the
tasklist.

.. variable:: SOURCES

   Generates a list files that end with the :var:`EXTENSION`. Excludes
   the output filneame and some temporary files. Taskfile computes
   :var:`SOURCES` using the ``find`` command and filters the results
   with ``grep``. The value of this variable is:

   .. code-block:: sh

      $(shell find $(SOURCE) -name "*$(EXTENSION)" -not \( -name ".\#*" \) | grep -v "$(OUTPUT_FILE_NAME)")

.. variable:: SOURCEDIR

   Returns a list of all directories, with recursive resolution that
   may contain source files. :var:`SOURCEDIR` only appears in the
   :var:`CACHE_DIRS` variable. It has the following value:

   .. code-block:: sh

      $(shell find $(SOURCE) -type d -not \( -name ".*" -prune \) -not \( -name "$(OUTPUT_FILE_NAME)" \))

.. variable:: CACHE_DIRS

   Using GNU Make's string substitution function, :var:`CACHE_DIRS`
   generates a list of directories but substitutes the path of the top
   level :var:`SOURCE` directory for the name of the :var:`CACHE`
   directory in the value of :var:`SOURCEDIR`. The actual value as
   specified is:

   .. code-block:: sh

      $(subst $(SOURCE),$(CACHE),$(SOURCEDIR))

   This variable ensures Taskfile creates all required
   directories in the task cache before attempting to write files.

.. variable:: CACHE_INDEX_FILES

   Using a nested string substitution, :var:`CACHE_INDEX_FILES`
   replaces :var:`CACHE` with :var:`SOURCE`, and "\.:var:`EXTENSION`"
   with "\.:var:`OUTPUT_FILE_NAME`" for all of the files in the
   :var:`SOURCES` directory that have end with the
   :var:`EXTENSION`. For instance, given the default configuration and
   a file in :var:`SOURCES` such as "``~/wiki/shopping.mdwn``", this
   will become "``.git/tasklist-build/shopping.todo``". The code
   itself is:

   .. code-block:: sh

      $(subst $(SOURCE),$(CACHE),$(subst .$(EXTENSION),.$(OUTPUT_FILE_NAME),$(wildcard $(SOURCES)/*.$(EXTENSION))))

   .. todo::

      Simplify this function by testing alternates to the ``wildcard`` expression.

.. variable:: CLEAN_UP_DELETED_FILES

   Defines a shell function/loop for use in the cleanup routines that
   deletes files in the :var:`CACHE`` directory if they do not exist
   in the :var:`SOURCE` directory.

   In some cases, if you delete or move a file within the
   :var:`SOURCE` hierarchy, stale tasks remain on the list. Use
   :target:`clean` to run this routine.

   The code that implements this function, formatted for easy reading,
   is as follows:

   .. code-block:: sh

      for item in `find $(CACHE)/ -name "*$(OUTPUT_FILE_NAME)"` ;
        do
          temp=`echo $$item | sed -e "s/$(OUTPUT_FILE_NAME)/$(EXTENSION)/" -e "s@$(CACHE)@$(SOURCE)@"`

          if [[ ! -f "$$temp" ]]
            then
              echo "rm $$item"
              rm $$item
          fi
      done

   .. seealso:: The ":target:`clean`" target. Additionally this
      shell operation uses the following Make variables:

      - :var:`CACHE`
      - :var:`OUTPUT_FILE_NAME`
      - :var:`EXTENSION`
      - :var:`CACHE`
      - :var:`SOURCE`

Targets
-------

User Interface
~~~~~~~~~~~~~~

These targets provide interface and output for Taskfile. While these
targets themselves do not write data to the cache or output, some
have dependencies that may trigger various rebuilds.

.. target:: help

   Returns a brief help text that lists the available build targets
   and a brief overview of their use.

.. target:: todo

   Prints the todo list to the terminal with ``cat``.

   This target depends on :var:`OUTPUT`, so will rebuild the todo list
   if it is out of date

.. target:: todo-work

   Prints the work-specific todo list to the terminal with ``cat``.

   This target depends on :var:`WORK_OUTPUT`, so will rebuild the
   work-specific todo list if it is out of date.

   .. note::

      The default distribution disables this target by default.

.. target:: todo-future

   Prints the aggregated future-todo list to the terminal with ``cat``.

   This target depends on :var:`WORK_OUTPUT`, so will rebuild the
   aggregated future-todo list if it is out of date.

   .. note::

      The default distribution disables this target by default.

Meta Targets
~~~~~~~~~~~~

These targets provide dependency groupings for task list to support
basic operation and configuration, but do not build

.. target:: tasklist

   Provides a single interface to build or rebuild all of the Tasklist
   output files and their dependencies.

   This is the default target for the Taskfile makefile.

   .. seealso:: :target:`tasklist` depends on the following targets:

      - :target:`$(SOURCES)`
      - :target:`$(CACHE)/.setup`
      - :target:`$(CACHE_INDEX_FILES)`
      - :target:`$(CACHE)/$(OUTPUT_FILE_NAME).list`
      - :target:`$(OUTPUT)`

      The default distribution disables the following dependencies:

      - :target:`$(FUTURE_OUTPUT)`
      - :target:`$(WORK_OUTPUT)`

.. target:: setup

   Runs a sub-make process that builds the :target:`$(CACHE)/.setup`
   target. This creates all of the required directories and template
   files for the Tasklist process.

Core Aggregation
~~~~~~~~~~~~~~~~

This group of targets does the actual core "work" of Taskfile: by
creating the cache, collecting the task items, and aggregating the
core output list.

.. target:: $(CACHE)/.setup

   This is a simple configuration target that creates all of the
   required cache directories, and touches several template files that
   makes it possible to build the Tasklists without error.

   The target creates the following directories:

   - :var:`CACHE` (to hold taskfile's cache.)

   - :var:`CACHE_DIRS` (to mirror the directory structure so that
     later targets don't attempt to write to impossible paths.)

   - :var:`EXTRA_OUTPUT_DIR` (to hold template files and special
     output.)

   And creates empty files (with the ``touch`` utility:)

   - ``$(EXTRA_OUTPUT_DIR)/tmpl.$(WORK_FILTER)``

     Ensures that the "tmpl" file for the work-output exists. Taskfile
     interest the contents of this file into the beginning of the
     work-output file before the task items. Taskfile does not
     generate work-output unless you edit the Makefile to uncomment
     the relevant targets.

   - ``$(EXTRA_OUTPUT_DIR)/tmpl.$(FUTURE_FILTER)``

     Ensures that the "tmpl" file for the future-output exists. Taskfile
     interest the contents of this file into the beginning of the
     future-output file before the task items. Taskfile does not
     generate future-output unless you edit the Makefile to uncomment
     the relevant targets.

   - ``$(CACHE)/.setup``

     Taskfile creates this folder to satisfy the dependency checking
     for the :target:`setup` target.

   The build target is just an empty placeholder file.

.. target:: $(CACHE)/%.$(OUTPUT_FILENAME)

   This target depends on :dep:`$(SOURCE)/%.$(EXTENSION)`, and is
   responsible for creating the cache. The cache is a mirror of all
   the source directory tree, except that only lines that contain a
   match for the regular expression specified in :var:`KEYWORDS`.

   The "``%``" character acts as a wildcard, and when used in both the
   target and the destination, this target ensures that Taskfile
   updates the cache whenever a file that matches the dependency
   (i.e. all files in the :var:`SOURCE` directory hierarchy,) is
   rebuilt into a cache target.

   Because of the structure of this operation, this target ensures
   that Taskfile only parses those files that end with
   :var:`EXTENSION`, and that all files in the cache have a distinct
   extension.

   
   ... note:: 
   
       This target suppresses normal output and instead prints
       "``Caching:`` :var:`$(CACHE)/.$(EXTENSION) <CACHE>`" 

The output of this operation 
.. target:: $(CACHE)/$(OUTPUT_FILENAME).list

   This target depends on :var:`CACHE_INDEX_FILES`, which holds a list
   of files that the ":target:`$(CACHE)/%.$(OUTPUT_FILENAME)`"
   generates.

   The target performs the following three actions:

   - Removes the previous version of "``$(CACHE)/$(OUTPUT_FILENAME).list``".

   - Outputs the entire contents of every file in the cache.

   - Performs a series of transformations to modify the output of
     "``grep``" to provide "back links" in the aggregated list that
     points back to the original source file.

.. target:: $(OUTPUT)

   This target depends on the ":target:`$(CACHE)/$(OUTPUT_FILENAME).list`"
   output.

   The target performs the following two actions:

   - Copies the content of ``$(EXTRA_OUTPUT_DIR)/tmpl.$(OUTPUT_FILE_NAME)``
     into the new :var:`OUTPUT` file. This provides any header
     material.

   - Performs a series of transformations on the content of the
     ":target:`$(CACHE)/$(OUTPUT_FILENAME).list`" file to remove any
     items that match the :var:`FUTURE_FILTER`,
     :var:`FUTURE_KEYWORDS`, or :var:`WORK_FILTER`.

     Finally Taskfile sorts the output and writes it to the new
     :var:`OUTPUT` file.

Advanced Aggregation
~~~~~~~~~~~~~~~~~~~~

Uncomment and customize these targets as necessary in
``taskfile.make`` file included in this distribution to provide these
advanced aggregation features.

.. target:: $(FUTURE_OUTPUT)

   This target builds the file described by the variable
   :var:`FUTURE_OUTPUT`. It depends on the :target:`$(OUTPUT)` target.

   Procedurally, this target is very similar to the
   :target:`$(OUTPUT)` :target:`$(FUTURE_OUTPUT)` targets and has the
   following components:

   - Copies the content of ``$(EXTRA_OUTPUT_DIR)/tmpl.$(FUTURE_FILTER)``
     into the new :var:`FUTURE_OUTPUT` file. This provides any header
     material.

   - Selects all of the lines that match :var:`FUTURE_KEYWORDS` in the
     file built by the target :target:`$(CACHE)/$(OUTPUT_FILE_NAME).list`.

     Taskfile sorts these lines before writing them to the output
     file.

   - Performs a series of transformations on the content of the
     ":target:`$(CACHE)/$(OUTPUT_FILENAME).list`" file. All
     transformations occur in the target file, the content in the
     :target:`$(CACHE)/$(OUTPUT_FILENAME).list` file is not modified.
     These transformations to remove any items that match the
     :var:`WORK_FILTER`, and clean up potential formatting errors.

.. target:: $(WORK_OUTPUT)

   This target builds the file described by the variable
   :var:`WORK_OUTPUT`. It depends on the :target:`$(OUTPUT)` target.

   Procedurally, this target is very similar to the
   :target:`$(OUTPUT)` and :target:`$(FUTURE_OUTPUT)` targets and has
   the following components:

   - Copies the content of ``$(EXTRA_OUTPUT_DIR)/tmpl.$(WORK_FILTER)``
     into the new :var:`WORK_OUTPUT` file. This provides any header
     material.

   - Selects all of the lines that match :var:`WORK_KEYWORDS` in the
     file built by the target :target:`$(CACHE)/$(OUTPUT_FILE_NAME).list`.

     Taskfile sorts these lines before writing them to the output
     file.

   - Performs a series of transformations on the content imported in
     from ":target:`$(CACHE)/$(OUTPUT_FILENAME).list`". All
     transformations occur in the target file, the content in the
     :target:`$(CACHE)/$(OUTPUT_FILENAME).list` file is not modified.

.. target:: $(PROJECTS_OUTPUT)

   This target, which builds the ``$(SOURCE)/projects.$(EXTENSION)``
   file, calls a sub-make in the context of the directory specified by
   the :var:`PROJECTS_MAKECONTEXT`. This assumes that, when active,
   there is a projects-specific Taskfile located in the
   :var:`PROJECTS_MAKECONTEXT`.

   The :file:`taskfile.projects` provides an example of such a file.

Cleaning Aggregation
~~~~~~~~~~~~~~~~~~~~

These targets are useful for forcing Taskfile to delete certain files
that have grown stale or that you would like to generate during the
next build.

.. target:: clean

   The :target:`clean` target will delete the generated output, remove
   stale files from the cache, and run the setup routine. In short,
   this target does everything that you need short of deleting the
   :var:`CACHE` directory to get a good build.

   Runs the command specified by the :var:`CLEAN_UP_DELETED_FILES`
   variable.

   :target:`clean` removes the following files directly:

   - :var:`OUTPUT`
   - :var:`FUTURE_OUTPUT`
   - :var:`WORK_OUTPUT`
   - :var:`PROJECTS_OUTPUT`
   - :dep:`$(CACHE)/$(OUTPUT_FILE_NAME).list`

   When the clean operation has finished, this target runs a sub-make
   using the :target:`setup` (in silent mode.)

.. target:: clean-output

   The :target:`clean-output` target removes the following files:

   - :var:`OUTPUT`
   - :var:`FUTURE_OUTPUT`
   - :var:`WORK_OUTPUT`
   - :var:`PROJECTS_OUTPUT`
   - :dep:`$(CACHE)/$(OUTPUT_FILE_NAME).list`

   When the clean operation has finished, this target runs a sub-make
   using the :target:`setup` (in silent mode.)

   Use :target:`clean-output` as a less intensive version of the
   :target:`clean` process because of the omission of the
   :var:`CLEAN_UP_DELETED_FILES` procedure.

.. target:: clean-setup

   The :target:`clean-setup` target removes the ``.setup`` file
   created by the :target:`$(CACHE)/.setup` target.

.. target:: clean-cache

   The :target:`clean-cache` removes the :var:`CACHE` directory. When
   the clean operation has finished, this target runs a sub-make using
   the :target:`setup` (in silent mode.)

.. target:: clean-dirty

   The :target:`clean-dirty` removes the :var:`CACHE` directory.

.. target:: clean-all

   The :target:`clean` target removes the following files:

   - :var:`CACHE`
   - :var:`OUTPUT`
   - :var:`FUTURE_OUTPUT`
   - :var:`WORK_OUTPUT`
   - :var:`PROJECTS_OUTPUT`
   - :dep:`$(CACHE)/$(OUTPUT_FILE_NAME).list`

   Building this target will remove all files created by Taskfile.

Dependencies
------------

.. dependency:: $(SOURCE)/%.$(EXTENSION)

   Used by the :target:`$(CACHE)/%.$(OUTPUT_FILENAME)`.

   This provides a matching dependency for all the files specified by
   the :var:`SOURCES` variable.
