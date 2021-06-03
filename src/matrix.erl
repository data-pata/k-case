-module(matrix).

-export([start/0]).

-compile(export_all).

% -define(MATRIX_FILE, filelib:wildcard("../assets/matrix.in")).
-define(MATRIX_FILE, filelib:wildcard("../assets/matrix.in")).

start() ->
  Matrix = get_matrix(?MATRIX_FILE),
  Checksum1 = part1(Matrix),
  Checksum2 = part2(Matrix),
  io:format("Part 1 Checksum: ~p~nPart2 Checksum: ~p~n",
    [Checksum1, Checksum2]).   

%% -------------------------------------
%% PART 2 CALCULATIONS 
%% -------------------------------------
%% ignores non-unique elements!
part2(Matrix) ->
    lists:foldl(
      fun (Row, Sum) ->
        [Quotient | _ ] = [X div Y || X <- Row, Y <- Row, (X rem Y) =:= 0, X =/= Y],
        Quotient + Sum
      end
      , 0, Matrix).


find_dividend(Divisor, Nums) ->
  lists:foldl(
    fun(X, Acc) ->
      case true_div(X, Divisor) of
        true -> [{X, Divisor} | Acc];
        false -> Acc
      end
    end
    , [], Nums).
  
  % returns true if 
  true_div(X, X) -> false;
  true_div(X, Y) -> X rem Y == 0.


%% -------------------------------------u
%% PART 1 CALCULATIONS 
% ------------------------------------- 
part1(Matrix) ->
  checksum(Matrix).

%% @doc calculate checksum of matrix 
checksum(Matrix) ->
  Checksum = lists:foldl(
    fun(X, Sum) ->
      {Min, Max} = min_n_max(X),
      Max-Min + Sum
    end
    , 0, Matrix),
  Checksum.

%% @doc return tuple of min and max value in given list of numbers
min_n_max(NumList) ->
  Min = lists:min(NumList),
  Max = lists:max(NumList),
  {Min, Max}.

%% -------------------------------------
%% READING AND PARSING INPUT 
%% -------------------------------------
get_matrix(Filepath) ->
  {ok, Binary} = file:read_file(Filepath),
  Matrix = parse_binary(Binary).

% takes the binary matrix and returns it as a list of lists
parse_binary(Matrix) ->
  Rows = string:lexemes(Matrix, "\n"),
  F = fun (A) ->
        [ binary_to_integer(B) || B <- string:lexemes(A, " ")]
      end,
  lists:map(F, Rows).
