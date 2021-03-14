from flask import Flask
#from flask_sqlalchemy import SQLAlchemy 
from flaskext.mysql import MySQL
import yaml
#from flask_restful import Resource, Api, reqparse
#import pandas as pd
#import ast


app = Flask(__name__)

#db config
db = yaml.load(open('db.yaml'))
app.config['MYSQL_HOST'] = db['mysql_host']
app.config['MYSQL_USER'] = db['mysql_user']
app.config['MYSQL_PASSWORD'] = db['mysql_password']
app.config['MYSQL_DB'] = db['mysql_db']

mysql = MySQL(app)



#db = SQLAlchemy(app)
#api = Api(app)


@app.route('/', methods= ['GET'])
def home():
	return"<h1>Hello world"

if __name__ == '__main__':
	app.run()



