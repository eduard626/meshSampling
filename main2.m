function [vertices,faces]=main2(file,maxDistance)
    [vert,faces]=read_off(file);
    vert1=vert/1000;
    faces1=faces;
    while (1)
        tic
        [n_vert,n_faces]=meshSamplingSimple3(vert1,faces1,maxDistance);
        v=size(n_vert,2);
        toc
        fprintf('%s %i vertices and %i faces \n',file,v,size(n_faces,2));
        %drawMesh(n_vert',n_faces')
        %input('Oportunity to break ')
        if((v-size(vert1,2))==0)
            break;
        end
        vert1=n_vert;
        faces1=n_faces;
    end
    vertices=n_vert;
    faces=n_faces;
end