#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# check if input is not a number
if ! [[ $1 =~ ^[0-9]+$ ]]
then
  # get atomic number
  ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol = '$1' or name = '$1'")
  if [[ -z $ATOMIC_NUMBER ]]
  then
    echo "I could not find that element in the database."
    exit 0
  fi
else
  ATOMIC_NUMBER=$1
fi

ELEMENT_INFO=$($PSQL "select * from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number='$ATOMIC_NUMBER'")

if [[ -z $ELEMENT_INFO ]]
then
  echo "I could not find that element in the database."
  exit 3
else
  read TYPE_ID BAR ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS BAR TYPE <<< $ELEMENT_INFO
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
fi
