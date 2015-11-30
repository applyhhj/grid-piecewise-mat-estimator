function [success]=runestimate(baseMVA,zonebus,zonebranch,zonegen,...
    zonebrconnf,zonebrconnt,zonebrfbusout,zonebrtbusout)

%% define named indices into bus, gen, branch matrices
[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;
[F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE_A, RATE_B, RATE_C, ...
    TAP, SHIFT, BR_STATUS, PF, QF, PT, QT, MU_SF, MU_ST, ...
    ANGMIN, ANGMAX, MU_ANGMIN, MU_ANGMAX] = idx_brch;
[GEN_BUS, PG, QG, QMAX, QMIN, VG, MBASE, GEN_STATUS, PMAX, PMIN, ...
    MU_PMAX, MU_PMIN, MU_QMAX, MU_QMIN, PC1, PC2, QC1MIN, QC1MAX, ...
    QC2MIN, QC2MAX, RAMP_AGC, RAMP_10, RAMP_30, RAMP_Q, APF] = idx_gen;

%% convert to matrix
bus=cell2mat(zonebus);
gen=cell2mat(zonegen);
branch=cell2mat(zonebranch);
brconnf=cell2mat(zonebrconnf);
brconnt=cell2mat(zonebrconnt);
busbrconnfout=cell2mat(zonebrfbusout);
busbrconntout=cell2mat(zonebrtbusout);

%% reoder bus number
buses=[bus;busbrconnfout;busbrconntout];
branches=[branch;brconnf,brconnt];
[i2e,buses,gen,branches]=ext2int(buses,gen,branches);

bn=size(bus,1);
bncfo=size(busbrconnfout,1);
% bncto=size(busbrconntout,1);
brn=size(branch,1);
brncf=size(brconnf,1);
% brnct=size(brconnt,1);

bus=buses(1:bn,:);
branch=branches(1:brn,:);
brconnf=branches(brn+1:brn+brncf,:);
brconnt=branches(brn+brncf+1:end,:);
busbrconnfout=buses(bn+1:bn+bncfo,:);
busbrconntout=buses(bn+bncfo+1:end,:);

%% get bus index lists of each type of bus
[ref, pv, pq] = getBusType(zonebus, zonegen);

%% generator info
on = find(zonegen(:, GEN_STATUS) > 0);      %% which generators are on?
gbus = zonegen(on, GEN_BUS);                %% what buses are they at?

%% build admittance matrices
[Yd, Yfd, Ytd] = getYMatrix(baseMVA, bus, branch);
[~, ~, ~,Yffconn,~] = getYMatrix(baseMVA, bus, brconnf);
[~, ~, ~,~,Yttconn] = getYMatrix(baseMVA, bus, brconnt);
YL=[Yffconn;Yttconn];
connbus=[brconnf(:,F_BUS);brconnt(:,T_BUS)];
Yeq=sparse(connbus,connbus,2*YL,bn,bn);
Yb=Yd+Yeq;
N=sparse(connbus,connbus,1,bn,bn);
Ybuseq=Yb-N*YL*N';

%% compute complex bus power injections (generation - load)
% Sbus = makeSbus(baseMVA, bus, gen);

%% import some values from load flow solution
Pflf=branch(:,PF);
Qflf=branch(:,QF);
Ptlf=branch(:,PT);
Qtlf=branch(:,QT);
Vm=bus(:,VM);
Va=bus(:,VA);
V=Vm.*cos(Va)+Vm.*sin(Va).*1j;
Ibus=Ybuseq*V;
Sbuslf = V .* conj(Ibus);
Vlf=V;

[V, converged, i] = state_estimate(branch, Ybuseq, Yfd, Ytd, Sbuslf, Vlf, ref, pv, pq, mpopt);

end