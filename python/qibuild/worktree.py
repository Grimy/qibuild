import os

import qisys.command
import qisys.worktree
from qibuild.dependencies_solver import topological_sort
import qibuild.build
import qibuild.build_config
import qibuild.project

class BuildWorkTreeError(Exception):
    pass

class BuildWorkTree(qisys.worktree.WorkTreeObserver):
    """

    """
    def __init__(self, worktree):
        self.worktree = worktree
        self.root = self.worktree.root
        self.build_config = qibuild.build_config.CMakeBuildConfig()
        self.build_projects = self._load_build_projects()
        worktree.register(self)

    @property
    def qibuild_xml(self):
        config_path = os.path.join(self.worktree.dot_qi, "qibuild.xml")
        if not os.path.exists(config_path):
            with open(config_path, "w") as fp:
                fp.write("<qibuild />\n")
        return config_path

    def get_build_project(self, name, raises=True):
        """ Get a build project given its name """
        for build_project in self.build_projects:
            if build_project.name == name:
                return build_project
        if raises:
            raise BuildWorkTreeError("No such qibuild project: %s" % name)

    def get_deps(self, top_project, runtime=False, build_deps_only=False):
        """ Get the depencies of a project """
        to_sort = dict()
        if build_deps_only:
            for project in self.build_projects:
                to_sort[project.name] = project.depends
        elif runtime:
            for project in self.build_projects:
                to_sort[project.name] = project.rdepends
        else:
            for project in self.build_projects:
                to_sort[project.name] = project.rdepends.union(project.depends)

        names = topological_sort(to_sort, [top_project.name])
        deps = list()
        for name in names:
            dep_project = self.get_build_project(name, raises=False)
            if dep_project:
                deps.append(dep_project)
        return deps

    def on_project_added(self, project):
        """ Called when a new project has been registered """
        self.build_projects = self._load_build_projects()

    def on_project_removed(self, project):
        """ Called when a build project has been removed """
        self.build_projects = self._load_build_projects()

    def _load_build_projects(self):
        """ Create BuildProject for every buildable project in the
        worktree

        """
        build_projects = list()
        for wt_project in self.worktree.projects:
            if not os.path.exists(wt_project.qiproject_xml):
                continue
            build_project = qibuild.project.BuildProject(self, wt_project)
            build_projects.append(build_project)
        return build_projects

    def configure_build_profile(self, name, flags):
        """ Configure a build profile for the worktree """
        qibuild.profile.configure_build_profile(self.qibuild_xml,
                                                name, flags)


    def remove_build_profile(self, name):
        """ Remove a build profile for this worktree """
        qibuild.profile.configure_build_profile(self.qibuild_xml, name)



