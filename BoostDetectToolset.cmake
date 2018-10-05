# Copyright 2017, 2018 Peter Dimov
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at http://boost.org/LICENSE_1_0.txt)

string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\..*)?" "\\1\\2" _BOOST_COMPILER_VERSION ${CMAKE_CXX_COMPILER_VERSION})

if(BORLAND)

  # Borland is unversioned

  set(BOOST_DETECTED_TOOLSET "bcb")
  unset(_BOOST_COMPILER_VERSION)

elseif(MINGW)

  set(BOOST_DETECTED_TOOLSET "mgw")

elseif(CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")

  set(BOOST_DETECTED_TOOLSET "clang-darwin")

elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")

  set(BOOST_DETECTED_TOOLSET "clang")

elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Intel")

  if(WIN32)

    # Intel-Win is unversioned

    set(BOOST_DETECTED_TOOLSET "iw")
    unset(_BOOST_COMPILER_VERSION)

  else()

    set(BOOST_DETECTED_TOOLSET "il")

  endif()

elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MIPSpro")

    set(BOOST_DETECTED_TOOLSET "mp")

elseif(CMAKE_CXX_COMPILER_ID STREQUAL "SunPro")

    set(BOOST_DETECTED_TOOLSET "sun")

elseif(CMAKE_CXX_COMPILER_ID STREQUAL "IBM XL")

    set(BOOST_DETECTED_TOOLSET "xlc")

elseif(CMAKE_COMPILER_IS_GNUCXX)

  if(APPLE)

    set(BOOST_DETECTED_TOOLSET "xgcc")

  else()

    set(BOOST_DETECTED_TOOLSET "gcc")

  endif()

elseif(MSVC)

  if(MSVC_VERSION EQUAL 1910)

    set(BOOST_DETECTED_TOOLSET "vc141")

  elseif(MSVC_VERSION EQUAL 1900)

    set(BOOST_DETECTED_TOOLSET "vc140")

  elseif(MSVC_VERSION EQUAL 1800)

    set(BOOST_DETECTED_TOOLSET "vc120")

  elseif(MSVC_VERSION EQUAL 1700)

    set(BOOST_DETECTED_TOOLSET "vc110")

  elseif(MSVC_VERSION EQUAL 1600)

    set(BOOST_DETECTED_TOOLSET "vc100")

  elseif(MSVC_VERSION EQUAL 1500)

    set(BOOST_DETECTED_TOOLSET "vc90")

  elseif(MSVC_VERSION EQUAL 1400)

    set(BOOST_DETECTED_TOOLSET "vc80")

  elseif(MSVC_VERSION EQUAL 1310)

    set(BOOST_DETECTED_TOOLSET "vc71")

  elseif(MSVC_VERSION EQUAL 1300)

    set(BOOST_DETECTED_TOOLSET "vc7")

  elseif(MSVC_VERSION EQUAL 1200)

    set(BOOST_DETECTED_TOOLSET "vc6")

  endif()

  unset(_BOOST_COMPILER_VERSION)

else()

  # Unknown toolset

  if(Boost_DEBUG)
    message(STATUS "BoostDetectToolset: unknown compiler ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
  endif()

  return()

endif()

# Add version

set(BOOST_DETECTED_TOOLSET ${BOOST_DETECTED_TOOLSET}${_BOOST_COMPILER_VERSION})

unset(_BOOST_COMPILER_VERSION)

if(Boost_DEBUG)
  message(STATUS "Boost toolset is ${BOOST_DETECTED_TOOLSET} (${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION})")
endif()
