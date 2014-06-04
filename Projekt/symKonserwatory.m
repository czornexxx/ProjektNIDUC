function [ czasPracyUkladu ] = symKonserwatory( wektorCzesci )
%SYMKONSERWATORY Summary of this function goes here
%   Detailed explanation goes here

rozkladKonserwatorow = [10 20]; 

wiersz = 1;
% Wczytanie z pliku rozk³adów dla ka¿dego el. 

fclose('all');
% odczytanie danych z pliku
[data,vname,cname] = tblread('dane.txt');

n = data(1,1);      %iloœæ elementów
iloscKonserwatorow = data(1,2);      %iloœæ konserwatorów

for j=2 :(n+1)      % wczytanie danych o elementach
    for l=1 :2
        elementy((j-1),l) = data(j,l);      % wczytanie wartosci kazdego elementu
    end;
end;

%**************************************************************************
%*                                 Symulator                              *
%**************************************************************************

czasDzialania = 0;
dziala = 1;
brakKons = 0;
% Za³adowanie tablicy zdarzeñ

for j=1 : n
    
    tabZdarzen(1,j) = 0;
    tabZdarzen(2,j) = wblrnd(elementy(j,1), elementy(j,2));
    
end;

while dziala == 1
    
    
   [wTMin,indexMin]= min(tabZdarzen(2,:)); 
   
   if(tabZdarzen(1,indexMin) == 0 )                 % element by³ sprawny uleg³ uszkodzneiu
   
       if(wektorCzesci(indexMin) == 0)              % sprzwdzenie czy s¹ dostêpne el. w magazynie
           dziala = 0;
           break;
       end;
       
    if(iloscKonserwatorow > 0)
        tabZdarzen(1,indexMin) = 1;
        iloscKonserwatorow = iloscKonserwatorow - 1;
               
        % aktualizacja czasow w tablicy
        tabZdarzen(2,:) = tabZdarzen(2,:) - wTMin; 
        
        % wylosowanie czasu naprawy el. 
        tabZdarzen(2,indexMin) = wblrnd(rozkladKonserwatorow(1), rozkladKonserwatorow(2));
        czasDzialania = czasDzialania + wTMin;      % zapisanie czasu zdarzenia 
        
        
        % zapisanie histori zdarzen do macierzy
        macHistoria(wiersz,1) = czasDzialania;
        for x=2 :(n+1)
            macHistoria(wiersz,x) = tabZdarzen(1,(x-1));
        end;
        wiersz = wiersz + 1; 
                
        
    else
        tabZdarzen(1,indexMin) = 2;
        tabZdarzen(2,indexMin) = 9999999999;
        
        % aktualizacja czasow w tablicy
        tabZdarzen(2,:) = tabZdarzen(2,:) - wTMin; 
        czasDzialania = czasDzialania + wTMin;      % zapisanie czasu zdarzenia 
        
        % zapisanie histori zdarzen do macierzy
        macHistoria(wiersz,1) = czasDzialania;
        for x=2 :(n+1)
            macHistoria(wiersz,x) = tabZdarzen(1,(x-1));
        end;
        wiersz = wiersz + 1;
        
        brakKons = 1;
    end;
    
  end;
  
    [wTMin,indexMin]= min(tabZdarzen(2,:)); 
  
   if(tabZdarzen(1,indexMin) == 1)                  % element by³ uszkodzony zosta³ naprawiony  
  
        wektorCzesci(indexMin) = wektorCzesci(indexMin) - 1;    % odejmujemy czesc z magazynu

        % aktualizacja czasow w tablicy
        tabZdarzen(2,:) = tabZdarzen(2,:) - wTMin; 
        tabZdarzen(1,indexMin) = 0;                 % el. zosta³ naprawiony, dzia³a poprawnie
            % wylosowanie czasu naprawy el. 
        tabZdarzen(2,indexMin) =  wblrnd(elementy(indexMin,1), elementy(indexMin,2));
        czasDzialania = czasDzialania + wTMin;      % zapisanie czasu zdarzenia 


            % zapisanie histori zdarzen do macierzy
        macHistoria(wiersz,1) = czasDzialania;
        for x=2 :(n+1)
             macHistoria(wiersz,x) = tabZdarzen(1,(x-1));
        end;
        wiersz = wiersz + 1; 
        
    iloscKonserwatorow = iloscKonserwatorow + 1;   % konserwator jest wolny
       
   end;
    
   if(brakKons)             % jeœli nie bylo konserwatorow to sprawczy czy sa
       
       if(iloscKonserwatorow > 0)
           
           tmp = find(tabZdarzen(1,:) == 2);
           [uio, iloscOczekujacych] = size(tmp);

           if(iloscOczekujacych > 0)
               
               tabZdarzen(1,tmp(1)) = 1;        % element bedzie naprawiany
               tabZdarzen(2,tmp(1)) = wblrnd(rozkladKonserwatorow(1), rozkladKonserwatorow(2));
               
               iloscKonserwatorow = iloscKonserwatorow - 1;
           else
               brakKons = 0;
           end;
           
       end;      
   end;
   
    
end;


plik = fopen('historia.txt', 'w'); 
for j=1 :(wiersz -1)
    fprintf(plik, '%6.2f', macHistoria(j,1));
        for i=2 :n+1
             fprintf(plik, '%6.0f', macHistoria(j,i));
        end;
   fprintf(plik, '\n');
end;

fclose(plik);

czasPracyUkladu = czasDzialania;

end

