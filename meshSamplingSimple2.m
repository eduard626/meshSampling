function [newVertices, newFaces] =  meshSamplingSimple2(vertices, faces,distance)
    %check all edges on each face
    global nVertices;
    global vert_arr;
    newFaces=[];
    new_faces=[];
    nFaces=size(faces,2);
    counterF=nFaces;
    counterC=size(vertices,2);
    new_vertices=vertices;
    nVertices=size(vertices,2);
    %Create array for upper triangular matrix
    vert_arr=zeros(1,nVertices*(nVertices+1)/2);
%     for i=1:nVertices
%         for j=1:nVertices
%             if (j>=i)
%                 ind=(nVertices*i)+j-(i(i+1)/2);
%                 vert_arr(ind)=0;
%             end
%         end
%     end
    %  0riginal vertices: va, vb, vc.
    %  New vertices: vp, vq, vr.
    %
    %      vb                   vb             
    %     / \                  /  \ 
    %    /   \                vp--vq
    %   /     \              / \  / \
    % va ----- vc   ->     va-- vr --vc 
    for n=1:nFaces
        [vaIndex,vbIndex,vcIndex]=deal(faces(1,n),faces(2,n),faces(3,n));
        va=vertices(:,vaIndex);
        vb=vertices(:,vbIndex);
        vc=vertices(:,vcIndex);
        %check distances
        vpIndex=0;
        vqIndex=0;
        vrIndex=0;
        if(distancePoints(va',vb')>distance)
            vpIndex=arr_check(vaIndex,vbIndex);
            vp=1/2*(va+vb);
            new_vertices=[new_vertices vp];
        end
        if(distancePoints(vb',vc')>distance)
            vqIndex=arr_check(vbIndex,vcIndex);
            vq=1/2*(vb+vc);
            new_vertices=[new_vertices vq];
        end
        if(distancePoints(va',vc')>distance)
            vrIndex=arr_check(vaIndex,vcIndex);
            vr=1/2*(va+vc);
            new_vertices=[new_vertices vr];
        end
        
        if(vpIndex==0)
            if(vqIndex==0)
                if(vrIndex==0)
                    cFaces=[vaIndex vbIndex vcIndex];
                else
                    cFaces=[vrIndex vaIndex vbIndex;vrIndex vbIndex vcIndex];
                end
            else
                if(vrIndex==0)
                    cFaces=[vaIndex vcIndex vqIndex;vaIndex vbIndex vqIndex];
                else
                    cFaces=[vcIndex vqIndex vrIndex; vbIndex vqIndex vrIndex; vaIndex vbIndex vrIndex];
                end
            end
        else
            if (vqIndex==0)
                if(vrIndex==0)
                    cFaces=[vbIndex vcIndex vpIndex; vaIndex vcIndex vpIndex];
                else
                    cFaces=[vaIndex vpIndex vrIndex; vcIndex vpIndex vrIndex; vbIndex vcIndex vpIndex];
                end
            else
                if(vrIndex==0)
                    cFaces=[vbIndex vpIndex vqIndex; vaIndex vcIndex vpIndex; vcIndex vpIndex vqIndex];
                else
                    cFaces=[vaIndex,vpIndex,vrIndex; vpIndex,vbIndex,vqIndex; vrIndex,vqIndex,vcIndex; vrIndex,vpIndex,vqIndex];
                end
            end
        end
        newFaces=[newFaces cFaces'];
    end
    newVertices=new_vertices;
    %[newVertices,auxId,auxIdc]=unique(new_vertices','rows');
    %for n=1:size(new_faces,2)
    %    newFaces(:,n)=[auxIdc(new_faces(1,n)) auxIdc(new_faces(2,n)) auxIdc(new_faces(3,n))]';
    %end
end

function out=arr_check(v1,v2)
    global nVertices;
    global vert_arr;
    if(v1>v2)
        aux=v1;
        v1=v2;
        v2=aux;
    end
    %index=(nVertices*v1)+v2-((v1*(v1+1))/2);
    %index=(nVertices*(nVertices-1)/2)-(nVertices-v1)*((nVertices-v1)-1)/2 + v2 -v1 -1;
    index=v1*(v1-1)/2+v2+1;
    if (vert_arr(index)==0)
       nVertices=nVertices+1;
       vert_arr(index)=nVertices;
       out=nVertices;
    else
        out=vert_arr(index);
    end
end
