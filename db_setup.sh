#! /bin/bash

# Bash script to easily set up the project database from a sql file

# to avoid re-writting the command each time I decided to refactor the database and flags
# into other variables

PSQL="psql --username=freecodecamp --dbname="

# DATABASES: --dbname= values
# postgres rdbms
POSTGRES="postgres"
# project particular database
PROJECT_DB="salon"

# FLAGS
# command flag, to pass commands from script
CMD="-c" 
# read sql commands from file flag
FROM_FILE="-a -f"

# Connect to postgres itself, passing commands from script, drop the database if exists
$PSQL$POSTGRES $CMD "DROP DATABASE IF EXISTS $PROJECT_DB;"
# Connect to postgres itself, passing commands from script, create the database
$PSQL$POSTGRES $CMD "CREATE DATABASE $PROJECT_DB;"
# Connect to postgres itself, passing commands from specified file
$PSQL$PROJECT_DB $FROM_FILE "salon_schema.sql"