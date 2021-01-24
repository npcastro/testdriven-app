import unittest

from project.tests.base import BaseTestCase
from project.tests.utils import add_exercise


class TestExerciseModel(BaseTestCase):
    def test_add_exercise(self):
        exercise = add_exercise(
            'Define a function that returns the sum of two integers.',
            'sum(2, 2)',
            '4'
        )

        self.assertTrue(exercise.id)
        self.assertEqual(exercise.body, 'Define a function that returns the sum of two integers.')
        self.assertEqual(exercise.test_code, 'sum(2, 2)')
        self.assertEqual(exercise.test_code_solution, '4')


if __name__ == '__main__':
    unittest.main()
