cmake_minimum_required(VERSION "3.28")

project("cpackexample" VERSION 0.1.0)

FIND_PACKAGE(deal.II 9.5 REQUIRED
  HINTS ${DEAL_II_DIR} ../ ../../ $ENV{DEAL_II_DIR}
  )
DEAL_II_INITIALIZE_CACHED_VARIABLES()

# Uses the FindBoost module of CMake
find_package(Boost 1.83 COMPONENTS filesystem REQUIRED)

find_package(yaml-cpp 0.6 REQUIRED)

add_library(cpackexamplelib filesystem/filesystem.cpp fem/fem.cpp flatset/flatset.cpp yamlParser/yamlParser.cpp)


set_target_properties(cpackexamplelib PROPERTIES
  PUBLIC_HEADER "fem/fem.hpp;filesystem/filesystem.hpp;flatset/flatset.hpp;yamlParser/yamlParser.hpp"
)

add_executable("${PROJECT_NAME}" main.cpp)

target_link_libraries("${PROJECT_NAME}" cpackexamplelib)
target_link_libraries(cpackexamplelib Boost::filesystem ${YAML_CPP_LIBRARIES})

DEAL_II_SETUP_TARGET("${PROJECT_NAME}")
DEAL_II_SETUP_TARGET(cpackexamplelib)


include(GNUInstallDirs)

set(LICENSE_FILE "${CMAKE_SOURCE_DIR}/LICENSE")
install(
    FILES "${LICENSE_FILE}"
    DESTINATION "${CMAKE_INSTALL_DOCDIR}"
    RENAME "copyright"
    COMPONENT doc
)

set(DEBIAN_CHANGELOG "${CMAKE_SOURCE_DIR}/changelog")
install(FILES "${DEBIAN_CHANGELOG}"
          DESTINATION "${CMAKE_INSTALL_DOCDIR}"
          RENAME "changelog")


install(CODE "
    set(f \"\${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_DATADIR}/doc/${PROJECT_NAME}/changelog.Debian\")
    if(EXISTS \"\${f}\")
      execute_process(COMMAND sh -c \"gzip -9 -f '\${f}'\")
    endif()
  ")

install(TARGETS cpackexample cpackexamplelib
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/cpackexamplelib
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/cpackexamplelib 
  )

include(cmake/CPackConfig.cmake)
