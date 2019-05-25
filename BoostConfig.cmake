# Copyright 2019 Peter Dimov
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at http://boost.org/LICENSE_1_0.txt)

# This CMake configuration file, installed as part of the Boost build
# and installation procedure done by `b2 install`, provides support
# for find_package(Boost).
#
# It's roughly, but not perfectly, compatible with the behavior
# of find_package(Boost) as provided by FindBoost.cmake.
#
# A typical use might be
#
# find_package(Boost 1.70 REQUIRED COMPONENTS filesystem regex PATHS C:/Boost)
#
# On success, the above invocation would define the targets Boost::headers,
# Boost::filesystem and Boost::regex. Boost::headers represents all
# header-only libraries. An alias, Boost::boost, for Boost::headers is
# provided for compatibility.
#
# Since Boost libraries can coexist in many variants - 32/64 bit,
# static/dynamic runtime, debug/release, the following variables can be used
# to control which variant is chosen:
#
# Boost_USE_DEBUG_LIBS:     When OFF, disables debug libraries.
# Boost_USE_RELEASE_LIBS:   When OFF, disables release libraries.
# Boost_USE_STATIC_LIBS:    When ON, uses static Boost libraries; when OFF,
#                           uses shared Boost libraries; when not set, uses
#                           static on Windows, shared otherwise.
# Boost_USE_STATIC_RUNTIME: When ON, uses Boost libraries linked against the
#                           static runtime. The default is shared runtime.
# Boost_USE_DEBUG_RUNTIME:  When ON, uses Boost libraries linked against the
#                           debug runtime. When OFF, against the release
#                           runtime. The default is to use either.
# Boost_COMPILER:           The compiler that has been used to build Boost,
#                           such as vc141, gcc7, clang37. The default is
#                           determined from CMAKE_CXX_COMPILER_ID.
# Boost_PYTHON_VERSION:     The version of Python against which Boost.Python
#                           has been built; only required when more than one
#                           Boost.Python library is present.
#
# The following variables control the verbosity of the output:
#
# Boost_VERBOSE:            Enable verbose output
# Boost_DEBUG:              Enable debug (even more verbose) output

if(Boost_VERBOSE OR Boost_DEBUG)

  message(STATUS "Found Boost ${Boost_VERSION} at ${Boost_DIR}")

  # Output requested configuration (f.ex. "REQUIRED COMPONENTS filesystem")

  if(Boost_FIND_QUIETLY)
    set(_BOOST_CONFIG "${_BOOST_CONFIG} QUIET")
  endif()

  if(Boost_FIND_REQUIRED)
    set(_BOOST_CONFIG "${_BOOST_CONFIG} REQUIRED")
  endif()

  foreach(__boost_comp IN LISTS Boost_FIND_COMPONENTS)
    if(${Boost_FIND_REQUIRED_${__boost_comp}})
      list(APPEND _BOOST_COMPONENTS ${__boost_comp})
    else()
      list(APPEND _BOOST_OPTIONAL_COMPONENTS ${__boost_comp})
    endif()
  endforeach()

  if(_BOOST_COMPONENTS)
    set(_BOOST_CONFIG "${_BOOST_CONFIG} COMPONENTS ${_BOOST_COMPONENTS}")
  endif()

  if(_BOOST_OPTIONAL_COMPONENTS)
    set(_BOOST_CONFIG "${_BOOST_CONFIG} OPTIONAL_COMPONENTS ${_BOOST_OPTIONAL_COMPONENTS}")
  endif()

  if(_BOOST_CONFIG)
    message(STATUS "  Requested configuration:${_BOOST_CONFIG}")
  endif()

  unset(_BOOST_CONFIG)
  unset(_BOOST_COMPONENTS)
  unset(_BOOST_OPTIONAL_COMPONENTS)

endif()

# find_dependency doesn't forward arguments until 3.9, so we have to roll our own

macro(boost_find_dependency dep req)

  set(_BOOST_QUIET)
  if(Boost_FIND_QUIETLY)
    set(_BOOST_QUIET QUIET)
  endif()

  set(_BOOST_REQUIRED)
  if(${req} AND Boost_FIND_REQUIRED)
    set(_BOOST_REQUIRED REQUIRED)
  endif()

  get_filename_component(_BOOST_CMAKEDIR "${CMAKE_CURRENT_LIST_DIR}/../" ABSOLUTE)

  if(Boost_DEBUG)
    message(STATUS "BoostConfig: find_package(boost_${dep} ${Boost_VERSION} EXACT CONFIG ${_BOOST_REQUIRED} ${_BOOST_QUIET} HINTS ${_BOOST_CMAKEDIR})")
  endif()
  find_package(boost_${dep} ${Boost_VERSION} EXACT CONFIG ${_BOOST_REQUIRED} ${_BOOST_QUIET} HINTS ${_BOOST_CMAKEDIR})

  # FindPackageHandleStandardArgs expects <package>_<component>_FOUND
  set(Boost_${dep}_FOUND ${boost_${dep}_FOUND})

  # FindBoost sets Boost_<COMPONENT>_FOUND
  string(TOUPPER ${dep} _BOOST_DEP)
  set(Boost_${_BOOST_DEP}_FOUND ${boost_${dep}_FOUND})

  # FindBoost compatibility variables: Boost_LIBRARIES, Boost_<C>_LIBRARY
  if(boost_${dep}_FOUND)
    list(APPEND Boost_LIBRARIES Boost::${dep})
    set(Boost_${_BOOST_DEP}_LIBRARY Boost::${dep})
  endif()

  unset(_BOOST_REQUIRED)
  unset(_BOOST_QUIET)
  unset(_BOOST_CMAKEDIR)
  unset(_BOOST_DEP)

endmacro()

# Find boost_headers

boost_find_dependency(headers 1)

if(NOT boost_headers_FOUND)

  set(Boost_FOUND 0)
  set(Boost_NOT_FOUND_MESSAGE "A required dependency, boost_headers, has not been found.")

  return()

endif()

# Compatibility variables

set(Boost_MAJOR_VERSION ${Boost_VERSION_MAJOR})
set(Boost_MINOR_VERSION ${Boost_VERSION_MINOR})
set(Boost_SUBMINOR_VERSION ${Boost_VERSION_PATCH})

set(Boost_VERSION_STRING ${Boost_VERSION})
set(Boost_VERSION_MACRO ${Boost_VERSION_MAJOR}0${Boost_VERSION_MINOR}0${Boost_VERSION_PATCH})

get_target_property(Boost_INCLUDE_DIRS Boost::headers INTERFACE_INCLUDE_DIRECTORIES)
set(Boost_LIBRARIES)

# Find components

foreach(__boost_comp IN LISTS Boost_FIND_COMPONENTS)

  boost_find_dependency(${__boost_comp} ${Boost_FIND_REQUIRED_${__boost_comp}})

endforeach()

# Compatibility targets

if(NOT TARGET Boost::boost)

  add_library(Boost::boost INTERFACE IMPORTED)
  set_property(TARGET Boost::boost APPEND PROPERTY INTERFACE_LINK_LIBRARIES Boost::headers)

  # All Boost:: targets already disable autolink
  add_library(Boost::diagnostic_definitions INTERFACE IMPORTED)
  add_library(Boost::disable_autolinking INTERFACE IMPORTED)
  add_library(Boost::dynamic_linking INTERFACE IMPORTED)

endif()
