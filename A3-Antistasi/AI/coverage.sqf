private ["_unit","_enemyX","_small","_big","_object","_posBehind","_objectsX","_roads","_typeX","_p1","_p2","_ancho","_grueso","_alto","_posEnemy","_pos","_arr","_group"];
_unit = _this select 0;
_enemyX = _this select 1;
_small= [];
_big = [];
_object = objNull;
_pos = [];
_posBehind = (position _unit) getPos [5,_enemyX getDir _unit];
_group = group _unit;
_objectsX = (nearestObjects [_posBehind, [], 30]) select {!(_x in (_group getVariable ["usedForCover",[]]))};
_roads = _posBehind nearRoads 30;
{
_typeX = typeOf _x;
if !(_typeX in ["#crater","#crateronvehicle","#soundonvehicle","#particlesource","#lightpoint","#slop","#mark","HoneyBee","Mosquito","HouseFly","FxWindPollen1","ButterFly_random","Snake_random_F","Rabbit_F","FxWindGrass2","FxWindLeaf1","FxWindGrass1","FxWindLeaf3","FxWindLeaf2"]) then
	{
	if (!(_x isKindOf "Man") && {!(_x isKindOf "Bird")} && {!(_x isKindOf "BulletCore")} && {!(_x isKindOf "Grenade")} && {!(_x isKindOf "WeaponHolder")} && {(_x distance _enemyX > 5)}) then
		{
		_p1 = (boundingBoxReal _x) select 0;
		_p2 = (boundingBoxReal _x) select 1;
		_ancho = abs ((_p2 select 0) - (_p1 select 0));
		_grueso = abs ((_p2 select 1) - (_p1 select 1));
		_alto = abs ((_p2 select 2) - (_p1 select 2));
		if (_ancho > 2 && _grueso > 0.5 && _alto > 2) then
			{
			if (_typeX isEqualTo "") then
				{
				_small pushback _x
				}
			else
				{
				_big pushback _x;
				};
			}
		};
	};
} foreach ((_objectsX) - (_roads));

if ((count _big == 0) and (count _small == 0)) exitWith {[]};

if !(_big isEqualTo []) then {_object = [_big,_unit] call BIS_fnc_nearestPosition} else {_object = [_small,_unit] call BIS_fnc_nearestPosition};

if (isNull _object) exitWith {_pos};
if !(_object isKindOf "House") then
	{
	_arr = _group getVariable ["usedForCover",[]];
	_arr pushBack _object;
	_group setVariable ["usedForCover",_arr];
	[_object,_group] spawn
		{
		sleep 60;
		private ["_object","_group","_arr"];
		_object = _this select 0;
		_group = _this select 1;
		if (!(isNull _group) and !(isNull _object)) then
			{
			_arr = _group getVariable ["usedForCover",[]];
			_arr = _arr - [_object];
			_group setVariable ["usedForCover",_arr];
			};
		};
	};
_posEnemy = position _enemyX;
_pos = _posEnemy getPos [(_object distance _posEnemy) + 2, _posEnemy getDir _object];
_pos