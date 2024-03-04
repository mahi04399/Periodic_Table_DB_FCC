# This project got debugged using chatGPT, stackOverflow and manual print statements
# and ultimately processing is done by the developer :).
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
# get element details
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    OUTPUT="$($PSQL "SELECT * FROM ELEMENTS WHERE ATOMIC_NUMBER=$1")"
    
  elif [[ $1 =~ ^[A-Z]+[a-z]?$ ]]
  then
    OUTPUT="$($PSQL "SELECT * FROM ELEMENTS WHERE SYMBOL='$1'")"
  else
    OUTPUT="$($PSQL "SELECT * FROM ELEMENTS WHERE NAME='$1'")"
  fi

  if [[ -z $OUTPUT ]]
  then
    echo -e "I could not find that element in the database."
  else  
    IFS='|'
    read ATOMIC_NUMBER SYMBOL NAME <<< $OUTPUT
    unset IFS

# get properties
    PROPERTIES_RESULT=$($PSQL "SELECT TYPES.TYPE,ATOMIC_MASS, MELTING_POINT_CELSIUS, BOILING_POINT_CELSIUS FROM PROPERTIES INNER JOIN TYPES USING(TYPE_ID) WHERE ATOMIC_NUMBER=$ATOMIC_NUMBER;")
    IFS='|'
    read TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS <<< $PROPERTIES_RESULT
    unset IFS

    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  fi
fi

# Thanks!

