
# Find variants of a library by searching for lib<lib_name>-variant*.cmake
# files in the current folder
# name     -- Name, e.g. 'system'
# lib_name -- Library name, e.g. 'boost_system'
function(boost_find_variants name lib_name)
  if(NOT DEFINED _BOOST_LIBDIR)
    message(FATAL_ERROR "Internal error: _BOOST_LIBDIR not defined")
  endif()

  include(${CMAKE_CURRENT_LIST_DIR}/../BoostDetectToolset.cmake)

  if(Boost_DEBUG)
    message(STATUS "Scanning ${CMAKE_CURRENT_LIST_DIR}/lib${lib_name}-variant*.cmake")
  endif()

  file(GLOB __boost_variants "${CMAKE_CURRENT_LIST_DIR}/lib${lib_name}-variant*.cmake")

  set(__boost_skipped "")
  macro(_BOOST_SKIPPED fname reason)
    if(Boost_VERBOSE OR Boost_DEBUG)
      message(STATUS "  [ ] ${fname}")
    endif()
    list(APPEND __boost_skipped "${fname} (${reason})")
  endmacro()

  string(TOUPPER "_BOOST_${name}_DEPS" deps_var)
  set(${deps_var} "")

  foreach(f IN LISTS __boost_variants)
    if(Boost_DEBUG)
      message(STATUS "  Including ${f}")
    endif()
    include(${f})
  endforeach()

  get_target_property(__boost_configs Boost::${name} IMPORTED_CONFIGURATIONS)

  if(__boost_variants AND NOT __boost_configs)
    set(__boost_message "No suitable build variant has been found.")
    if(__boost_skipped)
      set(__boost_message "${__boost_message}\nThe following variants have been tried and rejected:")
      foreach(s IN LISTS __boost_skipped)
        set(__boost_message "${__boost_message}\n* ${s}")
      endforeach()
    endif()
    set(${lib_name}_FOUND 0 PARENT_SCOPE)
    set(${lib_name}_NOT_FOUND_MESSAGE "${__boost_message}" PARENT_SCOPE)
  else()
    set(${lib_name}_FOUND 1 PARENT_SCOPE)
    list(REMOVE_DUPLICATES ${deps_var})
    set(${deps_var} "${${deps_var}}" PARENT_SCOPE)
  endif()
endfunction()
