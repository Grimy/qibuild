## Copyright (c) 2012-2015 Aldebaran Robotics. All rights reserved.
## Use of this source code is governed by a BSD-style license that can be
## found in the COPYING file.
cmake_minimum_required(VERSION 2.8)
project(hellojavajni)

find_package(qibuild)
if (NOT ANDROID)
  find_package(JNI REQUIRED)
  include_directories(${JNI_INCLUDE_DIRS})
endif()

include_directories("jni")

set(SOURCE
   jni/hello.hpp
   src/hello.cpp
   )

qi_create_lib(hellojavajni ${SOURCE} SHARED)
