cmake_minimum_required(VERSION 3.5)
project(m8mouse LANGUAGES C)
set(CMAKE_C_STANDARD 11)

find_package(PkgConfig REQUIRED)

pkg_check_modules(libhidapi REQUIRED IMPORTED_TARGET "hidapi-libusb")
 
add_executable(${PROJECT_NAME} main.c m8mouse.c m8mouse.h log.c log.h)
target_link_libraries(${PROJECT_NAME} PkgConfig::libhidapi)


install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
install(FILES 90-m8mouse.rules DESTINATION /etc/udev/rules.d)

# uninstall target for the two files
add_custom_target(uninstall COMMAND rm -v ${CMAKE_INSTALL_PREFIX}/bin/${PROJECT_NAME} /etc/udev/rules.d/90-m8mouse.rules)

