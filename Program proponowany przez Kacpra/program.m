clear
%Ustalamy maksymalny czas symulacji oraz liczbê symulacji.
Tsym = 500;
Lsym = 1000;

%Dobieramy rozk³ady prawdopodobieñstwa dla czasu poprawnej pracy systemu 
%i czasu naprawy.
F = 13;
G = 10;

%Ustalamy œcie¿ki zapisu plików zawieraj¹cych czasy do uszkodzenia - tff 
%oraz czasów do naprawy - ttr.
sciezka_ttf = sprintf('wyniki\\ttf.txt');
[file_ttf, message] = fopen(sciezka_ttf,'w');
%Sprawdzenie poprawnoœci otwarcia
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

%Wlaœciwa czêœæ programu bêd¹ca implementacj¹ schematu blokowego dzia³ania
%systemu. 
for L = 1:Lsym 
    %Inicjalizacja zmiennych.
    K = 1; %liczba konserwatorów
    T = 0; %czas symulacji
    tx = 0; %bie¿¹ca chwila (minimum z wylosowanych momentów)
    LO = 0; %liczba oczekuj¹cych na naprawê
    S = [0,0,0,0]; %stany poszczególnych elementów systemu - pierwszy uk³ad diagnostyki, nastêpnie czujniki
    Tx = [1,2,3,10]; %czasy uszkodzenia (najblizszego wydarzenia)
    
    %Losowanie momentów uszkodzenia
    for i = 1:4
        Tx(i) = exprnd(F);
    end

    x = -1;
    %Ustalenie œcie¿ki zapisu dla plików wynikowych symulacji
    sciezka_proba = sprintf('wyniki\\sym%d.txt',L);
    [file_proba, wiadomosc] = fopen(sciezka_proba,'w');
    if file_proba == -1
        disp(wiadomosc)
        return;
    end;
    
    %Zmienna przechowuj¹ca iloœæ elementów sprawnych
    sprawne = 0;
    
    for i = 2:4
        %Jeœli stan elementu jest równy 0 (jest sprawny) zwiêkszamy
        %zmienn¹ sprawne o 1
        if S(i) == 0
           sprawne = sprawne + 1;
        end
    end
    
    %W przypadku gdy liczba czujników sprawnych jest równa  przynajmniej 2
    %ca³y system jest sprawny (zasada '2z3')
    if sprawne > 1
        stan = 0;
    %w przeciwnym wypadku uk³ad jest niesprawny
    else
        stan = 1;
    end

    %Zapisujemy wyniki do pliku w postaci: stan systemu, stan uk³adu
    %diagnostyki, stany czujników, czas od momentu startu symulacji.
    fprintf(file_proba,'%d\t%d\t%d\t%d\t%d\t%f\r\n',stan,S(1),S(2),S(3),S(4),T);
    
    %Dopóki czas jest mniejszy od maksymalnego czasu symulacji
    while T < Tsym
        %zwiêkszamy bie¿¹c¹ chwilê
        tx = 2*Tsym;
        
        %Szukamy minimum z czasów uszkodzenia
        for i = 1:4
            if Tx(i) < tx
                x = i;
                tx = Tx(i);
            end
        end

        %Sprawdzamy czy urz¹dzenie w chwili tx_ by³o sprawne
        if S(x) == 0
            %Sprawdzamy czy uk³ad diagnostyki by³ sprawny i liczba
            %konserwatorów jest wiêksza od 0. Jeœli tak, oznacza to, ¿e
            %urz¹dzenie siê zepsu³o - musimy je wiêc naprawiæ. Zmniejszamy
            %liczbê dostêpnych konserwatorów i losujemy czas naprawy.
            %Zaznaczamy stan elementu jako 1 (w naprawie)
            if S(1) == 0 && K>0
                K = K-1;
                Tx(x) = exprnd(G) + tx;
                S(x) = 1;
            %W przeciwnym razie zwiêkszamy liczbê oczekuj¹cych na naprawê
            %i oznaczamy stan elementu jako 2 (czekaj¹cy na naprawê)
            else
                Tx(x) = 5*Tsym;
                LO = LO+1;
                S(x) = 2;
            end
        %Gdy element systemu by³ uszkodzony losujemy czas poprawnej pracy,
        %zwiêkszamy liczbe konserwatorów i oznaczamy stan elementu 0
        %(sprawny)
        else
            K = K+1;
            Tx(x) = exprnd(F) + tx;
            S(x) = 0;
        end

        %Jeœli uk³ad diagnostyki oczekuje na naprawê i s¹ dostêpni
        %konserwatorzy, naprawiamy ten uk³ad. Wynika z tego, i¿ uk³ad
        %diagnostyki ma priorytet jeœli chodzi o kolejnoœæ wykonywanych
        %napraw.
        if S(1) == 2 && K > 0
            K = K - 1;
            Tx(1) = exprnd(G) + tx;
            S(1) = 1;
            LO = LO - 1;
        end
        
        i = 2;
        %Dopóki liczba oczekuj¹cych na naprawê czujników jest wiêksza od 0, uk³ad
        %diagnostyki jest sprawny i s¹ dostêpni konserwatorzy, naprawiamy
        %poszczególne elementy systemu w kolejnoœci: 1-wszy, 2-gi, 3-ci czujnik.
        while LO > 0 && S(1) == 0 && K > 0
            if S(i) == 2
                K = K - 1;
                Tx(i) = exprnd(G) + tx;
                S(i) = 1;
                LO = LO - 1;
            end
            i = i + 1;
        end

        %Zwiêkszamy czas od startu systemu
        T = T + tx;
        %Zmniejszamy czasy najbli¿szego wydarzenia
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

        %Gdy liczba sprawnych czujników jest równa przynajmniej 2 system
        %jest sprawny.
        if sprawne > 1
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

    %Z pliku zczytujemy wartoœci do tablicy
    tab = fscanf(file_proba,'%d%d%d%d%d%f',[ 6 inf ]);
    fclose(file_proba);
    tab = tab';
    rozmiar = size(tab,1);
    ostatniStan = tab(1,1); %Pierwszy stan systemu
    ostatniRazSprawny = 0;  %Moment ostatniej sprawnoœci
    ostatniRazUszkodzony = 0;%Moment ostatniego uszkodzenia

    %W tym miejscu obliczymy poszczególne czasy do uszkodzenia i czasy do
    %naprawy - TTF oraz TTR
    for i = 2:rozmiar
        %Zczytujemy czas od momentu startu symulacji
        czas = tab(i,6);
        %oraz stan systemu
        stan = tab(i,1);
        %Jeœli ostatni odczytany stan ró¿ni siê od bie¿¹cego sprawdzamy czy
        %jest równy 1 jeœli tak zapisujemy do pliku obliczon¹ wartoœæ TTF. W
        %przeciwnym razie - wartoœæ TTR
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

%Otwieramy pliki z wartoœciami TTF oraz TTR
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

%Zapisujemy wartoœci TTF oraz TTR w tablicy
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