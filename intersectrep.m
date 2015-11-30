function [c,idxa]=intersectRep(a,b)
if isempty(a) || isempty(b)
   c=[];
   idxa=[];
   return;
end
buni=unique(b);
idxa=[];
[r,c]=size(buni);
for k=1:max(r,c)
    idxa=[idxa;find(a==buni(k))];
end
c=a(idxa);
end