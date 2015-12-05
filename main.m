clc;clear;close all;
global debug
casessmall={'case30' 'case300' 'case24_ieee_rts' 'case39'};
caseslarge={'case2383wp','case2736sp','case2746wp','case2869pegase'};
casestst={'case2869pegase'};
cases=casessmall;
mpopt = mpoption('verbose',0);
debug=3;

if debug==2
    cases=casestst;
end

if debug==3
    matpath='F:\projects\matpower5.1';
    %                out of mem err
    exclude_files={'case9241pegase','info','format'};
    cases=getAllCases(matpath,exclude_files);
end

warning('off');
fprintf('Max output difference.\n');
for k=1:size(cases,2)
    fprintf('%s\n',cases{k});
    outdiff=compareEst(cases{k},mpopt);
    fprintf('\nBus %10.6f',(max(max(abs(outdiff{1})))));
    fprintf('\tGen %10.6f',max(max(abs(outdiff{2}))));
    fprintf('\tEstConverged %5d',outdiff{3});
    fprintf('\tPFSuccess %5d\n\n',outdiff{end});
    
end

warning('on');