# Students should not edit this file, since changes here will _only_
# affect how your code runs locally.  It will not change how your code
# executes in the cloud.
from ArchLab.Runner import LabSpec
import functools
import unittest
import subprocess
import parameterized
from gradescope_utils.autograder_utils.decorators import weight, leaderboard, partial_credit
from ArchLab.CSE141Lab import CSE141Lab # The labs for the class have lots in common, so we have base class.
import logging as log
import json

class ThisLab(CSE141Lab):
    def __init__(self):
        super(ThisLab, self).__init__(
            lab_name = "A test lab",
            short_name = "test-lab",
            input_files = ['*.inp', 'config.env', 'png.in', 'code.cpp', 'opt_cnn.hpp'],
            output_files = ['*.out', '*.cp', 'code-stats.csv','*.gprof', 'regression.out', 'out.png', 'regression.json'],
            default_cmd = ['make'],
            clean_cmd = ['make', 'clean'],
            repo = "https://github.com/NVSL/CSE141pp-Lab-Test.git",
            reference_tag = "314bfbd09ab3a28b446742234851eeef2c29dcba",
            timeout = 10,
            valid_options = {
                "USER_CMD_LINE":"",
                "GPROF": "",
                "DEBUG": "",
                "C_OPTS": "",
                "COMPILER": "",
                "THE_ANSWER": "",
                "TEST_OPTION": "",
                "DEVEL_MODE": ""
            }
        )

    def filter_command(self, command):
        """
        This lets you filter the commands that are allowed to run.

        It should return a triple `good, error_msg, command`.  `not good` means
        the command should not be run for the reason given in `error_msg`.  If
        `good`, then return the (possibily modified) `command`.

        """

        # examples of generting a command that would not pass the filter.
        if command == ['special1']:
            return True, "", ["make", "1@.out"]
        if command == ['special2']:
            return True, "", ["make", "a=b"]

        # this is a helper that only allows simple calls to make.  Variables cannot be set.
        return self.make_target_filter(command)

    class GradedRegressions(CSE141Lab.GradedRegressions):

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
            
    class MetaRegressions(CSE141Lab.MetaRegressions):

        @parameterized.parameterized.expand([".", "solution"])
        def test_solution(self, solution):
            result = self.run_solution(solution)
            js = result.results
            log.debug(json.dumps(js, indent=4))
            if solution == ".":
                self.assertEqual(float(js['gradescope_test_output']['score']), 1)
            elif solution == "solution":
                self.assertEqual(float(js['gradescope_test_output']['score']), 2)



