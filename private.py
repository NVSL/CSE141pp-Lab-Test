from gradescope_utils.autograder_utils.decorators import weight, leaderboard, partial_credit
import logging as log
import os
import sys
from lab import ThisLab as PublicLab

class ThisLab(PublicLab):

    class GradedRegressions(PublicLab.GradedRegressions):

        # the numbers in the name are improtant.  They set the order
        # things run in.
        @weight(1)
        def test_0_regressions(self):
            self.go_run_tests("")

        @weight(1)
        def test_0_answer(self):
            self.assertEqual(self.read_file('answer.out',root=".").strip(), "correct answer")

        @leaderboard("winning")
        def test_98_leaderboard(self, set_leaderboard_value=None):
            set_leaderboard_value(self.csv_extract_by_line(result.files['code-stats.csv'], 'magic'))
            
