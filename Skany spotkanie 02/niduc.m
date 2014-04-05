clear
%Ustalamy maksymalny czas symulacji oraz ilosc symulacji.
Tsym = 500;
Lsym = 1;

%Dobieramy rozkłady prawdopodobieństwa dla czasu poprawnej pracy systemu 
%i czasu naprawy.
F = 1;
G = 100;

%Ustalamy sciezki zapisu plikow zawierajacych czasy do uszkodzenia - tff 
%oraz czasów do naprawy - ttr.
sciezka_ttf = sprintf('wyniki\\ttf.txt');
[file_ttf, wiadomosc] = fopen(sciezka_ttf,'w');
%Sprawdzenie poprawności otwarcia
if file_ttf == -1
    disp(wiadomosc)
    return;
end;

sciezka_ttr = sprintf('wyniki\\ttr.txt');
[file_ttr, wiadomosc] = fopen(sciezka_ttr,'w');
if file_ttr == -1
    disp(wiadomosc)
    return;
end;
 
czasSprawnego = 0;
czasUszkodzonego = 0;
clc

%Wlaściwa część programu będąca implementacją systemu


for L = 1:Lsym 
  
    %Inicjalizacja zmiennych.
    K =3; %liczba konserwatorow
    T = 0; %czas symulacji
    CZ=100;%ilosc czesci zamiennych
    tx = 0; %bieżca chwila (minimum z wylosowanych momentów)
    LO = 0; %liczba oczekujących na napraw
    S = [0,0,0,0]; %stany poszczególnych elementów systemu
    Tx = [1,2,3,10]; %czasy uszkodzenia (najblizszego wydarzenia)
    
     %Losowanie momentow uszkodzenia
    for i = 1:4
        Tx(i) = wblrnd(F,G);
    end
          x = -1;
    %Ustalenie sciezki zapisu dla plikow wynikowych symulacji
    sciezka_proba = sprintf('wyniki\\sym%d.txt',L);
    [file_proba, wiadomosc] = fopen(sciezka_proba,'w');
    if file_proba == -1
        disp(wiadomosc)
        return;
    end;
    
    %Zmienna przechowujaca ilosc elementow sprawnych
    sprawne = 0;
    
    for i = 2:4
        %Jesli stan elementu jest rowny 0 (jest sprawny) zwiekszamy
        %zmienna sprawne o 1
        if S(i) == 0
           sprawne = sprawne + 1;
        end
    end
    %W przypadku gdy każdy element jest sprawny
    %cały system jest sprawny 
    if sprawne == 3
        stan = 0;
    %w przeciwnym wypadku uk?ad jest niesprawny
    else
        stan = 1;
    end
    %Zapisujemy wyniki do pliku w postaci: stan systemu,stany czujników, czas od momentu startu symulacji.
    fprintf(file_proba,'%d\t%d\t%d\t%d\t%d\t%f\r\n',stan,S(1),S(2),S(3),S(4),T);
     %Dopóki czas jest mniejszy od maksymalnego czasu symulacji
    while T < Tsym & CZ > 0
        
        tx = 2*Tsym;
        
        %Szukamy minimum z czasów uszkodzenia
        for i = 1:4
            if Tx(i) < tx
                x = i;
                tx = Tx(i);
            end
        end
         %Sprawdzamy czy urzadzenie w chwili tx_ było sprawne
        if S(x) == 0
            
            %liczba konserwatorów jest większa od 0. Jeśli tak, oznacza to, że
            %urządzenie się zepsuło - musimy je więc naprawić. Zmniejszamy
            %liczbę dostepnych konserwatorów i losujemy czas naprawy.
            %Zaznaczamy stan elementu jako 1 (w naprawie)
            if S(1) == 0 && K>0
                K = K-1;
                Tx(x) = wblrnd(F,G); + tx;
                --CZ;
                S(x) = 1;
            %W przeciwnym razie zwiększamy liczbę oczekujących na naprawę
            %i oznaczamy stan elementu jako 2 (czekający na naprawę)
            else
                Tx(x) = 5*Tsym;
                LO = LO+1;
                S(x) = 2;
            end
            %Gdy element systemu będzie naprawiony losujemy czas poprawnej pracy,
            %zwiększamy liczbe konserwatorów i oznaczamy stan elementu 0
            %(sprawny)
        else
            K = K+1;
            Tx(x) = wblrnd(F,G); + tx;
            S(x) = 0;
        end

        %Jeśli układ diagnostyki oczekuje na naprawę i są dostępni
        %konserwatorzy, naprawiamy ten układ. Wynika z tego, że układ
        %diagnostyki ma priorytet jeśli chodzi o kolejność wykonywanych
        %napraw.
        if S(1) == 2 && K > 0
            K = K - 1;
            Tx(1) = exprnd(G) + tx;
            S(1) = 1;
            LO = LO - 1;
        end
        
        i = 2;
        %Dopuki liczba oczekujacych na naprawę czujników jest większa od 0, układ
        %diagnostyki jest sprawny i są dostępni konserwatorzy, naprawiamy
        %poszczeg?lne elementy systemu w kolejności: 1-wszy, 2-gi, 3-ci czujnik.
        while LO > 0 && S(1) == 0 && K > 0
            if S(i) == 2
                K = K - 1;
                Tx(i) = exprnd(G) + tx;
                S(i) = 1;
                LO = LO - 1;
            end
            i = i + 1;
        end

        %Zwiększamy czas od startu systemu
        T = T + tx;
        %Zmniejszamy czasy najbliższego wydarzenia
        for i = 1:4
            Tx(i) = Tx(i) - tx;
        end

        %Zliczamy czujniki sprawne
        sprawne = 0;
        for i = 2:4
            if S(i) == 0
                sprawne = sprawne + 1;
            end
        end

        %Gdy liczba sprawnych czujników jest równa 3 system
        %jest sprawny.
        if sprawne == 3
            stan = 0;
        else
            stan = 1;
        end

        %wpisanie wyników do pliku
        fprintf(file_proba,'%d\t%d\t%d\t%d\t%d\t%f\r\n',stan,S(1),S(2),S(3),S(4),T);
    end

    fclose(file_proba);
    
    %Otwieramy plik z wynikami konkretnej próby
    [file_proba, wiadomosc] = fopen(sciezka_proba,'r');
    if file_proba == -1
        disp(wiadomosc)
        return;
    end

    %Z pliku zczytujemy wartości do tablicy
    tab = fscanf(file_proba,'%d%d%d%d%d%f',[ 6 inf ]);
    fclose(file_proba);
    tab = tab';
    rozmiar = size(tab,1);
    ostatniStan = tab(1,1); %Pierwszy stan systemu
    ostatniRazSprawny = 0;  %Moment ostatniej sprawności
    ostatniRazUszkodzony = 0;%Moment ostatniego uszkodzenia

    %W tym miejscu obliczymy poszczególne czasy do uszkodzenia i czasy do
    %naprawy - TTF oraz TTR
    for i = 2:rozmiar
        %Zczytujemy czas od momentu startu symulacji
        czas = tab(i,6);
        %oraz stan systemu
        stan = tab(i,1);
        %Jeśli ostatni odczytany stan różni się od biezacego sprawdzamy czy
        %jest rowny 1 jeali tak zapisujemy do pliku obliczona wartosc TTF. W
        %przeciwnym razie - wartoscTTR
        if ostatniStan ~= stan
            if stan == 1
                czasSprawnego = (czas - ostatniRazSprawny);
                ostatniRazUszkodzony = czas;
                fprintf(file_ttf,'%f\r\n',czasSprawnego);
            else
                czasUszkodzonego = (czas - ostatniRazUszkodzony);
                ostatniRazSprawny = czas;
                fprintf(file_ttr,'%f\r\n',czasUszkodzonego);
            end
        end
        ostatniStan = stan;
    end
end
fclose(file_ttf);
fclose(file_ttr);

%Otwieramy pliki z wartosciami TTF oraz TTR
sciezka_ttf = sprintf('wyniki\\ttf.txt');
[file_ttf, wiadomosc] = fopen(sciezka_ttf,'r');
if file_ttf == -1
    disp(wiadomosc)
    return;
end;

sciezka_ttr = sprintf('wyniki\\ttr.txt');
[file_ttr, wiadomosc] = fopen(sciezka_ttr,'r');
if file_ttr == -1
    disp(wiadomosc)
    return;
end;

%Zapisujemy wartosci TTF oraz TTR w tablicy
ttf = fscanf(file_ttf,'%f',[ 1 inf ]);
ttf = ttf';

ttr = fscanf(file_ttr,'%f',[ 1 inf ]);
ttr = ttr';

fclose(file_ttf);
fclose(file_ttr);



x = 0:(size(ttf)-1);
dfittool



