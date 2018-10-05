# Copyright 2018 Peter Dimov
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at http://boost.org/LICENSE_1_0.txt)

cmake_minimum_required(VERSION 3.5)

project(CmakeConfigThreadTest LANGUAGES CXX)

set(THREADS_PREFER_PTHREAD_FLAG 1)
find_package(Threads REQUIRED)

find_package(boost_thread 1.69.0 EXACT CONFIG REQUIRED)

add_executable(main quick.cpp)
target_link_libraries(main Boost::thread Threads::Threads)

enable_testing()
add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure -C $<CONFIG>)

add_test(main main)
