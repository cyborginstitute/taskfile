# -*- coding: utf-8 -*-
"""
    Emacs Domain for Sphinx
    ~~~~~~~~~~~~~~~~~~~~~~~~~

    Based on the default JavaScript domain distributed with Sphinx.

    :copyright: Copyright 2007-2011 by the Sphinx team, see AUTHORS.
    :license: BSD, see LICENSE for details.

    Additional work to adapt for Emacs purposes done by Cyborg Institute,
    (Sam Kleinman, et al.)
"""

from sphinx import addnodes
from sphinx.domains import Domain, ObjType
from sphinx.locale import l_, _
from sphinx.directives import ObjectDescription
from sphinx.roles import XRefRole
from sphinx.domains.python import _pseudo_parse_arglist
from sphinx.util.nodes import make_refnode
from sphinx.util.docfields import Field, GroupedField, TypedField

class EmacsObject(ObjectDescription):
    """
    Description of a Emacs object.
    """
    #: If set to ``True`` this object is callable and a `desc_parameterlist` is
    #: added
    has_arguments = False

    #: what is displayed right before the documentation entry
    display_prefix = None

    def handle_signature(self, sig, signode):
        sig = sig.strip()
        prefix = sig
        arglist = None
        nameprefix = None
        name = prefix

        objectname = self.env.temp_data.get('emacs:object')
        if nameprefix:
            if objectname:
                # someone documenting the method of an attribute of the current
                # object? shouldn't happen but who knows...
                nameprefix = objectname + '.' + nameprefix
            fullname = nameprefix + '.' + name
        elif objectname:
            fullname = objectname + '.' + name
        else:
            # just a function or constructor
            objectname = ''
            fullname = name

        signode['object'] = objectname
        signode['fullname'] = fullname

        if self.display_prefix:
            signode += addnodes.desc_annotation(self.display_prefix,
                                                self.display_prefix)
        if nameprefix:
            signode += addnodes.desc_addname(nameprefix + '.', nameprefix + '.')
        signode += addnodes.desc_name(name, name)
        if self.has_arguments:
            if not arglist:
                signode += addnodes.desc_parameterlist()
            else:
                _pseudo_parse_arglist(signode, arglist)
        return fullname, nameprefix

    def add_target_and_index(self, name_obj, sig, signode):
        objectname = self.options.get(
            'object', self.env.temp_data.get('emacs:object'))
        fullname = name_obj[0]
        if fullname not in self.state.document.ids:
            signode['names'].append(fullname)
            signode['ids'].append(fullname.replace('$', '_S_'))
            signode['first'] = not self.names
            self.state.document.note_explicit_target(signode)
            objects = self.env.domaindata['emacs']['objects']
            # if fullname in objects:
            #     self.state_machine.reporter.warning(
            #         'duplicate object description of %s, ' % fullname +
            #         'other instance in ' +
            #         self.env.doc2path(objects[fullname][0]),
            #         line=self.lineno)
            objects[fullname] = self.env.docname, self.objtype

        indextext = self.get_index_text(objectname, name_obj)
        if indextext:
            self.indexnode['entries'].append(('single', indextext,
                                              fullname.replace('$', '_S_'),
                                              ''))

    def get_index_text(self, objectname, name_obj):
        name, obj = name_obj
        if self.objtype == 'function':
            return _('%s (emacs function)') % name
        elif self.objtype == 'keybinding':
            return _('%s (emacs keybinding)') % name
        elif self.objtype == 'variable':
            return _('%s (emacs variable)') % name
        return ''


class EmacsCallable(EmacsObject):
    """Description of a Emacs function, method or constructor."""
    has_arguments = False

class EmacsXRefRole(XRefRole):
    def process_link(self, env, refnode, has_explicit_title, title, target):
        # basically what sphinx.domains.python.PyXRefRole does
        refnode['emacs:object'] = env.temp_data.get('emacs:object')
        if not has_explicit_title:
            title = title.lstrip('.')
            target = target.lstrip('~')
            if title[0:1] == '~':
                title = title[1:]
                dot = title.rfind('.')
                if dot != -1:
                    title = title[dot+1:]
        if target[0:1] == '.':
            target = target[1:]
            refnode['refspecific'] = True
        return title, target

class EmacsDomain(Domain):
    """Emacs Documentation domain."""
    name = 'emacs'
    label = 'emacs'
    # if you add a new object type emacs sure to edit EmacsObject.get_index_string
    object_types = {
        'keybinding':   ObjType(l_('keybinding'),     'key'),
        'variable':     ObjType(l_('variable'),       'var'),
        'function':     ObjType(l_('function'),       'func'),
    }

    directives = {
        'keybinding':  EmacsCallable,
        'variable':    EmacsCallable,
        'function':    EmacsCallable,
    }

    roles = {
        'key':         EmacsXRefRole(),
        'var':         EmacsXRefRole(),
        'func':        EmacsXRefRole(),
    }

    initial_data = {
        'objects': {}, # fullname -> docname, objtype
    }

    def find_obj(self, env, obj, name, typ, searchorder=0):
        if name[-2:] == '()':
            name = name[:-2]
        objects = self.data['objects']
        newname = None
        if searchorder == 1:
            if obj and obj + '.' + name in objects:
                newname = obj + '.' + name
            else:
                newname = name
        else:
            if name in objects:
                newname = name
            elif obj and obj + '.' + name in objects:
                newname = obj + '.' + name
        return newname, objects.get(newname)

    def resolve_xref(self, env, fromdocname, builder, typ, target, node,
                     contnode):
        objectname = node.get('emacs:object')
        searchorder = node.hasattr('refspecific') and 1 or 0
        name, obj = self.find_obj(env, objectname, target, typ, searchorder)

        if not obj:
            return None
        return make_refnode(builder, fromdocname, obj[0],
                            name.replace('$', '_S_'), contnode, name)

    def get_objects(self):
        for refname, (docname, type) in self.data['objects'].items():
            yield refname, refname, type, docname, refname, 1

def setup(app):
    app.add_domain(EmacsDomain)
