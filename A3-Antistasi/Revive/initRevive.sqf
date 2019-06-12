private ["_unit"];
//this has to be put in onplayerrespawn as well
_unit = _this select 0;
//_unit setVariable ["inconsciente",false,true];

_unit setVariable ["respawning",false];
_unit addEventHandler ["HandleDamage", A3A_fnc_handleDamage];
