import json

from project.tests.base import BaseTestCase
from project.tests.utils import add_score


class TestScoresService(BaseTestCase):

    def test_get_all_scores(self):
        """Ensure get all scores behaves correctly."""
        add_score(1, 1, True)
        add_score(2, 1, False)

        with self.client:
            response = self.client.get('/scores')
            data = json.loads(response.data.decode())

            self.assertEqual(response.status_code, 200)
            self.assertIn('success', data['status'])

            self.assertEqual(len(data['data']['scores']), 2)

            self.assertEqual(1, data['data']['scores'][0]['user_id'])
            self.assertEqual(1, data['data']['scores'][0]['exercise_id'])
            self.assertEqual(True, data['data']['scores'][0]['correct'])

            self.assertEqual(2, data['data']['scores'][1]['user_id'])
            self.assertEqual(1, data['data']['scores'][1]['exercise_id'])
            self.assertEqual(False, data['data']['scores'][1]['correct'])

    def test_get_all_scores_by_user(self):
        """Ensure get all scores by user behaves correctly."""
        add_score(1, 1, True)
        add_score(2, 1, True)
        add_score(2, 2, True)
        add_score(2, 3, False)

        with self.client:
            response = self.client.get(
                '/scores/user',
                query_string={'user_id': 2},
                headers=({'Authorization': 'Bearer test'})
            )

            data = json.loads(response.data.decode())

            self.assertEqual(response.status_code, 200)
            self.assertIn('success', data['status'])

            self.assertEqual(len(data['data']['scores']), 3)

            self.assertEqual(1, data['data']['scores'][0]['exercise_id'])
            self.assertEqual(True, data['data']['scores'][0]['correct'])

            self.assertEqual(2, data['data']['scores'][1]['exercise_id'])
            self.assertEqual(True, data['data']['scores'][1]['correct'])

            self.assertEqual(3, data['data']['scores'][2]['exercise_id'])
            self.assertEqual(False, data['data']['scores'][2]['correct'])

    def test_get_single_score_of_user(self):
        """Ensure get single score by user behaves correctly."""
        add_score(1, 1, True)
        add_score(2, 1, True)
        add_score(2, 2, True)
        add_score(2, 3, False)

        with self.client:
            response = self.client.get(
                '/scores/user/2',
                query_string={'user_id': 2},
                headers=({'Authorization': 'Bearer test'})
            )

            data = json.loads(response.data.decode())

            self.assertEqual(response.status_code, 200)
            self.assertIn('success', data['status'])

            self.assertEqual(2, data['data']['user_id'])
            self.assertEqual(2, data['data']['exercise_id'])
            self.assertEqual(True, data['data']['correct'])

    def test_ping(self):
        """Ensure the /ping route behaves correctly."""
        response = self.client.get('/scores/ping')
        data = json.loads(response.data.decode())
        self.assertEqual(response.status_code, 200)
        self.assertIn('pong!', data['message'])
        self.assertIn('success', data['status'])
