-module(worker).
-export([start/0]).
-compile(export_all).

start() ->
    loop().

loop() ->
    receive
        {From, Row} ->
            From ! calculate(Row),
            loop()
    end.

calculate(NumList) ->
    D = diff(NumList),
    Q = quoutient(NumList),
    {D, Q}. % turn into kv list or map  

%% @doc Returns the quotient of two different numbers in list for which rem is 0.
%% runs through the whole list even when numbers found.
quoutient(NumList) ->
    [Q | _ ] = [X div Y || X <- NumList, Y <- NumList, (X rem Y) =:= 0, X =/= Y],
    Q.

%% @doc Returns the difference of the biggest and smallest number in a list.
diff(NumList) -> 
    Min = lists:min(NumList),
    Max = lists:max(NumList),
    Max - Min.
