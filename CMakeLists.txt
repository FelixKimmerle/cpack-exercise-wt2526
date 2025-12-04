cmake_minimum_required(VERSION "3.28")

project("cpackexample" VERSION 0.1.0)

FIND_PACKAGE(deal.II 9.5 REQUIRED
  HINTS ${DEAL_II_DIR} ../ ../../ $ENV{DEAL_II_DIR}
  )
DEAL_II_INITIALIZE_CACHED_VARIABLES()

# Uses the FindBoost module of CMake
find_package(Boost 1.83 COMPONENTS filesystem REQUIRED)

find_package(yaml-cpp 0.8 REQUIRED)

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


set(DEB_CHANGELOG_SRC "${CMAKE_SOURCE_DIR}/changelog")
set(DEB_CHANGELOG_GZ  "${CMAKE_BINARY_DIR}/changelog.gz")

add_custom_command(
    OUTPUT "${DEB_CHANGELOG_GZ}"
   COMMAND ${CMAKE_COMMAND} -E env SOURCE_DATE_EPOCH=0 GZIP=-9 sh -c
          "gzip -n -c '${DEB_CHANGELOG_SRC}' > '${DEB_CHANGELOG_GZ}'"
              DEPENDS "${DEB_CHANGELOG_SRC}"
    VERBATIM
  )
  add_custom_target(gen_deb_changelog ALL DEPENDS "${DEB_CHANGELOG_GZ}")

  install(
    FILES "${DEB_CHANGELOG_GZ}"
    DESTINATION "${CMAKE_INSTALL_DOCDIR}"
    RENAME "changelog.gz"
  )

set(DEB_MANPAGE_SRC "${CMAKE_SOURCE_DIR}/man/cpackexample.1")
set(DEB_MANPAGE_GZ  "${CMAKE_BINARY_DIR}/cpackexample.1.gz")

add_custom_command(
    OUTPUT "${DEB_MANPAGE_GZ}"
   COMMAND ${CMAKE_COMMAND} -E env SOURCE_DATE_EPOCH=0 GZIP=-9 sh -c
          "gzip -n -c '${DEB_MANPAGE_SRC}' > '${DEB_MANPAGE_GZ}'"
              DEPENDS "${DEB_MANPAGE_SRC}"
    VERBATIM
  )
  add_custom_target(gen_deb_manpage ALL DEPENDS "${DEB_MANPAGE_GZ}")

  install(
    FILES "${DEB_MANPAGE_GZ}"
    DESTINATION "${CMAKE_INSTALL_MANDIR}/man1"
  )


install(TARGETS cpackexample cpackexamplelib
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/cpackexamplelib
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/cpackexamplelib 
  )

include(cmake/CPackConfig.cmake)
