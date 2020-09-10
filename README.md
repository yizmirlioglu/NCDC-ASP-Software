
NCDC-ASP SOFTWARE:

NCDC-ASP is a framework developed by Izmirlioglu and Erdem (2018) for representing and reasoning about qualitative directional relations. NCDC-ASP uses Cardinal Directional Calculus (CDC) introduced by Skiadopulos and Koubarakis (2004,2005) to represent directional relations. This framework can solve consistency checking problems in nCDC, integrate commonsense knowledge into reasoning, handle incomplete or uncertain information, infer unknown relations between objects and find a suitable configuration of objects that fulfills the given inquiry.

Features of NCDC-ASP System:
- Reason with basic, disjunctive information
- Utilize commonsense knowledge by default CDC constraints
- Infer missing cardinal directions between objects
- Alternative domains: Connected (Reg) or possibly disconnected (Reg*)

This software uses ASP programs in the thesis for reasoning with nCDC. For deciding consistency and checking connectedness, the improved ASP formulation is utilized. Besides, the reduced grid size is used for computational efficiency.



REQUIREMENTS:

Python 3



USAGE:

Extract NCDC-ASP-Software.zip to a folder

Enter your nCDC constraint network into "network.txt" file according to below format

Open a Terminal from the folder
Run the command  "python3 ncdc_python.py"



FORMAT OF THE "network.lp" FILE:

[Number of Objects]

[Domain]

[Constraint Type] [Target Object] [CDC Relation] [Reference Object]

[Constraint Type] [Target Object] [CDC Relation] [Reference Object]

[Constraint Type] [Target Object] [CDC Relation] [Reference Object]
...
...


[Domain]
0   Disconnected

1   Connected

[Constraint Type]
"basic"            Basic CDC constraint

"disj"             Disjunctive CDC constraint

"default"          Default CDC constraint

"disjdefault"      Disjunctive Default CDC constraint


CDC relation must be written by separating each tile by ":" without any space between them. In case of single-tile relation, ":" is not used.  Tiles are written according to below encoding:

sw: southwest  s:south  se:southeast  w:west  o:on   e:east  nw:northwest  n:north  ne:northeast

In case of Disjunctive CDC constraint, Disjunctive Default CDC constraint or Disjunctive Positive Soft CDC constraint, disjuncts are written inside curly braces, separated by "," Some space can be left between disjuncts for readability but this is not necessary. See examples



EXAMPLES:

Look at the content of example1_connected.txt, example2_connected.txt, example3_disconnected.txt, example4_disconnected.txt files for an example network file
