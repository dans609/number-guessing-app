#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

# check whether it is exist or not
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
