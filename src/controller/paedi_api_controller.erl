%%%-------------------------------------------------------------------
%%% @author Rakibul Hasan
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Apr 2016 1:12 AM
%%%-------------------------------------------------------------------
-module(paedi_api_controller, [Req]).
-author("Rakibul Hasan").
-compile(export_all).

%% API
drugs('POST', []) ->
  GenericName = Req:post_param("genericName"),
  BrandName = Req:post_param("brandName"),
  Description = Req:post_param("description"),

  BrandNamesWithoutTrim = string:tokens(BrandName, ","),
  BrandNamesWithTrim = [string:strip(Brand) || Brand <- BrandNamesWithoutTrim],
  CurrentTime = utility:time(),
  DrugInfo = drugs:new(id, GenericName, BrandNamesWithTrim, Description, CurrentTime, CurrentTime),
  {ok, _} = DrugInfo:save(),
  {json, [{success, true}, {resposne, "New Drug Added"}]};

drugs('GET', []) ->
  DrugsGenericName = [
    [
      {id, list_to_binary(Drug:id())},
      {genericName, list_to_binary(Drug:generic_name())}
    ]
    || Drug <- boss_db:find(drugs, [])],
  {output, jsx:encode(DrugsGenericName), [{"Content-Type", "application/j-son;charset=UTF-8"}]};
drugs('GET', [Id]) ->
  Drug = boss_db:find(Id),
  BrandNames = [
    list_to_binary(EachBrand)
    ||
    EachBrand <- Drug:brand_name()
  ],
  DrugFormatted = [
    {id, Drug:id()},
    {genericName, Drug:generic_name()},
    {brandName, BrandNames},
    {description, Drug:description()}
  ],
  {json, DrugFormatted};
drugs('PUT', []) ->
  drugs('POST', []);
drugs('PUT', [Id]) ->
  Record = boss_db:find(drugs, [{id, Id}]),
  case Record of
    [] ->
      {json, [{success, false}, {errorMessage, "No entry."}]};
    [Entry] ->
      GenericName = Req:post_param("genericName"),
      BrandName = Req:post_param("brandName"),
      Description = Req:post_param("description"),

      BrandNamesWithoutTrim = string:tokens(BrandName, ","),
      BrandNamesWithTrim = [string:strip(Brand) || Brand <- BrandNamesWithoutTrim],
      CurrentTime = utility:time(),
      DrugInfo = drugs:new(Id, GenericName, BrandNamesWithTrim, Description, Entry:created_at(), CurrentTime),
      {ok, _} = DrugInfo:save(),
      {json, [{success, true}, {resposne, "Record updated"}]}
  end.