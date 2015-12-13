function [outdiff,zoneBuses]=compareEst(casedata,mpopt)
global debug
% [busBench, genBench, branchBench, success]=runBench(casedata,mpopt);
% clearvars -except mpopt casedata busBench genBench branchBench

[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;

outdiff=[{0},{0},{0},{0}];
zoneBuses=[];

if debug==1
    [~, bus, ~, ~] = loadcase(casedata);
    if size(bus,1)>300
        return;
    end
end

[baseMVA, bus, gen, branch, success,i2e,Sbuslf] = solvePowerFlow(casedata,mpopt);

if ~success
    return;
end

% bus=reassignZone(bus);

[zone_bus_map,zone_gen_map,zone_branch_map, ...
    zone_branch_connf_map,zone_branch_connt_map,...
    connbrf_bus_out_map,connbrt_bus_out_map,zoneStruct]=piecewise(bus,gen,branch);

busPiec=[];
genPiec=[];
branchPiec=[];
brconnPiec=[];
convergedoPiec=[];

for k=1:size(zoneStruct,2)
    zoneBuses(k,:)=[zoneStruct(k).no,size(zoneStruct(k).bus,1)];
    [busi,geni,branchi,brconni, convergedi]=runEstimateStruct(baseMVA,zoneStruct(k),mpopt);    
    busPiec=[busPiec;busi];
    genPiec=[genPiec;geni];
    branchPiec=[branchPiec;branchi];
    brconnPiec=[brconnPiec;brconni];
    convergedoPiec=[convergedoPiec,convergedi];
end
% 
% zones=keys(zone_bus_map);
% for k=1:size(zones,2)
%     zone=cell2mat(zones(k));
%     zoneBuses(k,:)=[zone,size(zone_bus_map(zone),1)];
%     [busi,geni,branchi,brconni, convergedi]=runEstimate(baseMVA,zone_bus_map(zone),...
%         zone_gen_map(zone),zone_branch_map(zone),...
%         zone_branch_connf_map(zone),zone_branch_connt_map(zone),...
%         connbrf_bus_out_map(zone),connbrt_bus_out_map(zone),mpopt);
%     
%     busPiec=[busPiec;busi];
%     genPiec=[genPiec;geni];
%     branchPiec=[branchPiec;branchi];
%     brconnPiec=[brconnPiec;brconni];
%     convergedoPiec=[convergedoPiec,convergedi];
% end

[r,c]=size(brconnPiec);
brconnPiec=sortrows(brconnPiec,c);
% average sf st
brconnPiec=(brconnPiec(1:2:r,:)+brconnPiec(2:2:r,:))/2;
branchPiec=[branchPiec;brconnPiec];
branchPiec=branchPiec(:,1:c-1);

[bus, gen, branch] = int2ext(i2e, bus, gen, branch);
[busPiec, genPiec, branchPiec] = int2ext(i2e, busPiec, genPiec, branchPiec);
converged=k-sum(convergedoPiec);
if converged==0
    converged=1;
else
    converged=0;
end
success={success};
converged={converged};

busPiecSort=sortrows(busPiec,1:size(busPiec,2));
genPiecSort=sortrows(genPiec,1:size(genPiec,2));
branchPiecSort=sortrows(branchPiec,1:size(branchPiec,2));
busSort=sortrows(bus,1:size(bus,2));
genSort=sortrows(gen,1:size(gen,2));
branchSort=sortrows(branch,1:size(branch,2));
% busBenchSort=sortrows(busBench,1:size(busBench,2));
% genBenchSort=sortrows(genBench,1:size(genBench,2));
outdiff=[{busSort-busPiecSort},{genSort-genPiecSort},{branchSort-branchPiecSort},converged,success];
% ids=real(i2e(extiV(:,1)));
% extiV(:,1)=ids;
% extiV=sortrows(extiV,1);
% ids=sort(ids);
% V=extiV(:,2);
% Vm=abs(V);
% Va=angle(V)/pi*180;
% outdiff=[busBench(:,BUS_I)-ids,busBench(:,VM)-Vm,busBench(:,VA)-Va];
% outdiff={bus-busPiec,gen-genPiec,branch-branchPiec};

end