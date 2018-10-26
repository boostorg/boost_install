# Copyright 2018 Peter Dimov
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at http://boost.org/LICENSE_1_0.txt)

cmake_minimum_required(VERSION 3.5)

project(CmakeConfigSerializationTest LANGUAGES CXX)

find_package(boost_serialization 1.69.0 EXACT CONFIG)

add_executable(quick quick.cpp)
target_link_libraries(quick Boost::serialization)

find_package(boost_wserialization 1.69.0 EXACT CONFIG)

add_executable(wquick wquick.cpp)
target_link_libraries(wquick Boost::wserialization)

enable_testing()
add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure -C $<CONFIG>)

add_test(quick quick)
add_test(wquick wquick)
