clc;clear;close all;
global debug

casessmall={'case30' 'case300' 'case24_ieee_rts' 'case39'};
caseslarge={'case2383wp','case2736sp','case2746wp','case2869pegase'};
casestst={'case30'};
cases=casessmall;

mpopt = mpoption('verbose',0);

debug=2;
if debug==2
    cases=casestst;
end
if debug==3
    matpath='F:\projects\matpower5.1';
%     matpath='E:\matpower5.1';
    %                out of mem err     'case9241pegase',
    exclude_files={'info','format'};
    cases=getAllCases(matpath,exclude_files);
end

warning('off');
for k=1:size(cases,2)   
    fprintf('Processing case %15s\n',cases{k});
    [outdiff,zoneBuses]=compareEst(cases{k},mpopt);
    res(k).case=cases{k};
    res(k).maxBusDiff=max(max(abs(outdiff{1})));
    res(k).maxGenDiff=max(max(abs(outdiff{2})));
    res(k).maxBranchDiff=max(max(abs(outdiff{3})));
    res(k).EstConvergence=outdiff{4};
    res(k).PFSuccess=outdiff{end};
    res(k).zoneBuses=zoneBuses;
end

printRes(res);
fprintf('Saving result!\n');
save('result','res');
warning('on');
fprintf('Done!\n')