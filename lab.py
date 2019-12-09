# Students should not edit this file, since changes here will _only_
# affect how your code runs locally.  It will not change how your code
# executes in the cloud.
from ArchLab.Runner import LabSpec
import functools

class ThisLab(LabSpec):
    def __init__(self):
        super(ThisLab, self).__init__(
            lab_name = "A test lab",
            short_name = "test-lab",
            input_files = ['*.inp', 'config.env', 'png.in'],
            output_files = ['*.out', '*.cp', 'code-stats.csv','*.gprof', 'regression.out', 'out.png', 'regression.json'],
            default_cmd = ['make'],
            clean_cmd = ['make', 'clean'],
            config_file = 'config.env',
            repo = "https://github.com/NVSL/CSE141pp-Lab-Test.git",
            reference_tag = "314bfbd09ab3a28b446742234851eeef2c29dcba",
            time_limit = 50,
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

    def post_run(self, result):
        """
        This gets called after your job completes.  You can build json and attach it to the `result.results` dict.
        
        Be sure to handle errors that might occur here.  For instance, if you
        allow non-standard `make targets` you might not have the outputs you
        expect.

        """
        self.run_gradescope_tests(result, GradedRegressions)
        
        r = []
        try:
            r.append(dict(name='magic', value=self.csv_extract_by_line(result.files['code-stats.csv'], 'magic')))
            r.append(dict(name='test_field', value="BOB"))
        except:
            pass
        result.results['figures_of_merit'] = r
        return result

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

import unittest
import subprocess
from gradescope_utils.autograder_utils.decorators import weight
class GradedRegressions(unittest.TestCase):
    def go(self, label):
        try:
            subprocess.check_call(["./run_tests.exe", f"--gtest_filter=.*{label}.*"],timeout=1)
        except:
            self.assertTrue(False)
        
    @weight(1)
    def test_level_0(self):
        self.go("level_0")

    @weight(1)
    def test_level_1(self):
        self.go("level_1")

    @weight(1)
    def test_level_2(self):
        self.go("level_2")
        
    @weight(1)
    def test_level_3(self):
        self.go("level_3")

    @weight(1)
    def test_level_4(self):
        self.go("level_4")

