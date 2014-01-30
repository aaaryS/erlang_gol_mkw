-module(gol).
-export([iterate/1,count_state/3]).


    
iterate(L)-> %główna funkcja zwracająca tablice po kolejnej iteracji gry w Ĺźycie
        H = array2d:getHeight(L),
        count_height(H,L,[]).
 
 
count_height(0,_,Ret)-> Ret; %rozpoczecie funkcji rekurencyjnej liczącej po wierszach
                
count_height(H,L,Ret)->
        CW = count_width(H,L),
        count_height(H-1,L,CW++Ret).
              
count_width(H,L) -> %funkcja licząca w danym wierszu
        W = array2d:getWidth(L),
        count_width(H,L,W,"").
        
     
count_width(_,_,0,Line) -> [Line];  
count_width(H,L,W,Line) ->
        count_width(H,L,W-1,count_state(W,H,L)++Line).                

count_state(W,H,L) -> %wyliczenie nowego stanu komorki
        Nei = array2d:neighbours(W,H),
        Nei_c = array2d:check_neighbours(Nei,L),
        Nei_sum = array2d:sum_neighbours(L,Nei_c),
        state(Nei_sum,array2d:getElem(H,W,L)). 
        

%zwraca jaki stan będzie miała dana komórka w zależności od ilości jej zywych sąsiadow i jej wartości aktualnej        
state(3,0) -> [1]; 
state(2,1) -> [1];
state(3,1) -> [1];
state(_,_) -> [0].
