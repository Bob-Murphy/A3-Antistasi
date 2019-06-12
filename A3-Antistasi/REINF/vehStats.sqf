if (count hcSelected player == 0) exitWith {hint "You must select one group on the HC bar"};

private ["_group","_veh","_textX","_unitsX"];

/*
_esStatic = false;
{if (vehicle _x isKindOf "StaticWeapon") exitWith {_esStatic = true}} forEach units _group;
if (_esStatic) exitWith {hint "Static Weapon squad vehicles cannot be managed"};
*/

if (_this select 0 == "mount") exitWith
	{
	_textX = "";
	{
	_group = _x;
	_veh = objNull;
	{
	_owner = _x getVariable "owner";
	if (!isNil "_owner") then {if (_owner == _group) exitWith {_veh = _x}};
	} forEach vehicles;
	if !(isNull _veh) then
		{
		_transport = true;
		if (count allTurrets [_veh, false] > 0) then {_transport = false};
		if (_transport) then
			{
			if (leader _group in _veh) then
				{
				_textX = format ["%2%1 dismounting\n",groupID _group,_textX];
				{[_x] orderGetIn false; [_x] allowGetIn false} forEach units _group;
				}
			else
				{
				_textX = format ["%2%1 boarding\n",groupID _group,_textX];
				{[_x] orderGetIn true; [_x] allowGetIn true} forEach units _group;
				};
			}
		else
			{
			if (leader _group in _veh) then
				{
				_textX = format ["%2%1 dismounting\n",groupID _group,_textX];
				if (canMove _veh) then
					{
					{[_x] orderGetIn false; [_x] allowGetIn false} forEach assignedCargo _veh;
					}
				else
					{
					_veh allowCrewInImmobile false;
					{[_x] orderGetIn false; [_x] allowGetIn false} forEach units _group;
					}
				}
			else
				{
				_textX = format ["%2%1 boarding\n",groupID _group,_textX];
				{[_x] orderGetIn true; [_x] allowGetIn true} forEach units _group;
				};
			};
		};
	} forEach hcSelected player;
	if (_textX != "") then {hint format ["%1",_textX]};
	};
_textX = "";
_group = (hcSelected player select 0);
player sideChat format ["%1, SITREP!!",groupID _group];
_unitsX = units _group;
_textX = format ["%1 Status\n\nAlive members: %2\nAble to combat: %3\nCurrent task: %4\nCombat Mode:%5\n",groupID _group,{alive _x} count _unitsX,{[_x] call A3A_fnc_canFight} count _unitsX,_group getVariable ["taskX","Patrol"],behaviour (leader _group)];
if ({[_x] call A3A_fnc_isMedic} count _unitsX > 0) then {_textX = format ["%1Operative Medic\n",_textX]} else {_textX = format ["%1No operative Medic\n",_textX]};
if ({_x call A3A_fnc_typeOfSoldier == "ATMan"} count _unitsX > 0) then {_textX = format ["%1With AT capabilities\n",_textX]};
if ({_x call A3A_fnc_typeOfSoldier == "AAMan"} count _unitsX > 0) then {_textX = format ["%1With AA capabilities\n",_textX]};
if (!(isNull(_group getVariable ["mortarsX",objNull])) or ({_x call A3A_fnc_typeOfSoldier == "StaticMortar"} count _unitsX > 0)) then
	{
	if ({vehicle _x isKindOf "StaticWeapon"} count _unitsX > 0) then {_textX = format ["%1Mortar is deployed\n",_textX]} else {_textX = format ["%1Mortar not deployed\n",_textX]};
	}
else
	{
	if ({_x call A3A_fnc_typeOfSoldier == "StaticGunner"} count _unitsX > 0) then
		{
		if ({vehicle _x isKindOf "StaticWeapon"} count _unitsX > 0) then {_textX = format ["%1Static is deployed\n",_textX]} else {_textX = format ["%1Static not deployed\n",_textX]};
		};
	};

_veh = objNull;
{
_owner = _x getVariable "owner";
if (!isNil "_owner") then {if (_owner == _group) exitWith {_veh = _x}};
} forEach vehicles;
if (isNull _veh) then
	{
	{
	if ((vehicle _x != _x) and (_x == driver _x) and !(vehicle _x isKindOf "StaticWeapon")) exitWith {_veh = vehicle _x};
	} forEach _unitsX;
	};
if !(isNull _veh) then
	{
	_textX = format ["%1Current vehicle:\n%2\n",_textX,getText (configFile >> "CfgVehicles" >> (typeOf _veh) >> "displayName")];
	if (!alive _veh) then
		{
		_textX = format ["%1DESTROYED",_textX];
		}
	else
		{
		if (!canMove _veh) then {_textX = format ["%1DISABLED\n",_textX]};
		if (count allTurrets [_veh, false] > 0) then
			{
			if (!canFire _veh) then {_textX = format ["%1WEAPON DISABLED\n",_textX]};
			if (someAmmo _veh) then {_textX = format ["%1Munitioned\n",_textX]};
			};
		_textX = format ["%1Boarded:%2/%3",_textX,{vehicle _x == _veh} count _unitsX,{alive _x} count _unitsX];
		};
	};
hint format ["%1",_textX];
