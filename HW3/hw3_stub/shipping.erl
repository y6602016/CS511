-module(shipping).
-compile(export_all).
-include_lib("./shipping.hrl").
-author("Qi-Rui Hong").

get_ship(Shipping_State, Ship_ID) ->
    %%% keyfind(key, record_field_name, list_of_records)
    case lists:keyfind(Ship_ID, #ship.id, Shipping_State#shipping_state.ships) of
        %%% It returns the atom error if the ship id does not exist.
        false -> error;
        R -> R
    end.
%%% Alternative: we can convert the list to [{id, record}], then we map it and get the value by the key
% IdList = lists:map(fun(R) -> {R#ship.id, R} end, Shipping_State#shipping_state.ships),
% IdMap = maps:from_list(IdList),
% maps:get(Ship_ID, IdMap, error).

get_container(Shipping_State, Container_ID) ->
    case lists:keyfind(Container_ID, #container.id, Shipping_State#shipping_state.containers) of
        %%% It returns the atom error if the container id does not exist.
        false -> error;
        R -> R
    end.

get_port(Shipping_State, Port_ID) ->
    case lists:keyfind(Port_ID, #port.id, Shipping_State#shipping_state.ports) of
        %%% It returns the atom error if the port id does not exist.
        false -> error;
        R -> R
    end.

get_occupied_docks(Shipping_State, Port_ID) ->
    case get_port(Shipping_State, Port_ID) of
        %%% It returns the empty list if the port id does not exist.
        error ->
            [];
        %%% refering to the Shipping_State#shipping_state.ship_locations, the returned list consists of
        %%% all occupied docks of Port_ID
        _ ->
            lists:map(
                fun({_P, D, _S}) -> D end,
                lists:filter(
                    fun({P, _D, _S}) -> P == Port_ID end,
                    Shipping_State#shipping_state.ship_locations
                )
            )
    end.

get_ship_location(Shipping_State, Ship_ID) ->
    case get_ship(Shipping_State, Ship_ID) of
        %%% It returns the atom error if the ship id does not exist.
        error ->
            error;
        _Else ->
            case lists:keyfind(Ship_ID, 3, Shipping_State#shipping_state.ship_locations) of
                %%% It returns the atom error if the ship id exists but not in the locations list.
                false -> error;
                {P, D, _S} -> {P, D}
            end
    end.

get_container_weight(Shipping_State, Container_IDs) ->
    case lists:all(fun(I) -> get_container(Shipping_State, I) =/= error end, Container_IDs) of
        false ->
            %%% It returns the atom error if any of the container Ids does not exist.
            error;
        true ->
            %%% filter out the required containers then sum up their weight
            lists:foldl(
                fun(C, Sum) -> C#container.weight + Sum end,
                0,
                lists:filter(
                    fun(C) ->
                        lists:member(C#container.id, Container_IDs)
                    end,
                    Shipping_State#shipping_state.containers
                )
            )
    end.

get_ship_weight(Shipping_State, Ship_ID) ->
    case get_ship(Shipping_State, Ship_ID) of
        %%% It returns the atom error if ship Id does not exist
        error ->
            error;
        _ ->
            case maps:get(Ship_ID, Shipping_State#shipping_state.ship_inventory, error) of
                %%% even the ship id exists, if it's not in the Ship_Inventory Map, return error
                error -> error;
                C -> get_container_weight(Shipping_State, C)
            end
    end.

load_ship(Shipping_State, Ship_ID, Container_IDs) ->
    %%% use ship Id as the key and get the port
    case get_ship_location(Shipping_State, Ship_ID) of
        %%% It returns the atom error if the ship id doesn't exist or exists but not in the locations list.
        error ->
            error;
        {Port_ID, _Dock_ID} ->
            %%% check whether all the containers are at the same port
            case
                is_sublist(
                    maps:get(Port_ID, Shipping_State#shipping_state.port_inventory),
                    Container_IDs
                )
            of
                %%% It returns error if there are container IDs that aren’t in the same port as the ship
                false ->
                    error;
                true ->
                    %%% check whether the ship has enough capacity
                    ShipContainers = maps:get(
                        Ship_ID, Shipping_State#shipping_state.ship_inventory
                    ),
                    PortContainers = maps:get(
                        Port_ID, Shipping_State#shipping_state.port_inventory
                    ),
                    Ship = get_ship(Shipping_State, Ship_ID),
                    RemainingCap = Ship#ship.container_cap - length(ShipContainers),
                    case RemainingCap >= length(Container_IDs) of
                        %%% It returns error if loading the ship would put the ship over capacity
                        false ->
                            error;
                        true ->
                            %%% loading can work, we can update the records
                            Shipping_State#shipping_state{
                                ship_inventory = maps:update(
                                    Ship_ID,
                                    ShipContainers ++ Container_IDs,
                                    Shipping_State#shipping_state.ship_inventory
                                ),
                                port_inventory = maps:update(
                                    Port_ID,
                                    PortContainers -- Container_IDs,
                                    Shipping_State#shipping_state.port_inventory
                                )
                            }
                    end
            end
    end.

unload_ship_all(Shipping_State, Ship_ID) ->
    %%% use ship Id as the key and get the dock
    case get_ship_location(Shipping_State, Ship_ID) of
        %%% It returns the atom error if the ship id doesn't exist or exists but not in the locations list.
        error ->
            error;
        {Port_ID, _Dock_ID} ->
            ShipContainers = maps:get(
                Ship_ID, Shipping_State#shipping_state.ship_inventory
            ),
            PortContainers = maps:get(
                Port_ID, Shipping_State#shipping_state.port_inventory
            ),
            Port = get_port(Shipping_State, Port_ID),
            RemainingCap = Port#port.container_cap - length(PortContainers),
            case RemainingCap >= length(ShipContainers) of
                false ->
                    error;
                true ->
                    Shipping_State#shipping_state{
                        ship_inventory = maps:update(
                            Ship_ID,
                            [],
                            Shipping_State#shipping_state.ship_inventory
                        ),
                        port_inventory = maps:update(
                            Port_ID,
                            PortContainers ++ ShipContainers,
                            Shipping_State#shipping_state.port_inventory
                        )
                    }
            end
    end.

unload_ship(Shipping_State, Ship_ID, Container_IDs) ->
    case get_ship_location(Shipping_State, Ship_ID) of
        %%% It returns the atom error if the ship id doesn't exist or exists but not in the locations list.
        error ->
            error;
        {Port_ID, _Dock_ID} ->
            %%% check whether all the containers are located on the ship
            case
                is_sublist(
                    maps:get(Ship_ID, Shipping_State#shipping_state.ship_inventory),
                    Container_IDs
                )
            of
                %%% It returns error if there are container IDs that aren’t located on the ship
                false ->
                    io:fwrite("The given conatiners are not all on the same ship...~n"),
                    error;
                true ->
                    %%% check whether the port has enough capacity
                    ShipContainers = maps:get(
                        Ship_ID, Shipping_State#shipping_state.ship_inventory
                    ),
                    PortContainers = maps:get(
                        Port_ID, Shipping_State#shipping_state.port_inventory
                    ),
                    Port = get_port(Shipping_State, Port_ID),
                    RemainingCap = Port#port.container_cap - length(PortContainers),
                    case RemainingCap >= length(Container_IDs) of
                        %%% It returns error if loading the ship would put the ship over capacity
                        false ->
                            error;
                        true ->
                            %%% loading can work, we can update the records
                            Shipping_State#shipping_state{
                                ship_inventory = maps:update(
                                    Ship_ID,
                                    ShipContainers -- Container_IDs,
                                    Shipping_State#shipping_state.ship_inventory
                                ),
                                port_inventory = maps:update(
                                    Port_ID,
                                    PortContainers ++ Container_IDs,
                                    Shipping_State#shipping_state.port_inventory
                                )
                            }
                    end
            end
    end.

set_sail(Shipping_State, Ship_ID, {Port_ID, Dock}) ->
    case get_ship(Shipping_State, Ship_ID) of
        %%% It returns the atom error if the ship id doesn't exist
        error ->
            error;
        _Else ->
            %%% check whether {Port_ID, Dock} exist
            Port = get_port(Shipping_State, Port_ID),
            case get_port(Shipping_State, Port_ID) of
                %%% It returns the atom error if the port id doesn't exist
                error ->
                    error;
                Port ->
                    case lists:member(Dock, Port#port.docks) of
                        %%% It returns the atom error if the dock doesn't exist
                        false ->
                            error;
                        true ->
                            Locations = Shipping_State#shipping_state.ship_locations,
                            %%% check whether {Port_ID, Dock} is occupied
                            ProcessedLocations = lists:map(
                                fun({X, Y, Z}) -> {{X, Y}, Z} end, Locations
                            ),
                            case lists:keyfind({Port_ID, Dock}, 1, ProcessedLocations) of
                                %%% if false, it means {Port_ID, Dock} is not occupied
                                false ->
                                    TheShipLocation = lists:keyfind(Ship_ID, 3, Locations),
                                    RemovedShipLocation = Locations -- [TheShipLocation],
                                    Shipping_State#shipping_state{
                                        ship_locations =
                                            RemovedShipLocation ++ [{Port_ID, Dock, Ship_ID}]
                                    };
                                {{_, _}, S} ->
                                    if
                                        %%% if they are occupied by the ship itself, it's fine and nothing changed
                                        S == Ship_ID ->
                                            Shipping_State;
                                        %%% It returns error if the Port or the Dock are occupied
                                        true ->
                                            error
                                    end
                            end
                    end
            end
    end.

%% Determines whether all of the elements of Sub_List are also elements of Target_List
%% @returns true is all elements of Sub_List are members of Target_List; false otherwise
is_sublist(Target_List, Sub_List) ->
    lists:all(fun(Elem) -> lists:member(Elem, Target_List) end, Sub_List).

%% Prints out the current shipping state in a more friendly format
print_state(Shipping_State) ->
    io:format("--Ships--~n"),
    _ = print_ships(
        Shipping_State#shipping_state.ships,
        Shipping_State#shipping_state.ship_locations,
        Shipping_State#shipping_state.ship_inventory,
        Shipping_State#shipping_state.ports
    ),
    io:format("--Ports--~n"),
    _ = print_ports(
        Shipping_State#shipping_state.ports, Shipping_State#shipping_state.port_inventory
    ).

%% helper function for print_ships
get_port_helper([], _Port_ID) -> error;
get_port_helper([Port = #port{id = Port_ID} | _], Port_ID) -> Port;
get_port_helper([_ | Other_Ports], Port_ID) -> get_port_helper(Other_Ports, Port_ID).

print_ships(Ships, Locations, Inventory, Ports) ->
    case Ships of
        [] ->
            ok;
        [Ship | Other_Ships] ->
            {Port_ID, Dock_ID, _} = lists:keyfind(Ship#ship.id, 3, Locations),
            Port = get_port_helper(Ports, Port_ID),
            {ok, Ship_Inventory} = maps:find(Ship#ship.id, Inventory),
            io:format("Name: ~s(#~w)    Location: Port ~s, Dock ~s    Inventory: ~w~n", [
                Ship#ship.name, Ship#ship.id, Port#port.name, Dock_ID, Ship_Inventory
            ]),
            print_ships(Other_Ships, Locations, Inventory, Ports)
    end.

print_containers(Containers) ->
    io:format("~w~n", [Containers]).

print_ports(Ports, Inventory) ->
    case Ports of
        [] ->
            ok;
        [Port | Other_Ports] ->
            {ok, Port_Inventory} = maps:find(Port#port.id, Inventory),
            io:format("Name: ~s(#~w)    Docks: ~w    Inventory: ~w~n", [
                Port#port.name, Port#port.id, Port#port.docks, Port_Inventory
            ]),
            print_ports(Other_Ports, Inventory)
    end.
%% This functions sets up an initial state for this shipping simulation. You can add, remove, or modidfy any of this content. This is provided to you to save some time.
%% @returns {ok, shipping_state} where shipping_state is a shipping_state record with all the initial content.
shipco() ->
    Ships = [
        #ship{id = 1, name = "Santa Maria", container_cap = 20},
        #ship{id = 2, name = "Nina", container_cap = 20},
        #ship{id = 3, name = "Pinta", container_cap = 20},
        #ship{id = 4, name = "SS Minnow", container_cap = 20},
        #ship{id = 5, name = "Sir Leaks-A-Lot", container_cap = 20}
    ],
    Containers = [
        #container{id = 1, weight = 200},
        #container{id = 2, weight = 215},
        #container{id = 3, weight = 131},
        #container{id = 4, weight = 62},
        #container{id = 5, weight = 112},
        #container{id = 6, weight = 217},
        #container{id = 7, weight = 61},
        #container{id = 8, weight = 99},
        #container{id = 9, weight = 82},
        #container{id = 10, weight = 185},
        #container{id = 11, weight = 282},
        #container{id = 12, weight = 312},
        #container{id = 13, weight = 283},
        #container{id = 14, weight = 331},
        #container{id = 15, weight = 136},
        #container{id = 16, weight = 200},
        #container{id = 17, weight = 215},
        #container{id = 18, weight = 131},
        #container{id = 19, weight = 62},
        #container{id = 20, weight = 112},
        #container{id = 21, weight = 217},
        #container{id = 22, weight = 61},
        #container{id = 23, weight = 99},
        #container{id = 24, weight = 82},
        #container{id = 25, weight = 185},
        #container{id = 26, weight = 282},
        #container{id = 27, weight = 312},
        #container{id = 28, weight = 283},
        #container{id = 29, weight = 331},
        #container{id = 30, weight = 136}
    ],
    Ports = [
        #port{
            id = 1,
            name = "New York",
            docks = ['A', 'B', 'C', 'D'],
            container_cap = 200
        },
        #port{
            id = 2,
            name = "San Francisco",
            docks = ['A', 'B', 'C', 'D'],
            container_cap = 200
        },
        #port{
            id = 3,
            name = "Miami",
            docks = ['A', 'B', 'C', 'D'],
            container_cap = 200
        }
    ],
    %% {port, dock, ship}
    Locations = [
        {1, 'B', 1},
        {1, 'A', 3},
        {3, 'C', 2},
        {2, 'D', 4},
        {2, 'B', 5}
    ],
    Ship_Inventory = #{
        1 => [14, 15, 9, 2, 6],
        2 => [1, 3, 4, 13],
        3 => [],
        4 => [12, 8, 11, 7],
        5 => [5, 10, 12]
    },
    Port_Inventory = #{
        1 => [16, 17, 18, 19, 20],
        2 => [21, 22, 23, 24, 25],
        3 => [26, 27, 28, 29, 30]
    },
    #shipping_state{
        ships = Ships,
        containers = Containers,
        ports = Ports,
        ship_locations = Locations,
        ship_inventory = Ship_Inventory,
        port_inventory = Port_Inventory
    }.
