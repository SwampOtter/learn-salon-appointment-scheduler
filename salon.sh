#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~~ Salon Salon ~~~~~\n"

MAIN_MENU() {

  echo "Welcome to Salon Salon, please choose a service from the options below."
  echo -e "\n1) Cut\n2) Cut and Style\n3) Dye\n4) Extensions\n5) Exit"
  read SERVICE_ID_SELECTED 

  case $SERVICE_ID_SELECTED in
    1) APPOINTMENT_MENU ;;
    2) APPOINTMENT_MENU ;;
    3) APPOINTMENT_MENU ;;
    4) APPOINTMENT_MENU ;;
    5) EXIT ;;
    *) MAIN_MENU ;;
  esac
}

APPOINTMENT_MENU() {
  
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo -e "\nYou have chosen$SERVICE.\n"

  echo -e "What is your phone number?\n"
  read CUSTOMER_PHONE

  NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  #if phone doesn't exist
  if [[ -z $NAME ]]
  then
    echo -e "\nWhat is your name?\n"
    read CUSTOMER_NAME

    INSERT_NAME_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # get customer id
  CUST_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  echo -e "\nWhat time would would you like to schedule your$SERVICE,$CUSTOMER_NAME?\n"
  read SERVICE_TIME

  APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUST_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a$SERVICE at $SERVICE_TIME,$CUSTOMER_NAME."
}

MAIN_MENU