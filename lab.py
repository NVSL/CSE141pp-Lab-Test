# Students should not edit this file, since changes here will _only_
# affect how your code runs locally.  It will not change how your code
# executes in the cloud.
from Runner import LabSpec
import functools

class ThisLab(LabSpec):
    def __init__(self):
        super(ThisLab, self).__init__(
            lab_name = "A test lab",
            input_files = ['*.inp', 'config.env'],
            output_files = ['*.out', '*.cp'],
            default_cmd = ['make'],
            clean_cmd = ['make', 'clean'],
            config_file = 'config.env',
            repo = "https://github.com/NVSL/CSE141pp-Lab-Characterizing-A-Perceptron.git",
            reference_tag = "314bfbd09ab3a28b446742234851eeef2c29dcba",
            time_limit = 50,
            valid_options = {
                "USER_CMD_LINE":"",
                "GPROF": "",
                "DEBUG": "",
                "C_OPTS": "",
                "COMPILER": "",
                "THE_ANSWER": "",
                "TEST_OPTION": ""
                
            }
        )
