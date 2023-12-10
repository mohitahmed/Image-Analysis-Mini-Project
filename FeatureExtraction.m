function F=FeatureExtraction(I)

    F1 = ShapeFeats(I);
    F2=hu_moments(I);
    F=[F1 F2];
    F =  normalize(F, "scale");
end

function F=ShapeFeats(S)
	fts={'Area', 'Perimeter', 'Solidity','Centroid','MajorAxisLength', 'MinorAxisLength'}; 
    Ft=regionprops('Table',S,fts{:});
	[~,idx]=max(Ft.Area);
	F=[Ft(idx,:).Variables];
end

