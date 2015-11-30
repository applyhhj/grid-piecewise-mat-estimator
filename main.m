clc;clear;close all;

casedata='case300';

[baseMVA, bus, gen, branch] = loadcase(casedata);

% [i2e, bus, gen, branch]  = ext2int(bus, gen, branch);
% 
% [Ybusfull,Yffull,Ytfull]=makeYbus(baseMVA,bus,branch);

[zone_bus_map,zone_gen_map,zone_branch_map, ...
    zone_branch_connf_map,zone_branch_connt_map,...
    connbrf_bus_out_map,connbrt_bus_out_map]=piecewise(bus,gen,branch);

for k=1:size(keys(zone_bus_map),2)
    
    zones=keys(zone_bus_map);
    
    runestimate(baseMVA,zone_bus_map(zones(k)),zone_gen_map(zones(k)),...
        zone_branch_map(zones(k)),zone_branch_connf_map(zones(k)),...
        zone_branch_connt_map(zones(k)),connbrf_bus_out_map(zones(k)),...
        connbrt_bus_out_map(zones(k)));
    
end