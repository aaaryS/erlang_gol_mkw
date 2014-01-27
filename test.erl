-module(test).

-export([test_time/2,test_plain/0,nodeTest/0,nodeEcho/1]).

test_time(Size,Iterations)->
        
        lifeio:testWrite(Size),
        LifeTab = lifeio:testRead("fff.gz"),
        {Time,Tab} = timer:tc(mainProgram,start,[Iterations,LifeTab]),
        Time.

test_plain()->
        lifeio:testWrite(10),        
        LifeTab = lifeio:testRead("fff.gz"),
        LifeDivide = array2d:divideArray(LifeTab,6),
        io:format("Ruszam ~n",[]),
        {Time,Tab} = timer:tc(gol,iterate,[lists:nth(1,LifeDivide)]),
        Time.


nodeTest()->
        NodeList = net_adm:world(),
        NodeNumber = length(NodeList),
        spawnLoop(NodeNumber,NodeList,1),
        listenLoop(NodeNumber).
        
        

spawnLoop(0,_,_) -> ok; 
 
spawnLoop(Iteracja,NodeList,NodeID) ->
        spawn(lists:nth(NodeID,NodeList),test,nodeEcho,[self()]),
        spawnLoop(Iteracja-1,NodeList,NodeID+1).
         
        
listenLoop(0) ->
        io:format("Koniec~n",[]);

listenLoop(NodeNumber)->
        receive
                Msg ->
                        io:format("Msg~n",[Msg]),
                        listenLoop(NodeNumber-1)
        end.
        
        

nodeEcho(PPid)->
        PPid ! "siema".
