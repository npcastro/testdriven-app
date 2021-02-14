from flask import Blueprint, jsonify, request
from flask_restful import Resource, Api

from project.api.models import Score
from project.api.utils import authenticate_restful


scores_blueprint = Blueprint('scores', __name__)
api = Api(scores_blueprint)


class ScoresList(Resource):

    def get(self):
        """Get all scores"""

        response_object = {
            'status': 'success',
            'data': {
                'scores': [score.to_json() for score in Score.query.all()]
            }
        }

        return response_object, 200


api.add_resource(ScoresList, '/scores')


class UserScores(Resource):
    method_decorators = {'get': [authenticate_restful]}

    def get(self, resp):
        """Get all scores of a single user"""
        url_params = request.args

        user_id = url_params.get('user_id')
        scores = Score.query.filter(Score.user_id == user_id)

        response_object = {
            'status': 'success',
            'data': {
                'scores': [score.to_json() for score in scores]
            }
        }

        return response_object, 200


api.add_resource(UserScores, '/scores/user')


class UserScore(Resource):
    method_decorators = {'get': [authenticate_restful]}

    def get(self, resp, exercise_id):
        """Get a score of a single user"""
        url_params = request.args

        user_id = url_params.get('user_id')
        score = Score.query.filter(Score.user_id == user_id, Score.exercise_id == exercise_id).first()

        response_object = {
            'status': 'success',
            'data': score.to_json()
        }

        return response_object, 200


api.add_resource(UserScore, '/scores/user/<exercise_id>')


@scores_blueprint.route('/scores/ping', methods=['GET'])
def ping_pong():
    return jsonify({
        'status': 'success',
        'message': 'pong!'
    })
