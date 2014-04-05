clear
%Ustalamy maksymalny czas symulacji oraz liczb� symulacji.
Tsym = 500;
Lsym = 1000;

%Dobieramy rozk�ady prawdopodobie�stwa dla czasu poprawnej pracy systemu 
%i czasu naprawy.
F = 13;
G = 10;

%Ustalamy �cie�ki zapisu plik�w zawieraj�cych czasy do uszkodzenia - tff 
%oraz czas�w do naprawy - ttr.
sciezka_ttf = sprintf('wyniki\\ttf.txt');
[file_ttf, message] = fopen(sciezka_ttf,'w');
%Sprawdzenie poprawno�ci otwarcia
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

%Wla�ciwa cz�� programu b�d�ca implementacj� schematu blokowego dzia�ania
%systemu. 
for L = 1:Lsym 
    %Inicjalizacja zmiennych.
    K = 1; %liczba konserwator�w
    T = 0; %czas symulacji
    tx = 0; %bie��ca chwila (minimum z wylosowanych moment�w)
    LO = 0; %liczba oczekuj�cych na napraw�
    S = [0,0,0,0]; %stany poszczeg�lnych element�w systemu - pierwszy uk�ad diagnostyki, nast�pnie czujniki
    Tx = [1,2,3,10]; %czasy uszkodzenia (najblizszego wydarzenia)
    
    %Losowanie moment�w uszkodzenia
    for i = 1:4
        Tx(i) = exprnd(F);
    end

    x = -1;
    %Ustalenie �cie�ki zapisu dla plik�w wynikowych symulacji
    sciezka_proba = sprintf('wyniki\\sym%d.txt',L);
    [file_proba, wiadomosc] = fopen(sciezka_proba,'w');
    if file_proba == -1
        disp(wiadomosc)
        return;
    end;
    
    %Zmienna przechowuj�ca ilo�� element�w sprawnych
    sprawne = 0;
    
    for i = 2:4
        %Je�li stan elementu jest r�wny 0 (jest sprawny) zwi�kszamy
        %zmienn� sprawne o 1
        if S(i) == 0
           sprawne = sprawne + 1;
        end
    end
    
    %W przypadku gdy liczba czujnik�w sprawnych jest r�wna  przynajmniej 2
    %ca�y system jest sprawny (zasada '2z3')
    if sprawne > 1
        stan = 0;
    %w przeciwnym wypadku uk�ad jest niesprawny
    else
        stan = 1;
    end

    %Zapisujemy wyniki do pliku w postaci: stan systemu, stan uk�adu
    %diagnostyki, stany czujnik�w, czas od momentu startu symulacji.
    fprintf(file_proba,'%d\t%d\t%d\t%d\t%d\t%f\r\n',stan,S(1),S(2),S(3),S(4),T);
    
    %Dop�ki czas jest mniejszy od maksymalnego czasu symulacji
    while T < Tsym
        %zwi�kszamy bie��c� chwil�
        tx = 2*Tsym;
        
        %Szukamy minimum z czas�w uszkodzenia
        for i = 1:4
            if Tx(i) < tx
                x = i;
                tx = Tx(i);
            end
        end

        %Sprawdzamy czy urz�dzenie w chwili tx_ by�o sprawne
        if S(x) == 0
            %Sprawdzamy czy uk�ad diagnostyki by� sprawny i liczba
            %konserwator�w jest wi�ksza od 0. Je�li tak, oznacza to, �e
            %urz�dzenie si� zepsu�o - musimy je wi�c naprawi�. Zmniejszamy
            %liczb� dost�pnych konserwator�w i losujemy czas naprawy.
            %Zaznaczamy stan elementu jako 1 (w naprawie)
            if S(1) == 0 && K>0
                K = K-1;
                Tx(x) = exprnd(G) + tx;
                S(x) = 1;
            %W przeciwnym razie zwi�kszamy liczb� oczekuj�cych na napraw�
            %i oznaczamy stan elementu jako 2 (czekaj�cy na napraw�)
            else
                Tx(x) = 5*Tsym;
                LO = LO+1;
                S(x) = 2;
            end
        %Gdy element systemu by� uszkodzony losujemy czas poprawnej pracy,
        %zwi�kszamy liczbe konserwator�w i oznaczamy stan elementu 0
        %(sprawny)
        else
            K = K+1;
            Tx(x) = exprnd(F) + tx;
            S(x) = 0;
        end

        %Je�li uk�ad diagnostyki oczekuje na napraw� i s� dost�pni
        %konserwatorzy, naprawiamy ten uk�ad. Wynika z tego, i� uk�ad
        %diagnostyki ma priorytet je�li chodzi o kolejno�� wykonywanych
        %napraw.
        if S(1) == 2 && K > 0
            K = K - 1;
            Tx(1) = exprnd(G) + tx;
            S(1) = 1;
            LO = LO - 1;
        end
        
        i = 2;
        %Dop�ki liczba oczekuj�cych na napraw� czujnik�w jest wi�ksza od 0, uk�ad
        %diagnostyki jest sprawny i s� dost�pni konserwatorzy, naprawiamy
        %poszczeg�lne elementy systemu w kolejno�ci: 1-wszy, 2-gi, 3-ci czujnik.
        while LO > 0 && S(1) == 0 && K > 0
            if S(i) == 2
                K = K - 1;
                Tx(i) = exprnd(G) + tx;
                S(i) = 1;
                LO = LO - 1;
            end
            i = i + 1;
        end

        %Zwi�kszamy czas od startu systemu
        T = T + tx;
        %Zmniejszamy czasy najbli�szego wydarzenia
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

        %Gdy liczba sprawnych czujnik�w jest r�wna przynajmniej 2 system
        %jest sprawny.
        if sprawne > 1
            stan = 0;
        else
            stan = 1;
        end

        %wpisanie wynik�w do pliku
        fprintf(file_proba,'%d\t%d\t%d\t%d\t%d\t%f\r\n',stan,S(1),S(2),S(3),S(4),T);
    end

    fclose(file_proba);
    
    %Otwieramy plik z wynikami konkretnej pr�by
    [file_proba, wiadomosc] = fopen(sciezka_proba,'r');
    if file_proba == -1
        disp(wiadomosc)
        return;
    end

    %Z pliku zczytujemy warto�ci do tablicy
    tab = fscanf(file_proba,'%d%d%d%d%d%f',[ 6 inf ]);
    fclose(file_proba);
    tab = tab';
    rozmiar = size(tab,1);
    ostatniStan = tab(1,1); %Pierwszy stan systemu
    ostatniRazSprawny = 0;  %Moment ostatniej sprawno�ci
    ostatniRazUszkodzony = 0;%Moment ostatniego uszkodzenia

    %W tym miejscu obliczymy poszczeg�lne czasy do uszkodzenia i czasy do
    %naprawy - TTF oraz TTR
    for i = 2:rozmiar
        %Zczytujemy czas od momentu startu symulacji
        czas = tab(i,6);
        %oraz stan systemu
        stan = tab(i,1);
        %Je�li ostatni odczytany stan r�ni si� od bie��cego sprawdzamy czy
        %jest r�wny 1 je�li tak zapisujemy do pliku obliczon� warto�� TTF. W
        %przeciwnym razie - warto�� TTR
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

%Otwieramy pliki z warto�ciami TTF oraz TTR
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

%Zapisujemy warto�ci TTF oraz TTR w tablicy
ttf = fscanf(file_ttf,'%f',[ 1 inf ]);
ttf = ttf';

ttr = fscanf(file_ttr,'%f',[ 1 inf ]);
ttr = ttr';

fclose(file_ttf);
fclose(file_ttr);

%Obliczamy parametry MTBF, MTTF oraz MTTR
fprintf('MTBF: %f\n',mean(ttf) + mean(ttr));
fprintf('MTTF: %f\n',mean(ttf));
fprintf('MTTR: %f\n',mean(ttr));

x = 0:(size(ttf)-1);
dfittool