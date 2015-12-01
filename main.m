clc;clear;close all;
casedata='case30';
mpopt = mpoption('verbose',1);
[busBench, genBench, branchBench, success]=runBench(casedata,mpopt);
clearvars -except casedata busBench genBench branchBench

[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;

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
end
ids=real(i2e(extiV(:,1)));
extiV(:,1)=ids;
extiV=sortrows(extiV,1);
ids=sort(ids);
V=extiV(:,2);
Vm=abs(V);
Va=angle(V)/pi*180;

outdiff=[busBench(:,BUS_I)-ids,busBench(:,VM)-Vm,busBench(:,VA)-Va];

fprintf('Output difference\n');
fprintf('\n\tBus\t\tVm\t\tVa\n');
for k=1:size(V,1)
    fprintf('%5d%10.4f%10.4f\n',outdiff(k,1),outdiff(k,2),outdiff(k,3));
end