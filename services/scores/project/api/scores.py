from flask import Blueprint, jsonify
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


@scores_blueprint.route('/scores/ping', methods=['GET'])
def ping_pong():
    return jsonify({
        'status': 'success',
        'message': 'pong!'
    })
