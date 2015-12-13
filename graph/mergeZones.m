function [ mergedZoneSet,unmergedZoneIds] = mergeZones( subZones,N)
subZn=size(subZones,2);
if subZn>1
    for k=1:subZn
        sizes(k)=size(subZones(k).graph,1);
    end
    unmergedZoneIds=find(sizes>=N);
    zonesToMerge=find(sizes<N);
    zonesToMerge=[zonesToMerge sizes(zonesToMerge)];
%     resultSet=mergeZones(subZones,zonesToMerge,N);
else
    unmergedZoneIds=1;   
    mergedZoneSet=[];
    return;
end

zonesToMerge=sortrows(zonesToMerge,2);
k=1;
merging=0;
while(size(zonesToMerge,1)>0)
    if ~merging
        if size(zonesToMerge,1)<2||zonesToMerge(1,2)+zonesToMerge(2,2)>N
            break;
        else
            merging=1;
            sum=zonesToMerge(1,2)+zonesToMerge(2,2);
            mergingZone=[subZones(zonesToMerge(1,1)).graph;subZones(zonesToMerge(2,1)).graph];
            zonesToMerge(1:2,:)=[];
        end
    else
        if sum+zonesToMerge(1,2)<=N
            mergingZone=[mergingZone;subZones(zonesToMerge(1,1)).graph];
            zonesToMerge(1,:)=[];
        else
            mergedZoneSet(k).graph=mergingZone;
            k=k+1;
            merging=0;
        end
    end
end

if merging
    mergedZoneSet(k).graph=mergingZone;
else
    if size(zonesToMerge,1)>0
       for l=1: size(zonesToMerge,1)
           mergedZoneSet(k).graph=subZones(zonesToMerge(l,1)).graph;
           k=k+1;
       end
    end
end

