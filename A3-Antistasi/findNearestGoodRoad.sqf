private ["_pos","_roads","_road","_radius"];

_pos = _this select 0;

_roads = [];
_radius = 10;
_road = objNull;
while {isNull _road} do
	{
	_roads = _pos nearRoads _radius;
	if (count _roads > 0) then
		{
		{
		if ((surfaceType (position _x)!= "#GdtForest") and (surfaceType (position _x)!= "#GdtRock") and (surfaceType (position _x)!= "#GdtGrassTall")) exitWith {_road = _x};
		} forEach _roads;
		};
	_radius = _radius + 10;
	};
_road