function [outdiff]=compareEst(casedata,mpopt)
[busBench, genBench, branchBench, success]=runBench(casedata,mpopt);
clearvars -except mpopt casedata busBench genBench branchBench

[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;

[baseMVA, bus, gen, branch, success,i2e] = solvePowerFlow(casedata,mpopt);
[zone_bus_map,zone_gen_map,zone_branch_map, ...
    zone_branch_connf_map,zone_branch_connt_map,...
    connbrf_bus_out_map,connbrt_bus_out_map]=piecewise(bus,gen,branch);

busPiec=[];
genPiec=[];
branchPiec=[];
convergedo=[];
for k=1:size(keys(zone_bus_map),2)
    zones=keys(zone_bus_map);
    zone=cell2mat(zones(k));
    
    [busi,geni,branchi, convergedi]=runEstimate(baseMVA,zone_bus_map(zone),...
        zone_gen_map(zone),zone_branch_map(zone),...
        zone_branch_connf_map(zone),zone_branch_connt_map(zone),...
        connbrf_bus_out_map(zone),connbrt_bus_out_map(zone),mpopt);
    
    busPiec=[busPiec;busi];
    genPiec=[genPiec;geni];
    branchPiec=[branchPiec;branchi];
    convergedo=[convergedo,convergedi];
end
[bus, gen, branch] = int2ext(i2e, bus, gen, branch);
[busPiec, genPiec, branchPiec] = int2ext(i2e, busPiec, genPiec, branchPiec);
busPiecSort=sortrows(busPiec,1:size(busPiec,2));
busBenchSort=sortrows(busBench,1:size(busBench,2));
genPiecSort=sortrows(genPiec,1:size(genPiec,2));
genBenchSort=sortrows(genBench,1:size(genBench,2));
% ids=real(i2e(extiV(:,1)));
% extiV(:,1)=ids;
% extiV=sortrows(extiV,1);
% ids=sort(ids);
% V=extiV(:,2);
% Vm=abs(V);
% Va=angle(V)/pi*180;
% outdiff=[busBench(:,BUS_I)-ids,busBench(:,VM)-Vm,busBench(:,VA)-Va];
% outdiff={bus-busPiec,gen-genPiec,branch-branchPiec};
outdiff={busBenchSort-busPiecSort,genBenchSort-genPiecSort};
end