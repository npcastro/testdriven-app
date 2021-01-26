import json
import unittest

from project.tests.base import BaseTestCase
from project.tests.utils import add_exercise


class TestExercisesService(BaseTestCase):
    def test_all_exercises(self):
        """Ensure get all exercises behaves correctly."""
        add_exercise('Define a function called sum', 'sum(2, 2)', '4')
        add_exercise('Just a sample', 'print("Hello, World!")', 'Hello, World!')

        with self.client:
            response = self.client.get('/exercises')
            data = json.loads(response.data.decode())

            self.assertEqual(response.status_code, 200)
            self.assertIn('success', data['status'])

            self.assertEqual(len(data['data']['exercises']), 2)

            self.assertIn('Define a function called sum', data['data']['exercises'][0]['body'])
            self.assertEqual('sum(2, 2)', data['data']['exercises'][0]['test_code'])
            self.assertEqual('4', data['data']['exercises'][0]['test_code_solution'])

            self.assertEqual('Just a sample', data['data']['exercises'][1]['body'])
            self.assertEqual('print("Hello, World!")', data['data']['exercises'][1]['test_code'])
            self.assertEqual('Hello, World!', data['data']['exercises'][1]['test_code_solution'])


if __name__ == '__main__':
    unittest.main()
