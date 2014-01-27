-module(nodeProgram).
-export([startTop/4,startMiddle/5,startBottom/5,topIteration/1,botIteration/1,midIteration/1,middleReceiveBotton/5,middleReceiveTop/5]).


startTop(Ppid,Tab,0,NodeID)-> Ppid ! {Tab, NodeID};

startTop(Ppid,Tab,ItNumber,NodeID)-> %%proces dla tablicy pierwszej
         %io:format("Góra poczatek ~p ~n",[Tab]),
        NewTab = receive
                {From, TabRec} -> 
                        %io:format("jestem puerwszy otrzymałem i wysyłam odpowiedz ~n",[]),
                        From ! {array2d:getLast(Tab)},
                        Tab++[TabRec]
                        
                       
        end,
        %io:format("Góra po dodaniu ~p ~n",[NewTab]),
         startTop(Ppid,topIteration(NewTab),ItNumber-1,NodeID).
         
        %io:format("Pierwszy LICZY ~n",[]).
        

topIteration(Tab)->
         %io:format("Góra ~p ~n",[Tab]),
        array2d:removeLast(gol:iterate(Tab)).      
        
        
startMiddle(Ppid,_,Tab,0,NodeID) -> Ppid ! {Tab,NodeID};        
startMiddle(Ppid,PrevPid,Tab,ItNumber,NodeID) -> %proces dla tablicy środkowych
        % io:format("Wysylam do poprzedni jestem id:~p~n",[NodeID]),
         PrevPid ! {self(),array2d:getFirst(Tab)},
         receive
                {TabRec} ->
                    %io:format("Otrzymałem odpowiedz od poprzedni id:~p  ~n",[NodeID]),
                    middleReceiveTop(Ppid,PrevPid,[TabRec]++Tab,ItNumber,NodeID);

                {From, TabRec} ->
                  %  io:format("Otrzymałem od następny id:~p i wysyłąm odpowiedz~n",[NodeID]),
                    From ! {array2d:getLast(Tab)},
                    middleReceiveBotton(Ppid,PrevPid,Tab++[TabRec],ItNumber,NodeID)
         end.
         
     

middleReceiveBotton(Ppid,PrevPid,Tab,ItNumber,NodeID) -> 
        receive
                {TabRec} ->
                       % io:format("Otrzymałem odpowiedz od poprzedni id:~p  ~n",[NodeID]),
                        %io:format("~p LICZY ~n",[NodeID]),
                        startMiddle(Ppid,PrevPid,midIteration([TabRec]++Tab),ItNumber-1,NodeID)
        end.              
         
middleReceiveTop(Ppid,PrevPid,Tab,ItNumber,NodeID) ->
        receive
                {From, TabRec} ->
                       % io:format("Otrzymałem od następny o id:~p i wysyłam odpowiedz~n",[NodeID]),
                        From ! {array2d:getLast(Tab)},
                        %io:format("~p LICZY ~n",[NodeID]),
                        startMiddle(Ppid,PrevPid,midIteration(Tab++[TabRec]),ItNumber-1,NodeID)
        end.          

midIteration(Tab)->
      %  io:format("Środek ~p ~n",[Tab]),
        array2d:removeFirst(array2d:removeLast(gol:iterate(Tab))).   
        
startBottom(Ppid,_,Tab,0,NodeID) -> Ppid ! {Tab,NodeID};  
        
startBottom(Ppid,PrevPid,Tab,ItNumber,NodeID)-> %proces dla tablicy ostatniej
         
         %io:format("Ostatni wysyłam do poprzedni~n",[]),
         PrevPid ! {self(),array2d:getFirst(Tab)},
         receive
                {TabRec} -> 
                       % io:format("Ostatni dostaje zwrot i LICZY~n",[]),
                        startBottom(Ppid,PrevPid,botIteration([TabRec]++Tab) ,ItNumber-1, NodeID)
         end.
        % io:format("Ostatni proces konczy zywot trud skonczony~n",[]).
         
         
botIteration(Tab)->
        array2d:removeFirst(gol:iterate(Tab)).  
