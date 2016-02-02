function [newVertices, newFaces] =  meshSamplingSimple3(vertices, faces,distance)
    %check all edges on each face
    global nVertices;
    global vert_arr;
    global indices;
    newFaces=[];
    vert_arr=[];
    indices=[];
    nFaces=size(faces,2);
    new_size=4*size(vertices,2);
    new_vertices=zeros(3,new_size);
    new_vertices(:,1:size(vertices,2))=vertices;
    nVertices=size(vertices,2);
    maxDistanceVert=0;
    %Create array for upper triangular matrix
    %vert_arr=zeros(1,nVertices*(nVertices+1)/2,'uint32');
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
    aux_c=size(vertices,2);
    for n=1:nFaces
        [vaIndex,vbIndex,vcIndex]=deal(faces(1,n),faces(2,n),faces(3,n));
        va=vertices(:,vaIndex);
        vb=vertices(:,vbIndex);
        vc=vertices(:,vcIndex);
        %check distances
        vpIndex=0;
        vqIndex=0;
        vrIndex=0;
        aDistance=distancePoints(va',vb');
        if(aDistance>distance)
            temp=nVertices;
            vpIndex=arr_check(vaIndex,vbIndex);
            if ((nVertices-temp)>0)
                aux_c=aux_c+1;
                if(aux_c==new_size) 
                end
                vp=1/2*(va+vb);
                new_vertices(:,aux_c)=vp;
            end
        end
        if(maxDistanceVert<aDistance)
            maxDistanceVert=aDistance;
        end
        aDistance=distancePoints(vb',vc');
        if(aDistance>distance)
            temp=nVertices;
            vqIndex=arr_check(vbIndex,vcIndex);
            if((nVertices-temp)>0)
                aux_c=aux_c+1;
                vq=1/2*(vb+vc);
                new_vertices(:,aux_c)=vq;
            end
        end
        if(maxDistanceVert<aDistance)
            maxDistanceVert=aDistance;
        end
        aDistance=distancePoints(va',vc');
        if(aDistance>distance)
            temp=nVertices;
            vrIndex=arr_check(vaIndex,vcIndex);
            if ((nVertices-temp)>0)
                aux_c=aux_c+1;
                vr=1/2*(va+vc);
                new_vertices(:,auc_c)=vr;
            end
        end
        if(maxDistanceVert<aDistance)
            maxDistanceVert=aDistance;
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
                    cFaces=[vaIndex,vpIndex,vrIndex; vpIndex,vbIndex,vqIndex; vrIndex,vqIndex,vcIndex; vpIndex,vqIndex,vrIndex,];
                end
            end
        end
        newFaces=[newFaces cFaces'];
    end
    fprintf(' Max distance %f ',maxDistanceVert);
    newVertices=new_vertices;
    %[newVertices,auxId,auxIdc]=unique(new_vertices','rows');
    %for n=1:size(new_faces,2)
    %    newFaces(:,n)=[auxIdc(new_faces(1,n)) auxIdc(new_faces(2,n)) auxIdc(new_faces(3,n))]';
    %end
end

function out=arr_check(v1,v2)
    global nVertices;
    global vert_arr;
    global indices;
    if(v1>v2)
        aux=v1;
        v1=v2;
        v2=aux;
    end
    %index=(nVertices*v1)+v2-((v1*(v1+1))/2);
    %index=(nVertices*(nVertices-1)/2)-(nVertices-v1)*((nVertices-v1)-1)/2 + v2 -v1 -1;
    index=v2*(v2-1)/2+v1+1;
    [res,id]=ismember(index,vert_arr);
    if (res==0)
        nVertices=nVertices+1;
        vert_arr=[vert_arr index];
        indices=[indices nVertices];
        out=nVertices;
    else
        out=indices(id);
    end
end
