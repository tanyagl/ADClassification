refT1Dir = 'E:/DATA/ADNI/ADNI';
fsInDir = 'E:/DATA/ADNI/aparc+aseg';

T1folders = dir(refT1Dir);
T1folders = T1folders([T1folders.isdir]);

FSfolders = dir(fsInDir);
FSfolders = FSfolders([FSfolders.isdir]);

for t1folder = 1:length(T1folders)
    %find compatible fs file
    for fsfolder = 1:length(FSfolders)
        if(strcmp(FSfolders(fsfolder).name,'.') || strcmp(T1folders(t1folder).name,'..') ||...
                strcmp(FSfolders(fsfolder).name,'.') || strcmp(T1folders(t1folder).name,'..'))
            continue;
        end
        if strcmp(FSfolders(fsfolder).name,T1folders(t1folder).name)
            path2fs = fullfile(fsInDir, FSfolders(fsfolder).name,'FreeSurfer_Cross-Sectional_Processing_aparc+aseg');
            path2T1 = fullfile(refT1Dir, T1folders(t1folder).name,'MPR-R__GradWarp__B1_Correction__N3');
            T1results = dir(path2T1);
            FSresults = dir(path2fs);
            T1results = T1results([T1results.isdir]);
            FSresults = FSresults([FSresults.isdir]);
            %check compatibility of scan (different dates)
             for FSscan = 1:length(FSresults)
                 for T1scan = 1:length(T1results)
               
                    if(strcmp(FSresults(FSscan).name,'.') || strcmp(T1results(T1scan).name,'..'))
                        continue;
                    end
                    if(strcmp(FSresults(FSscan).name,'.') || strcmp(T1results(T1scan).name,'..'))
                        continue;
                    end
                    if strcmp(T1results(T1scan).name,FSresults(FSscan).name)
                        refT1path = fullfile(path2T1,T1results(T1scan).name);
                        refFSpath = fullfile(path2fs,FSresults(FSscan).name);
                        
                        T1files = dir(refT1path);
                        FSfiles = dir(refFSpath);
                        for i=1:length(T1files)
                            if(strcmp(T1files(i).name,'.') || strcmp(T1files(i).name,'..'))
                                continue;
                            end
                            for j=1:length(FSfiles)
                                if (strcmp(FSfiles(j).name,'..') || strcmp(FSfiles(j).name,'.'))
                                    continue;
                                end
                                %here we are!!
                                %look for *.nii and *.mgz files
                                refT1 = fullfile(refT1path, T1files(i).name);
                                FSin = fullfile(refFSpath,FSfiles(j).name,'mri','aparc+aseg.mgz');
                                T1files = dir(refT1);
                                
                                for k=1:length(T1files)
                                    [~,name,ext] = fileparts(fullfile(refT1,T1files(k).name));
                                    if(strcmp(ext,'.nii'))
                                        %%foundit!!
                                        refT1 = fullfile(refT1,T1files(k).name);
                                        fsIn   = FSin;
                                        outDir = fullfile('E:/DATA/ADNI/ROIs/',FSfolders(fsfolder).name);
                                        type   = 'mat';
                                        fs_roisFromAllLabels(fsIn,outDir,type,refT1);
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

