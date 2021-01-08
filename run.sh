#!/bin/bash

# If INPUT_FILE is empty, then open User Interface for the user pass the input
# Otherwise, specify an example to run (without graphical interface). Ex: INPUT_FILE="tests/aula1_ex1.m" 
INPUT_FILE="tests/aula3_ex3.m"
INPUT_FILE="tests/my_test.m"

octave main.m ${INPUT_FILE}