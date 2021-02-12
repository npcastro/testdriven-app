import unittest

from project import db
from project.api.models import Score
from project.tests.base import BaseTestCase


class TestScoreModel(BaseTestCase):
    def test_add_score(self):
        score = Score(user_id=1, exercise_id=1, correct=True)
        db.session.add(score)
        db.session.commit()


if __name__ == '__main__':
    unittest.main()
