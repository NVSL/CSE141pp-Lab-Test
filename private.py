from gradescope_utils.autograder_utils.decorators import weight, leaderboard, partial_credit
import logging as log
from ArchLab.CSE141Lab import load_public_lab
PublicLab = load_public_lab(__file__)

class ThisLab(PublicLab):

    # These are tests for the student's code.  Gradescope will run
    # them and score the lab accordingly.
    class GradedRegressions(PublicLab.GradedRegressions):
        def setUp(self):
            PublicLab.GradedRegressions.setUp(self)
            self.lab_spec = ThisLab.load(".")

        @weight(1)
        def test_0_answer(self):
            self.assertEqual(self.read_text_file('answer.out',root=".").strip(), "correct answer")

        @leaderboard("winningest")
        def test_98_leaderboard(self, set_leaderboard_value=None):
            with open("code-stats.csv") as f:
                c = f.read()
                log.debug(self.lab_spec.csv_extract_by_line(c, 'magic'))
                set_leaderboard_value(self.lab_spec.csv_extract_by_line(c, 'magic'))
