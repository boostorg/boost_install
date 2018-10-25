# Copyright 2018 Peter Dimov
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at http://boost.org/LICENSE_1_0.txt)

cmake_minimum_required(VERSION 3.5)

project(CmakeConfigAtomicTest LANGUAGES CXX)

find_package(boost_atomic 1.69.0 EXACT CONFIG)

add_executable(main quick.cpp)
target_link_libraries(main Boost::atomic)

enable_testing()
add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure -C $<CONFIG>)

add_test(main main)
