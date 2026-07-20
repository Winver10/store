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
elif [[ "$lang" == "CXX" ]]; then
    filename="main.cpp"
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
printf "cmake_minimum_required(VERSION 3.10)\nproject($projectname)\nset(CMAKE_EXPORT_COMPILE_COMMANDS ON)\nset(CMAKE_$lang_STANDARD 17)\nset(CMAKE_$lang_STANDARD_REQUIRED ON)\nadd_executable($projectname src/$filename)\ntarget_include_directories($projectname PRIVATE include)"  > CMakeLists.txt

mkdir build
cd build
cmake ..

cd ..
ln -s build/compile_commands.json ./compile_commands.json

echo "Done"
