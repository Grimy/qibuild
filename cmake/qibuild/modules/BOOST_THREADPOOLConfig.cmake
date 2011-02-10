## Copyright (C) 2011 Aldebaran Robotics



#get the root folder of this sdk
get_filename_component(_ROOT_DIR ${CMAKE_CURRENT_LIST_FILE} PATH)
include("${_ROOT_DIR}/boostutils.cmake")

set(_suffix "THREADPOOL")

clean(BOOST_${_suffix})
fpath(BOOST_${_suffix} threadpool.hpp SUBDIRS boost)

boost_flib(BOOST_${_suffix} thread)
boost_flib(BOOST_${_suffix} date_time)

export_header (BOOST_${_suffix})
