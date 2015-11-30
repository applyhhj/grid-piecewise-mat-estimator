clc;clear;close all;
casedata='case300';
[baseMVA, bus, gen, branch, success,i2e] = solvePowerFlow(casedata);

[zone_bus_map,zone_gen_map,zone_branch_map, ...
    zone_branch_connf_map,zone_branch_connt_map,...
    connbrf_bus_out_map,connbrt_bus_out_map]=piecewise(bus,gen,branch);

extiV=[];
for k=1:size(keys(zone_bus_map),2)
    zones=keys(zone_bus_map);    
    zone=cell2mat(zones(k));
    
    [extiVtmp, converged]=runEstimate(baseMVA,zone_bus_map(zone),...
        zone_gen_map(zone),zone_branch_map(zone),...
        zone_branch_connf_map(zone),zone_branch_connt_map(zone),...
        connbrf_bus_out_map(zone),connbrt_bus_out_map(zone));
    
    extiV=[extiV;extiVtmp];
    extiV(:,1)=i2e(extiV(:,1));
end