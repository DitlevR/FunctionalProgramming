from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from flaskext.mysql import MySQL
import yaml
from flask_restful import Resource, Api, reqparse
from flask_cors import CORS
from sqlalchemy_serializer import SerializerMixin
from sqlalchemy.ext.declarative import DeclarativeMeta
import json


# import pandas as pd
# import ast


app = Flask(__name__)
CORS(app)


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


projects = db.Table('projects',
                    db.Column('project_id', db.Integer, db.ForeignKey(
                        'project.id'), primary_key=True),
                    db.Column('employee_id', db.Integer, db.ForeignKey('employee.id')), primary_key=True)


class Project(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)

    def __init__(self, name):
        self.name = name


class Employee(db.Model, SerializerMixin):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    project = db.relationship('Project', secondary=projects, lazy='subquery',
                              backref=db.backref('employees', lazy=True))
    departments = db.relationship('Department', backref='employee', lazy=True)

    serialize_only = ('id', 'name', 'email', 'project', 'departments')

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

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

    def __init__(self, name, desc):
        self.name = name
        self.description = desc


@app.route('/', methods=['GET'])
def home():

    return"<h1>Hello world"


@app.route('/allemployees', methods=['GET'])
def employees():
    # employee = Employee.query.all()
    all = Employee.query.all()
    names = []
    for p in all:
        names.append(Employee.as_dict(p))
    return str(names)


if __name__ == '__main__':

    db.create_all()
    # e = Employee("Hans1", "hansa@mail.dk")
    # p = Project("Clean")
    # e.project.append(p)
    # db.session.add(e)
    # e = Employee("Mogens", "Mogens@mmogmaill.dk")
    # d = Department("HR", "1st floor")
    # e.departments.append(d)
    # db.session.add(e)

    # db.session.commit()


#
# d=Deparment

# db.session.add(e)
# db.session.commit()

app.run()
