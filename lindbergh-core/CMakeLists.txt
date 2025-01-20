cmake_minimum_required(VERSION 3.10)
project(Lindbergh)

# Set compiler and linker
set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)
set(CMAKE_LINKER g++)

# Force 32-bit compilation
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -m32")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -m32")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -m32")

# Define output directories
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/build)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/build)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/build)

# Source files for various targets
file(GLOB LIND_OBJS "src/lindbergh/*.c" "src/lindbergh/*.cpp")
list(FILTER LIND_OBJS EXCLUDE REGEX "src/lindbergh/lindbergh.o")
list(FILTER LIND_OBJS EXCLUDE REGEX "src/lindbergh/evdevinput.o")

file(GLOB XDIFF_SRCS "src/libxdiff/xdiff/*.c")

# Custom compiler and linker flags
set(LINDBERGH_EXE -m32)
set(LINDBERGH_C_FLAGS -g -fPIC -m32 -Wall -Werror -Wno-unused-variable -Wno-unused-function -D_GNU_SOURCE)
SET(CMAKE_C_FLAGS_RELEASE -O3)
set(LINDBERGH_CXX_FLAGS ${LINDBERGH_C_FLAGS} -std=c++11)
set(LIBXDIFF_C_FLAGS -DHAVE_CONFIG_H -fPIC -m32)
set(LIBSEGAAPI_CXX_FLAGS -m32 -fPIC -shared)
set(LIBSEGAAPI_LINKER_FLAGS -m32 -lFAudio)
set(SHARED_LINKER_FLAGS -m32 -Wl,-z,defs -rdynamic -static-libstdc++ -static-libgcc -lc -ldl -lGL -lglut -lX11 -lSDL2 -lm -lpthread -shared -lstdc++ -nostdlib -lasound)

# Build static library libxdiff.a with its own flags
add_library(xdiff STATIC ${XDIFF_SRCS})
set_target_properties(xdiff PROPERTIES OUTPUT_NAME xdiff ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY} LINK_FLAGS "-m32")
target_compile_options(xdiff PRIVATE ${LIBXDIFF_C_FLAGS})

# Build shared library lindbergh.so
add_library(lindbergh SHARED ${LIND_OBJS})
set_target_properties(lindbergh PROPERTIES PREFIX "")
target_link_libraries(lindbergh xdiff ${SHARED_LINKER_FLAGS})
target_compile_options(lindbergh PRIVATE ${LINDBERGH_EXE})

# Build shared library libsegaapi.so
add_library(segaapi SHARED src/libsegaapi/libsegaapi.c)
target_link_libraries(segaapi FAudio ${LIBSEGAAPI_LINKER_FLAGS})
set_target_properties(segaapi PROPERTIES PREFIX "lib")
target_compile_options(segaapi PRIVATE ${LIBSEGAAPI_CXX_FLAGS})

# Build shared library libkswapapi.so
add_library(kswapapi SHARED src/libkswapapi/libkswapapi.c)
set_target_properties(kswapapi PROPERTIES PREFIX "lib")
target_compile_options(kswapapi PRIVATE ${LINDBERGH_EXE})

# Build shared library libposixtime.so
add_library(posixtime SHARED src/libposixtime/libposixtime.c)
set_target_properties(posixtime PROPERTIES PREFIX "lib")
target_compile_options(posixtime PRIVATE ${LINDBERGH_EXE})

# Build executable for lindbergh
add_executable(lindyloader src/lindbergh/lindbergh.c src/lindbergh/evdevinput.c src/lindbergh/evdevinput.h)
target_link_libraries(lindyloader PRIVATE lindbergh m)
set_target_properties(lindyloader PROPERTIES OUTPUT_NAME "lindbergh")
set_target_properties(lindyloader PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_RUNTIME_OUTPUT_DIRECTORY} LINK_FLAGS "-m32")
target_compile_options(lindyloader PRIVATE ${LINDBERGH_EXE})

# Install targets
install(TARGETS lindyloader lindbergh segaapi kswapapi posixtime xdiff
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
)
