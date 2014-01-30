-module(test).

-export([test_time/2,test_plain/0]).

test_time(Size,Iterations)-> %funkcja testowa jak w założeniach
        lifeio:testWrite(Size),
        LifeTab = lifeio:testRead("fff.gz"),
        {Time,Tab} = timer:tc(mainProgram,next,[Iterations,LifeTab]),
        Time.

test_plain()-> %funkcja testowa dla wilości 2^10
        lifeio:testWrite(10),        
        LifeTab = lifeio:testRead("fff.gz"),
        LifeDivide = array2d:divideArray(LifeTab,6),
        io:format("Start ~n",[]),
        {Time,Tab} = timer:tc(gol,iterate,[lists:nth(1,LifeDivide)]),
        Time.

