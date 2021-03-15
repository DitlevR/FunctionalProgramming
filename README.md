# Preparing the scene

## How to use:
First connect to your local setup of mysql and craete a databse.
In line 15 in api.py change the "root" to your local user and "password" to youre local password for mysql and change the "/funk" with the database you created. 


With Python 3 use pip to install requirements.txt


In terminal:
run command "pip install -r requirements.txt"
run command "python3 api.py" to launch project

When you run this this will create the schemas on localhost. 

You will need to insert something in to the employees table. SO connect to your local db and run:

" insert into employee (id, name, email) values (1, "john", "john@johnmail.com"); "

go to "localhost:5000/allemployees" to see john

This is all we have done at the moment for this api. 

