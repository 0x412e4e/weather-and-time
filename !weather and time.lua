require 'lib.moonloader'
--------------------------------------------------------------------------------
-------------------------------------META---------------------------------------
--------------------------------------------------------------------------------
script_name("Weather and Time")
script_version("25.06.2022")
script_author("qrlk")
script_description("Мощный инструмент для изменения внутриигрового погоды и времени.")
script_url("https://github.com/qrlk/weather-and-time")

-- https://github.com/qrlk/qrlk.lua.moonloader
local enable_sentry = true -- false to disable error reports to sentry.io
if enable_sentry then
  local sentry_loaded, Sentry = pcall(loadstring, [=[return {init=function(a)local b,c,d=string.match(a.dsn,"https://(.+)@(.+)/(%d+)")local e=string.format("https://%s/api/%d/store/?sentry_key=%s&sentry_version=7&sentry_data=",c,d,b)local f=string.format("local target_id = %d local target_name = \"%s\" local target_path = \"%s\" local sentry_url = \"%s\"\n",thisScript().id,thisScript().name,thisScript().path:gsub("\\","\\\\"),e)..[[require"lib.moonloader"script_name("sentry-error-reporter-for: "..target_name.." (ID: "..target_id..")")script_description("Этот скрипт перехватывает вылеты скрипта '"..target_name.." (ID: "..target_id..")".."' и отправляет их в систему мониторинга ошибок Sentry.")local a=require"encoding"a.default="CP1251"local b=a.UTF8;local c="moonloader"function getVolumeSerial()local d=require"ffi"d.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local e=d.new("unsigned long[1]",0)d.C.GetVolumeInformationA(nil,nil,0,e,nil,nil,nil,0)e=e[0]return e end;function getNick()local f,g=pcall(function()local f,h=sampGetPlayerIdByCharHandle(PLAYER_PED)return sampGetPlayerNickname(h)end)if f then return g else return"unknown"end end;function getRealPath(i)if doesFileExist(i)then return i end;local j=-1;local k=getWorkingDirectory()while j*-1~=string.len(i)+1 do local l=string.sub(i,0,j)local m,n=string.find(string.sub(k,-string.len(l),-1),l)if m and n then return k:sub(0,-1*(m+string.len(l)))..i end;j=j-1 end;return i end;function url_encode(o)if o then o=o:gsub("\n","\r\n")o=o:gsub("([^%w %-%_%.%~])",function(p)return("%%%02X"):format(string.byte(p))end)o=o:gsub(" ","+")end;return o end;function parseType(q)local r=q:match("([^\n]*)\n?")local s=r:match("^.+:%d+: (.+)")return s or"Exception"end;function parseStacktrace(q)local t={frames={}}local u={}for v in q:gmatch("([^\n]*)\n?")do local w,x=v:match("^	*(.:.-):(%d+):")if not w then w,x=v:match("^	*%.%.%.(.-):(%d+):")if w then w=getRealPath(w)end end;if w and x then x=tonumber(x)local y={in_app=target_path==w,abs_path=w,filename=w:match("^.+\\(.+)$"),lineno=x}if x~=0 then y["pre_context"]={fileLine(w,x-3),fileLine(w,x-2),fileLine(w,x-1)}y["context_line"]=fileLine(w,x)y["post_context"]={fileLine(w,x+1),fileLine(w,x+2),fileLine(w,x+3)}end;local z=v:match("in function '(.-)'")if z then y["function"]=z else local A,B=v:match("in function <%.* *(.-):(%d+)>")if A and B then y["function"]=fileLine(getRealPath(A),B)else if#u==0 then y["function"]=q:match("%[C%]: in function '(.-)'\n")end end end;table.insert(u,y)end end;for j=#u,1,-1 do table.insert(t.frames,u[j])end;if#t.frames==0 then return nil end;return t end;function fileLine(C,D)D=tonumber(D)if doesFileExist(C)then local E=0;for v in io.lines(C)do E=E+1;if E==D then return v end end;return nil else return C..D end end;function onSystemMessage(q,type,i)if i and type==3 and i.id==target_id and i.name==target_name and i.path==target_path and not q:find("Script died due to an error.")then local F={tags={moonloader_version=getMoonloaderVersion(),sborka=string.match(getGameDirectory(),".+\\(.-)$")},level="error",exception={values={{type=parseType(q),value=q,mechanism={type="generic",handled=false},stacktrace=parseStacktrace(q)}}},environment="production",logger=c.." (no sampfuncs)",release=i.name.."@"..i.version,extra={uptime=os.clock()},user={id=getVolumeSerial()},sdk={name="qrlk.lua.moonloader",version="0.0.0"}}if isSampAvailable()and isSampfuncsLoaded()then F.logger=c;F.user.username=getNick().."@"..sampGetCurrentServerAddress()F.tags.game_state=sampGetGamestate()F.tags.server=sampGetCurrentServerAddress()F.tags.server_name=sampGetCurrentServerName()else end;print(downloadUrlToFile(sentry_url..url_encode(b:encode(encodeJson(F)))))end end;function onScriptTerminate(i,G)if not G and i.id==target_id then lua_thread.create(function()print("скрипт "..target_name.." (ID: "..target_id..")".."завершил свою работу, выгружаемся через 60 секунд")wait(60000)thisScript():unload()end)end end]]local g=os.tmpname()local h=io.open(g,"w+")h:write(f)h:close()script.load(g)os.remove(g)end}]=])
  if sentry_loaded and Sentry then
    pcall(Sentry().init, { dsn = "https://3e529cd476dc40e6b03ce2eca6a40efa@o1272228.ingest.sentry.io/6530029" })
  end
end

-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
  local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
  if updater_loaded then
    autoupdate_loaded, Update = pcall(Updater)
    if autoupdate_loaded then
      Update.json_url = "https://raw.githubusercontent.com/qrlk/weather-and-time/master/version.json?" .. tostring(os.clock())
      Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
      Update.url = "https://github.com/qrlk/weather-and-time"
    end
  end
end
--------------------------------------VAR---------------------------------------
local dlstatus = require('moonloader').download_status
color = 0x348cb2
local prefix = '['..string.upper(thisScript().name)..']: '
local inicfg = require 'inicfg'
local data = inicfg.load({
  options =
  {
    startmessage = 1,
    timebycomp1 = true,
    weatherrandom = false,
    autoupdate = 1,
    lastw = 1,
    lastt = 25,
  },
}, 'weather and time')
--------------------------------------------------------------------------------
-------------------------------------MAIN---------------------------------------
--------------------------------------------------------------------------------
function main()
  if not isSampLoaded() or not isCleoLoaded() or not isSampfuncsLoaded() then return end
  while not isSampAvailable() do wait(100) end
  if data.options.autoupdate == 1 then
    -- вырежи тут, если хочешь отключить проверку обновлений
    if autoupdate_loaded and enable_autoupdate and Update then
      pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end
    -- вырежи тут, если хочешь отключить проверку обновлений
  end

  if data.options.timebycomp1 == false and data.options.lastt ~= 25 then time = data.options.lastt end
  onload()
  menuupdate()
  if data.options.weatherrandom == false then addweather = data.options.lastw end
  while true do
    wait(0)
    if weatherrandom12:status() == 'dead' then weatherrandom12:run() end
    if timesync:status() == 'dead' then timesync:run() end
    if addweather ~= nil then forceWeatherNow(addweather) end
    if time and data.options.timebycomp1 == false then
      if minutes == nil then
        setTimeOfDay(time, 0)
      else
        setTimeOfDay(time, minutes)
      end
    end
  end
end
function menuuuu()
  while true do
    wait(0)
    if menutrigger ~= nil then menu() menutrigger = nil end
  end
end
--------------------------------------------------------------------------------
------------------------------------ONLOAD--------------------------------------
--------------------------------------------------------------------------------
function onload()
  sampRegisterChatCommand("weather", watmenu)
  sampRegisterChatCommand("wat", watmenu)
  sampRegisterChatCommand("sw", cmdSetWeather)
  sampRegisterChatCommand("st", st)
  sampRegisterChatCommand("setweather", cmdSetCustomWeather)
  sampRegisterChatCommand("timelapse", function(param) lua_thread.create(timelapse, param) end)
  if data.options.startmessage == 1 then sampAddChatMessage(('Weather and Time v '..thisScript().version..' started.'), color) end
  if data.options.startmessage == 1 then sampAddChatMessage(('More details - /weather or /wat. You can disable this message in the settings.'), color) end
  weatherrandom12 = lua_thread.create_suspended(weatherrandom1)
  weatherrandom12:terminate()
  if data.options.weatherrandom == true then
    weatherrandom12:run()
  end
  timesync = lua_thread.create_suspended(timesync)
  timesync:terminate()
  lua_thread.create(menuuuu)
  lua_thread.create(nextpls)
end
--------------------------------------------------------------------------------
------------------------------------WEATHER-------------------------------------
--------------------------------------------------------------------------------
--АЛГОРИТМ РАНДОМНОГО ВЫБОРА ПОГОДЫ
function weatherrandom1()
  while true do
    wait(0)
    if data.options.weatherrandom == true then
      math.randomseed(os.time())
      addweather = math.random(0, 23)
      wait(math.random(180000, 600000))
    end
  end
end
function nextpls()
  while true do
    wait(0)
    if data.options.weatherrandom == true then
      if isKeyDown(35) and isPlayerPlaying(playerPed) and isSampfuncsConsoleActive() == false and sampIsChatInputActive() == false and sampIsDialogActive() == false then
        weatherrandom12:terminate()
        weatherrandom12:run()
      end
    else
      if isKeyDown(35) and isPlayerPlaying(playerPed) and isSampfuncsConsoleActive() == false and sampIsChatInputActive() == false and sampIsDialogActive() == false then
        math.randomseed(os.time())
        addweather = math.random(0, 23)
        data.options.lastw = addweather
        inicfg.save(data, "weather and time")
      end
    end
  end
end
---------------------------------SETWEATHER-------------------------------------
--ДИАЛОГ /SETWEATHER
function cmdChangeWeatherUnstableDialog()
  sampShowDialog(987, "Change Weather", string.format("Enter Weather ID"), "Select", "Close", 1)
  while sampIsDialogActive() do wait(100) end
  local result, button, list, input = sampHasDialogRespond(987)
  if button == 1 then
    if tonumber(sampGetCurrentDialogEditboxText(987)) ~= nil then
      cmdSetCustomWeather(sampGetCurrentDialogEditboxText(987))
    end
  end
end
--ФУНКЦИЯ /SETWEATHER
function cmdSetCustomWeather(param)
  local newweather = tonumber(param)
  if newweather == nil then
    lua_thread.create(cmdChangeWeatherUnstableDialog)
  end
  if newweather ~= nil then
    addweather = newweather
    data.options.lastw = addweather
    inicfg.save(data, "weather and time")
    if data.options.weatherrandom == true then cmdWeather1Toggle() end
  end
end
-------------------------------------SW-----------------------------------------
--ДИАЛОГ /SW
function cmdChangeWeatherDialog()
  sampShowDialog(838, "/sw - change weather: ", "ID\tDescription\n00\tStandard weather\n01\tStandard weather\n02\tStandard weather\n03\tStandard weather\n04\tStandard weather\n05\tStandard weather\n06\tStandard weather\n07\tStandard weather\n08\tRain, thunderstorm\n09\tCloudy, foggy weather\n10\tClear sky\n11\tScorching heat\n12\tDull weather\n13\tDull weather\n14\tDull weather\n15\tDull, colorless weather\n16\tDull, rainy\n17\tScorching heat\n18\tScorching heat\n19\tSandstorm\n20\tFoggy\n21\tVery dark, purple\n22\tVery dark, green", "Select", "Close", 5)
  while sampIsDialogActive() do wait(0) end
  sampCloseCurrentDialogWithButton(0)
  local resultMain, buttonMain, typ, tryyy = sampHasDialogRespond(838)
  if resultMain then
    if buttonMain == 1 then
      addweather = typ
      data.options.lastw = addweather
      inicfg.save(data, "weather and time")
      if data.options.weatherrandom == true then cmdWeather1Toggle() end
    end
  end
end
--ФУНКЦИЯ /SW
function cmdSetWeather(param)
  local newweather = tonumber(param)
  if newweather == nil then
    lua_thread.create(cmdChangeWeatherDialog)
  end
  if newweather ~= nil and newweather > - 1 and newweather < 23 and newweather ~= nil then
    addweather = newweather
    data.options.lastw = addweather
    inicfg.save(data, "weather and time")
    if data.options.weatherrandom == true then cmdWeather1Toggle() end
  end
end
--------------------------------------------------------------------------------
--------------------------------------TIME--------------------------------------
--------------------------------------------------------------------------------
--СИНХРОНИЗАЦИЯ ЛОКАЛЬНОГО ВРЕМЕНИ
function timesync()
  while true do
    wait(0)
    if data.options.timebycomp1 == true then setTimeOfDay(os.date("%H"), os.date("%M")) end
  end
end
--ДИАЛОГ /SETWEATHER
function stdialog()
  sampShowDialog(988, "Change Time", string.format("Enter hour [1-23]"), "Select", "Close", 1)
  while sampIsDialogActive() do wait(100) end
  local result, button, list, input = sampHasDialogRespond(988)
  if button == 1 then
    if tonumber(sampGetCurrentDialogEditboxText(988)) ~= nil and tonumber(sampGetCurrentDialogEditboxText(988)) >= 1 and tonumber(sampGetCurrentDialogEditboxText(988)) < 24 then
      st(tonumber(sampGetCurrentDialogEditboxText(988)))
    end
  end
end
function st(param)
  data.options.timebycomp1 = false
  local hour = tonumber(param)
  if hour ~= nil and hour >= 0 and hour <= 23 then
    time = hour
    data.options.lastt = time
  else
    time = nil
  end
  inicfg.save(data, "weather and time")
end
--time lapse
function split(s, delimiter)
  result = {};
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match);
  end
  return result;
end
function timelapse(str)
  if str == "" then
    sampAddChatMessage(prefix.."Usage: /timelapse [start hour] [how many hours to spin] [hour change delay (ms)] [delay before start]", - 1)
  else
		restore_set1 = data.options.timebycomp1
		restore_set2 = time
    data.options.timebycomp1 = false
    tab = split(str, " ")
    lengthNum = 0
    for k, v in pairs(tab) do -- for every key in the table with a corresponding non-nil value
      lengthNum = lengthNum + 1
    end
    if lengthNum == 4 then
      start = tonumber(tab[1])
      finish = tonumber(tab[2])
      delay1 = tonumber(tab[3])
      delay2 = tonumber(tab[4])
    end
    if start == nil or finish == nil or delay1 == nil or delay2 == nil or start < 0 or start >= 24 or finish < 1 or delay1 < 0 or delay2 < 0 then
      sampAddChatMessage(prefix.."Input error. Usage: /timelapse [start hour] [how many hours to spin] [hour change delay (ms)] [delay before start]", color)
      return
    end
    wait(delay2)
		--a = os.clock()
		for i = 1, finish, 1 do
      for z = 0, 12, 1 do
        if start + i >= 24 then
          time = (start + i) % 24
        else
          time = start + i
        end
				minutes = z*5
				wait(math.floor(delay1 / 12))
			--	print(time..":"..minutes.." Delay: "..math.floor(delay1 / 12)..". Time"..os.clock()-a)
      end
    end
		minutes = nil
		data.options.timebycomp1 = restore_set1
		time = restore_set2
  end
end
--------------------------------------------------------------------------------
-------------------------------------MENU---------------------------------------
--------------------------------------------------------------------------------
--TOGGLE MENU
function watmenu()
  menutrigger = 1
end
--MENU
function menu()
  menuupdate()
  submenus_show(mod_submenus_sa, '{348cb2}Weather & Time v'..thisScript().version..'', 'Select', 'Close', 'Back')
end
--менюшка
function menuupdate()
  mod_submenus_sa = {
    {
      title = 'Script Information',
      onclick = function()
        wait(100)
        cmdScriptInfo()
      end
    },
    {
      title = 'Contact the author (all bugs here)',
      onclick = function()
        os.execute('explorer "http://qrlk.me/sampcontact"')
      end
    },
    {
      title = ' '
    },
    {
      title = '{AAAAAA}Weather Functions'
    },
    {
      title = string.format("Random weather selection: %s", data.options.weatherrandom),
      onclick = function()
        cmdWeather1Toggle()
        menuupdate()
        menu()
      end
    },
    {
      title = 'Change Weather (stable)',
      onclick = function()
        wait(100)
        cmdChangeWeatherDialog()
      end
    },
    {
      title = 'Change Weather (unstable)',
      onclick = function()
        wait(100)
        cmdSetCustomWeather()
      end
    },
    {
      title = 'Open Weather ID Gallery',
      onclick = function()
        cmdHelpWeather()
      end
    },
    {
      title = ' '
    },
    {
      title = '{AAAAAA}Time Functions'
    },
    {
      title = string.format("Sync local time: %s", data.options.timebycomp1),
      onclick = function()
        cmdTimeNot()
        menuupdate()
        menu()
      end
    },
    {
      title = 'Change Time Manually',
      onclick = function()
        stdialog()
      end
    },
    {
      title = 'NEW: timelapse',
      onclick = function()
        timelapse("")
      end
    },
    {
      title = ' '
    },
    {
      title = '{AAAAAA}Settings'
    },
    {
      title = 'Script Settings',
      submenu = {
        {
          title = 'Enable/disable startup notification',
          onclick = function()
            cmdWeatherInform()
          end
        },
        {
          title = 'Enable/disable auto-update',
          onclick = function()
            cmdWatUpdate()
          end
        },
      }
    },
    {
      title = ' '
    },
    {
      title = '{AAAAAA}Updates'
    },
    {
      title = 'Subscribe to the VKontakte group!',
      onclick = function()
        os.execute('explorer "http://qrlk.me/sampvk"')
      end
    },
    {
      title = 'Open script page',
      onclick = function()
        os.execute('explorer "http://qrlk.me/samp/wat"')
      end
    },
    {
      title = 'Update History',
      onclick = function()
        lua_thread.create(
          function()
            if changelogurl == nil then
              changelogurl = "http://qrlk.me/changelog/wat"
            end
            sampShowDialog(222228, "{ff0000}Update Information", "{ffffff}"..thisScript().name.." {ffe600}is about to open its changelog for you.\nIf you click {ffffff}Open{ffe600}, the script will try to open the link:\n        {ffffff}"..changelogurl.."\n{ffe600}If your game crashes, you can open this link yourself.", "Open", "Cancel")
            while sampIsDialogActive() do wait(100) end
            local result, button, list, input = sampHasDialogRespond(222228)
            if button == 1 then
              os.execute('explorer "'..changelogurl..'"')
            end
          end
        )
      end
    },
  }
end
--контент
function cmdScriptInfo()
  sampShowDialog(2342, "{348cb2}Weather and Time. Author: qrlk.", "{ffcc00}What is this script for?\n{ffffff}The script provides many features for managing weather and time in SA:MP.\nThe future has arrived: now you can render 2004 rain without lag.\nIt stands out among others with unique features, convenience, and settings.\n{AAAAAA}Weather Functions:\n{348cb2}Random weather selection: {ffffff}AI randomly changes the weather every 3-10 minutes.\n{348cb2}Change Weather (stable): {ffffff}change the weather to stable (0-22).\n{348cb2}Change Weather (unstable): {ffffff}change the weather to unstable (any id).\n{348cb2}Open Weather ID Gallery: {ffffff}open the weather ID gallery in the browser.\n{AAAAAA}Time Functions:\n{348cb2}Sync local time: {ffffff}the function changes the game time to the computer time.\n{348cb2}Change time manually: {ffffff}change the time to the specified hour.\n{ffcc00}Available commands:\n{00ccff}/weather (/wat){ffffff} - script menu.\n{00ccff}/weatherlog {ffffff}- script changelog.\n{AAAAAA}Time Functions:\n{00ccff}/st [0-23] {ffffff}- change time.\n{00ccff}/timelapse [0-23] [0-23] [0+] [0+] {ffffff}- timelapse.\n{AAAAAA}Weather Functions:\n{00ccff}/sw {ffffff}- change weather through dialog window.\n{00ccff}/sw [0-22] {ffffff}- change weather by id (stable weather).\n{00ccff}/setweather {ffffff}- change weather through dialog window (unstable weather).\n{00ccff}/setweather [any id] {ffffff}- change weather by id (unstable weather).\n{00ccff}Key \"End\"{ffffff} - sets random stable weather. Compatible with AI mode.", "Okay")
end
--функция отвечает за удобные менюшки, спасибо фипу
function submenus_show(menu, caption, select_button, close_button, back_button)
  select_button, close_button, back_button = select_button or 'Select', close_button or 'Close', back_button or 'Back'
  prev_menus = {}
  function display(menu, id, caption)
    local string_list = {}
    for i, v in ipairs(menu) do
      table.insert(string_list, type(v.submenu) == 'table' and v.title .. '  >>' or v.title)
    end
    sampShowDialog(id, caption, table.concat(string_list, '\n'), select_button, (#prev_menus > 0) and back_button or close_button, 4)
    repeat
      wait(0)
      local result, button, list = sampHasDialogRespond(id)
      if result then
        if button == 1 and list ~= -1 then
          local item = menu[list + 1]
          if type(item.submenu) == 'table' then -- submenu
            table.insert(prev_menus, {menu = menu, caption = caption})
            if type(item.onclick) == 'function' then
              item.onclick(menu, list + 1, item.submenu)
            end
            return display(item.submenu, id + 1, item.submenu.title and item.submenu.title or item.title)
          elseif type(item.onclick) == 'function' then
            local result = item.onclick(menu, list + 1)
            if not result then return result end
            return display(menu, id, caption)
          end
        else -- if button == 0
          if #prev_menus > 0 then
            local prev_menu = prev_menus[#prev_menus]
            prev_menus[#prev_menus] = nil
            return display(prev_menu.menu, id - 1, prev_menu.caption)
          end
          return false
        end
      end
    until result
  end
  return display(menu, 31337, caption or menu.title)
end
--------------------------------------------------------------------------------
-----------------------------------SETTINGS-------------------------------------
--------------------------------------------------------------------------------
--ФУНКЦИЯ ОТКРЫВАЕТ В БРАУЗЕРЕ ГАЛЕРЕЮ ПОГОД
function cmdHelpWeather()
  os.execute('explorer "http://dev.prineside.com/gtasa_weather_id/"')
end
function cmdWeather1Toggle()
  if data.options.weatherrandom == true then
    data.options.weatherrandom = false sampAddChatMessage(('[WAT]: Weather change algorithm deactivated'), color)
  else
    data.options.weatherrandom = true sampAddChatMessage(('[WAT]: Weather change algorithm activated'), color)
  end
  inicfg.save(data, "weather and time")
end
function cmdWeatherInform()
  if data.options.startmessage == 1 then
    data.options.startmessage = 0 sampAddChatMessage(('[WAT]: Weather and Time startup notification disabled'), color)
  else
    data.options.startmessage = 1 sampAddChatMessage(('[WAT]: Weather and Time startup notification enabled'), color)
  end
  inicfg.save(data, "weather and time")
end
function cmdTimeNot()
  if data.options.timebycomp1 == true then
    data.options.timebycomp1 = false sampAddChatMessage(('[WAT]: Local time synchronization disabled'), color)
  else
    data.options.timebycomp1 = true sampAddChatMessage(('[WAT]: Local time synchronization enabled'), color)
  end
  inicfg.save(data, "weather and time")
end
function cmdWatUpdate()
  if data.options.autoupdate == 1 then
    data.options.autoupdate = 0 sampAddChatMessage(('[WAT]: WAT auto-update disabled'), color)
  else
    data.options.autoupdate = 1 sampAddChatMessage(('[WAT]: WAT auto-update enabled'), color)
  end
  inicfg.save(data, "weather and time")
end
