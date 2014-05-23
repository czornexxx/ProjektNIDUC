% *************************************************************************
% *********************** Przegl¹d Zupe³ny ********************************
% *************************************************************************

budzet = 300;                                % bud¿et 
n = 4;                                      % Iloœæ el. Zgoda z plikiem
kosztyEl = [5 7 10 15];                         % koszt elementow
% wygenerowanie macierzy wektorow
macierzWektorow = generujWektory(kosztyEl, budzet);

tmp = size(macierzWektorow);                % odczytanie ilosci potencjalnych wektorów
iloscW = tmp(1);                            % iloœæ potencjalnych wektorów

for a=1 :20                                 % Przeprowadzenie symulacji 20 razy
  
clear wynik;
wynik = 0;
% przeprowadzanie symulacji
    for i=1 :iloscW
        wynik(i,1) = symulacjaCzasu(macierzWektorow(i,:),1);
        wynik(i,2) = i;
    end;

i = max(wynik(:,1));                         % wybranie najd³u¿szego czasu

    for k=1 :iloscW                         % wyszukanie wektora odpowiadaj¹cego max czas.
        if(wynik(k,1) == i)
            break;    
        end;
    end;
    
% wyszukanie najczêœciej powtarzaj¹cego siê wektora
macWyniki(a,:) =  macierzWektorow(wynik(k,2),:);               % wypisanie tego wektora na konsoli.
end;

maxWektor = mode(macWyniki)


for a=1 : 1000
    
    wynikWektor(a) = symKonserwatory(maxWektor)   
    
end;

hist(wynikWektor);


plik = fopen('czasySymulacji.txt', 'w'); 
for j=1 :a 
   
    fprintf(plik, '%6.2f', wynikWektor(j));
    fprintf(plik, '\n');
    
end;
fclose(plik);

