function [ srednia ] = symulacjaCzasu(magazyn, funkcja)

% jeœli funkcja = 0, to wczytuj z pliku magazyn, i zwracaj œrednia.
% jeœli funkcja = 1, to magazyn jest podany w arg. 

if(funkcja == 1)
fclose('all');
% odczytanie danych z pliku
[data,vname,cname] = tblread('dane.txt');

n = data(1,1);      %iloœæ elementów
k = data(1,2);      %iloœæ konserwatorów

for j=2 :(n+1)
    
    for l=1 :2
    elementy((j-1),l) = data(j,l);      % wczytanie wartosci kazdego elementu
    end;
end;

ltmp = 1;
%Czyszczenie danych
for h=1 :30

clear czasZycia;
clear cname;
clear vname;
clear data;
clear plik;
clear magazyn1;
%losowanie czasów ¿ycia elemntów

magazyn1 = magazyn;

for i=1 :n
    czasZycia(i) = wblrnd(elementy(i,1), elementy(i,2));
end;

% Symulacja pracy uk³adu

wynik(ltmp, 1) = -99;
wynik(ltmp, 2) = h;
wynik(ltmp, 3) = -99;
ltmp = ltmp + 1;
czas = 0;
dziala = 1;

while dziala == 1
    
    czas = czas + 0.01;         % zwiekszenie czasu dzialania
    for i=1 :n                  % odejmowanie czasu zycia elementow
        czasZycia(i) = czasZycia(i) - 0.01; 
    end;
    
    for i=1 :n
        if(czasZycia(i) <= 0)    % czy skoñczy³ siê czas ¿ycia elementu
            if(magazyn1(i) == 0 )   % jeœli brak elementow to zakoncz pêtle
                dziala = 0;
           
            % Dopisanie ostatniego elementu który siê skoñczy³
                wynik(ltmp,1) = czas;
                 for l=1 :(n+1)
                      if(l == i)
                          wynik(ltmp,(l+1)) = 1;
                      else
                          wynik(ltmp,(l+1)) = 0;
                      end;
                  end;
                  ltmp = ltmp + 1;
                
            else
                magazyn1(i) = magazyn1(i) - 1;    
                wynik(ltmp,1) = czas;
                for l=1 :(n+1)
                    if(l == i)
                        wynik(ltmp,(l+1)) = 1;
                    else
                        wynik(ltmp,(l+1)) = 0;
                    end;
                end;
                ltmp = ltmp + 1;
                % losowanie nowego czasu zycia elementu
                czasZycia(i) =  wblrnd(elementy(i,1), elementy(i,2));
            end;
        end;
    end;
      
    j = j+1;
end;

wynikCaly(h) = czas;

end;

% Zapisywanie do pliku przebiegu symulacji.
% save('wynik.txt','wynik','-ascii');
plik = fopen('wynik.txt', 'w'); 
for j=1 :(ltmp -1)
    fprintf(plik, '%6.2f', wynik(j,1));
    for i=2 :n+1
         fprintf(plik, '%6.0f', wynik(j,i));
    end;
   fprintf(plik, '\n');
end;

fclose(plik);

suma = 0;
for i=1 :h
    suma = suma + wynikCaly(i);
end;
srednia = suma/h;

hist(wynikCaly,5);
end;

% *************************************************************************
if(funkcja == 0)
    
clc;
clear;
fclose('all');
% odczytanie danych z pliku
[data,vname,cname] = tblread('dane.txt');

n = data(1,1);      %iloœæ elementów
k = data(1,2);      %iloœæ konserwatorów

for j=2:(n+1)
    
    for l=1:3
    elementyBazowe((j-1),l) = data(j,l);      % wczytanie wartosci kazdego elementu
    end;
end;

ltmp = 1;
%Czyszczenie danych
for h=1 :100

clear elementy;
clear czasZycia;
clear cname;
clear vname;
clear data;
clear plik;

%losowanie czasów ¿ycia elemntów

elementy = elementyBazowe;

for i=1 :n
    czasZycia(i) = wblrnd(elementy(i,1), elementy(i,2));
end;

% Symulacja pracy uk³adu

wynik(ltmp, 1) = -99;
wynik(ltmp, 2) = h;
wynik(ltmp, 3) = -99;
ltmp = ltmp + 1;
czas = 0;
dziala = 1;

while dziala == 1
    
    czas = czas + 0.01;         % zwiekszenie czasu dzialania
    for i=1 :n                  % odejmowanie czasu zycia elementow
        czasZycia(i) = czasZycia(i) - 0.01; 
    end;
    
    for i=1 :n
        if(czasZycia(i) <= 0)    % czy skoñczy³ siê czas ¿ycia elementu
            if(elementy(i,3) == 0 )   % jeœli brak elementow to zakoncz pêtle
                dziala = 0;
           
            % Dopisanie ostatniego elementu który siê skoñczy³
                wynik(ltmp,1) = czas;
                 for l=1 :i
                      if(l == i)
                          wynik(ltmp,(i+1)) = 1;
                      else
                          wynik(ltmp,(i+1)) = 0;
                      end;
                  end;
                  ltmp = ltmp + 1;
                
            else
                elementy(i,3) = elementy(i,3) - 1;    
                wynik(ltmp,1) = czas;
                for l=1 :i
                    if(l == i)
                        wynik(ltmp,(i+1)) = 1;
                    else
                        wynik(ltmp,(i+1)) = 0;
                    end;
                end;
                ltmp = ltmp + 1;
                % losowanie nowego czasu zycia elementu
                czasZycia(i) =  wblrnd(elementy(i,1), elementy(i,2));
            end;
        end;
    end;
      
    j = j+1;
end;

wynikCaly(h) = czas;

end;

% Zapisywanie do pliku przebiegu symulacji.
% save('wynik.txt','wynik','-ascii');
plik = fopen('wynik.txt', 'w'); 
for j=1 :(ltmp -1)
    fprintf(plik, '%6.2f', wynik(j,1));
for i=2 :n+1
     fprintf(plik, '%6.0f', wynik(j,i));
end;
   fprintf(plik, '\n');
end;

fclose(plik);

suma = 0;
for i=1 :h
    suma = suma + wynikCaly(i);
end;
srednia = suma/h;

hist(wynikCaly,40);
    
end;
end

