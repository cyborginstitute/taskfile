=====================
Working with Taskfile
=====================

Synopsis
--------

The overriding goal of Taskfile is to provide a means to organize
tasks with as little conceptual overhead as possible. As long as you
can find a way to include unique markers to identify your tasks, and
your work exists in "``grep``"-able text, you should be able to use
Taskfile without. This document discusses usage patterns how to
integrate Taskfile into practical workflows.

Patterns
--------

TODO fix links in this section.

Once you've :doc:`configured <configuration>` Taskfile, running the
``make`` command in the directory where the makefile lives is usually
all you need to do. The makefile provides a "``make todo``" operation
that prints the task list, or you can view the output using an
interface like `Geektool <geektool>`_, `Ikiwki <http://ikiwiki.info>`_
or preferred text editor. Ikiwiki, and `Emacs'
<http://gnu.org/s/emacs>`_ `Markdown Mode <markdown>`_ provide some
linkingf ability that facilitates "moving backwards" from the task on
the "todo" output to the embeded task in a file.

There are two major approaches to organizing a Taskfile system. The
first is to just work in files and insert task items that Taskfile
will pickup. It's simple and there's no real downside, though you can
end up with task items in inopportune places if you're careless. The
second is that you might have a collection of project-specific files
for task planning that contain a few notes and some "``TODO``" option.

Both methods are equivalent, and Taskfile doesn't "prefer" one
modality over the other. Furthermore, you there is no need to work in
a "pure" system: you can mix "embeded tasks" within a notes file, or
just use "tracking files" that are *only* tasks. Either works equally
well. Nevertheless, there are some moment-to-moment implications of
using one organizational scheme over another, in terms of how you
transverse "up" from the aggregate todo list, to the location where
the task item originally resides, to the location where you will
actually work. A combination of both methods will likely prove most
optimal.

There are a variety of options for day-to-day and moment-to-moment
work. You may choose to keep a view of the of your task list or task
lists open at all times either in an editor window or in a rendered
page in a browser, and then use this to either jump to the relevant
file to begin work. Many text editors have file searching
functionality that makes it possible to find all references of a
string within a file, [#occur]_ that you may find helpful.

.. [#occur] In emacs this is "occur" mode. `TextMate
   <http://macromates.org>`_ also has or had a "TODO" mode that
   performs a similar function.

Components
----------

Projects
~~~~~~~~

In the context of Taskfile, a project represents a class of
non-overlapping tasks that Taskfile will aggregate separately. In
other project management systems, projects often refer to smaller
groupings of tasks, where a project might be a paper or a release of a
piece of software, or some other logical grouping. In taskfile,
you may use projects to filter the tasks that you're currently working
on with from tasks marked "future" or "frozen". Furthermore, you may
use project separation to separate tasks for personal and side
projects from your works projects.

The goal of Tasklist is to provide an aggregate view into all of your
tasks so that you'll be able to see at a glance what tasks require
your attention without relying on your memory to remember
tasks. Usually this means "make all tasks visible all the time," but
for some classes of tasks (like work and home tasks) it makes sense to
separate things. Used judiciously, projects are great for keeping
things organized.

There are two features of the way Taskfile handles projects that are
worth noting:

1. Projects make it difficult to track and follow tasks back to their
   original location in the source file. Sometimes this doesn't
   matter.

2. Project separation is easy to configure, but requires some manual
   intervention in the makefile itself. The method is fully documented
   in ":doc:`configuration`" and ":doc:`internals`"

Keywords
~~~~~~~~

Keywords are unique strings of characters that identify
tasks. There are no formal limitation on what can be a keyword, but
they should be distinct, the default behavior is for keywords to be
case sensitive but this is simple to disable. The default keywords
are:

- ``TODO``
- ``FIXME``
- ``EDIT``
- ``ONGOING``
- ``FUTURE``
- ``FROZEN``

Specify these keywords in regular expression syntax, [#grep]_ and
keywords can be quite specific, both in terms of the letters used and
their position in the line. The best keywords contain characters that
are unlikely to appear in the textfiles that you aggregate tasks
from. Case sensitivity helps reduce collisions, but certian letter
combinations are incredibly uncommon in some languages (i.e. "``tk``"
and "``q``" followed by most letters.) You may also consider requiring
that your keywords the keyword appear at the beginning of a line
(which is in the default makefile.) You may also wish to require that
your TODO item take the form of a comment in whatever syntax your
textfiles are in.

.. [#grep] Unsurprisingly, perhaps, Taskfile uses "``grep -E``" to
   find and filter tasks from the source files.

Integration
~~~~~~~~~~~

The "``make todo``" output of the task list is good for most
rudimentary tasklist viewing; however, you may find that you want a
more interactive and integrated tasklist in some situations. In most
cases, whatever tools you use to edit your source files work fine with
the output of Taskfile, and it's easy to modify some common tools to
provide support for the taskfile output.

Ikiwiki provided the initial inspiration for and hosting of Taskfile
and the default configuration maintains compatibility with this
approach. Just make sure that Taskfile's output has an extension that
Ikiwiki can parse and ends up in a location that Ikiwiki will build.

If you use Emacs, consider the following modes and functions that
might be useful for interacting with Taskfile:

- `Markdown Mode <>`_

  The latest versions of markdown mode, include an automatic
  wiki-link following feature that allows you to travel from the
  current file to the linked file within the file by overloading the
  "Enter" key.

- `Occur <>`_

  Occur ships with recent versions of Emacs and searches and indexes
  textfiles. Use ``occur`` within the source files, to find instances
  of keywords within a file. Occur cites line numbers and makes it
  easy to jump to specific line numbers.

- `Auto-Revert Mode <>`_ or `Revbufs <>`_

  Because Taskfile generates the todo files outside of Emacs, use a system
  like auto revert mode or ``revbufs`` to get emacs to refresh the
  buffer from the disk when you update.

- `Compile Mode <>`_

  Emacs includes compile mode, which provides an easy method to run,
  rerun and monitor make and make-like processes within emacs.

.. note::

   Most text editors contain some or all of these features, with
   different interfaces and names. If you use another text editor,
   consider :doc:`contributing <contribute>` documentation to Taskfile
   to explain these functions and possible configurations.

Internal Approach
-----------------

Taskfile operates by scanning a directory tree for files that contain
TODO keywords and copying *only* those TODO lines to a "cache." Todo
lists are then built from this mirroed "cache tree." Using GNU Make's
dependency checking, when running Taskfile, files in the cache (and
the todo lists themselves) are only reread or rescanned when the TODO
items change.

Depending on the number of files and the number of lines in the file,
the initial creation of a crash can take a number of seconds; however,
refreshing the list in the course of normal operation goes very
quickly in every situation because the amount of work is minimal.

Taskfile is the successor to a similar tool implemented as a basic
shell script. Using many of the same operations, the original
implementation had no dependency checking and had to aggregate all of
the data on every run, was more difficult to customize, and was not
a feasible solution for checking projects with large numbers of files
or high quantities of data.

The primary limitation of Taskfile at present is the fact that many
deployments will require some duplication of the Taskfile makefile to
track different project trees and output configuration. While the
duplication is a concern, the difficult configuration method
(i.e. writing and tweaking the makefile) is a larger concern. Future
distributions of Taskfile will include a "meta-maker" that will guide
some Taskfile customization.

.. seealso:: ":doc:`internals`"
