% *************************************************************************
% *********************** Przegl�d Zupe�ny ********************************
% *************************************************************************

budzet = 20;                                % bud�et 
n = 3;                                      % Ilo�� el. Zgoda z plikiem
kosztyEl = [5 5 5];                         % koszt elementow
% wygenerowanie macierzy wektorow
macierzWektorow = generujWektory(kosztyEl, budzet);

tmp = size(macierzWektorow);                % odczytanie ilosci potencjalnych wektor�w
iloscW = tmp(1);                            % ilo�� potencjalnych wektor�w

for a=1 :20                                 % Przeprowadzenie symulacji 20 razy
  
clear wynik;
wynik = 0;
% przeprowadzanie symulacji
    for i=1 :iloscW
        wynik(i,1) = symulacjaCzasu(macierzWektorow(i,:),1);
        wynik(i,2) = i;
    end;

i = max(wynik(:,1))                         % wybranie najd�u�szego czasu

    for k=1 :iloscW                         % wyszukanie wektora odpowiadaj�cego max czas.
        if(wynik(k,1) == i)
            break;    
        end;
    end;
    
macierzWektorow(wynik(k,2),:)               % wypisanie tego wektora na konsoli.
end;