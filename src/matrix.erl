-module(matrix).

-export([start/0]).
% -compile(export_all).

% -define(MATRIX_FILE, filelib:wildcard("../assets/matrix.in")).
-define(MATRIX_FILE, filelib:wildcard("../assets/matrix.in")).

start() ->
  Matrix = get_matrix(),
  Checksum = part1(Matrix),
  io:format("Part 1 Checksum: ~p~n", [Checksum]).  

%% CALCULATIONS  -----------------------
part1(Matrix) ->
  checksum(Matrix).

checksum(Matrix) ->
  % Sums = [Row_sum || Row <- Matrix, {Min, Max} <- min_n_max(Row), Row_sum <- Max-Min],
  Checksum = lists:foldl(
    fun(X, Sum) ->
      {Min, Max} = min_n_max(X),
      Max-Min + Sum
    end
    , 0, Matrix),
  Checksum.

%% return tuple of min and max value in given list of numbers
min_n_max(Nums) ->
  Min = lists:min(Nums),
  Max = lists:max(Nums),
  {Min, Max}.

%% READING AND PARSING INPUT ----------------------
get_matrix() ->
  {ok, Binary} = file:read_file(?MATRIX_FILE),
  Matrix = parse_binary(Binary).

% takes the binary matrix and returns it as a list of lists
parse_binary(Matrix) ->
  Rows = string:lexemes(Matrix, "\n"),
  F = fun (A) ->
        [ binary_to_integer(B) || B <- string:lexemes(A, " ")]
      end,
  lists:map(F, Rows).
