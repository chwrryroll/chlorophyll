-module(chlorophyll_ffi).
-export([mala_clear/1]).
mala_clear(Bag) ->
    try {ok, ets:delete_all_objects(Bag)}
    catch error:badarg -> {error, nil}
    end.
