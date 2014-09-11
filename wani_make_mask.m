function wani_make_mask(fname, cl, varargin)

% function wani_make_mask(fname, cl, varargin)
%
% This is a function to make a mask file. This function is using
% clusters2mask.m and 'brainmask.nii' as a overlay. 
% input: 
%    fname: filename and path
%       e.g.) outputdir = 'Volume/current/BMRK3';
%             fname = fullfile(outputdir, 'mask_DMPFC.img');
% varargin options:
%    'unique_mask_values': will save cl with different numbers
%

dounique = 0;
if nargin > 2
    dounique = 1;
end

if ~dounique
    
    % new method using region object
%     try
%         cldat = region2imagevec(cl);
%     catch
%         for i = 1:numel(cl), cl(i) = cluster2region(cl(i)); end
%         cldat = region2imagevec(cl);
%     end
%     cldat.dat(cldat.dat ~= 0) = 1;
%     cldat.fullpath = fname;
%     write(cldat);

% old method: this is much faster
    P = which('brainmask.nii');
    % P = which('weights_NSF_grouppred_cvpcr.img');
    V = spm_vol(P);
    V = V(1);
    V(1).private = [];
    V(1).fname = fname;

    clusters2mask(cl,V,0,fname);

elseif dounique
    try
        cldat = region2imagevec(cl(1));
    catch
        cl(1) = cluster2region(cl(1));
        cldat = region2imagevec(cl(1));
    end
    cldat = replace_empty(cldat);
    dat = cldat;
    dat.dat = zeros(size(dat.dat));
    
    for i = 1:numel(cl)
        cldat = region2imagevec(cl(i));
        cldat.dat(cldat.dat ~= 0) = 1;
        cldat = replace_empty(cldat);
        dat.dat(cldat.dat ~=0) = i;
    end
    
    dat.fullpath = fname;
    write(dat);
end

end

