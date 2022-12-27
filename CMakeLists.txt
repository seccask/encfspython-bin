cmake_minimum_required(VERSION 3.17)
project(seccask2)

set(CMAKE_CXX_STANDARD 17)

# set(BOOST_USE_ASAN TRUE)
# set(ASAN_SYMBOLIZER_PATH /usr/bin/llvm-symbolizer-10)
# add_compile_options(-fsanitize=address)
# add_link_options(-fsanitize=address)
include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

include_directories(include/)

set(Python3_ROOT_DIR /home/mlcask/sgx/lib/cpython-3.9.13-install)
find_package(Python3 3.9 EXACT COMPONENTS Development)

add_executable(encfspython
    csrc/encfs.cc
    csrc/main.cc
)
set_property(TARGET encfspython PROPERTY ENABLE_EXPORTS ON)
target_compile_definitions(encfspython PRIVATE BOOST_USE_VALGRIND)
target_include_directories(encfspython
    PRIVATE
    ${Python3_INCLUDE_DIRS}
    extern/ustore_release/include
    extern/include
)
target_link_libraries(encfspython
    ${CONAN_LIBS}
    ${Python3_LIBRARIES}
    dl
)