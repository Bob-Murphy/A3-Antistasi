private ["_group","_killer","_markerX","_super","_enemy"];
_group = _this select 0;
_killer = _this select 1;

{
if (fleeing _x) then
	{
	if ([_x] call A3A_fnc_canFight) then
		{
		_enemy = _x findNearestEnemy _x;
		if (!isNull _enemy) then
			{
			if ((_x distance _enemy < 50) and (vehicle _x == _x)) then
				{
				[_x] spawn A3A_fnc_surrenderAction;
				}
			else
				{
				if (_x == leader group _x) then
					{
					_super = false;
					_markerX = (leader _group) getVariable "markerX";
					if (!isNil "_markerX") then
						{
						if (_markerX in airportsX) then {_super = true};
						};
					if (vehicle _killer == _killer) then
						{
						[[getPosASL _enemy,side _x,"Normal",_super],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]
						}
					else
						{
						if (vehicle _killer isKindOf "Air") then {[[getPosASL _enemy,side _x,"Air",_super],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]} else {if (vehicle _killer isKindOf "Tank") then {[[getPosASL _enemy,side _x,"Tank",_super],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]} else {[[getPosASL _enemy,side _x,"Normal",_super],"A3A_fnc_patrolCA"] remoteExec ["A3A_fnc_scheduler",2]}};
						};
					};
				if (([primaryWeapon _x] call BIS_fnc_baseWeapon) in mguns) then {[_x,_enemy] call A3A_fnc_suppressingFire} else {[_x,_x,_enemy] spawn A3A_fnc_chargeWithSmoke};
				};
			};
		};
	}
else
	{
	if ([_x] call A3A_fnc_canFight) then
		{
		_enemy = _x findNearestEnemy _x;
		if (!isNull _enemy) then
			{
			if (([primaryWeapon _x] call BIS_fnc_baseWeapon) in mguns) then
				{
				[_x,_enemy] call A3A_fnc_suppressingFire;
				}
			else
				{
				if (sunOrMoon == 1 or haveNV) then
					{
					[_x,_x,_enemy] spawn A3A_fnc_chargeWithSmoke;
					}
				else
					{
					if (sunOrMoon < 1) then
						{
						if ((hasIFA and (typeOf _x in squadLeaders)) or (count (getArray (configfile >> "CfgWeapons" >> primaryWeapon _x >> "muzzles")) == 2)) then
							{
							[_x,_enemy] spawn A3A_fnc_useFlares;
							};
						};
					};
				};
			}
		else
			{
			if ((sunOrMoon <1) and !haveNV) then
				{
				if ((hasIFA and (typeOf _x in squadLeaders)) or (count (getArray (configfile >> "CfgWeapons" >> primaryWeapon _x >> "muzzles")) == 2)) then
					{
					[_x] call A3A_fnc_useFlares;
					};
				};
			};
		if (random 1 < 0.5) then {if (count units _group > 0) then {_x allowFleeing (1 -(_x skill "courage") + (({!([_x] call A3A_fnc_canFight)} count units _group)/(count units _group)))}};
		};
	};
sleep 1 + (random 1);
} forEach units _group;

