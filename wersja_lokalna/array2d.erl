-module(array2d).
-export([showArray/1,flattenArray/2,removeLast/1,removeFirst/1,getLast/1,getFirst/1,getElem/3,getElem/2,getHeight/1,getWidth/1,neighbours/2,check_neighbours/2,sum_neighbours/2,composeOneArray/4,divideArray/2]).


getElem(X,Y,Arr)->  %zwraca element tablicy znajdujacy się pod X,Y
       S = lists:nth(X,Arr), %uwaga zwraca 0 i 1 a nie 1 i 2 tak jak jest w plikach
       lists:nth(Y,S)-49.
       
getElem({X,Y},Arr)-> %zwraca element tablicy znajdujacy się pod {X,Y}
      getElem(X,Y,Arr).

getFirst(L) -> %zwraca pierwszy element tablicy
        lists:nth(1,L).
        
getLast(L) -> %zwraca ostatni element
        lists:nth(getHeight(L),L).
  
  
removeLast(List)-> %zwraca bez ostatniego
        lists:reverse(tl(lists:reverse(List))).           
              
removeFirst(List)-> %zwraca bez pierwszego
        tl(List).         
              
getHeight(Arr)-> %zwraca wysokosc tablicy
        length(Arr).
        
getWidth(Arr)-> % zwraca dlugosc tablicy
        S = lists:nth(1,Arr),
        length(S).
        
        
onBoard(X,Y,L) -> %sprawdza czy podana komórka znajduje się na tablicy
        W=getWidth(L),
        H=getHeight(L),
        onBoard(X,Y,W,H).        
        
onBoard(X, Y, W, H)  when (X > 0) and (Y > 0) and (X < W+1) and (Y < H+1) -> true;
         
onBoard(_, _, _, _) -> false.

neighbours(X, Y) -> % generuje wszystkich sąsiadow danej komorki - ich wspolrzedne
    [{X + OffX, Y + OffY} || {OffX, OffY} <- offsets()].
    
check_neighbours(Coordinates,L) -> % usuwa sasiadow ktorzy sa po za tablica
    [{X, Y} || {X, Y} <- Coordinates, onBoard(X, Y, L)].
    
sum_neighbours(Arr,Nei)-> %sumuje wszystkich sasiadow 
        lists:sum([getElem({Y,X},Arr) || {X,Y} <- Nei]).
        

divideArray(Arr,Size)-> %dzieli podana tablice na podana ilośc podtablic - potrzebne przy dzieleniu tablicy na procesy
        Avg = round(getHeight(Arr)/Size),
        Last = getHeight(Arr) - ((Size-1)*Avg),
        composeWholeArray(Arr,Size,Avg,Last,[]).   
              

flattenArray([],FArr) -> FArr;

flattenArray([{_,Y}|T],FArr)->
        flattenArray(T,FArr++Y).
                

showArray([])-> "Koniec";

showArray([H|T])->
        io:format("~p~n",[H]),
        showArray(T).
              


composeOneArray(Arr,1, StartPoint,FinalList)-> % funkcja pomocnicza dla divideArray
        FinalList ++ [lists:nth(StartPoint,Arr)];
        
composeOneArray(Arr,Counter,StartPoint,FinalList)-> % funkcja pomocnicza dla divideArray
        composeOneArray(Arr,Counter-1,StartPoint,FinalList ++ [lists:nth(StartPoint-Counter+1,Arr)]).
  
composeWholeArray(Arr,1,_, LastSize,FinalArr)->  % funkcja pomocnicza dla divideArray
        FinalArr++[composeOneArray(Arr,LastSize,getHeight(Arr),[])];
        
composeWholeArray(Arr,Counter,Size, LastSize,FinalArr)-> % funkcja pomocnicza dla divideArray
        Val = getHeight(Arr)-LastSize-((Counter-2)*Size),
        composeWholeArray(Arr,Counter-1,Size, LastSize,FinalArr++[composeOneArray(Arr,Size,Val,[])]).

offsets() ->
    [offset(D) || D <- directions()].
    
offset('N')  -> { 0, -1};
offset('NE') -> { 1, -1};
offset('E')  -> { 1,  0};
offset('SE') -> { 1,  1};
offset('S')  -> { 0,  1};
offset('SW') -> {-1,  1};
offset('W')  -> {-1,  0};
offset('NW') -> {-1, -1}.
 
directions() ->
    ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'].
    
        
