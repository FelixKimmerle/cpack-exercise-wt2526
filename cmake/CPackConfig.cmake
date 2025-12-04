set(CPACK_PACKAGE_NAME ${PROJECT_NAME})


set(CPACK_DEBIAN_PACKAGE_DESCRIPTION
"SSE artificial cpack example
This package demonstrates packaging with CMake/CPack to TGZ and DEB.
It installs a small binary and a library and ships docs under
/usr/share/doc/${CPACK_PACKAGE_NAME}/."
)
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY ""
  CACHE STRING "Very extensive description of the cpack example module")

set(CPACK_PACKAGE_VENDOR "Felix Kimmerle")
set(CPACK_PACKAGE_CONTACT "FelixKimmerle@hotmail.com")
set(CPACK_PACKAGE_MAINTAINER "FelixKimmerle <${CPACK_PACKAGE_CONTACT}>")
set(CPACK_PACKAGE_HOMEPAGE_URL "https://github.com/FelixKimmerle/cpack-exercise-wt2526")

set(CPACK_STRIP_FILES "TRUE")
set(CPACK_GENERATOR "TGZ;DEB")
set(CPACK_DEBIAN_FILE_NAME "DEB-DEFAULT")
set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS YES)
# set(CPACK_DEBIAN_PACKAGE_VERSION 1)
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Felix Kimmerle <${CPACK_PACKAGE_CONTACT}>")

include(CPack)
