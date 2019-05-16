clear
clc

a = importdata('C:\Users\Usuario\Desktop\Projeto Final\3-cdigosdehoje-06-10\constantes2.mat');
const = a.constantes;
m = (a.m)';
erro = zeros(size(const));
erro(1:2,:) = const(1:2,:);

for i = 1:size(const,2),
  
    erro(3,i) = 100*abs(m(1,1)-const(3,i))/m(1,1);
    erro(4,i) = 100*abs(m(2,1)-const(4,i))/m(2,1);
    erro(5,i) = 100*abs(m(3,1)-const(5,i))/m(3,1);
    
end

erro
