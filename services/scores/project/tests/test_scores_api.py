import json

from project.tests.base import BaseTestCase


class TestScoresService(BaseTestCase):

    def test_ping(self):
        """Ensure the /ping route behaves correctly."""
        response = self.client.get('/scores/ping')
        data = json.loads(response.data.decode())
        self.assertEqual(response.status_code, 200)
        self.assertIn('pong!', data['message'])
        self.assertIn('success', data['status'])
