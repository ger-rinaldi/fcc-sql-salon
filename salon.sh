#! /bin/bash

# Bash script to allow users to interact with salon database

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only --no-align --csv -c"

function SHOW_SERVICES(){
  echo "$($PSQL "SELECT * FROM services")" | while IFS=',' read service_id service
  do
    echo "$service_id) $service"
  done
}

function USER_SERVICE_CHOICE() {
  echo "What service would you like to enjoy?"
  read SERVICE
}

function IS_VALID_CHOICE(){
  CORRECT_OPTION=$($PSQL "SELECT 1 FROM services WHERE service_id = $1")
}

SHOW_SERVICES