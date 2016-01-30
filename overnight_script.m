listing=dir('*.off');
diary on
diary('log.txt')
parpool('local',8)
parfor i=1:size(listing,1)
    file=listing(i).name;
    file_s=strtok(file,'.');
    new_name=strcat(file_s,'_dense.off');
    %disp(new_name)
    fprintf('Working with %s\n',file);
    [v,f]=mSampling(file,0.025);
    write_off(new_name,v,f);
    fprintf(' ....done. Saved as %s\n',new_name);
end
exit
