#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"


#get services
LIST_SERVICES=$($PSQL "SELECT * FROM services")
echo -e "Welcome to My Salon, how can I help you?\n"

LIST(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  
  echo "$LIST_SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME" 
  done
  read SERVICE_ID_SELECTED
  SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_ID ]]
  then 
    #send to list function again.
    LIST "I could not find that service. What would you like today?"
  fi
}

LIST

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
#get customer name
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

if [[ -z $CUSTOMER_NAME ]]
then
  echo -e "\nI don't have a record for that phone number,what's your name?"
  read CUSTOMER_NAME

  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
fi
echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
read SERVICE_TIME
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
#insert data 
INSERT_APPOINTMENTS=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,'$SERVICE_ID','$SERVICE_TIME')")

echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."