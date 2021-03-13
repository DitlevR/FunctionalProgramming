from flask import Flask
from flask_sqlalchemy import SQLAlchemy
#from flask_restful import Resource, Api, reqparse
#import pandas as pd
#import ast


app = Flask(__name__)
app.configi['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///funkdb.db'
db = SQLAlchemy(app)
#api = Api(app)


@app.route('/', methods= ['GET'])
def home():
	return"<h1>Hello world"

if __name__ == '__main__':
	app.run()



