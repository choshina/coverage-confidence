# A Robustness-based Confidence Measure for Hybrid System Falsification

## System requirement

- Operating system: Linux or MacOS;

- Matlab (Simulink/Stateflow) version: >= 2020a. (Matlab license needed)

- Python version: >= 3.3

## Installation

- Clone the repository.
  - `git clone https://github.com/choshina/coverage-confidence.git`

- Install [Breach](https://github.com/decyphir/breach). *(Optional)*
  1. `git submodule init` and `git submodule update`
  1. start matlab, set up a C/C++ compiler using the command `mex -setup`. (Refer to [here](https://www.mathworks.com/help/matlab/matlab_external/changing-default-compiler.html) for more details.)
  2. navigate to `breach/` in Matlab commandline, and run `InstallBreach`

## Usage

### Generate test suite *(Optional)*
- navigate to `test/`
- write a configuration file and put it in `config/`. 
- generate executable file by running `python [Alg]_test.py [config]`
- navigate to project home and run `make`. Wait for some time, and the test suites will be gnerated.

### Generate confidence

- you can manually put the test suites in `test/log/...`
- navigate to `test/`, and write a configuration file in `test/config/coverage/`.
- run `python compute_cov.py [config]`. An executable file will be generated in `test/cov/`.
  - Mind the matlab path in Line 36: `matlab_path = 'matlab'`  If you cannot use `matlab` in commandline, you should change the value of `matlab_path` to the matlab executable, which is usually found in `bin/` of matlab home.
- navigate to project home, and run `./test/cov/[exe]`. The results will be generated in `result/` as a csv file.

## Configuration File

### For test suite *(Optional)*
...
### For coverage computation
```
model 1                #model is a keyword, 1 indicates it takes 1 line
Autotrans_shift
input_range 2          #don't modify this because order matters.
0 325 
0 100 
controlpoints 1        
3
base 1                 #weight function parameter.You can test many: write them in the following multiple lines, and write how many lines in this line.
30
bound 5                #size of test suites. You can test many: similarly to "base"
400
800
1200
1600
2000
path 1                 #the directory where logs are. All the logs in this directory will be computed.
/Users/zhenya/git/coverage-confidence/test/log/AT1
```
