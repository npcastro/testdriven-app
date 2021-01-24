from project import db
from project.api.models import Exercise


def add_exercise(body, test_code, test_code_solution):
    exercise = Exercise(
        body=body,
        test_code=test_code,
        test_code_solution=test_code_solution
    )
    db.session.add(exercise)
    db.session.commit()

    return exercise
