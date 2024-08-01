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
  fi
}

MAIN