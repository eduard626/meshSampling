function [vertices,faces] = mSampling(file,distance)
    [vert,~]=read_off(file);
    scale=max(max(vert,[],2));
    if(scale>100)
        if(scale>1000)
            [i_vertices,i_faces]=main2(file,distance);
        else
            [i_vertices,i_faces]=main3(file,distance);
        end
    else
        [i_vertices,i_faces]=main(file,distance);
    end
    vertices=i_vertices;
    faces=i_faces;
end