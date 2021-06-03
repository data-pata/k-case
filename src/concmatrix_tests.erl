-module(concmatrix_tests).
-include_lib("eunit/include/eunit.hrl").
% -include("../src/")
start_test() ->
    ?assertEqual({54426, 333}, concmatrix:start()).