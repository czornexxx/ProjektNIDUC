function [ macierzW ] = generujWektory( kosztEl, kasa )

macierzWektorow = 0; 
tmp = size(kosztEl);
n = tmp(2);

%wyliczanie ilosci elementow od ceny
for i=1 :n
wIlosc(i) = kasa/kosztEl(i);
end;
najwiecejEl = max(wIlosc);

wektory = 0;
for i=1 :n
    wektory(i) = najwiecejEl;
end;

test = 1;
licznik = 1;
while test == 1
    
    for i=1 :n
    macierzWektorow(licznik,i) = wektory(i);
    end;
    licznik = licznik + 1;
    
    % odliczanie do 0
    tmpn = n;
    wektory(tmpn) = wektory(tmpn) - 1;
    if(wektory(tmpn) < 0)
      
        while tmpn > 0
            if(wektory(tmpn) > 0)
                wektory(tmpn) = wektory(tmpn) -1;
                wektory(tmpn +1) = najwiecejEl;
                tmpn = 0;
            else
                if(tmpn == 1)
                    test = 0
                end;
            
            end;
            tmpn = tmpn-1;
        end;
    end;
end;


tmp = size(macierzWektorow);

nn = tmp(1);

tmp = 1;
for i=1 :nn
    
    suma = 0;
    for l=1 :n
     suma = suma + ( macierzWektorow(i,l) * kosztEl(l));
    end;   
    
    if(suma <= kasa && suma > (kasa * 90/100))
        
        for l=1 :n
            macierzW(tmp,l) = macierzWektorow(i,l);
        end;
    tmp = tmp + 1;
    end;
    
end;

end

