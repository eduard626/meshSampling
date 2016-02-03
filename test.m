vert1=v;
faces1=f;
maxDistance=0.02;
while (1)
        tic
        [n_vert,n_faces]=test_sampling(vert1,faces1,maxDistance);
        v=size(n_vert,2);
        toc
        fprintf('%s %i vertices and %i faces \n','file',v,size(n_faces,2));
        %drawMesh(n_vert',n_faces')
        %input('Oportunity to break ')
        if((v-size(vert1,2))==0)
            break;
        end
        vert1=n_vert;
        faces1=n_faces;
end