# CMakeList.txt : CMake project for Lua_EndAssignment, include source and define
# project specific logic here.
#
cmake_minimum_required (VERSION 3.8)

# Enable Hot Reload for MSVC compilers if supported.
if (POLICY CMP0141)
  cmake_policy(SET CMP0141 NEW)
  set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<IF:$<AND:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>,$<$<CONFIG:Debug,RelWithDebInfo>:EditAndContinue>,$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>>")
endif()

project ("Lua_EndAssignment")

LIST(APPEND LUA_SRC
"game1.lua"
)

# Add source to this project's executable.
add_executable (Lua_EndAssignment WIN32 "src/Lua_EndAssignment.cpp" "src/Lua_EndAssignment.h"
"src/AbstractGame.cpp" "src/AbstractGame.h"
"src/Game.h" "src/Game.cpp" "src/Game.rc"
"src/GameDefines.h"
"src/GameEngine.h" "src/GameEngine.cpp"
"src/GameWinMain.h" "src/GameWinMain.cpp"
 "src/LuaBindings.h" "src/LuaBindings.cpp"
${LUA_SRC}
)


include(FetchContent)

# Add lua
FetchContent_Declare(
    lua
    URL https://github.com/marovira/lua/archive/refs/tags/5.4.4.tar.gz
)
FetchContent_MakeAvailable(lua)


# Add sol
FetchContent_Declare(
    sol2
    URL https://github.com/ThePhD/sol2/archive/refs/tags/v3.3.0.tar.gz
)
FetchContent_MakeAvailable(sol2)


# add script to out
add_custom_target(OutputLuaSrc ALL
    COMMENT "Copying Lua scripts to output directory"
)

FOREACH(LUA_SOURCE IN LISTS LUA_SRC)
    add_custom_command(TARGET OutputLuaSrc POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        ${CMAKE_CURRENT_SOURCE_DIR}/${LUA_SOURCE}
        $<TARGET_FILE_DIR:${PROJECT_NAME}>/${LUA_SOURCE})
ENDFOREACH()

target_link_libraries(Lua_EndAssignment PRIVATE lua::lua sol2)
target_include_directories(Lua_EndAssignment PRIVATE src)


if (CMAKE_VERSION VERSION_GREATER 3.12)
  set_property(TARGET Lua_EndAssignment PROPERTY CXX_STANDARD 20)
endif()

if(MSVC)
	target_compile_definitions(Lua_EndAssignment PUBLIC UNICODE _UNICODE)
endif()

# TODO: Add tests and install targets if needed.
