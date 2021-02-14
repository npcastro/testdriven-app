from flask import Blueprint, jsonify, request
from flask_restful import Resource, Api

from project.api.models import Score


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

    def get(self):
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


@scores_blueprint.route('/scores/ping', methods=['GET'])
def ping_pong():
    return jsonify({
        'status': 'success',
        'message': 'pong!'
    })
