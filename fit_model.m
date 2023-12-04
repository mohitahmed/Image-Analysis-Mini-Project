function Mdl=fit_model(train_patterns, train_labels)
    X_train=[];
    Y_train={};
    for i=1:length(train_patterns)
        preprocessed_image = extractDigits1(train_patterns{i}); 
        for j=1:3
            X_train(end+1,:) = preprocessed_image(j,:);
            Y_train{end+1} = num2str(train_labels(i,j));
        end
    
    end
    
    k=3;
    Mdl = fitcknn(X_train,Y_train, 'NumNeighbors',k, 'BreakTies','nearest');
    
end
