-module(nodeProgram).
-export([startTop/4,startMiddle/5,startBottom/5,topIteration/1,botIteration/1,midIteration/1,middleReceiveBotton/5,middleReceiveTop/5]).

startTop(Ppid,Tab,0,NodeID)-> Ppid ! {Tab, NodeID};

startTop(Ppid,Tab,ItNumber,NodeID)-> %%proces dla tablicy pierwszej
        NewTab = receive
                {From, TabRec} -> 
                        From ! {array2d:getLast(Tab)},
                        Tab++[TabRec]
        end,
        startTop(Ppid,topIteration(NewTab),ItNumber-1,NodeID).
        

topIteration(Tab)->
        array2d:removeLast(gol:iterate(Tab)).      
        
startMiddle(Ppid,_,Tab,0,NodeID) -> Ppid ! {Tab,NodeID};        
startMiddle(Ppid,PrevPid,Tab,ItNumber,NodeID) -> %proces dla tablicy środkowych
         PrevPid ! {self(),array2d:getFirst(Tab)},
         receive
                {TabRec} ->
                    middleReceiveTop(Ppid,PrevPid,[TabRec]++Tab,ItNumber,NodeID);
                {From, TabRec} ->
                    From ! {array2d:getLast(Tab)},
                    middleReceiveBotton(Ppid,PrevPid,Tab++[TabRec],ItNumber,NodeID)
         end.
     
middleReceiveBotton(Ppid,PrevPid,Tab,ItNumber,NodeID) -> 
        receive
                {TabRec} ->
                        startMiddle(Ppid,PrevPid,midIteration([TabRec]++Tab),ItNumber-1,NodeID)
        end.              
         
middleReceiveTop(Ppid,PrevPid,Tab,ItNumber,NodeID) ->
        receive
                {From, TabRec} ->
                        From ! {array2d:getLast(Tab)},
                        startMiddle(Ppid,PrevPid,midIteration(Tab++[TabRec]),ItNumber-1,NodeID)
        end.          

midIteration(Tab)->
        array2d:removeFirst(array2d:removeLast(gol:iterate(Tab))).   
        
startBottom(Ppid,_,Tab,0,NodeID) -> Ppid ! {Tab,NodeID};  
        
startBottom(Ppid,PrevPid,Tab,ItNumber,NodeID)-> %proces dla tablicy ostatniej
         PrevPid ! {self(),array2d:getFirst(Tab)},
         receive
                {TabRec} -> 
                        startBottom(Ppid,PrevPid,botIteration([TabRec]++Tab) ,ItNumber-1, NodeID)
         end.
         
botIteration(Tab)->
        array2d:removeFirst(gol:iterate(Tab)).  
