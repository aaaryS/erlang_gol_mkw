-module(mainProgram).

-export([start/2]). 


start(ItNumber,LifeTab)->

        NodeNumber = 8,
        NodeID=1, % do inkrementacji
        ArrayForNodes = array2d:divideArray(LifeTab,NodeNumber),
        FirstPid = spawn(nodeProgram,startTop,[self(),lists:nth(NodeID,ArrayForNodes),ItNumber,NodeID]),
        PidList = spawnLoop(NodeNumber-1,FirstPid,[FirstPid],ItNumber,NodeID+1, ArrayForNodes),
     
        io:format("Listen~n",[]),
        FinishList = listenLoop(NodeNumber,[]),
        array2d:flattenArray(lists:keysort(1,FinishList),[]).    
        
spawnLoop(1,PrevPid,List,ItNumber,NodeID, ArrayForNodes) -> %% tworzy liste wezlow
        List ++ [spawn(nodeProgram,startBottom,[self(),PrevPid,lists:nth(NodeID,ArrayForNodes),ItNumber,NodeID])];

spawnLoop(N,PrevPid,List,ItNumber,NodeID, ArrayForNodes) ->
        Next = spawn(nodeProgram,startMiddle,[self(),PrevPid,lists:nth(NodeID,ArrayForNodes),ItNumber,NodeID]),
        spawnLoop(N-1,Next,List++[Next],ItNumber,NodeID+1, ArrayForNodes).

listenLoop(0,List) ->
        io:format("Koniec~n",[]),
        List;

listenLoop(NodeNumber,List)->
        receive
                {Msg, NodeID} ->
                        %io:format("~w~n",[NodeID]),
                        %io:format("Czekam~n",[]),
                        listenLoop(NodeNumber-1,List++[{NodeID,Msg}])
        end.
