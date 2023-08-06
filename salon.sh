#! /bin/bash

# Bash script to allow users to interact with salon database

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only --no-align --csv -c"

function SHOW_SERVICES(){
  echo "$($PSQL "SELECT * FROM services")" | while IFS=',' read service_id service
  do
    echo "$service_id) $service"
  done
}

function QUERY_SELECTED_SERVICE_NAME() {

  # Function to query customers selected service name

  SELECTED_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $1")

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

function IS_EXISTING_PHONE(){

  # Query to validate existance of CUSTOMER_PHONE in database

  EXISTING_PHONE=$($PSQL "SELECT 1 FROM customers WHERE phone = '$1'")

}

function GET_CUSTOMER_NAME(){

  # Procedure to require user input of CUSTOMER_NAME

  echo "I don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME

}

function QUERY_CUSTOMER_ID() {

  # Query to retrive customers id from database based in their phone

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$1'")

}

function QUERY_CUSTOMER_NAME(){

  # Query to retrieve CUSTOMER_NAME when CUSTOMER_PHONE exists

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$1'")

}

function INSERT_NEW_CUSTOMER(){

  # Function to insert a new customer to customers table

  NEW_CUSTOMER_RESULT=$($PSQL  "INSERT INTO customers(name, phone) VALUES ('$1', '$2')")

}

function GET_CUSTOMER_INFO(){

  # Procedure to request customer or query all customer personal info requiered

  GET_CUSTOMER_PHONE
  IS_EXISTING_PHONE $CUSTOMER_PHONE

  # When validation queries fail, they end up as empty strings
  if [[ -z $EXISTING_PHONE ]]
  then
  echo -e "\n"
    GET_CUSTOMER_NAME
    INSERT_NEW_CUSTOMER $CUSTOMER_NAME $CUSTOMER_PHONE
  else
    # If the bool variables has value (meaning that user exists)
    # retrieve customers name based in their phone
    QUERY_CUSTOMER_NAME $CUSTOMER_PHONE
  fi

  QUERY_CUSTOMER_ID $CUSTOMER_PHONE

}

function GET_CUSTOM_APPOINTMENT_TIME() {

  # Procedure to request user for the appointment time to schedule

  echo "What time would you like your $SELECTED_SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME

}

function INSERT_NEW_APPOINTMENT() {

  # Function to insert new appointment into the db

  NEW_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES ('$1', $2, $3)")

}

function MAIN(){

  echo -e "\n\n~~~~~ MY SALON ~~~~~"

  echo -e "\nWelcome to My Salon, how can I help you?\n"

  while [[ -z "$CORRECT_OPTION" ]]
  do

    SHOW_SERVICES
    USER_SERVICE_CHOICE
    IS_VALID_CHOICE $SERVICE_ID_SELECTED

    if [[ -z $CORRECT_OPTION ]]
    then
      echo -e "\nI could not find that service. What would you like today?"
    else
      QUERY_SELECTED_SERVICE_NAME $SERVICE_ID_SELECTED
      echo "You chose: $SELECTED_SERVICE_NAME"
    fi

  done

  echo -e "\n"
  GET_CUSTOMER_INFO
  echo -e "\n"
  GET_CUSTOM_APPOINTMENT_TIME
  INSERT_NEW_APPOINTMENT

  echo -e "\nI have put you down for a $SELECTED_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.\n"
}

MAIN
