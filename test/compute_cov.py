import sys
import os
from datetime import datetime

model = ''
algorithm = '' 
optimization = []
phi_str = []
controlpoints = ''
input_name = []
input_range = []
parameters = []
timespan = ''
loadfile = ''

bound = []
base = []

status = 0
arg = ''
linenum = 0

algopath = ''
trials = ''
timeout = ''
max_sim = ''

argument = []
directory = ''
addpath = []

conf_file = sys.argv[1]
#script_file = sys.argv[2]
script_file = 'benchmark/'
#matlab_path = sys.argv[3]
matlab_path = 'matlab'

sys_time = datetime.now().strftime("%Y%m%d%H%M%S")

with open(conf_file,'r') as conf:
	for line in conf.readlines():
		argu = line.strip().split()
		if status == 0:
			status = 1
			arg = argu[0]
			linenum = int(argu[1])
		elif status == 1:
			linenum = linenum - 1
			if arg == 'model':
				model = argu[0]

			elif arg == 'optimization':
				optimization.append(argu[0])
			elif arg == 'phi':
				complete_phi = argu[0]+';'+argu[1]
				for a in argu[2:]:
					complete_phi = complete_phi + ' '+ a
				phi_str.append(complete_phi)
			elif arg == 'controlpoints':
			#	controlpoints.append(int(argu[0]))
				controlpoints = argu[0]
			elif arg == 'input_name':
				input_name.append(argu[0])
			elif arg == 'input_range':
				input_range.append([float(argu[0]),float(argu[1])])
			elif arg == 'parameters':
				parameters.append(argu[0])	
			elif arg == 'timespan':
				timespan = argu[0]
			elif arg == 'trials':
				trials = argu[0]
			elif arg == 'timeout':
				timeout = argu[0]
			elif arg == 'max_sim':
				max_sim  = argu[0]
			elif arg == 'addpath':
				addpath.append(argu[0])
			elif arg == 'loadfile':
				loadfile = argu[0]
			elif arg == 'arg':
				argument.append(argu[0])
			elif arg == 'bound':
				bound.append(argu[0])
			elif arg == 'path':
				directory = argu[0]
			elif arg == 'base':
				base.append(argu[0])
			else:
				continue
			if linenum == 0:
				status = 0


#for ph in phi_str:
	#for cp in controlpoints:
        #for opt in optimization:
		#property = ph.split(';')
covfilename = 'cov/' + model+ sys_time

def listdir(path):
	L = []
	for file in os.listdir(path):
		if os.path.splitext(file)[1] == '.mat':
			L.append(file)
	return L


list_name = listdir(directory)

with open(covfilename,'w') as bm:
	bm.write('#!/bin/sh\n')
	bm.write(matlab_path + ' -nodesktop -nosplash <<EOF\n')
	
	
	bm.write('addpath(genpath(\'' + '.' + '\'));\n')

	bm.write('controlpoints = ' + controlpoints + ';\n')

	bm.write('input_range = [['+ str(input_range[0][0])+' '+str(input_range[0][1])+']')
	for ir in input_range[1:]:
		bm.write(';[')
		bm.write(str(ir[0])+' '+str(ir[1]))
		bm.write(']')
	bm.write('];\n')
    

	bm.write('min_rob = [];\n')
	bm.write('coverage = [];\n')
	bm.write('time_cov =[];\n')
	bm.write('filename_pre = [];\n')
	bm.write('arg = [];\n')
	bm.write('bound = [];\n')
	bm.write('range_t = get_full_range(input_range, controlpoints);\n')
	bm.write('\n')

	for ln in list_name[0:]:
		for bnd in bound[0:]:
			for ag in base[0:]:
				bm.write('tic\n')
				bm.write('ct = CoverageTester(range_t, '+ ag + ',\''+ directory+ '/' + ln +'\',' + bnd+  ');\n')
				bm.write('time = toc;\n')
				ln_p = ln[0:ln.rfind('_')]
				bm.write('filename_pre = [filename_pre;\"'+ ln_p +'\"];\n')
				bm.write('arg = [arg;'+ ag +'];\n')
				bm.write('bound = [bound;'+ bnd +'];\n')
				bm.write('min_rob = [min_rob;ct.min_rob];\n')
				bm.write('coverage = [coverage;ct.coverage];\n')
				bm.write('time_cov = [time_cov;time];\n')
				bm.write('\n')
	
	bm.write('filename_precell = cellstr(filename_pre);\n')
	bm.write('result = table(filename_precell, arg, bound, min_rob, coverage, time_cov);\n')
	bm.write('writetable(result, \'results/'+ model + sys_time + '.csv\', \'Delimiter\',\';\')\n')
	bm.write('quit\n')
	bm.write('EOF\n')
