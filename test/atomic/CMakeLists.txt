# Copyright 2018, 2019 Peter Dimov
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at http://boost.org/LICENSE_1_0.txt)

cmake_minimum_required(VERSION 3.5)

if(POLICY CMP0074)
  cmake_policy(SET CMP0074 NEW)
endif()

project(CmakeConfigAtomicTest LANGUAGES CXX)

include(${CMAKE_CURRENT_LIST_DIR}/../BoostVersion.cmake)

set(BOOST_HINTS)

if(USE_STAGED_BOOST)
  set(BOOST_HINTS HINTS ../../../../stage)
endif()

if(USE_BOOST_PACKAGE)

  find_package(Boost ${BOOST_VERSION} EXACT REQUIRED COMPONENTS atomic ${BOOST_HINTS})

else()

  find_package(boost_atomic ${BOOST_VERSION} EXACT CONFIG REQUIRED ${BOOST_HINTS})

endif()

add_executable(main quick.cpp)
target_link_libraries(main Boost::atomic)

enable_testing()
add_custom_target(check VERBATIM COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure --no-tests=error -C $<CONFIG>)

add_test(main main)
