# Students should not edit this file, since changes here will _only_
# affect how your code runs locally.  It will not change how your code
# executes in the cloud.
from Runner import LabSpec
import functools

class ThisLab(LabSpec):
    def __init__(self):
        super(ThisLab, self).__init__(
            lab_name = "A test lab",
            input_files = ['*.inp'],
            output_files = ['*.out'],
            default_cmd = ['make', 'default'],
            repo = "https://github.com/NVSL/CSE141pp-Lab-Characterizing-A-Perceptron.git",
            reference_tag = "314bfbd09ab3a28b446742234851eeef2c29dcba",
            time_limit = 50,
            valid_options = {
                "USER_CMD_LINE":"",
                "GPROF": "",
                "DEBUG": "",
                "C_OPTS": "",
                "COMPILER": ""
            }
        )
        
    def extract_figures_of_merit(self, result):
        r = []

        runtime=self.csv_column_values(result.files['code-stats.csv'], 'runtime')
        r.append(dict(name='execution_time', value=functools.reduce(lambda x,y:float(x)+float(y), runtime, 0)))
        energy=self.csv_column_values(result.files['code-stats.csv'], 'energy')
        r.append(dict(name='energy (J)', value=functools.reduce(lambda x,y:float(x)+float(y), energy, 0)/1e9))

        return r
