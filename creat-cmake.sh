#!/bin/bash

echo "Input the name of the cmake project"

while true; do
    read -r projectname
    if [[ -z "$projectname" ]]; then
        echo "The project name cannot be null!!"
    else
        break
    fi
done

PS3="Choose your language: "

select lang in C CXX; do
    echo "The language is $lang"
    break
done

if [[ "$lang" == "C" ]]; then
    sign="CMAKE_C_STANDARD"
    req="CMAKE_C_STANDARD_REQUIRED"
    ext="c"
elif [[ "$lang" == "CXX" ]]; then
    sign="CMAKE_CXX_STANDARD"
    req="CMAKE_CXX_STANDARD_REQUIRED"
    ext="cxx"
fi

echo "This porject will use $lang 17"

PS3="Choose the project type: "

select ptype in executable shared static; do
    echo "The project type is $ptype"
    break
done

if [[ "$ptype" == "executable" ]]; then
    filename="main.$ext"
    addcmd="add_executable($projectname src/$filename)"
else
    filename="$projectname.$ext"
    addcmd="add_library($projectname ${ptype^^} src/$filename)"
fi

mkdir "$projectname"
echo "Created the project directry"
cd "$projectname"
echo "Into project"

touch CMakeLists.txt
echo "Created the CMakeLists.txt"

mkdir src
mkdir include

touch src/$filename
touch include/header.h

echo "Created the src/$filename"
printf "cmake_minimum_required(VERSION 3.14)\n" >> CMakeLists.txt
printf "project($projectname VERSION 0.0.1 LANGUAGES $lang)\n" >> CMakeLists.txt

printf "set(CMAKE_EXPORT_COMPILE_COMMANDS ON)\n" >> CMakeLists.txt

if [[ $ptype == executable ]]; then

printf "set($sign 17)\n" >> CMakeLists.txt
printf "set($req ON)\n" >> CMakeLists.txt

fi

printf "$addcmd\n" >> CMakeLists.txt

if [[ $ptype == executable ]]; then

printf "target_include_directories($projectname PRIVATE include)\n"  >> CMakeLists.txt

elif [[ $ptype == static ]]; then

printf "target_include_directories($projectname PUBLIC\n" >> CMakeLists.txt
printf "    \$<BUILD_INTERFACE:\${CMAKE_CURRENT_SOURCE_DIR}/include>\n" >> CMakeLists.txt
printf "    \$<INSTALL_INTERFACE:include>\n" >> CMakeLists.txt
printf ")\n\n" >> CMakeLists.txt 
# Empty line|
printf "target_compile_features($projectname PUBLIC " >> CMakeLists.txt
printf "$ext" >> CMakeLists.txt
printf "_std_17)\n\n" >> CMakeLists.txt #Just One Line
# Empty line       |
printf "install(TARGETS $projectname EXPORT $projectname ARCHIVE DESTINATION lib)\n\n" >> CMakeLists.txt
# Empty line                                                                         |
printf "install(DIRECTORY include/ DESTINATION include)\n\n" >> CMakeLists.txt
# Empty line
printf "install(EXPORT $projectname FILE ${projectname}Config.cmake DESTINATION lib/cmake/$projectname)\n\n" >> CMakeLists.txt
# Empty line

else

printf "set_target_properties($projectname PROPERTIES POSITION_INDEPENDENT_CODE ON)\n" >> CMakeLists.txt
printf "set_target_properties($projectname PROPERTIES\n" >> CMakeLists.txt
printf "    VERSION \${PROJECT_VERSION}\n" >> CMakeLists.txt
printf "    SOVERSION \${PROJECT_VERSION_MAJOR}\n" >> CMakeLists.txt
printf ")\n\n" >> CMakeLists.txt
# Empty line
printf "target_include_directories($projectname PUBLIC\n" >> CMakeLists.txt
printf "    \$<BUILD_INTERFACE:\${CMAKE_CURRENT_SOURCE_DIR}/include>\n" >> CMakeLists.txt
printf "    \$<INSTALL_INTERFACE:include>\n" >> CMakeLists.txt
printf ")\n\n" >> CMakeLists.txt 
# Empty line
printf "install(TARGETS $projectname EXPORT $projectname ARCHIVE DESTINATION lib LIBRARY DESTINATION lib RUNTIME DESTINATION bin)\n\n" >> CMakeLists.txt
# Empty line                                                                         
printf "install(DIRECTORY include/ DESTINATION include)\n\n" >> CMakeLists.txt
# Empty line
printf "install(EXPORT $projectname FILE ${projectname}Config.cmake DESTINATION lib/cmake/$projectname)\n\n" >> CMakeLists.txt
# Empty line

fi

printf "if(EXISTS \${CMAKE_SOURCE_DIR}/compile_commands.json)\n" >> CMakeLists.txt
printf "    file(REMOVE \${CMAKE_SOURCE_DIR}/compile_commands.json)\n" >> CMakeLists.txt
printf "endif()\n" >> CMakeLists.txt
printf "file(CREATE_LINK \${CMAKE_BINARY_DIR}/compile_commands.json \${CMAKE_SOURCE_DIR}/compile_commands.json SYMBOLIC)\n" >> CMakeLists.txt

echo "CmakeLists.txt is created"

touch .gitignore

printf "build/\n" >> .gitignore
printf "compile_commands.json\n" >> .gitignore
printf ".cache/\n" >> .gitignore

echo ".gitignore is created"

mkdir build
cd build
cmake ..
cd ..

echo "Done"
