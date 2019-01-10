# Copyright 2019 Peter Dimov
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at http://boost.org/LICENSE_1_0.txt)

cmake_minimum_required(VERSION 3.5)

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

  string(TOUPPER ${dep} _BOOST_DEP)
  set(Boost_${_BOOST_DEP}_FOUND ${boost_${dep}_FOUND})

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
