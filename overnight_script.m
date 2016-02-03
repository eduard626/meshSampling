listing=dir('*.off');
parpool('local',6)
parfor i=1:size(listing,1)
    file=listing(i).name;
    file_s=strtok(file,'.');
    new_name=strcat(file_s,'_dense.off');
    %disp(new_name)
    if( strcmp(file,'office-desk3.off')==0)
        fprintf('Working with %s\n',file);
        [v,f]=mSampling(file,0.01);
        write_off(new_name,v,f);
        fprintf(' ....done. Saved as %s\n',new_name);
    else
        fprintf('Skipping %s \n',file);
    end
end
exit
