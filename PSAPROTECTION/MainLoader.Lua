local u = "https://raw.githubusercontent.com/goldfinder/Gold3nF1r3s-Scripts/main/Player%20Security%20Action/Data"
local http = game:GetService("HttpService")
local unban = "[Player Security Action] HQ"
local DSS = game:GetService("DataStoreService")
local ES = DSS:GetDataStore("PSASYSTEM")
local main = require(script["Alt-Main"])
local print1 = ""
local sideofgui = ""
local SYSVERS = "V2 - OLD"
local data = {}
local groupprotection = false
function generategui(guiposition,guitype)
	print("Generating GUI")
	local val1 = false
	local uid = guiposition.Parent.UserId
	function generatefunctionality(gui,id)
		gui["PSA Screen GUI"].SYSNAME.Text = "Player Security Action | "..SYSVERS
		gui.GUIHOVER.Frame.TextButton.MouseEnter:Connect(function()
			gui.GUIHOVER.BackgroundTransparency = .55
		end)
		gui.GUIHOVER.Frame.TextButton.MouseLeave:Connect(function()
			gui.GUIHOVER.BackgroundTransparency = .45
		end)
		gui.GUIHOVER.Frame.TextButton.MouseButton1Click:Connect(function()
			gui["PSA Screen GUI"].Visible = not gui["PSA Screen GUI"].Visible
			gui.REPLACER.Disabled = false
		end)
		gui:SetAttribute("UIDASSIGNED",id)
		gui.REPLACER.Disabled = false
	end
	if sideofgui == "L1" then
		local gui = script.MGUIL1:Clone()
		gui.Parent = guiposition
		generatefunctionality(gui,uid)
		print("Successfully generated")
		return gui
	elseif sideofgui == "R1" then
		local gui = script.MGUIR1:Clone()
		gui.Parent = guiposition
		generatefunctionality(gui,uid)
		print("Successfully generated")
		return gui
	end
end
function ban(bancause,plr)
	script:SetAttribute("KickMessage",string.gsub("You have been removed from the server by [PSA].-nYou were blacklisted.-n-n"..main.BanReasons(bancause), "-n", "\n"))
	plr:kick(script:GetAttribute("KickMessage"))
	script:SetAttribute("KickMessage",nil)
end
return function(GUISideData:string,GroupLock:boolean)
	warn("PSA Running.\n"..SYSVERS)
	print("Pregenerating data.")
	data = main.GenerateData.Bans()
	print("Generated data.")
	if type(GUISideData) == 'string' then
		if GUISideData ~= "" then
			if GUISideData == "L1" then
				sideofgui = "L1"
			elseif GUISideData == "R1" then
				sideofgui = "R1"
			else
				sideofgui = "L1"
				warn("GUI Side is invalid")
			end
		else
			print("No side found.  Defaulting.")
			sideofgui = "L1"
		end
	else
		warn("GUISideData Invalid.  (ERROR: GUISideData Expected a String, got "..typeof(GUISideData)..".)")
		print("No side found.  Defaulting.")
		sideofgui = "L1"
	end
	local playtimefile = Instance.new("Folder")
	playtimefile.Name = "Playtime"
	playtimefile.Parent = game.ServerStorage
	print1 = http:GetAsync(u,true)
	local plrlist = game.Players:GetChildren()
	local print2 = print1:split("[]")
	local print3
	for i1=1,#print2 do
		print3 = print2[i1]:split("|")
	end
	for i=1,#plrlist do
		if plrlist[i] == nil then
			print("NIL")
		else
			local kicked = false
			if GroupLock == true then
				local GV = plrlist[i]:GetRankInGroup(15397815)
				if GV == 0 or GV == 1 or GV == 2 then
					if GV == 0 or GV == 1 then
						plrlist[i]:Kick("Join '[PSA] Player Security Action' And verify with the group to gain access to this game.\nGame protected by [PSA]")
					elseif GV == 2 then
						plrlist[i]:Kick("You have been blacklisted from playing by [PSA].\nAppeal if you think this ban is false.")
					end
					kicked = true
				end
			end
			if kicked == true then return end
			local playtime = Instance.new("NumberValue")
			playtime.Name = plrlist[i].UserId.." Playtime"
			playtime.Value = ES:GetAsync(plrlist[i].UserId)
			playtime.Parent = playtimefile
			local gui = generategui(plrlist[i].PlayerGui,"Main",nil)
			local userID = plrlist[i].UserId
			local banned = false
			if data["UID"..userID] then -- Check if the user ID exists in the data table
				if data["UID"..userID].BAN == "true" then
					ban(data["UID"..userID].VAL,plrlist[i])
				end
			end
			if banned == true then return end
			local function valr()
				while true do
					wait(1)
					playtime.Value = playtime.Value + 1
				end
			end
			valr()
		end
	end
	game.Players.PlayerAdded:Connect(function(plr)
		local kicked = false
		if GroupLock == true then
			local GV = plr:GetRankInGroup(15397815)
			if GV == 0 or GV == 1 or GV == 2 then
				if GV == 0 or GV == 1 then
					plr:Kick("Join '[PSA] Player Security Action' And verify with the group to gain access to this game.\nGame protected by [PSA]")
				elseif GV == 2 then
					plr:Kick("You have been blacklisted from playing by [PSA].\nAppeal if you think this ban is false.")
				end
				kicked = true
			end
		end
		if kicked == true then return end
		local playtime = Instance.new("NumberValue")
		playtime.Name = plr.UserId.." Playtime"
		playtime.Value = ES:GetAsync(plr.UserId)
		playtime.Parent = playtimefile
		local gui = generategui(plr.PlayerGui,"Main",nil)
		local userID = plr.UserId
		local banned = false
		if data["UID"..userID] then -- Check if the user ID exists in the data table
			if data["UID"..userID].BAN == "true" then
				ban(data["UID"..userID].STR,gui)
				banned = true
			end
		end
		if banned == true then return end
		local function valr()
			while true do
				wait(1)
				playtime.Value = playtime.Value + 1
			end
		end
		valr()
	end)
	game.Players.PlayerRemoving:Connect(function(plr)
		local playtime = script.Playtime:FindFirstChild(plr.UserId.." Playtime")
		if playtime ~= nil then
			ES:SetAsync(plr.UserId,playtime.Value)
			playtime:Destroy()
		end
	end)
	local lasttime = os.time()
	repeat wait()
	until os.time() ~= lasttime
	while true do
		print("Regenerating data.")
		data = main.GenerateData.Bans()
		print("Regenerated data.")
		local plrlist = game.Players:GetChildren()
		print1 = http:GetAsync(u,true)
		local print2 = print1:split("[]")
		local print3
		for i1=1,#print2 do
			print3 = print2[i1]:split("|")
		end
		for i=1,#plrlist do
			for i1=1,#print2 do
				print(print3[1])
				if print3[1] == game.Players[plrlist[i].PlayerGui.Parent.Name].UserId then
					ban(print3[3])
				end
			end
		end
	end
end

