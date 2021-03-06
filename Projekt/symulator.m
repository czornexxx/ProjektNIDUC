% *************************************************************************
% ************************** Symulator ************************************
% *************************************************************************

budzet = 100;                                % bud�et 
n = 4;                                      % Ilo�� el. Zgoda z plikiem
kosztyEl = [15 10 11 14];                          % koszt elementow

% wygenerowanie macierzy wektorow
macierzWektorow = generujWektory(kosztyEl, budzet);

tmp = size(macierzWektorow);                % odczytanie ilosci potencjalnych wektor�w
iloscW = tmp(1);                            % ilo�� potencjalnych wektor�w

for a=1 :10                                 % Przeprowadzenie symulacji 20 razy
  
clear wynik;
wynik = 0;
% przeprowadzanie symulacji
    for i=1 :iloscW
        wynik(i,1) = symulacjaCzasu(macierzWektorow(i,:),1);
        wynik(i,2) = i;
    end;

i = max(wynik(:,1));                         % wybranie najd�u�szego czasu

    for k=1 :iloscW                         % wyszukanie wektora odpowiadaj�cego max czas.
        if(wynik(k,1) == i)
            break;    
        end;
    end;
    
% wyszukanie najcz�ciej powtarzaj�cego si� wektora
macWyniki(a,:) =  macierzWektorow(wynik(k,2),:);
end;

maxWektor = mode(macWyniki);

% G��wna symulacja przeprowadzona 1000x
for a=1 : 1000
    
    wynikWektor(a) = symKonserwatory(maxWektor);   
end;

% Wygenerowanie histogramu
hist(wynikWektor);

% Zapis wynik�w do pliku 
plik = fopen('czasySymulacji.txt', 'w'); 
for j=1 :a 
   
    fprintf(plik, '%6.2f', wynikWektor(j));
    fprintf(plik, '\n');
    
end;
fclose(plik);

