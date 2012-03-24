=======================
Setup and Configuration
=======================

EDIT file

.. default-domain:: make

This document addresses basic setup and configuration of Taskfile. For
more in-depth information on using taskfile for day-to-day see
":doc:`internals`" for an overview of every component in the operation
of Taskfile.

Installing
----------

To install Taskfile:

1. Clone the taskfile repository. Perhaps in your home directory
   (i.e. "``~/``" or "``/home/username/``") For example:

   .. code-block:: sh

      git clone http://cyborginstitute.com/git/taskfile.git

2. Copy the primary :file:`taskfile.make` into your default notes
   directory where you keep your text files [#projects]_
   (e.g. "``~/notes``") and rename it as needed.  For example:

   .. code-block:: sh

      cp taskfile/taskfile.make ~/notes/makefile

3. (Optional.) Copy the :file:`taskfile.project` to another project
   folder (e.g. "``~/projects/``") and rename it as needed. For
   example:

   .. code-block:: sh

      cp taskfile/taskfile.proejct ~/projects/makefile

Congratulations! You have now installed Taskfile. Unfortunately, this
is the easier part of getting started with Taskfile. Continue reading
this document, and consult ":doc:`internals`" for more about
configuring your own Taskfile system.

.. [#projects] Because Taskfile recurses into all sub-directories, you
   can place the makefile anywhere, as long as you have tasks below
   this point in the hierarchy. At the same time you may want to chose
   carefully because Taskfile must scan (and create a mirror every
   directory (and potentially every file) within this directory tree
   every time you refresh your list. Use symbolic links and groups of
   folders to limit your taskfile as needed.

Configuration
-------------

In truth, the default configuration is largely sufficient for most
basic uses: if all the project files you use are in a single folder,
and you do not need to generate multiple lists, you may only have to
modify the following variables at the beginning of the makefile, which
control the input and output of the make system:

- :var:`EXTENSION`,
- :var:`SOURCE`,

Including whitespace and comments, the makefile is under 200 lines,
and only 20-30 lines, or so, are relevant to the operation of
Taskfile, and you can find complete documentation of all taskfile
elements on the :doc:`internals <internals>` page.

Customizing
~~~~~~~~~~~

There are many possible customizations. In general there are two
classes of customization that makes sense with Taskfile:

#. Creating different aggregation selections and outputs, to separate
   work domains that don't share any contextual overlap.

   Currently, by default, Taskfile supports a single :file:`todo.mdwn`
   output. However, there are two additional outputs possible in the
   default taskfile, if you un-comment and modify several lines. Using
   these targets and variables as an example you can create any number
   of unique aggregations.

   Consider the following: In addition to adding targets to build a
   secondary tasklist, you must also ensure that those items on that
   secondary items do not end up on your primary list (unless you want
   them to.)

#. Modifying the output of the taskfile output to enhance capability
   with your own preferred text file editing system.

   Currently, Taskfile produces Markdown output that allows for a
   double square bracket "wiki link" syntax (i.e. ``[[link]]``) to the
   page that contains the original source of the task item. Modify the
   transformation in the ``sed`` expression in the end of the
   :target:`$(OUTPUT)` target. Alternatively, you can add an
   additional expression (e.g. "``-e s/^TODO/TASK/``") to the end of
   this statement (before "``| sort -u >> $@``".)

Extending
~~~~~~~~~

Because Taskfile is just a makefile, and a reasonably simple
makefile at that, there are a number of options and directions that
you may chose to take if you want to extend Taskfile. This section
contains a list of possible extensions and enhancements to Taskfile:

- **Additional output formats:**

  Make exists to generate output according to custom specifications,
  so it's trivial to add new output formats to a makefile, assuming
  you have generic converters. Consider the following "extension,"
  which uses `Multi-Markdown <http://fletcherpenney.net/multimarkdown/>`_
  to convert the standard markdown output of Taskfile to PDF.

  .. code-block:: make

     taskfile: [...] $(OUTPUT_FILE_NAME).pdf

     $(OUTPUT_FILE_NAME).tex:$(OUTPUT)
           mmd2LaTeX.pl $<
     $(OUTPUT_FILE_NAME).pdf:$(OUTPUT_FILE_NAME).tex
           pdflatex $(OUTPUT_FILE_NAME).tex

- **Integrate into emacs** (*or other text editor:*)

  There are a number of functions and keybindings in the
  :file:`taskfile.el` that you may find helpful. These functions make
  it possible for you to:

  - Regenerate your taskfile inside of Emacs, using ``compilation-mode``.

  - Change a task state to "``DONE``"

  - Open the tasklist (i.e. :var:`OUTPUT`) from a key
    binding.

  - Open a "flow" buffer for ad hoc tasks.

  .. seealso:: :doc:`emacs`

- **Git Integration:**

  Run Taskfile as part of a ``pre-commit`` hook to update the taskfile
  before committing the repository.

  Conversely, you may want to exclude your Taskfile output from
  version control because it's always possible to generate the
  taskfile.

- **Scheduling with Cron:**

  Because re-generating the Taskfile output is efficient, it's safe to
  run as a cron task.

While the initial distribution of Taskfile should be as simple and
"base" as possible, we can include any good and appropriately licensed
extension in the default distribution. See ":doc:`contribute` for
more.
