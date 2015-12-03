clc;clear;close all;
global debug
casessmall={'case30' 'case300' 'case24_ieee_rts' 'case39'};
caseslarge={'case2383wp','case2736sp','case2746wp','case2869pegase'};
casestst={'case2746wp'};
cases=casessmall;
mpopt = mpoption('verbose',0);
debug=0;

if debug==2
    cases=casestst;
end

fprintf('Max output difference.\n');
for k=1:size(cases,2)
    fprintf('%s\n',cases{k});
    outdiff=compareEst(cases{k},mpopt);
    fprintf('\nBus %10.4f',(max(max(abs(outdiff{1})))));
    fprintf('\tGen %10.4f\n\n',max(max(abs(outdiff{2}))));
end

