import sys
import unittest

import coverage
from flask.cli import FlaskGroup

from project import db, create_app
from project.api.models import Score


COV = coverage.coverage(
    branch=True,
    include='project/*',
    omit=[
        'project/tests/*',
        'project/config.py',
    ]
)
COV.start()

app = create_app()
cli = FlaskGroup(create_app=create_app)


@cli.command()
def test():
    """Runs the tests without code coverage"""
    tests = unittest.TestLoader().discover('project/tests', pattern='test*.py')
    result = unittest.TextTestRunner(verbosity=2).run(tests)
    if result.wasSuccessful():
        return 0
    sys.exit(result)


@cli.command()
def cov():
    """Runs the unit tests with coverage."""
    tests = unittest.TestLoader().discover('project/tests')
    result = unittest.TextTestRunner(verbosity=2).run(tests)
    if result.wasSuccessful():
        COV.stop()
        COV.save()
        print('Coverage Summary:')
        COV.report()
        COV.html_report()
        COV.erase()
        return 0
    sys.exit(result)


# @cli.command('recreate_db')
# def recreate_db():
#     db.drop_all()
#     db.create_all()
#     db.session.commit()


# @cli.command('seed_db')
# def seed_db():
#     db.session.add(
#         Score(user_id=1, exercise_id=1, correct=True)
#     )
#     db.session.commit()


if __name__ == '__main__':
    cli()
