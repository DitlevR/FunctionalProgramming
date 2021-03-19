from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from flaskext.mysql import MySQL
import yaml
from flask_restful import Resource, Api, reqparse


# import pandas as pd
# import ast


app = Flask(__name__)


app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:password@localhost/funk'
# db config

# db = yaml.load(open('db.yaml'))
# app.config['MYSQL_HOST'] = db['mysql_host']
# app.config['MYSQL_USER'] = db['mysql_user']
# app.config['MYSQL_PASSWORD'] = db['mysql_password']
# app.config['MYSQL_DB'] = db['mysql_db']

mysql = MySQL(app)


db = SQLAlchemy(app)
api = Api(app)


class HelloWorld(Resource):
    def get(self):
        return {'hello': 'world'}


api.add_resource(HelloWorld, '/hello')


class Project(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)
    employee_id = db.Column(db.Integer, db.ForeignKey('employee.id'),
                            nullable=False)


class Employee(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    projects = db.relationship('Project', backref='employee', lazy=True)
    departments = db.relationship('Department', backref='employee', lazy=True)

    def __init__(self, name, email):
        self.name = name
        self.email = email

    def __repr__(self):
        return '<Employee %r>' % (self.name)


class Department(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)
    description = db.Column(db.String(200), unique=True, nullable=True)
    employee_id = db.Column(db.Integer, db.ForeignKey('employee.id'),
                            nullable=False)


@app.route('/', methods=['GET'])
def home():

    return"<h1>Hello world"


@app.route('/allemployees', methods=['GET'])
def employees():
    # employee = Employee.query.all()
    em = Employee.query.first()
    print(str(em))
    return "<h1> Our best employee of the year is: " + str(em.name) + "</h1>"


if __name__ == '__main__':
    db.create_all()
    app.run()