%           stany 0 sprawy 1 uszkodzony w naprawie 2 uszkodzony oczekujacy
t_zak_kons_1=0;
t_zak_kons_2=0;
flaga_nowy =false;
flaga_symulacja=true;
ilosc_elementow = [ 125 169 178 ];
suma=ilosc_elementow(1)+ilosc_elementow(2)+ilosc_elementow(3);
Tab_cz_z= [0 0 0];
Tab_cz_n= [0 0 0];
%Konserwatorzy_czas_zak=[0 0 0 0];%czas zakonczenia pracy na pozycji 2 i 4 numer elementu na nieparzystych
S  = [0 0 0];%0 sprawne 1 uszkodzone 2 w naprawie
macierz_glowna=zeros(suma,3);%wszystkie czasy życia , czas naprawy i numer elementu
macierz_glowna_prim=zeros(2*suma,5); %czas     numer elementu zmienionego stany elementów
t_symulacji=50000;
ilosc_konserwatorow =2;

%           czas życia i naprawy każdego elementu
for i=1:suma
          
          Tab_zd_cz_z = [round(wblrnd(1000,2)) round(wblrnd(1000,2)) round(wblrnd(1000,2))]; %czas życia
          Tab_zd_cz_n = [round(wblrnd(100,2)) round(wblrnd(100,2)) round(wblrnd(100,2))];       %czas naprawy
          mi_zycie= min(Tab_zd_cz_z );
          for j=1:3
                    
                    if  Tab_zd_cz_z (j) ==  mi_zycie
                              mi=j;
                    end;
                    
          end;
          macierz_glowna(i,1)=mi_zycie;
          macierz_glowna(i,2)=Tab_zd_cz_n(mi);
          macierz_glowna(i,3)=mi;
          
          
          
          
          
end;
%           czas wystapienia uszkodzenia i zakonczenia naprawy każdego elementu bez
%           uwzglednienia konserwatorów i ilosci czesci zamiennych
flaga =true;

for i=1:suma
          
          if flaga
                    if i>1
                              macierz_glowna(i,1)=macierz_glowna(i,1)+macierz_glowna(i-1,1);
                              macierz_glowna(i,2)=macierz_glowna(i,2)+ macierz_glowna(i-1,2);
                    end;
                    if macierz_glowna(i,3)==1
                              
                              ilosc_elementow(1)=ilosc_elementow(1)-1;
                              
                    end;
                    if macierz_glowna(i,3)==2
                              
                              ilosc_elementow(2)=ilosc_elementow(2)-1;
                    end;
                    if macierz_glowna(i,3)==2
                              
                              ilosc_elementow(3)=ilosc_elementow(3)-1;
                              
                    end;
          end;
          if min(ilosc_elementow)==0 ||macierz_glowna(i,1)> t_symulacji
                    flaga=false;
                    
          end;
          if flaga==false
                    macierz_glowna(i,1)=0 ;
                    macierz_glowna(i,2)=0 ;
                    macierz_glowna(i,3)=0 ;
          end;
          
          
          
          
end;
j=1;
%  petla itworzaca wszystkie zdarzenia teoretyczne czyli uszkodzenia i
%  naprawy nie uwzgledniajaca konserwatorow

indeks=1;
for i=1:suma
          
          
          %uszkodzenie
          macierz_glowna_prim(indeks,1)=macierz_glowna(i,1);
          
          if macierz_glowna(i,3)==1 || macierz_glowna(i,3)==2 || macierz_glowna(i,3)==3
                    
                    S(macierz_glowna(i,3))=1;
          end;
          
          macierz_glowna_prim(indeks,2)=macierz_glowna(i,3);
          macierz_glowna_prim(indeks,3)=S(1);
          macierz_glowna_prim(indeks,4)=S(2);
          macierz_glowna_prim(indeks,5)=S(3);
          indeks=indeks+1;
          
          
          %naprawa
          macierz_glowna_prim(indeks,1)=macierz_glowna(i,1)+ macierz_glowna(i,2);
          if macierz_glowna(i,3)==1 || macierz_glowna(i,3)==2 || macierz_glowna(i,3)==3
                    S(macierz_glowna(i,3))=0;
          end;
          macierz_glowna_prim(indeks,2)=macierz_glowna(i,3);
          macierz_glowna_prim(indeks,3)=S(1);
          macierz_glowna_prim(indeks,4)=S(2);
          macierz_glowna_prim(indeks,5)=S(3);
          
          indeks=indeks+1;
          
          
          
          
          
          
          
          
end;

%usuniecie elementow zerowych
macierz_glowna_prim=sortrows(macierz_glowna_prim,1);
macierz_glowna_secans =  macierz_glowna_prim( all( macierz_glowna_prim(:,1:2) ~= 0,2),:);
wymiary=size(macierz_glowna_secans );
wiersz=wymiary(1);
%uwzgledniajaca konserwatorow
macierz_glowna_tertio=zeros(2*wiersz,5);
%petla tworzaca ostateczny wynik
%indeksem macierzy ostatecznego wyniku jest j 

j=1;
for i=1:wiersz
          
          
          %jesli wystapiło uszkodenie a mamy wolnych konserwrorów
          %zapisujemy dane zdarzenie
          if macierz_glowna_secans(i, macierz_glowna_secans(i,2)+2)==1 && ilosc_konserwatorow>0 ;
                    
                    %zmniejszamy ilosc dostepnych konserwatorow
                    ilosc_konserwatorow=ilosc_konserwatorow-1;
                    %zapisujemy stan
                    S(macierz_glowna_secans(i,2))= macierz_glowna_secans(i, macierz_glowna_secans(i,2)+2);
                    macierz_glowna_tertio(j,1)=macierz_glowna_secans(i,1);
                    macierz_glowna_tertio(j,2)=macierz_glowna_secans(i,2);
                    macierz_glowna_tertio(j,3)=S(1);
                    macierz_glowna_tertio(j,4)=S(2);
                    macierz_glowna_tertio(j,5)=S(3);
                    j=j+1;
                    
          end;
          
          %jesli wystapiło uszkodenie i nie mamy wolnych konserwatorów
          %stan danego elementu zapisujemy jako 2
          if macierz_glowna_secans(i, macierz_glowna_secans(i,2)+2)==1 && ilosc_konserwatorow==0 ;
                   
                    S(macierz_glowna_secans(i,2))=2;
                    macierz_glowna_tertio(j,1)=macierz_glowna_secans(i,1);
                    macierz_glowna_tertio(j,2)=macierz_glowna_secans(i,2);
                    macierz_glowna_tertio(j,3)=S(1);
                    macierz_glowna_tertio(j,4)=S(2);
                    macierz_glowna_tertio(j,5)=S(3);
                    j=j+1;
                    %w macierzy secans czas zakonczenia naprawy to czas
                    %zwolnienia konserwtora + czas naprawy
                    
                    
                   
                    pierwszy=false;
                    %szukamy więc min czasu zakonczenia naprawy 
                    for k=i:1
                              if macierz_glowna(macierz_glowna_secans(k,2)+2)==0 && pierwszy==false
                                        t_zak_kons_1=macierz_glowna_secans(k,1);
                                        
                              end;
                              
                              if macierz_glowna(macierz_glowna_secans(k,2)+2)==0 && pierwszy==true
                                        
                                        t_zak_kons_2=macierz_glowna_secans(k,1);
                                        
                                        
                                        break;
                              end;
                              
                    end;
                  
                    
                    
          end;
          
          %jesli wystapiło zakończenie naprawy stan danego elementu zapisujemy jako 0
          %zwiekszamy ilość dostepnych konserwatorów
          
          if macierz_glowna_secans(i, macierz_glowna_secans(i,2)+2)==0  ;
                    
                    if  S(macierz_glowna_secans(i,2))==2
                      %do pom przypisujemy mniejszy z czasów zakonczenia
                    %naprawy
                    pom=min(t_zak_kons_1,t_zak_kons_2);
                   
                    %zapisujemy czas numer elementu i stany elementów
                    S(macierz_glowna_secans(i,2))=0;
                    macierz_glowna_tertio(j,1)=macierz_glowna_secans(i,1)+pom;
                    macierz_glowna_tertio(j,2)=macierz_glowna_secans(i,2);
                    macierz_glowna_tertio(j,3)=S(1);
                    macierz_glowna_tertio(j,4)=S(2);
                    macierz_glowna_tertio(j,5)=S(3);
                    
                    %zwiekszamy ilosc konserwatorów
                    ilosc_konserwatorow=ilosc_konserwatorow+1;
                    j=j+1;
                    end;
                    
                    if  S(macierz_glowna_secans(i,2))~=2
                    %zapisujemy czas numer elementu i stany elementów
                    S(macierz_glowna_secans(i,2))=0;
                    macierz_glowna_tertio(j,1)=macierz_glowna_secans(i,1);
                    macierz_glowna_tertio(j,2)=macierz_glowna_secans(i,2);
                    macierz_glowna_tertio(j,3)=S(1);
                    macierz_glowna_tertio(j,4)=S(2);
                    macierz_glowna_tertio(j,5)=S(3);
                    
                    %zwiekszamy ilosc konserwatorów
                    ilosc_konserwatorow=ilosc_konserwatorow+1;
                    j=j+1;
                    end;
          end;       
end;

macierz_glowna_quatro=zeros(wiersz,1);
j=1;
for i=1:wiersz
          
    if max(macierz_glowna_tertio(i,3:5))~=0
    macierz_glowna_quatro(j,1)=macierz_glowna_tertio(i,1);
    j=j+1;
    end;
end;

%czasy zdarzen
figure(1);
hist(macierz_glowna_tertio(1:239,1));

%czasy uszkodzenia systemu
figure(2);     
hist(macierz_glowna_quatro(1:173,1));











