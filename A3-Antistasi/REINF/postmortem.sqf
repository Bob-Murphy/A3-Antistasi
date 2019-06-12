_victim = _this select 0;
sleep cleantime;
deleteVehicle _victim;
_group = group _victim;
if (!isNull _group) then
	{
	if ({alive _x} count units _group == 0) then {deleteGroup _group};
	}
else
	{
	if (_victim in staticsToSave) then {staticsToSave = staticsToSave - [_victim]; publicVariable "staticsToSave";};
	};
