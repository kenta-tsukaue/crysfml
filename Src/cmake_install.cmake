# Install script for directory: /Users/tsukauekenta/Documents/university/research/crysfml_test/Src

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/Users/tsukauekenta/Documents/university/research/crysfml_test/gfortran")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/Users/tsukauekenta/Documents/university/research/crysfml_test/gfortran/LibC/libcrysfml.a")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/Users/tsukauekenta/Documents/university/research/crysfml_test/gfortran/LibC" TYPE STATIC_LIBRARY FILES "/Users/tsukauekenta/Documents/university/research/crysfml_test/Src/libcrysfml.a")
  if(EXISTS "$ENV{DESTDIR}/Users/tsukauekenta/Documents/university/research/crysfml_test/gfortran/LibC/libcrysfml.a" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/Users/tsukauekenta/Documents/university/research/crysfml_test/gfortran/LibC/libcrysfml.a")
    execute_process(COMMAND "/usr/bin/ranlib" "$ENV{DESTDIR}/Users/tsukauekenta/Documents/university/research/crysfml_test/gfortran/LibC/libcrysfml.a")
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/Users/tsukauekenta/Documents/university/research/crysfml_test/gfortran/LibC/;/Users/tsukauekenta/Documents/university/research/crysfml_test/gfortran/LibC/")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/Users/tsukauekenta/Documents/university/research/crysfml_test/gfortran/LibC" TYPE DIRECTORY FILES
    "/Users/tsukauekenta/Documents/university/research/crysfml_test/crysfml_common_modules/"
    "/Users/tsukauekenta/Documents/university/research/crysfml_test/crysfml_modules/"
    FILES_MATCHING REGEX "/[^/]*\\.mod$" REGEX "/cmakefiles$" EXCLUDE)
endif()

