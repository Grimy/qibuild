## Copyright (C) 2011 Aldebaran Robotics


# This is to be used when the names of the
# flags have changed:


# TODO:
# - subfolder in install_ functions
# - ALL, REQUIRED, LINUX, in use_lib() <- filter this
#


# Example:
# After calling:
#      _fix_flags(_res DEPENDS DEPENDENCIES
#          foo SRC foo.h foo.cpp DEPENDENCIES bar)
# _res equals:
#  "foo;SRC;foo.h;foo.cpp;DEPENDS;bar
function(_fix_flags _res _old _new)
  set(_out)
  foreach(_flag ${ARGN})
    string(REPLACE ${_old} ${_new} _new_flag ${_flag})
    list(APPEND _out ${_new_flag})
  endforeach()
  set(${_res} ${_out} PARENT_SCOPE)
endfunction()

function(sdk_add_include _name _subfolder)
  qi_deprecated("no implementation")
endfunction()

######################
# Install
######################
function(install_header)
  qi_deprecated("install_header is deprecated.
  Use qi_install_header instead")
  qi_install_header(${ARGN})
endfunction()

function(install_data)
  qi_deprecated("install_data is deprecated.
  Use qi_install_data instead")
  qi_install_data(${ARGN})
endfunction()

function(install_data_dir _subfolder)
  qi_deprecated("no implementation")
endfunction()

function(install_doc)
  qi_deprecated("install_doc is deprecated.
  Use qi_install_doc instead")
  qi_install_doc(${ARGN})
endfunction()

function(install_conf)
  qi_deprecated("install_conf is deprecated.
  Use qi_install_conf instead")
  qi_install_conf(${ARGN})
endfunction()

function(install_cmake)
  qi_deprecated("install_cmake is deprecated.
  Use qi_install_cmake instead")
  qi_install_cmake(${ARGN})
endfunction()

######################
# Target
######################
function(create_bin)
  qi_deprecated("create_bin is deprecated:
    use qi_create_bin instead
  ")
  qi_create_bin(${ARGN})
endfunction()

function(create_script)
  qi_deprecated("create_script is deprecated:
    use qi_create_script instead")
  qi_create_script(${ARGN})
endfunction()

function(create_lib)
  qi_deprecated("create_lib is deprecated:
    use qi_create_lib instead")
  qi_create_lib(${ARGN})
endfunction()

function(create_config_h)
  qi_deprecated("create_config_h is deprecated:
    use qi_create_config_h instead")
  qi_create_config_h(${ARGN})
endfunction()

function(create_gtest)
  qi_deprecated("create_gtest is deprecated:
    use qi_create_gtest instead")
  _fix_flags(_new_args DEPENDENCIES DEPENDS ${ARGN})
  qi_create_gtest(${_new_args})
endfunction()

function(create_cmake _NAME)
  qi_deprecated("create_cmake is deprecated
    use qi_stage_cmake instead.")
  qi_stage_cmake(${_NAME})
endfunction()

function(use)
  qi_deprecated("use() is deprecated
   Simply use find_package() instead.
  Old:
    create_cmake(foo)
    use(foo)
  New:
    qi_stage_cmake(foo)
    find_package(foo)
  ")
  find_package(${ARGN} QUIET)
endfunction()

function(use_lib)
  qi_deprecated("use_lib is deprecated.
    Note that the names can be target names.
    old:
      create_lib(foo foo.cpp)
      stage_lib(foo FOO)
      use_lib(bar FOO)
    new:
      qi_create_lib(foo foo.cpp)
      qi_stage_lib(foo)
      qi_use_lib(bar foo)
  ")
  qi_use_lib(${ARGN})

endfunction()

######################
# Log
######################
function(debug)
  qi_deprecated("debug is deprecated:
    Use qi_debug instead:
  ")
  qi_debug(${ARGN})
endfunction()

function(verbose)
  qi_deprecated("verbose is deprecated:
    Use qi_verbose instead:
  ")
  qi_verbose(${ARGN})
endfunction()

function(info)
  qi_deprecated("info is deprecated:
    Use qi_info instead:
  ")
  qi_info(${ARGN})
endfunction()

function(warning)
  qi_deprecated("warning is deprecated:
    Use qi_warning instead")
  qi_warning(${ARGN})
endfunction()

function(error)
  qi_deprecated("error is deprecated:
    Use qi_error instead")
  qi_error(${ARGN})
endfunction()

#####################
# stage
#####################
function(stage_lib _targetname _name)
  qi_deprecated("stage_lib is deprecated:
    Use qi_stage_lib instead.
    Warning the signature has changed:
    Instead of:
      create_lib(foo foo.cpp)
      stage_lib(foo FOO)
    Use:
      qi_create_lib(foo foo.cpp)
      # No need for upper-case \"stage name\"
      # anymore:
      qi_stage_lib(foo)
  ")
  string(TOUPPER ${_targetname} _U_targetname)
  if (NOT ${_U_targetname} STREQUAL ${_name})
    qi_warning("
      Not using stage_lib(foo FOO) where the second
      argument if not equals to the upper-version of the first
      argument is not supported anymore.
      Old:
        stage_lib(${_targetname} ${_U_targetname})
      New:
        stage_lib(${_targetname} ${_name})
    "
    )
    # FIXME: stage the lib with an other name ...
  endif()
  qi_stage_lib(${_targetname} ${ARGN})
endfunction()

function(stage_script _file _name)
  qi_deprecated("unimplemented")
endfunction()

function(stage_bin _targetname _name)
  qi_deprecated("unimplemented")
endfunction()

function(stage_header _name)
  qi_deprecated("unimplemented")
endfunction()

function(cond_subdirectory)
  qi_deprecated("cond_subdirectory is deprecated.
  Use qi_add_subdirectory() instead.")
  qi_add_subdirectory(${ARGN})
endfunction()

function(add_python_test _name _pythonFile)
  qi_deprecated("unimplemented")
endfunction()

function(gen_trampoline _binary_name _trampo_name)
  qi_deprecated("unimplemented")
endfunction()

function(gen_sdk_trampoline _binary_name _trampo_name)
  qi_deprecated("unimplemented")
endfunction()

# hack:
function(add_msvc_precompiled_header)
  qi_deprecated("not implemented yet")
endfunction()



#####################
# swig
#####################
function(wrap_python)
  qi_deprecated("wrap_python is deprecated.
  Instead of:
    use(PYTHON-TOOLS)
    wrap_python(foo foo.i
      SRCS foo.h
      DEPENDENCIES BAR
    )
  Use:
    include(qibuild/swig/python)
    qi_swig_wrap_python(foo foo.i
      SRCS foo.h
      DEPENDS BAR
    )
  "
  )
  include(qibuild/swig/python)
  _fix_flags(_new_args DEPENDENCIES DEPENDS ${ARGN})
  qi_swig_wrap_python(${ARGN})
endfunction()


#####################
# tests
#####################
function(configure_tests _name)
  if(BUILD_TESTS)
    include("${CMAKE_CURRENT_SOURCE_DIR}/${_name}")
  endif()
endfunction()

