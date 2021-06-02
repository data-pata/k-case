-module(matrix).

-export([start/0]).

% -define(MATRIX_SIZE, {16, 16}).
-define(MATRIX_FILE, filelib:wildcard("../assets/matrix.in")).

start() ->
  {ok, Binary} = file:read_file(?MATRIX_FILE),
  Matrix = parse_binary(Binary),
  Matrix.

  

% takes the binary matrix and returns it as a list of lists
parse_binary(Matrix) ->
  Rows = string:lexemes(Matrix, "\n"),
  F = fun (A) ->
        [ binary_to_integer(B) || B <- string:lexemes(A, " ")]
      end,
  lists:map(F, Rows).
