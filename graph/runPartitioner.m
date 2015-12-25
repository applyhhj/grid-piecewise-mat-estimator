clc;clear;close all;

casedata='case9241pegase';
[F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE_A, RATE_B, RATE_C, ...
    TAP, SHIFT, BR_STATUS, PF, QF, PT, QT, MU_SF, MU_ST, ...
    ANGMIN, ANGMAX, MU_ANGMIN, MU_ANGMAX] = idx_brch;

N=300;

[baseMVA, bus, gen, branch] = loadcase(casedata);
[i2e, bus, gen, branch] = ext2int(bus, gen, branch);

bus = reassignZone( bus,gen,branch,N );