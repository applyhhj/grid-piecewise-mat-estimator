clc;clear;close all;
global debug
cases={'case30' 'case300' 'case24_ieee_rts' 'case39'};
mpopt = mpoption('verbose',0);
debug=1;
fprintf('Max output difference.\n');
% fprintf('\n No.\t\t\tCaseName\t\t\tVm\t\tVa\n');
for k=1:size(cases,2)
    fprintf('%s\n',cases{k});
    outdiff=compareEst(cases{k},mpopt);
    fprintf('Bus %10.4f',(max(max(abs(outdiff{1})))));
    fprintf('\tGen %10.4f\n\n',max(max(abs(outdiff{2}))));
%     fprintf('Branch---------------------------\n')
%     disp(max((outdiff{3})));
%     fprintf('%4d%20s\t%10.4f\t%10.4f\n',k,cases{k},max(abs(outdiff(:,2))),max(abs(outdiff(:,3))));
end
% 
% fprintf('Output difference\n');
% fprintf('\n\tBus\t\tVm\t\tVa\n');
% for k=1:size(V,1)
%     fprintf('%5d%10.4f%10.4f\n',outdiff(k,1),outdiff(k,2),outdiff(k,3));
% end
% 
