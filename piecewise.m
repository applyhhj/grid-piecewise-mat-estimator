function [zone_bus_map,zone_gen_map,zone_branch_map, ...
    zone_branch_conn_map]=piecewise(bus,gen,branch)

[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;

[GEN_BUS, PG, QG, QMAX, QMIN, VG, MBASE, GEN_STATUS, PMAX, PMIN, ...
    MU_PMAX, MU_PMIN, MU_QMAX, MU_QMIN, PC1, PC2, QC1MIN, QC1MAX, ...
    QC2MIN, QC2MAX, RAMP_AGC, RAMP_10, RAMP_30, RAMP_Q, APF] = idx_gen;

[F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE_A, RATE_B, RATE_C, ...
    TAP, SHIFT, BR_STATUS, PF, QF, PT, QT, MU_SF, MU_ST, ...
    ANGMIN, ANGMAX, MU_ANGMIN, MU_ANGMAX] = idx_brch;

zones=sort(unique(bus(:,ZONE)));

zn=size(zones,1);

buses=cell(1,zn);

gens=cell(1,zn);

branches=cell(1,zn);

connbr=cell(2,zn);

for k=1:zn
    
    %     piecewise buses
    zonebuses=bus(bus(:,ZONE)==zones(k),:);
    
    buses(k)={zonebuses};
    
    %     piecewise gens
    [c,igen,ibus]=intersect(gen(:,GEN_BUS),zonebuses(:,BUS_I));
    
    zonegens=gen(igen,:);
    
    gens(k)={zonegens};
    
    %     piecewise branches
    [c,ibrf,ibus]=intersect(branch(:,F_BUS),zonebuses(:,BUS_I));
    
    [c,ibrt,ibus]=intersect(branch(:,T_BUS),zonebuses(:,BUS_I));
    
    ibrzone=intersect(ibrf,ibrt);
        
    connbr(:,k)={setdiff(ibrf,ibrzone),setdiff(ibrt,ibrzone)};
    
    branches(k)={branch(ibrzone,:)};
    
end

zone_bus_map=containers.Map(zones,buses);

zone_gen_map=containers.Map(zones,gens);

zone_branch_map=containers.Map(zones,branches);

zone_branch_conn_map=containers.Map(zones,connbr);

end