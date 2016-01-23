function [newVertices, newFaces] =  meshSamplingSimple(vertices, faces,distance)
    %check all edges on each face
    newFaces=[];
    new_faces=[];
    nFaces=size(faces,2);
    counterF=nFaces;
    counterC=size(vertices,2);
    new_vertices=vertices;
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
            vp=1/2*(va+vb);
            [res,id]=ismember(vp',new_vertices','rows');
            if(res==0)
                counterC=counterC+1;
                vpIndex=counterC;
                new_vertices=[new_vertices vp];
            else
                vpIndex=id;
            end
        end
        if(distancePoints(vb',vc')>distance)
            vq=1/2*(vb+vc);
            [res,id]=ismember(vq',new_vertices','rows');
            if(res==0)
                counterC=counterC+1;
                vqIndex=counterC;
                new_vertices=[new_vertices vq];
            else
                vqIndex=id;
            end
        end
        if(distancePoints(va',vc')>distance)
            vr=1/2*(va+vc);
            [res,id]=ismember(vr',new_vertices','rows');
            if(res==0)
                counterC=counterC+1;
                vrIndex=counterC;
                new_vertices=[new_vertices vr];
            else
                vrIndex=id;
            end
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