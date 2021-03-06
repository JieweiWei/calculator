#!/bin/bash

# Author: Jiewei Wei
# Student ID: 12330318
# Copyright: 12330318
# Script follows here:

BISON_FILE_NAME=calculator
FLEX_FILE=token.l
LEX_FILE=lex.yy.c
CC=g++
EXE=demo

# Run bison and flex, compile the c file.
if [ ${#} -eq 0 ]
then
  bison -d ${BISON_FILE_NAME}.y
  flex ${FLEX_FILE}
  ${CC} -o ${EXE} ${BISON_FILE_NAME}.tab.c ${LEX_FILE}
# Install g++, flex and bison
elif [ ${#} -eq 1 -a ${1} == "install" ]
then
  for item in g++ flex bison
  do
    if which item > /dev/null;
    then
      echo "please install ${item} first!"
      if uname -a| grep "Ubuntu";
      then
        sudo apt-get install item
      fi
    else
      echo "you have install ${item}!"
    fi
  done
# Clear file generated by compiling and running.
elif [ ${#} -eq 1 -a ${1} == "clean" ]
then
  rm -f ${BISON_FILE_NAME}.tab.* ${LEX_FILE} ${EXE}
else
  echo "please read README file"
fi
