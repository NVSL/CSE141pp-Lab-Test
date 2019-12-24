# Students should not edit this file, since changes here will _only_
# affect how your code runs locally.  It will not change how your code
# executes in the cloud.
from ArchLab.Runner import LabSpec
import functools
import unittest
import subprocess
import parameterized
from gradescope_utils.autograder_utils.decorators import weight, leaderboard, partial_credit
from ArchLab.CSE141Lab import CSE141Lab, test_configs, test_flags
import logging as log
import json

class ThisLab(CSE141Lab):

    def __init__(self, **kwargs):
        super(ThisLab, self).__init__(
            lab_name = "A test lab",
            short_name = "test-lab",
            input_files = ['*.inp', 'config.env', 'png.in', 'code.cpp', 'opt_cnn.hpp'],
            output_files = ['*.out', '*.cp', 'code-stats.csv','*.gprof', 'regression.out', 'out.png', 'regression.json'],
            default_cmd = ['make'],
            clean_cmd = ['make', 'clean'],
            repo = kwargs.get("repo") or "https://github.com/NVSL/CSE141pp-Lab-Test.git",
            reference_tag = kwargs.get("reference_tag") or "master",
            timeout = 20,
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

    class MetaRegressions(CSE141Lab.MetaRegressions):
        @parameterized.parameterized.expand(test_configs("solution", "."))
        def test_solution(self, solution, flags):
            result, tag = self.run_solution(solution, flags)
            js = result.results
            log.debug(json.dumps(js, indent=4))
            if solution == ".":
                if flags.grades_valid():
                    self.assertEqual(float(js['gradescope_test_output']['score']), 1)
            elif solution == "solution":
                if flags.grades_valid():                
                    self.assertEqual(float(js['gradescope_test_output']['score']), 2)
                
