clc;clear;close all;
global debug

casessmall={'case30' 'case300' 'case24_ieee_rts' 'case39'};
caseslarge={'case2383wp','case2736sp','case2746wp','case2869pegase'};
casestst={'case2736sp'};
cases=casessmall;

mpopt = mpoption('verbose',0);

debug=3;
if debug==2
    cases=casestst;
end
if debug==3
    matpath='F:\projects\matpower5.1';
    %                out of mem err     'case9241pegase',
    exclude_files={'info','format'};
    cases=getAllCases(matpath,exclude_files);
end

warning('off');
fprintf('Max output difference.\n');
for k=1:size(cases,2)   
    fprintf('%s\n',cases{k});
    [outdiff,zoneBuses]=compareEst(cases{k},mpopt);
    res(k).case=cases{k};
    res(k).maxBusDiff=max(max(abs(outdiff{1})));
    res(k).maxGenDiff=max(max(abs(outdiff{2})));
    res(k).EstConvergence=outdiff{3};
    res(k).PFSuccess=outdiff{end};
    res(k).zoneBuses=zoneBuses;
    fprintf('\nBus %10.6f',res(k).maxBusDiff);
    fprintf('\tGen %10.6f',res(k).maxGenDiff);
    color=1;
    if ~outdiff{3},color=2;end
    if ~outdiff{end},color=2;end
    fprintf(color,'\tEstConverged %5d',res(k).EstConvergence);
    fprintf(color,'\tPFSuccess %5d\n\n',res(k).PFSuccess);
end
save('result','res');
warning('on');