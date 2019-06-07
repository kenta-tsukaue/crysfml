if(DEFINED ENV{CRYSFML_BOOST_DIR})
 set(Boost_HINTS_DIR "$ENV{CRYSFML_BOOST_DIR}" "$ENV{CRYSFML_BOOST_DIR}/include")
 find_path(Boost_INCLUDE_DIR format.hpp HINTS ${Boost_HINTS_DIR})
 get_filename_component(Boost_INCLUDE_DIR ${Boost_INCLUDE_DIR} DIRECTORY)
else()
 find_package(Boost 1.45.0)
endif()