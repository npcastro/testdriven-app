from flask import Blueprint
from flask_restful import Resource, Api

from project.api.models import Exercise


exercises_blueprint = Blueprint('exercises', __name__)
api = Api(exercises_blueprint)


class ExercisesList(Resource):
    def get(self):
        """Get all exercises"""
        response_object = {
            'status': 'success',
            'data': {
                'exercises': [exercise.to_json() for exercise in Exercise.query.all()]
            }
        }
        return response_object, 200


api.add_resource(ExercisesList, '/exercises')
