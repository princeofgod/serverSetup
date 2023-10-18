#!/bin/bash

# Check if the script is being run with root privileges
if [[ $(id -u) -ne 0 ]]; then
  echo "This script must be run as root. Please use 'sudo' or run it as the root user."
  exit 1
fi

# Generate a random temporary password for MySQL root user
TEMP_ROOT_PASSWORD="zyonel4321"

# Install MySQL
apt-get update
apt-get install -y mysql-server

# Check if MySQL installation was successful
if systemctl is-active --quiet mysql; then
  echo "MySQL installed successfully."

  # Set temporary root password
  mysqladmin --user=root --password= password "$TEMP_ROOT_PASSWORD"

  # Run mysql_secure_installation using the temporary root password
  mysql_secure_installation <<EOF

y
$TEMP_ROOT_PASSWORD
$TEMP_ROOT_PASSWORD
y
y
y
y
EOF

  # Prompt for the new MySQL root password
  # echo "Enter a new secure password for the MySQL root user:"
  # read -s NEW_ROOT_PASSWORD

  # Change the MySQL root password to the new secure value
  # mysql -uroot -p"$TEMP_ROOT_PASSWORD" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$NEW_ROOT_PASSWORD'; FLUSH PRIVILEGES;"

  echo "MySQL installation secured."

else
  echo "Failed to install MySQL."
  exit 1
fi

# Prompt for creating a new MySQL user
read -p "Do you want to create a new MySQL user? (yes/no): " create_user

if [[ "$create_user" == "yes" ]]; then
  # Prompt for the new user details
  read -p "Enter the new MySQL username: " new_username
  read -s -p "Enter the password for the new MySQL user: " new_user_password

  # Create the new MySQL user with the provided password
  mysql -uroot -p"$NEW_ROOT_PASSWORD" -e "CREATE USER '$new_username'@'localhost' IDENTIFIED BY '$new_user_password'; GRANT ALL PRIVILEGES ON *.* TO '$new_username'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"
  echo "New MySQL user $new_username created."
fi

# Prompt for creating a new database
read -p "Do you want to create a new MySQL database? (yes/no): " create_db

if [[ "$create_db" == "yes" ]]; then
  # Prompt for the new database name
  read -p "Enter the new MySQL database name: " new_db_name

  # Create the new database
  mysql -uroot -p"$NEW_ROOT_PASSWORD" -e "CREATE DATABASE $new_db_name;"
  echo "New MySQL database $new_db_name created."

  # Grant all privileges on the new database to the earlier created user
  mysql -uroot -p"$NEW_ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $new_db_name.* TO '$new_username'@'localhost'; FLUSH PRIVILEGES;"
  echo "All privileges granted on $new_db_name to user $new_username."
fi

