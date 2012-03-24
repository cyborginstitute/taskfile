=============================
Taskfile: A Tasklist Compiler
=============================

A simple tasklist aggregator build using GNU make and text files to
support task tracking for a diverse collection of workflows and
tools.

Contents
--------

.. toctree::
   :maxdepth: 1

   operation
   configuration
   internals
   emacs
   contribute
   glossary

- :ref:`genindex`

Resources
---------

- `taskfile git repository <http://git.cyborginstitute.net/?p=taskfile.git>`_
- `taskfile on Github <https://github.com/tychoish/taskfile/>`_
- `taskfile issue tracker <http://issues.cyborginstitute.net/>`_

Overview
--------

Taskfile, using GNU make, compiles a tasklist from one or more
directories of files, using keywords (i.e. "``TODO``", "``FIXME``",
"``FROZEN``") to identify tasks and then generate a task
list. Basically, you focus on your own work, create tasks as you need
to, and run "``make``" every now and then. While
the approach is exceedingly simple, there are a number of practical
advantages that this approach provides:

- Task planning can transpire in-parallel with actual work on code or
  writing, without needing to switch to a task management system.

- Complete interoperation with a host of existing systems, including:

  - Ikiwki
  - Sphinx
  - Git
  - File systems and text files.
  - Emacs' markdown mode, occur, and deft.
  - Pretty much anything else you want.

- Using GNU make, makes it possible for the aggregation operation to
  be *very* efficient and robust, so you can use it against a large
  collections of files quite efficiently.

- From an implementation perspective Taskfile is nearly
  trivial. Dozens of make/shell lines do everything that you need, so
  it's easy to improve, extend, and tweak how the system works.

In truth this "project," if I may be so bold, is more about the text
and documentation that surrounds the code than the other way
around. Thus, consider this document a primmer on creating your own
taskfile system.
