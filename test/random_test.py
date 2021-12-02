import sys

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

status = 0
arg = ''
linenum = 0

algopath = ''
trials = ''
timeout = ''
max_sim = ''

argument = ''
addpath = []

conf_file = sys.argv[1]
#script_file = sys.argv[2]
script_file = 'benchmark/'
#matlab_path = sys.argv[3]
matlab_path = 'matlab'

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
				argument = argu[0]
			else:
				continue
			if linenum == 0:
				status = 0


for ph in phi_str:
	for cp in controlpoints:
        #for opt in optimization:
		property = ph.split(';')
		filename = model+ '_random_' + property[0]+'_' + str(cp) + '_' + timeout
		param = '\n'.join(parameters)
		with open(script_file + filename,'w') as bm:
			bm.write('#!/bin/sh\n')
			bm.write('csv=$1\n')
			bm.write(matlab_path + ' -nodesktop -nosplash <<EOF\n')
			bm.write('clear;\n')
		
			bm.write('brpath_i = which(\'InitBreach\');\n')
			bm.write('while ~isempty(brpath_i)\n')
			bm.write('\tbrpath = replace(brpath_i, \'InitBreach.m\',\'\');\n')
			bm.write('\trmpath(brpath);\n')
			bm.write('\tbrpath_i = which(\'InitBreach\');\n')
			bm.write('end\n')
			bm.write('addpath(genpath(\'' + '.' + '\'));\n')
			for ap in addpath:
				bm.write('addpath(genpath(\'' + ap + '\'));\n')
			if loadfile!= '':
				bm.write('load ' + loadfile + '\n')
			bm.write('InitBreach;\n\n')
			bm.write(param + '\n')
			bm.write('mdl = \''+ model + '\';\n')
			bm.write('Br = BreachSimulinkSystem(mdl);\n')
			bm.write('br = Br.copy();\n')
            #bm.write('Br.Sys.tspan ='+ timespan +';\n')
            #bm.write('input_gen.type = \'UniStep\';\n')
            #bm.write('input_gen.cp = '+ str(cp) + ';\n')
            #bm.write('Br.SetInputGen(input_gen);\n')
            #bm.write('for cpi = 0:input_gen.cp -1\n')
            #for i in range(len(input_name)):
            #    bm.write('\t' + input_name[i] + '_sig = strcat(\''+input_name[i]+'_u\',num2str(cpi));\n')
            #    bm.write('\tBr.SetParamRanges({'+input_name[i] + '_sig},[' +str(input_range[i][0])+' '+str(input_range[i][1]) + ']);\n')
        
        #bm.write('end\n')
			bm.write('spec = \''+ property[1]+'\';\n')
			bm.write('phi = STL_Formula(\'phi\',spec);\n')
			bm.write('tspan = ' + timespan + ';\n')
			bm.write('controlpoints = ' + controlpoints + ';\n')

			bm.write('input_name = {\''+input_name[0]+'\'')
			for inm in input_name[1:]:
				bm.write(',\'')
				bm.write(inm)
				bm.write('\'')
			bm.write('};\n')
			bm.write('input_range = [['+ str(input_range[0][0])+' '+str(input_range[0][1])+']')
			for ir in input_range[1:]:
				bm.write(';[')
				bm.write(str(ir[0])+' '+str(ir[1]))
				bm.write(']')
			bm.write('];\n')
    
			bm.write('trials = ' + trials + ';\n')
			bm.write('filename = \''+filename+'\';\n')
			bm.write('specID = \'' + property[0] + '\';\n')
			bm.write('algorithm = \'random\';\n')
            #bm.write('falsified = [];\n')
            #bm.write('time = [];\n')
			bm.write('budget = ' + timeout + ';\n')

#			bm.write('arg = ' + argument + ';\n')

			bm.write('min_rob = [];\n')
			bm.write('coverage = [];\n')
			bm.write('time_cov =[];\n')

    
			bm.write('for n = 1:trials\n')
            #bm.write('\tfalsif_pb = FalsificationProblem(Br,phi);\n')
            #if timeout!='':
            #    bm.write('\tfalsif_pb.max_time = '+ timeout + ';\n')
            #if max_sim!='':
            #    bm.write('\tfalsif_pb.max_obj_eval = ' + max_sim + ';\n')
            #bm.write('\tfalsif_pb.setup_solver(\''+ opt  +'\');\n')
            #bm.write('\tfalsif_pb.solve();\n')
            #bm.write('\tif falsif_pb.obj_best < 0\n')
            #bm.write('\t\tfalsified = [falsified;1];\n')
            #bm.write('\telse\n')
            #bm.write('\t\tfalsified = [falsified;0];\n')
            #bm.write('\tend\n')
            #bm.write('\tnum_sim = [num_sim;falsif_pb.nb_obj_eval];\n')
            #bm.write('\ttime = [time;falsif_pb.time_spent];\n')
            #bm.write('\tobj_best = [obj_best;falsif_pb.obj_best];\n')
			bm.write('\tlogname = strcat(\'test/log/' + filename + '_\', int2str(n));\n')

			bm.write('\tlog = randomSample(br, budget, phi, controlpoints, tspan, input_name, input_range);\n')
#			bm.write('\ttic')
#			bm.write('\trange_t = get_full_range(input_range, controlpoints);\n')
#			bm.write('\tct = CoverageTester(range_t, arg, log);\n')
#			bm.write('\ttime = toc;\n')
#			bm.write('\tmin_rob = [min_rob; ct.min_rob];\n')
#			bm.write('\tcoverage = [coverage; ct.coverage];\n')
#			bm.write('\ttime_cov = [time_cov; time];\n')
			bm.write('\tsave(logname, \'log\');\n')
			bm.write('end\n')

#			bm.write('spec = {spec')
#			n_trials = int(trials)
#			for j in range(1,n_trials):
#				bm.write(';spec')
#			bm.write('};\n')
#
#			bm.write('filename = {filename')
#			for j in range(1,n_trials):
#				bm.write(';filename')
#			bm.write('};\n')


#			bm.write('specID = {specID')
#			for j in range(1,n_trials):
#				bm.write(';specID')
#			bm.write('};\n')
#			bm.write('num_sim = budget*ones(trials,1);\n')
#
#			bm.write('result = table(filename, specID, spec, num_sim, min_rob, coverage, time_cov);\n')
#            
#			bm.write('writetable(result,\'$csv\',\'Delimiter\',\';\')\n')
#				bm.write('type \'$csv\'\n')
			bm.write('quit\n')
#			bm.write('save_system(mdl+\'_breach\',false);\n')
			bm.write('EOF\n')
