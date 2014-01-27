-module(gol).
-export([iterate/1,count_state/3]).


    
iterate(L)-> %gĹowna funkcja zwracajÄca tablice po kolejnej iteracji gry w Ĺźycie
        H = array2d:getHeight(L),
        count_height(H,L,[]).
 
 
count_height(0,_,Ret)-> Ret; %rozpoczecie funkcji rekurencyjnej liczÄcej po wierszach
                
count_height(H,L,Ret)->
        CW = count_width(H,L),
        count_height(H-1,L,CW++Ret).
              
count_width(H,L) -> %funkcja liczÄca w danym wierszu
        W = array2d:getWidth(L),
        count_width(H,L,W,"").
        
     
count_width(_,_,0,Line) -> [Line];  
count_width(H,L,W,Line) ->
        count_width(H,L,W-1,count_state(W,H,L)++Line).                

count_state(W,H,L) -> %wyliczenie nowego stanu komorki
        Nei = array2d:neighbours(W,H),
        Nei_c = array2d:check_neighbours(Nei,L),
        Nei_sum = array2d:sum_neighbours(L,Nei_c),
        state(Nei_sum,array2d:getElem(H,W,L)). %tu jest coĹ dodawane odwrotnie, gdzieĹ mi siÄ tablica odwraca, ale dziaĹa
        

%zwraca jaki stan bÄdzie miaĹa dana komĂłrka w zaleĹźnoĹci od iloĹci jej zywych sÄsiadow i jej wartoĹci aktualnej        
state(3,0) -> "2"; 
state(2,1) -> "2";
state(3,1) -> "2";
state(_,_) -> "1".
