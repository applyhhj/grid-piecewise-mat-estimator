function [zone_bus_map,zone_gen_map,zone_branch_map, ...
    zone_branch_connf_map,zone_branch_connt_map,...
    connbrf_bus_out_map,connbrt_bus_out_map]=piecewise(bus,gen,branch)

[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;

[GEN_BUS, PG, QG, QMAX, QMIN, VG, MBASE, GEN_STATUS, PMAX, PMIN, ...
    MU_PMAX, MU_PMIN, MU_QMAX, MU_QMIN, PC1, PC2, QC1MIN, QC1MAX, ...
    QC2MIN, QC2MAX, RAMP_AGC, RAMP_10, RAMP_30, RAMP_Q, APF] = idx_gen;

[F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE_A, RATE_B, RATE_C, ...
    TAP, SHIFT, BR_STATUS, PF, QF, PT, QT, MU_SF, MU_ST, ...
    ANGMIN, ANGMAX, MU_ANGMIN, MU_ANGMAX] = idx_brch;

ref=getBusType(bus, gen);
refZoneNum=-1;

zref=bus(ref,ZONE);
bus(ref,ZONE)=refZoneNum;
aref=bus(ref,BUS_AREA);
bus(ref,BUS_AREA)=refZoneNum;

zones=sort(unique(bus(:,ZONE)));
areas=sort(unique(bus(:,BUS_AREA)));

if size(zones,1)>size(areas,1)
    idx=ZONE;
else
    idx=BUS_AREA;
    zones=areas;
end

zn=size(zones,1);

buses=cell(1,zn);
gens=cell(1,zn);
branches=cell(1,zn);
connbrf=cell(1,zn);
connbrt=cell(1,zn);
connbrf_bus_out=cell(1,zn);
connbrt_bus_out=cell(1,zn);

for k=1:zn
    %     piecewise buses
    zonebuses=bus(bus(:,idx)==zones(k),:);  
    buses(k)={zonebuses};
    
    %     piecewise gens
    [~,igen]=intersectRep(gen(:,GEN_BUS),zonebuses(:,BUS_I));    
    zonegens=gen(igen,:);    
    gens(k)={zonegens};
    
    %     piecewise branches
    [~,ibrf]=intersectRep(branch(:,F_BUS),zonebuses(:,BUS_I));    
    [~,ibrt]=intersectRep(branch(:,T_BUS),zonebuses(:,BUS_I));    
    ibrzone=intersectRep(ibrf,ibrt);        
    branches(k)={branch(ibrzone,:)};
    
    %   connection branches
    connbrf(k)={branch(diffRep(ibrf,ibrzone),:)};    
    connbrt(k)={branch(diffRep(ibrt,ibrzone),:)};

    %   buses of connection branches that are out of the zone
    %% ibus may have duplicated elements
    [~,ibus]=intersectRep(bus(:,BUS_I),branch(diffRep(ibrf,ibrzone),T_BUS));    
    connbrf_bus_out(k)={bus(ibus,:)};    
    [~,ibus]=intersectRep(bus(:,BUS_I),branch(diffRep(ibrt,ibrzone),F_BUS));    
    connbrt_bus_out(k)={bus(ibus,:)};    
end
busref=cell2mat(buses(1));
busref(1,ZONE )=zref;
busref(1,BUS_AREA)=aref;
buses(1)={busref};

zone_bus_map=containers.Map(zones,buses);
zone_gen_map=containers.Map(zones,gens);
zone_branch_map=containers.Map(zones,branches);
zone_branch_connf_map=containers.Map(zones,connbrf);
zone_branch_connt_map=containers.Map(zones,connbrt);
connbrf_bus_out_map=containers.Map(zones,connbrf_bus_out);
connbrt_bus_out_map=containers.Map(zones,connbrt_bus_out);

end