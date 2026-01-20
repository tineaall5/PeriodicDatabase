#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Argument Null
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi
# Argument Angka
if [[ $1 =~ ^[0-9]+$ ]]
then
  element_result=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
  FROM elements 
  INNER JOIN properties USING(atomic_number) 
  INNER JOIN types USING(type_id)
  WHERE atomic_number = $1")
else
  # Argumen Nama / Simbol
  element_result=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius 
  FROM elements 
  INNER JOIN properties USING(atomic_number) 
  INNER JOIN types USING(type_id)
  WHERE symbol = '$1' OR name = '$1'")
fi

# Hasil Null
if [[ -z $element_result ]]
then
  echo "I could not find that element in the database."
  exit
fi

# Total Hasil
IFS="|" read atomic_no element_name element_symbol element_type atomic_weight melt_temp boil_temp <<< "$element_result"

echo "The element with atomic number $atomic_no is $element_name ($element_symbol). It's a $element_type, with a mass of $atomic_weight amu. $element_name has a melting point of $melt_temp celsius and a boiling point of $boil_temp celsius."
