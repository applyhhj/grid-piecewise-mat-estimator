function [ resultSet ] = splitZone( zoneToSplit,C,N )
% zoneToSplit contains all connected buses in this zone
k=1;
i2e=zoneToSplit;
Cz=C(zoneToSplit,zoneToSplit);
A=primMinTree( Cz );
nzts=size(zoneToSplit,1);
while size(zoneToSplit,1)>0
    nz=size(zoneToSplit,1);
    if nz<N
        resultSet(k).graph=zoneToSplit;
        break;
    end
    
    rA=size(A,1);
    zoneSizes=zeros(rA,2);
    Cz=sparse(A(:,1),A(:,2),1,nzts,nzts);
    for l=1:rA
        Cztmp=Cz;
        f=A(l,1);
        t=A(l,2);
        Cztmp(f,t)=0;
        Cztmp(t,f)=0;
        subZones=BFSDivideGraph(Cztmp);
        zoneSizes(l,:)=[size(subZones(1).graph,1),size(subZones(2).graph,1)];
        subZoneArr(l).subZones=subZones;
    end
    
    if N<=nz&&nz<2*N
        zoneSizes=abs(zoneSizes(:,1)-zoneSizes(:,2));
        [~,I]=min(zoneSizes);
        resultSet(k).graph=i2e(subZoneArr(I).subZones(1).graph);
        resultSet(k+1).graph=i2e(subZoneArr(I).subZones(2).graph);
        break;
    else
        zoneSizes=abs(zoneSizes-N);
        [r,c]=find(zoneSizes==min(min(zoneSizes)));
        resultIn=subZoneArr(r).subZones(c).graph;
        resultSet(k).graph=i2e(resultIn);
        [~,idsf]=diffRep(A(:,1),resultIn);
        [~,idst]=diffRep(A(:,2),resultIn);
        [ids,~]=intersectRep(idsf,idst);
        A=A(ids,:);
        A(:,1)=i2e(A(:,1));
        A(:,2)=i2e(A(:,2));
        zoneToSplit=setdiff(zoneToSplit,resultSet(k).graph);
        i2e=zoneToSplit;
        nzts=size(zoneToSplit,1);
        e2i=sparse(i2e,ones(nzts,1),1:nzts,max(i2e),1);
        A(:,1)=e2i(A(:,1));
        A(:,2)=e2i(A(:,2));
        k=k+1;
    end
end

[ mergedZoneSet,unmergedZoneIds] = mergeZones( resultSet,N);
if ~isempty(mergedZoneSet)
    resultSet=[resultSet(unmergedZoneIds) mergedZoneSet];
end

