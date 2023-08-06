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

function IS_EXISTING_PHONE(){

  # Query to validate existance of CUSTROMER_PHONE in database

  EXISTING_PHONE=$($PSQL "SELECT 1 FROM customers WHERE phone = '$1'")

}

function GET_CUSTOMER_NAME(){

  # Procedure to require user input of CUSTOMER_NAME

  echo "You don't seem to be registered, please, input your name:"
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

  # Procedure to request customer or query all custromer personal info requiered

  GET_CUSTOMER_PHONE
  IS_EXISTING_PHONE $CUSTOMER_PHONE

  # When validation queries fail, they end up as empty strings
  if [[ -z $EXISTING_PHONE ]]
  then
    GET_CUSTOMER_NAME
    INSERT_NEW_CUSTOMER $CUSTOMER_NAME $CUSTOMER_PHONE
  else
    # If the bool variables has value (meaning that user exists)
    # retrieve customers name based in their phone
    QUERY_CUSTOMER_NAME $CUSTOMER_PHONE
  fi

  QUERY_CUSTOMER_ID $CUSTOMER_PHONE

}
}

function MAIN(){
  while [[ -z "$CORRECT_OPTION" ]]
  do

    SHOW_SERVICES
    USER_SERVICE_CHOICE
    echo "You chose: $SERVICE_ID_SELECTED"
    IS_VALID_CHOICE $SERVICE_ID_SELECTED
  done

  GET_CUSTOMER_INFO
}