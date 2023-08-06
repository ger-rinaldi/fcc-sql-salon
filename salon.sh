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
  read SERVICE_ID_SELECTED
}

function IS_VALID_CHOICE(){
  CORRECT_OPTION=$($PSQL "SELECT 1 FROM services WHERE service_id = $1")
}

function GET_CUSTOMER_PHONE(){

  # Procedure to require user input of CUSTOMER_PHONE

  echo "Please input your phone number:"
  read CUSTOMER_PHONE

}

function GET_CUSTOMER_NAME(){

  # Procedure to require user input of CUSTOMER_NAME

  echo "You don't seem to be registered, please, input your name:"
  read CUSTOMER_NAME

}
function MAIN_LOOP(){
  while [[ -z "$CORRECT_OPTION" ]]
  do

    SHOW_SERVICES
    USER_SERVICE_CHOICE
    echo "You chose: $SERVICE_ID_SELECTED"
    IS_VALID_CHOICE $SERVICE_ID_SELECTED

  done
}