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

To insert data into the department table - execute the following line in your database:
" insert into department(name, description, employee_id) values("PR", "1st floor", 1); "

go to "localhost:5000/allemployees" to see john

The relations between the tabels is made in python and can be seen on line 60, 62, 79.

This is all we have done at the moment for this api.

# The elm Frontend

Our Elm frontend is not a Single Page application, we could not get it to work. So we made to seperate files.
In Employee. elm you can see a single result of employee with the id of 1 or all employees.

In Department.elm you can see all departments.

The button on the page sends a http get request to the backend and you get the response in a json format.

We use a Json decoder of a single element on the json list to decode the reponse and we then create tables in the endpoints.

to insert data into the department table - execute the following line in your database:

"insert into department(name, description, employee_id) values("PR", "1st floor", 1);"
