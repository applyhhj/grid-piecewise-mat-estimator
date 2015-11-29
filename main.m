clc;clear;close all;

casedata='case300';

[baseMVA, bus, gen, branch] = loadcase(casedata);

[zone_bus_map,zone_gen_map,zone_branch_map, ...
    zone_branch_conn_map]=piecewise(bus,gen,branch);

