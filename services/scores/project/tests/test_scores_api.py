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
        add_score(33, 1, True)
        add_score(33, 2, True)
        add_score(33, 3, False)

        with self.client:
            response = self.client.get(
                '/scores/user',
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
        add_score(33, 1, True)
        add_score(33, 2, True)
        add_score(33, 3, False)

        with self.client:
            response = self.client.get(
                '/scores/user/3',
                headers=({'Authorization': 'Bearer test'})
            )

            data = json.loads(response.data.decode())

            self.assertEqual(response.status_code, 200)
            self.assertIn('success', data['status'])

            self.assertEqual(33, data['data']['user_id'])
            self.assertEqual(3, data['data']['exercise_id'])
            self.assertEqual(False, data['data']['correct'])

    def test_add_score(self):
        with self.client:
            response = self.client.post(
                '/scores',
                data=json.dumps({
                    'exercise_id': 4,
                    'correct': True,
                }),
                content_type='application/json',
                headers=({'Authorization': 'Bearer test'})
            )
            data = json.loads(response.data.decode())
            self.assertEqual(response.status_code, 201)
            self.assertEqual('New score was added!', data['message'])
            self.assertIn('success', data['status'])

    def test_put_score_first_time(self):
        with self.client:
            response = self.client.put(
                '/scores/3',
                data=json.dumps({
                    'correct': True,
                }),
                content_type='application/json',
                headers=({'Authorization': 'Bearer test'})
            )
            data = json.loads(response.data.decode())
            self.assertEqual(response.status_code, 201)
            self.assertEqual('New score was added!', data['message'])
            self.assertIn('success', data['status'])

    def test_update_score(self):
        add_score(1, 1, True)
        add_score(33, 1, True)
        add_score(33, 2, True)
        add_score(33, 3, False)

        with self.client:
            response = self.client.put(
                '/scores/3',
                data=json.dumps({
                    'correct': True,
                }),
                content_type='application/json',
                headers=({'Authorization': 'Bearer test'})
            )
            data = json.loads(response.data.decode())
            self.assertEqual(response.status_code, 200)
            self.assertEqual('Score updated', data['message'])
            self.assertIn('success', data['status'])

    def test_ping(self):
        """Ensure the /ping route behaves correctly."""
        response = self.client.get('/scores/ping')
        data = json.loads(response.data.decode())
        self.assertEqual(response.status_code, 200)
        self.assertIn('pong!', data['message'])
        self.assertIn('success', data['status'])
