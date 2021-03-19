from flask import Flask, render_template, request, redirect
from flask_sqlalchemy import SQLAlchemy 
#from flaskext.mysql import MySQL
import yaml



app = Flask(__name__)

#mysql = MySQL()
#db config
#db = yaml.load(open('db.yaml'))
#app.config['MYSQL_HOST'] = '46.101.167.169'
#app.config['MYSQL_USER'] = db['mysql_user']
#app.config['MYSQL_PASSWORD'] = db['mysql_password']
#app.config['MYSQL_DB'] = db['mysql_db']

#mysql.init_app(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+mysqlconnector://funk_user:funkyfunk950318@46.101.167.169/funk'
db = SQLAlchemy(app)
#api = Api(app)


class Project:
	def __init__(self, id, title, duration):
		self.id = id
		self.title = title
		self.duration = duration

class Employee:
	def __init__(self, id, firstName, lastName, email):
		self.id = id
		self.firstName = firstName
		slef.lastName = lastName
		slef.email = email

class Department:
	def __init__(self, code, name, description):
		slef.code = code
		self.name = name
		self.description = description 


@app.route('/', methods= ['GET'])
def home():
	return"<h1>Hello world"

@app.route('/allemp', methods=['GET'])
def allemp():
	cur = mysql.get_db().cursor()
	resultValue = cur.execute("SELECT * FROM employee")
	if resultValue > 0:
		emp = cur.fetchall()
		print(emp)
		return emp

if __name__ == '__main__':
	app.run(debug=True)



