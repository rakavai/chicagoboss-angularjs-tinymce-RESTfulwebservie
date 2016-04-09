%%%-------------------------------------------------------------------
%%% @author Rakibul Hasan
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Apr 2016 2:35 AM
%%%-------------------------------------------------------------------
-module(utility).
-author("Rakibul Hasan").
-compile(export_all).

%% API
time()->
  calendar:datetime_to_gregorian_seconds(calendar:universal_time()) - 62167219200.
