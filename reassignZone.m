function [bus]=reassignZone(bus)
[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;
% test 
bus=[bus bus(:,BUS_AREA)];
return;

nb=size(bus,1);
if nb<400
    bus=[bus ones(nb,1)];
    return;
end