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

echo "This porject will use cxx 17"

mkdir "$projectname"
echo "Created the projcet directry"
cd "$projectname"
echo "Into project"

touch CMakeLists.txt
echo "Created the CMakeLists.txt"

mkdir src
mkdir include

touch main.cpp
echo "Created the main.cpp"
printf "cmake_minimum_required(VERSION 3.10)\nproject($projectname)\nset(CMAKE_CXX_STANDARD 17)\nset(CMAKE_CXX_STANDARD_REQUIRED ON)\nadd_executable($projectname src/main.cpp)\ntarget_include_directories($projectname PRIVATE include)"  > CMakeLists.txt
echo "Done"
