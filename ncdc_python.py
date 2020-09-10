
import os
import sys
import subprocess
import time
import itertools
import random
import string
import copy
import math

DEBUG = True



def measure_grid_size(gridfinder, instancefile):
    command = "./clingo " + gridfinder + " " + instancefile + " --stats=2  --warn none "
    p = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
    (output, err) = p.communicate()
    p.wait()
    aspoutput = str(output)
    hsize_ind1 = aspoutput.find("hsize(")
    hsize_ind2 = aspoutput.find(")", hsize_ind1+4)
    hsizef = aspoutput[(hsize_ind1+6):hsize_ind2]
    grid_x = int(hsizef)

    vsize_ind1 = aspoutput.find("vsize(")
    vsize_ind2 = aspoutput.find(")", vsize_ind1+4)
    vsizef = aspoutput[(vsize_ind1+6):vsize_ind2]
    grid_y = int(vsizef)

    return grid_x, grid_y





def extract_times(aspout):

    actual_time_ind = aspout.find("Time     ")
    actual_end_ind = aspout.find("s", actual_time_ind+1)
    atime_text_all = aspout[(actual_time_ind+15):actual_end_ind]
    actual_time_float = float(atime_text_all)
    total_time = float(format(actual_time_float, '.2f'))

    solving_ind = aspout.find("Solving:", actual_time_ind+4)
    send_ind = aspout.find("s", solving_ind+7)
    solving_text_all = aspout[(solving_ind+9):send_ind]
    solving_float = float(solving_text_all)
    solving_time = float(format(solving_float, '.2f'))

    time_ind = aspout.find("CPU Time")
    end_ind = aspout.find("s", time_ind+1)
    time_text_all = aspout[(time_ind+15):end_ind]
    time_float = float(time_text_all)
    cpu_time = float(format(time_float, '.2f'))

    ground_time = total_time - solving_time

    return total_time, cpu_time, solving_time, ground_time




def find_program(aspout):

    atoms_ind_sat = aspout.find("Atoms")
    atoms_text_sat = aspout[(atoms_ind_sat+14):(atoms_ind_sat+23)]
    atoms_count_sat = int(atoms_text_sat)
    rules_ind_sat = aspout.find("Rules")
    rules_text_sat = aspout[(rules_ind_sat+14):(rules_ind_sat+23)]
    rules_count_sat = int(rules_text_sat)
    vars_ind_sat = aspout.find("Variables")
    vars_text_sat = aspout[(vars_ind_sat+14):(vars_ind_sat+23)]
    vars_count_sat = int(vars_text_sat)
    const_ind_sat = aspout.find("Constraints")
    const_text_sat = aspout[(const_ind_sat+14):(const_ind_sat+23)]
    const_count_sat = int(const_text_sat)

    return atoms_count_sat, rules_count_sat, vars_count_sat, const_count_sat



def find_disjuncts(relstr, openbr, closebr, separator):
    disjuncts = []
    num_disjuncts = 0
    ind_obr = relstr.find(openbr)
    ind_cbr = relstr.find(closebr,ind_obr+1)
    if (ind_obr < 0) or (ind_cbr < 0):
        iserrorx = 8
    else:
        str1 = relstr[(ind_obr+1):ind_cbr]
        str2 = str1.replace(" ","")
        alldisjunct = str2.split(separator)
        num_disjuncts = len(alldisjunct)
        for adisjunc in alldisjunct:
            rels = adisjunc.split(":")
            disjuncts.append(rels)

    return disjuncts, num_disjuncts



    
def writefile(relmat, linemat, subfolder, nobj, nrow):
    fnamex = os.path.join(subfolder,inst_file)
    fptr = open(fnamex, "w")
    fptr.write(" \n")
    fptr.write(tiletext)
    fptr.write(" \n")
    fptr.write("region(1.." + str(nobj) + ").")
    fptr.write(" \n")
    fptr.write(" \n")
    to_infer = []
    known_rel = []

    mind = 2
    while mind < nrow:
        reltype = relmat[mind][0]
        trgobj = relmat[mind][1]
        refobj = relmat[mind][-1]

        if (reltype == "basic"):   
            arel = (relmat[mind][2]).split(":")                
            for atile in arel:
                fptr.write("relation(" + str(trgobj) + "," + str(refobj) + "," + str(atile) + ").  ")
            fptr.write("\n")
            known_rel.append([str(trgobj), str(refobj)])
        elif (reltype == "disj"):      # disjunctive
            known_rel.append([str(trgobj), str(refobj)])
            alldisjuncts, numdsj = find_disjuncts(linemat[mind], "{", "}", ",")
            disjind = 1
            for arel in alldisjuncts:
                for atile in arel:
                    fptr.write("disjrelation(" + str(trgobj) + "," + str(refobj) + "," + str(disjind) + "," + str(atile) + ").  ")
                fptr.write("\n")
                disjind = disjind + 1
        elif (reltype == "default"):      # default
            arel = (relmat[mind][2]).split(":")   
            for atile in arel:
                fptr.write("defaultrelation(" + str(trgobj) + "," + str(refobj) + "," + str(atile) + ").  ")
            fptr.write("\n")
        elif (reltype == "disjdefault"):      # disjunctive default
            alldisjuncts, numdsj = find_disjuncts(linemat[mind], "{", "}", ",")
            disjind = 1
            for arel in alldisjuncts:
                for atile in arel:
                    fptr.write("disjdefaultrelation(" + str(trgobj) + "," + str(refobj) + "," + str(disjind) + "," + str(atile) + ").  ")
                fptr.write("\n")
                disjind = disjind + 1

        mind = mind + 1
       
    fptr.close()
    outcome = 1
    return known_rel




tiletext = "alltiles(sw).  alltiles(s).  alltiles(se).  alltiles(w).  alltiles(o).  alltiles(e).  alltiles(nw).  alltiles(n).  alltiles(ne). \n "

alltiles = ["sw", "s", "se", "w", "o", "e", "nw", "n", "ne"]

allreltypes = ["basic", "disj", "default", "disjdefault"]

basic_solver = " improved_consistency.lp "
disjunc_solver = " disjunctive.lp "
default_solver = " default.lp "
infer_solver = " inference.lp "

grid_finder = " grid_theorem8.lp "
  
grid_file_name = "grid_enum.lp"
conn_solver = " improved_connected.lp "
network_file = "network.txt"
inst_file = "instance.lp"
 


print("\n--------- nCDC-ASP --------- \n")

# Read user input and place to a matrix

allmat = []
alllines = []
for line in open('network.txt','r').readlines():
    if len(line) > 1:
         allmat.append([str(i) for i in line.split()])
         alllines.append(str(line))

numrow = len(allmat)

# Find whether there is error in the format in the user input

iserror = []
if (not ((allmat[0][0]).isdigit())) or (len(allmat[0]) > 1):
    iserror.append(1)
if (allmat[1][0] not in ["0","1"]) or (len(allmat[1]) > 1):
    iserror.append(2)

mind = 2
while mind < numrow:
    if (len(allmat[mind]) >= 3):
         if (allmat[mind][0] not in allreltypes):
             iserror.append(3)
         if (len(allmat[mind]) < 4):
             iserror.append(4)
         if (not ((allmat[mind][1]).isdigit())) or (not ((allmat[mind][-1]).isdigit())):
             iserror.append(5)
         if (allmat[mind][0] == "basic") or (allmat[mind][0] == "default"):
             rels = (allmat[mind][2]).split(":")   
             if len(rels) < 1:
                 iserror.append(6)
             for atile in rels:
                 if atile not in alltiles:
                     iserror.append(7)

         if (allmat[mind][0] == "disj") or (allmat[mind][0] == "disjdefault"):
             alldisjuncts, numdisj = find_disjuncts(alllines[mind], "{", "}", ",")
             if numdisj < 1:
                 iserror.append(8)
             elif (numdisj < 2) and (alldisjuncts[0] == [""]):
                 iserror.append(8)
             else:
                 for adisj in alldisjuncts:
                     for atile in adisj:
                         if atile not in alltiles:
                             iserror.append(7)

    else:
         iserror.append(4)
    mind = mind + 1



if len(iserror) > 0:
    print("  ERROR: Input File not in Correct Format: \n")
    if 1 in iserror:
        print("  Number of objects not properly entered. \n")
    if 2 in iserror:
        print("  Domain is not properly entered, must be only 0 or 1. \n")
    if 3 in iserror:
        print("  Type of relation is not valid. \n")
    if 4 in iserror:
        print("  One item is missing in a constraint. \n")
    if 5 in iserror:
        print("  Object identifier is not numeric. \n")
    if 6 in iserror:
        print("  No tile is entered in a constraint. \n")
    if 7 in iserror:
        print("  Tile of a CDC constraint is not recognized. \n")
    if 8 in iserror:
        print("  Disjunctive constraint is not properly entered or no disjunct is specified. \n")

    sys.exit(1)


# Convert user-defined input into ASP representation of nCDC network
# and write to instance.lp file

numobj = int(allmat[0][0])
is_conn = int(allmat[1][0])

reltypes = []
nind = 2
while nind < numrow:
    if len(allmat[nind]) > 1:
         reltypes.append(allmat[nind][0])
    nind = nind + 1

knownrel = writefile(allmat, alllines, "", numobj, numrow)

# Find the missing relations in the input network

toinfer = []
tobj = 1
while tobj <= numobj:
     robj = 1
     while robj <= numobj:
         if ([str(tobj), str(robj)] not in knownrel) and (tobj != robj):
             toinfer.append([str(tobj), str(robj)])
         robj += 1
     tobj += 1

arow = len(toinfer)


# Determine the ASP (sub)programs needed to solve this instance

connected_solver = " "
if (is_conn > 0):
    connected_solver = conn_solver
  

grid_solver = grid_finder

solver_name = basic_solver
if (arow > 0):
    solver_name = infer_solver

if ("disj" in reltypes):
    solver_name = solver_name + disjunc_solver
if ("default" in reltypes) or ("disjdefault" in reltypes):     #default
    solver_name = solver_name + default_solver



# Solve the Instance

gridx, gridy = measure_grid_size(grid_solver, inst_file)
htext = "hsize(" + str(gridx) + "). \n"
vtext = "vsize(" + str(gridy) + "). \n"
gridfile = open(grid_file_name, "w")
gridfile.write("\n")
gridfile.write(htext)
gridfile.write(vtext)
gridfile.close()

acommand = "./clingo " + grid_file_name + " " + solver_name + connected_solver + inst_file + " --stats=2  --warn none "

start = time.time()
p = subprocess.Popen(acommand, stdout=subprocess.PIPE, shell=True)
(output, err) = p.communicate()
p.wait()
outputx = str(output)
wtime = time.time() - start

ttime, ctime, stime, gtime = extract_times(outputx)
atomc, rulec, varc, constrc = find_program(outputx)


# Print outcome and statistics about the problem instance

unsatindex = outputx.find("UNSATISFIABLE")
if (unsatindex >= 0):
    is_sat = 0
    print(" INCONSISTENT NETWORK \n")
else:
    is_sat = 1
    print(" CONSISTENT NETWORK \n")
  
print(" CPU Time: ", str(ttime))
print(" Grounding Time: ", str(gtime))
print("\n")
print(" Grid: ", str(gridx), "x", str(gridy))
print("\n")
print(" Atoms: ", str(atomc))
print(" Rules: ", str(rulec))
print(" Variables: ", str(varc))
print(" Constraints: ", str(constrc), "\n")

# Print inferred nCDC relations:

if (arow > 0) and (is_sat > 0):
     print("\n INFERRED MISSING nCDC RELATIONS: \n")
     startind = outputx.rfind("Answer: ")
     for atupl in toinfer:
          trgobj = atupl[0]
          refobj = atupl[1]
          atiletext = " Between Objects " + str(trgobj) + " and " + str(refobj) + ":  "
          skey = "inferrel(" + str(trgobj) + "," + str(refobj) + ","
          indx = outputx.find(skey,startind)
          while (indx >= 0):
              indp = outputx.find(")",indx+len(skey)-1)
              atiletext = atiletext + outputx[indx+len(skey):indp] + ":"
              indx = outputx.find(skey,indp)
          print(atiletext[0:-1])    # dont print the last ":"


# Print locations of objects based on ASP output

if (is_sat > 0):
     print("\n\n OBJECT LOCATIONS: \n")
     startind = outputx.rfind("Answer: ")
     aobj = 1
     while aobj <= numobj:
          atext = " Object " + str(aobj)  + ":  "
          skey = "occupy(" + str(aobj) + ","
          indx = outputx.find(skey,startind)
          while (indx >= 0):
              indp1 = outputx.find(",",indx+len(skey))
              indp2 = outputx.find(")",indp1)
              atext += "(" + outputx[indx+len(skey):indp1] + "," + outputx[(indp1+1):indp2] + "), "
              indx = outputx.find(skey,indp2)
          print(atext[0:-2])
          aobj += 1


# Print the actual clingo output

print("\n\n ASP OUTPUT: \n ");
indx = outputx.find("Solving...")
endp1 = outputx.find("SATISFIABLE",indx)
endp2 = outputx.find("OPTIMUM FOUND",indx)
endp3 = outputx.find("UNSATISFIABLE",indx)

if (endp2 > 0):
     print(outputx[indx+12:endp2+13])
elif (endp1 > 0):
     print(outputx[indx+12:endp1+11])

