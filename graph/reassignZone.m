function [ bus ] = reassignZone( bus,ref,C,N )
%% define named indices into bus, branch matrices
[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;
[F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE_A, RATE_B, RATE_C, ...
    TAP, SHIFT, BR_STATUS, PF, QF, PT, QT, MU_SF, MU_ST, ...
    ANGMIN, ANGMAX, MU_ANGMIN, MU_ANGMAX] = idx_brch;

%% bus numbers should be converted to internal consecutive numbers
bn=size(bus,1);
if any(bus(:, BUS_I) ~= (1:bn)')
    error('Buses must appear in order by bus number')
end

zone=ones(bn,1);
zone(ref)=0;
%% split system
% normally we should not split the system when the number of buses is no
% large, however due to the bug of the original estimator we have to split
% the reference bus so that the estimator can get more accurate result.
if bn<N
    bus=[bus zone];
    return;
end

%% compute connection matrix
% convert to symmetric matrix
C=C+C';
Ctmp=C;

%% check the rest system after split the reference bus
i2e=setdiff(bus(:,BUS_I),ref);
Ctmp(ref,:)=[];
Ctmp(:,ref)=[];
subZones=BFSDivideGraph(Ctmp,i2e);
[resultSet,zIdsToSplit]=mergeZones(subZones,N);

%% split rest subsystems
for k=1:size(zIdsToSplit,1)
    zoneToSplit=subZones(zIdsToSplit(k)).graph;
    resultSetTmp=splitZone(zoneToSplit,C,N);    
end
resultSet=[resultSet resultSetTmp];
for k=1:size(resultSet,2)
   zone(resultSet(k).graph)=k; 
end
bus=[bus zone];
end

