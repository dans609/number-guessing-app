#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN() {
  if [[ -n $1 ]]; then
    echo -e "\n$1"
  fi

  echo "Enter your username:"
  read USERNAME

  # perform a query, get the user's id by its username
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

  # check whether the user is exist or not
  if [[ -z $USER_ID ]]; then
    INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')" 2>/dev/null)
    if [[ ! $INSERT_USER = "INSERT 0 1" ]]; then
      MAIN "username is too long, maximum characters is (22)"    
    fi

    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
    echo "Welcome, $USERNAME! It looks like this is your first time here."
  else
    TOTAL_GAMES=$($PSQL "SELECT COUNT(game_id) FROM games WHERE user_id=$USER_ID")
    BEST_GAME=$($PSQL "SELECT MIN(number_of_guess) FROM games WHERE user_id=$USER_ID")
    echo "Welcome back, $USERNAME! You have played $TOTAL_GAMES games, and your best game took $BEST_GAME guesses."
  fi

  GAME $USER_ID
}

GAME() {
  if [[ -z $1 ]]; then
    echo "Missing user id parameter"
  else
    TRY=0
    ID=$1
    EXPECTED_NUMBER=$(( RANDOM % 1000 + 1 ))
    echo "Guess the secret number between 1 and 1000:"
    read NUMBER_GUESS

    while [[ ! $NUMBER_GUESS =~ ^[0-9]+$ ]]; do
      echo "That is not an integer, guess again:"
      read NUMBER_GUESS
    done

    TRY=$(( TRY + 1 ))

    while [[ $NUMBER_GUESS -ne $EXPECTED_NUMBER ]] 2>/dev/null; do
      if [[ ! $NUMBER_GUESS =~ ^[0-9]+$ ]]; then
        echo "That is not an integer, guess again:"
      elif [[ $NUMBER_GUESS -lt $EXPECTED_NUMBER ]]; then
        echo "It's higher than that, guess again:"
        TRY=$(( TRY + 1 ))
      else
        echo "It's lower than that, guess again:"
        TRY=$(( TRY + 1 ))
      fi

      read NUMBER_GUESS
    done

    if [[ $NUMBER_GUESS -eq $EXPECTED_NUMBER ]]; then
      echo "You guessed it in $TRY tries. The secret number was $EXPECTED_NUMBER. Nice job!"
      INSERT_GAME=$($PSQL "INSERT INTO games(user_id, number_of_guess) VALUES($ID, $TRY)")
    else
      echo "An error occur unexpectedly"
    fi
  fi
}

MAIN