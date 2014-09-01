## Copyright (c) 2012, 2013 Aldebaran Robotics. All rights reserved.
## Use of this source code is governed by a BSD-style license that can be
## found in the COPYING file.

""" Generate a binary package, ready to be used for a behavior """
import copy

from qisys import ui
import qisys.parsers
import qipkg.builder

import qibuild.parsers
import qipy.parsers
import qilinguist.parsers
import qipkg.metapackage


def pml_parser(parser):
    qisys.parsers.build_parser(parser)
    parser.add_argument("pml_path")


def get_pml_builder(worktrees, args):
    pml_path = args.pml_path
    build_worktree, python_worktree, linguist_worktree = worktrees
    cmake_builder = qibuild.cmake_builder.CMakeBuilder(build_worktree)
    cmake_builder.projects = list()
    python_builder = qipy.python_builder.PythonBuilder(python_worktree,
                                                       build_worktree=build_worktree)
    python_builder.projects = list()
    linguist_builder = qilinguist.builder.QiLinguistBuilder(linguist_worktree)
    linguist_builder.projects = list()
    return qipkg.builder.PMLBuilder(pml_path, cmake_builder,
                                    python_builder, linguist_builder)

def get_pml_builders(args):
    res = list()
    build_worktree = qibuild.parsers.get_build_worktree(args)
    python_worktree = qipy.parsers.get_python_worktree(args)
    linguist_worktree = qilinguist.parsers.get_linguist_worktree(args)
    worktrees = [build_worktree, python_worktree, linguist_worktree]
    if args.pml_path.endswith(".mpml"):
        ui.info(ui.green, "::", ui.reset, ui.bold, "Reading", args.pml_path, "\n")
        worktree = qisys.parsers.get_worktree(args)
        metapackage = qipkg.metapackage.MetaPackage(worktree, args.pml_path)
        for pml_path in metapackage.pml_paths:
            new_args = copy.copy(args)
            new_args.pml_path = pml_path
            res.append(get_pml_builder(worktrees, new_args))
    else:
        res.append(get_pml_builder(worktrees, args))
    return res
