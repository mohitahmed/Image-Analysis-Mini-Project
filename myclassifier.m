function test_patterns =myclassifier(I, model)
  I=extractDigits1(I);
  test_patterns = [];
  for j=1:3
      im=I(j,:);
      test = predict(model,im);
      test_patterns(end+1)=str2num(test{1});
  end
end    

