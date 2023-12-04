function F=FeatureExtraction(I)
% Compute a row-vector of feature values for an image I

    %I2 = bwskel(I,'MinBranchLength',4);
    F2 = ShapeFeats(I);
    F3=hu_moments(I);

    F=[ F2 F3];
    F =  normalize(F, "scale");
end


% Subfunction, compute a selected set of shape features of a binary region S
function F=ShapeFeats(S)
	fts={'Area', 'Perimeter', 'Solidity','Centroid','MajorAxisLength', 'MinorAxisLength'}; % List of features we wish to compute
	Ft=regionprops('Table',S,fts{:}); % Extract the features from a BW image (e.g., from imbinarize(...))
	[~,idx]=max(Ft.Area); % Region with largest Area
	F=[Ft(idx,:).Variables]; % Only using the one region with largest Area
end