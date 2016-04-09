%% Migration: create_at




{create_at,
fun(up) -> fun() ->
NewRecord = fun({drugs, Id, GenericName, Brands, Description}) ->
CurrentTimestamp = calendar:datetime_to_gregorian_seconds(calendar:universal_time()) - 62167219200,
{drugs, Id, GenericName, Brands, Description, CurrentTimestamp, CurrentTimestamp}
end,
mnesia:transform_table(drugs,NewRecord, [id,generic_name, brand_name, description,created_at, updated_at])
end;
(down) -> undefined
end}.
