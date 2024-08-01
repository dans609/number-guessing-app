#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

# perform a query, get the user's id by its username
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
