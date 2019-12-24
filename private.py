from gradescope_utils.autograder_utils.decorators import weight, leaderboard, partial_credit
import logging as log
import os
import sys
from lab import ThisLab as PublicLab

class ThisLab(PublicLab):

    # These are tests for the student's code.  Gradescope will run
    # them and score the lab accordingly.
    class GradedRegressions(PublicLab.GradedRegressions):
        def setUp(self):
            CSE141Lab.GradedRegressions.setUp(self)
            self.lab_spec = ThisLab.load(".")


        @weight(3)
        def test_getting_this_far(self):
            self.assertTrue(True)

        @weight(3)
        def test_for_correct_output(self):
            with open("code.out") as f:
                contents = f.read()
            self.assertNotRegex(contents, 'Your Name', "I found 'Your Name' in your 'code.out'.  It shouldn't be there.")
            self.assertRegex(contents, 'hi', "I couldn't find text match 'hi,' in your output")

        @weight(1)
        def test_starter_output(self):
            c = self.read_file("outputs/starter-output.txt")
            self.assertRegex(c, "Hello, world!", "I couldn't find 'Hello, world!' in your 'outputs/starter-output.txt'")


