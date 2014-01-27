-module(mainProgram).

-export([start/2]). 


start(ItNumber,LifeTab)->
        NodeList = net_adm:world(),
        NodeNumber = length(NodeList)-1,
        NodeID=1, % do inkrementacji
        ArrayForNodes = array2d:divideArray(LifeTab,NodeNumber),
        FirstPid = spawn(lists:nth(NodeID,NodeList),nodeProgram,startTop,[self(),lists:nth(NodeID,ArrayForNodes),ItNumber,NodeID]),
        PidList = spawnLoop(NodeList, NodeNumber-1,FirstPid,[FirstPid],ItNumber,NodeID+1, ArrayForNodes),
     
        io:format("Listen~n",[]),
        FinishList = listenLoop(NodeNumber,[]),
        array2d:flattenArray(lists:keysort(1,FinishList),[]).    
        
spawnLoop(NodeList ,1,PrevPid,List,ItNumber,NodeID, ArrayForNodes) -> %% tworzy liste wezlow
        List ++ [spawn(lists:nth(NodeID,NodeList),nodeProgram,startBottom,[self(),PrevPid,lists:nth(NodeID,ArrayForNodes),ItNumber,NodeID])];

spawnLoop(NodeList, N,PrevPid,List,ItNumber,NodeID, ArrayForNodes) ->
        Next = spawn(lists:nth(NodeID,NodeList),nodeProgram,startMiddle,[self(),PrevPid,lists:nth(NodeID,ArrayForNodes),ItNumber,NodeID]),
        spawnLoop(NodeList ,N-1,Next,List++[Next],ItNumber,NodeID+1, ArrayForNodes).

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
