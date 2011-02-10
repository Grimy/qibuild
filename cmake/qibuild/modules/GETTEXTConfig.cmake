## Copyright (C) 2011 Aldebaran Robotics



clean(GETTEXT)

if(NOT WIN32)
  depend(GETTEXT REQUIRED DL)
endif()
fpath(GETTEXT libintl.h SYSTEM)

#dont find libintl on linux => libintl is part of glibc
if (NOT UNIX OR APPLE)
  flib(GETTEXT NAMES intl libintl intl.8.0.2)
endif()

if (NOT WIN32)
  flib(GETTEXT NAMES gettextpo gettextpo.0 gettextpo.0.4.0)
  flib(GETTEXT gettextsrc  gettextsrc-0.17)
  flib(GETTEXT gettextlib  gettextlib-0.17)
endif()

export_lib(GETTEXT)
