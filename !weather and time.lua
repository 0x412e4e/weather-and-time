script_name("Weather and Time")
script_version("1.1")
script_author("James_Bond/rubbishman/Coulson")
local LIP = {};
local dlstatus = require('moonloader').download_status
local mod_submenus_sa = {
	{
		title = '���������� � �������',
		onclick = function()
			wait(100)
			cmdInfo()
		end
	},
	{
		title = ' '
	},
	{
		title = '{AAAAAA}���������'
	},
	{
		title = '��������� �������',
		submenu = {
			{
				title = '�������� ������� ���������',
				onclick = function()
					cmdHotKey()
				end
			},
			{
				title = '��������/��������� ����������� ��� �������',
				onclick = function()
					cmdInform()
				end
			},
		}
	},
	{
		title = ' '
	},
	{
		title = '{AAAAAA}����������'
	},
	{
		title = '������� ����������',
		onclick = function()
			changelog()
		end
	},
	{
		title = '������������� ��������',
		onclick = function()
			lua_thread.create(goupdate)
		end
	},
}
require 'lib.moonloader'
require 'lib.sampfuncs'
function main()
	if not isSampLoaded() or not isCleoLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	lua_thread.create(checkversion)
	while goplay == 0 or goplay == 2 do wait(100) end
	firstload()
	onload()
	while true do
		wait(0)
		if data.options.timebycomp == 1 then setTimeOfDay(os.date("%H"), os.date("%M")) end
	end
end

function firstload()
	if not doesDirectoryExist("moonloader\\config") then createDirectory("moonloader\\config") end
	if not doesFileExist("moonloader\\config\\weather and time.ini") then
		local data =
		{
			options =
			{
				startmessage = 1,
				timebycomp = 1,
			},
		};
		LIP.save('moonloader\\config\\weather and time.ini', data);
		sampAddChatMessage(('������ ������ �������. ��� ������ .ini: moonloader\\config\\weather and time.ini'), 0x348cb2)
	end
end
function onload()
	data = LIP.load('moonloader\\config\\weather and time.ini');
	LIP.save('moonloader\\config\\weather and time.ini', data);
	sampRegisterChatCommand("weather", watmenu)
	sampRegisterChatCommand("wat", watmenu)
	sampRegisterChatCommand("sw", cmdSetWeather)
	sampRegisterChatCommand("setweather", cmdSetCustomWeather)
	sampRegisterChatCommand("timenot", cmdTimeNot)
	sampRegisterChatCommand("weatherhelp", cmdHelpWeather)
	sampRegisterChatCommand("weathernot", cmdWeatherInform)
	sampRegisterChatCommand("weatherlog", changelog)
	if data.options.startmessage == 1 then sampAddChatMessage(('Weather and Time �������. v '..thisScript().version), 0x348cb2) end
	if data.options.startmessage == 1 then sampAddChatMessage(('��������� - /weather. ��������� ��� ��������� - /weathernot'), 0x348cb2) end
end

function watmenu()
	menutrigger = 1
end
function menu()
	submenus_show(mod_submenus_sa, '{348cb2}Weather & Time v'..thisScript().version..'', '�������', '�������', '�����')
end


function cmdSetWeather(param)
	local newweather = tonumber(param)
	if newweather == nil then
		lua_thread.create(cmdChangeWeatherDialog)
	end
	if newweather ~= nil and newweather > - 1 and newweather < 23 and newweather ~= nil then
		forceWeatherNow(newweather)
	end
end
function cmdChangeWeatherDialog()
	sampShowDialog(838, "/sw - �������� ������: ", "ID\t��������\n00\t����������� ������\n01\t����������� ������\n02\t����������� ������\n03\t����������� ������\n04\t����������� ������\n05\t����������� ������\n06\t����������� ������\n07\t����������� ������\n08\t�����, �����\n09\t��������, �������� ������\n10\t������ ����\n11\t���������� ����\n12\t������� ������\n13\t������� ������\n14\t������� ������\n15\t�������, ���������� ������\n16\t�������, ���������\n17\t���������� ����\n18\t���������� ����\n19\t�������� ����\n20\t��������\n21\t����� �����, ���������\n22\t����� �����, �������", "�������", "�������", 5)
	while sampIsDialogActive() do wait(0) end
	sampCloseCurrentDialogWithButton(0)
	local resultMain, buttonMain, typ, tryyy = sampHasDialogRespond(838)
	if resultMain then
		if buttonMain == 1 then
			forceWeatherNow(typ)
		end
	end
end
function cmdSetCustomWeather(param)
	local newweather = tonumber(param)
	if newweather ~= nil then
		forceWeatherNow(newweather)
	end
end
function cmdScriptInfo()
	sampShowDialog(2342, "{ffbf00}Weather and Time. �����: James_Bond/rubbishman/Coulson.", "{ffcc00}��� ���� ���� ������?\n{ffffff}������ ������� ���������� ����������� ������ �� �������� SA:MP. Ÿ �� ����� ������ ��-�� ����, ���\n�� � ���� ����� � "..os.date("%Y").." ���� ���������� ������ ���������, ����� ��������� ����� ���� 2004 ����.\n������ ������ ������� ��������� ��� ��������, ��� ����������� ���������� 1080 ti ��������� ��������.\n{ffcc00}� ��� ����������-��?\n{ffffff}������ ����� ������ ���������� ����� ������ �� ����� ���� � ��������� �� ������.\n����� ����, �� ������ ���� ���������� ������ ��� ������ ����� ������� � ���� ��� ������. \n{ffcc00}��������� �������:\n{00ccff}/weather {ffffff}- ��� ����\n{00ccff}/sw {ffffff}- �������� ������ ����� ���������� ����\n{00ccff}/sw [0-22] {ffffff}- �������� ������ �� id (���������� ������)\n{00ccff}/setweather [����� �����] {ffffff}- �������� ������ �� id (������������ ������)\n{00ccff}/weatherhelp {ffffff}- ������� ���� � ��������\n{00ccff}/timenot {ffffff}- ��������/��������� ������� ����� �������� ������� �� ����� ����������\n{00ccff}/weathernot {ffffff}- ��������/��������� ����������� ��� ������� SA:MP\n{00ccff}/weatherlog {ffffff}- changelog �������\n\nP.S. ������� � ������������ �������, ����� �������, ��� id'� ���� 22 ����� ������ ���������� ����\n� ����������� �����. ��������� - {00ccff}/weatherhelp\n\n{ffffff}����� ������� ������� �� ������������ �������� ����� GTA San Andreas ����� �������������\n������ ������ � ����������� �� ����� ������ �����. � ����������..", "����")
end
function cmdHelpWeather()
	local ffi = require 'ffi'
	ffi.cdef [[
					void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
					uint32_t __stdcall CoInitializeEx(void*, uint32_t);
				]]
	local shell32 = ffi.load 'Shell32'
	local ole32 = ffi.load 'Ole32'
	ole32.CoInitializeEx(nil, 2 + 4) -- COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE
	print(shell32.ShellExecuteA(nil, 'open', 'http://dev.prineside.com/gtasa_weather_id/', nil, nil, 1))
end
function changelog()
	sampShowDialog(2342, "{ffbf00}Weather and Time: ������� ������.", "{ffcc00}v1.0 [23.10.17]\n{ffffff}������ ����� �������.\n������ ��� ����� ������ ������ �� id.\n������ ��� ����� ������ ������ ����� ������.\n������ ��� ����� ������ ����� ���� �� ������� �������.\n������ ��� ����� ���������.\n������ ��� ����� ��������������.\n������ ��� ����� ���� changelog.", "�������")
end
function cmdWeatherInform()
	if data.options.startmessage == 1 then
		data.options.startmessage = 0 sampAddChatMessage(('����������� ��������� Weather and Time ��� ������� ���� ���������'), 0x348cb2)
	else
		data.options.startmessage = 1 sampAddChatMessage(('����������� ��������� Weather and Time ��� ������� ���� ��������'), 0x348cb2)
	end
	LIP.save('moonloader\\config\\weather and time.ini', data);
	data = LIP.load('moonloader\\config\\weather and time.ini');
end
function cmdTimeNot()
	if data.options.timebycomp == 1 then
		data.options.timebycomp = 0 sampAddChatMessage(('��������� ������� ����� ����� ���������� ���������'), 0x348cb2)
	else
		data.options.timebycomp = 1 sampAddChatMessage(('��������� ������� ����� ����� ���������� ��������'), 0x348cb2)
	end
	LIP.save('moonloader\\config\\weather and time.ini', data);
	data = LIP.load('moonloader\\config\\weather and time.ini');
end

-- do not touch
function LIP.load(fileName)
	assert(type(fileName) == 'string', 'Parameter "fileName" must be a string.');
	local file = assert(io.open(fileName, 'r'), 'Error loading file : ' .. fileName);
	local data = {};
	local section;
	for line in file:lines() do
		local tempSection = line:match('^%[([^%[%]]+)%]$');
		if(tempSection)then
			section = tonumber(tempSection) and tonumber(tempSection) or tempSection;
			data[section] = data[section] or {};
		end
		local param, value = line:match('^([%w|_]+)%s-=%s-(.+)$');
		if(param and value ~= nil)then
			if(tonumber(value))then
				value = tonumber(value);
			elseif(value == 'true')then
				value = true;
			elseif(value == 'false')then
				value = false;
			end
			if(tonumber(param))then
				param = tonumber(param);
			end
			data[section][param] = value;
		end
	end
	file:close();
	return data;
end
function LIP.save(fileName, data)
	assert(type(fileName) == 'string', 'Parameter "fileName" must be a string.');
	assert(type(data) == 'table', 'Parameter "data" must be a table.');
	local file = assert(io.open(fileName, 'w+b'), 'Error loading file :' .. fileName);
	local contents = '';
	for section, param in pairs(data) do
		contents = contents .. ('[%s]\n'):format(section);
		for key, value in pairs(param) do
			contents = contents .. ('%s=%s\n'):format(key, tostring(value));
		end
		contents = contents .. '\n';
	end
	file:write(contents);
	file:close();
end
function checkversion()
	goplay = 0
	local fpath = os.getenv('TEMP') .. '\\weather-version.json'
	downloadUrlToFile('http://rubbishman.ru/dev/samp/weather%20and%20time/version.json', fpath, function(id, status, p1, p2)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
		local f = io.open(fpath, 'r')
		if f then
			local info = decodeJson(f:read('*a'))
			updatelink = info.updateurl
			if info and info.latest then
				version = tonumber(info.latest)
				if version > tonumber(thisScript().version) then
					sampAddChatMessage(('[Weather and Time]: ���������� ����������. AutoReload ����� �������������. ����������..'), 0x348cb2)
					sampAddChatMessage(('[Weather and Time]: ������� ������: '..thisScript().version..". ����� ������: "..version), 0x348cb2)
					goplay = 2
					lua_thread.create(goupdate)
				end
			end
		end
	end
end)
wait(1000)
if goplay ~= 2 then goplay = 1 end
end
function goupdate()
wait(300)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23)
	if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
	sampAddChatMessage(('[Weather and Time]: ���������� ���������! ��������� �� ���������� - /weatherlog.'), 0x348cb2)
	goplay = 1
	thisScript():reload()
end
end)
end
