

% bud¿et 
budzet = 20;
n = 3; 
%koszt elementow
kosztyEl = [5 5 5];

% wygenerowanie macierzy wektorow
macierzWektorow = generujWektory(kosztyEl, budzet);

tmp = size(macierzWektorow);
iloscW = tmp(1);


for a=1 :20
  
clear wynik;
    
wynik = 0;
% przeprowadzanie symulacji
for i=1 :iloscW
    
    wynik(i,1) = symulacjaCzasu(macierzWektorow(i,:),1);
    wynik(i,2) = i;

end;

i = max(wynik(:,1))

for k=1 :iloscW
    
    if(wynik(k,1) == i)
        break;    
    end;
end;
macierzWektorow(wynik(k,2),:)

end;