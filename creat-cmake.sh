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
    filename="main.c"
    sign="CMAKE_C_STANDARD"
    req="CMAKE_C_STANDARD_REQUIRED"
elif [[ "$lang" == "CXX" ]]; then
    filename="main.cpp"
    sign="CMAKE_CXX_STANDARD"
    req="CMAKE_CXX_STANDARD_REQUIRED"
fi

echo "This porject will use $lang 17"

mkdir "$projectname"
echo "Created the projcet directry"
cd "$projectname"
echo "Into project"

touch CMakeLists.txt
echo "Created the CMakeLists.txt"

mkdir src
mkdir include

touch src/$filename
echo "Created the src/$filename"
printf "cmake_minimum_required(VERSION 3.10)\n" >> CMakeLists.txt
printf "project($projectname)\n" >> CMakeLists.txt
printf "set(CMAKE_EXPORT_COMPILE_COMMANDS ON)\n" >> CMakeLists.txt
printf "set($sign 17)\n" >> CMakeLists.txt
printf "set($req ON)\n" >> CMakeLists.txt
printf "add_executable($projectname src/$filename)\n" >> CMakeLists.txt
printf "target_include_directories($projectname PRIVATE include)"  >> CMakeLists.txt

mkdir build
cd build
cmake ..

cd ..
ln -s build/compile_commands.json ./compile_commands.json

echo "Done"
