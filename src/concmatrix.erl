-module(concmatrix).

-export([start/0]).

-compile(export_all).

% -ifdef(Debug).
% -else.
% -endif.

% -define(MATRIX_FILE, filelib:wildcard("../assets/matrix.in")).
-define(MATRIX_FILE, filelib:wildcard("../assets/matrix.in")).

start() ->
    Matrix = get_matrix(?MATRIX_FILE),
    timer(start),
    Super = spawn(?MODULE, start_super, [Matrix, self()]), % not a supervisor per se, bad idea to send big matrix?
    receive
        {Super, {D, Q}} ->
            Time = timer(read),
            print_result(D, Q, Time)
    end,
    {D, Q}.

start_super(Matrix, FromPid) ->
    NumRows = length(Matrix),
    Workers = spawn_workers(Matrix),
    send_rows(Matrix, Workers),
    CheckSums = receive_res(NumRows),
    FromPid ! {self(), CheckSums}.

%% give workers id:s? 
%% multiple list traversals...
receive_res(NumWorkers) -> receive_res({0, 0}, 0, NumWorkers).
receive_res(CheckSums, Count, Count) -> CheckSums;
receive_res({Dsum, Qsum}, Count, NumWorkers) ->
    receive
        {D, Q} ->
            receive_res({D+Dsum, Q+Qsum}, Count+1, NumWorkers)
    end.    
    
spawn_workers(Matrix) ->[spawn_link(worker, start, []) || _Row <- Matrix].
send_rows(Matrix, Workers) ->
    lists:foldl(
        fun(Worker, [Row | T]) ->
            Worker ! {self(), Row},
            T
        end
        , Matrix, Workers
        ).

print_result(Checksum1, Checksum2, {CpuTime, WallTime}) ->
    io:format("Part 1 Checksum: ~p~nPart2 Checksum: ~p~n"++
        "Completed in ~p (~p) milliseconds~n",
        [Checksum1, Checksum2, CpuTime, WallTime]).  

%% OBS! This is the sum of the runtime for all threads in the Erlang runtime system
%% and can therefore be greater than the wall clock time.
timer(start) -> 
    statistics(runtime),
    statistics(wall_clock);
timer(read) ->
    {_,CPU} = statistics(runtime),
    {_,Clock} = statistics(wall_clock),
    {CPU , Clock}.

%   Checksum1 = part1(Matrix),
%   Checksum2 = part2(Matrix),
%   io:format("Part 1 Checksum: ~p~nPart2 Checksum: ~p~n",
%     [Checksum1, Checksum2]).


%% -------------------------------------
%% READING AND PARSING INPUT 
%% -------------------------------------
get_matrix(Filepath) ->
  {ok, Binary} = file:read_file(Filepath),
  parse_binary(Binary).

% takes the binary matrix and returns it as a list of lists
parse_binary(Matrix) ->
  Rows = string:lexemes(Matrix, "\n"),
  F = fun (A) ->
        [ binary_to_integer(B) || B <- string:lexemes(A, " ")]
      end,
  lists:map(F, Rows).