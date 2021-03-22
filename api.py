from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from flaskext.mysql import MySQL
import yaml
from flask_restful import Resource, Api, reqparse
from flask_cors import CORS
from sqlalchemy_serializer import SerializerMixin
from sqlalchemy.ext.declarative import DeclarativeMeta
import json
from flask_marshmallow import Marshmallow


# import pandas as pd
# import ast


app = Flask(__name__)
CORS(app)
ma = Marshmallow(app)
api = Api(app)


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


projects = db.Table('projects',
                    db.Column('project_id', db.Integer, db.ForeignKey(
                        'project.id'), primary_key=True),
                    db.Column('employee_id', db.Integer, db.ForeignKey('employee.id')), primary_key=True)


class Project(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)

    def __init__(self, name):
        self.name = name

        def as_dict(self):
            return {c.name: getattr(self, c.name) for c in self.__table__.columns}


class Employee(db.Model, SerializerMixin):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    project = db.relationship('Project', secondary=projects, lazy='subquery',
                              backref=db.backref('employees', lazy=True))
    departments = db.relationship('Department', backref='employee', lazy=False)

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

    def as_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}


"""class EmployeeData(ma.Schema):
    class Meta:
        field = ("id", "name", "email")
        model = Employee

    em_schema = EmployeeData()
    ems_schema = EmployeeData(many=True)


class Hello(Resource):
    def get(self):
        ems = Employee.query.all()
        return ems_schema.dump(ems)
"""

# api.add_resource(Hello, '/hello')


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
    return jsonify(names)


@app.route('/employee/<id>', methods=['GET'])
def employeeById(id):
    em = Employee.query.filter_by(id=id).first_or_404()
    print(em)
    return jsonify(Employee.as_dict(em))


@app.route('/department/<departmentname>', methods=['GET'])
def EmInDep(departmentname):
    all = Employee.query.join(Department).filter(
        Department.name == departmentname).all()
    em = ""
    for p in all:
        em = em + json.dumps(p)
    return em


@app.route('/department/alldep', methods=['GET'])
def allDep():
    all = Department.query.all()
    allemps = []
    for p in all:
        allemps.append(Department.as_dict(p))
    return jsonify(allemps)


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
