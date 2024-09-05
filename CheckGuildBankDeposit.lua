SLASH_CHECKGUILDBANKDEPOSIT1 = '/checkguildbank'
DEFAULT_CHAT_FRAME:AddMessage('[|cFF8B008BCheckGuildBankDeposit|r] While in a Raid/Group, open Guild Bank and Run Command: /checkguildbank <Item name>, <Hour limit>', 1,1,0)

isLogUpdated = false;

local function onEvent(self,event,...)
	if ( event == 'GUILDBANKFRAME_OPENED' or event == 'GUILDBANKBAGSLOTS_CHANGED' ) then
		isLogUpdated = false;
		-- 0º Query registry
		for tabIndex = 1, GetNumGuildBankTabs() do
			-- Updates bank log data from the server
			QueryGuildBankLog(tabIndex);
		end
	end
	if ( event == 'GUILDBANKLOG_UPDATE' ) then
		isLogUpdated = true;
	end
end

local function CheckGuildBankDeposit(input)

    -- Only work if the Guild Bank Frame is open 
    if (GuildBankFrame == nil or not GuildBankFrame:IsVisible()) then
        DEFAULT_CHAT_FRAME:AddMessage('[CheckGuildBankDeposit] Please, open your guild bank', 1,1,0);
		return;
	end
	
	-- If it is not updated yet
	if (isLogUpdated == false) then
		DEFAULT_CHAT_FRAME:AddMessage('[CheckGuildBankDeposit] Querying guild bank data... Please, retry', 1,1,0);
		return;
	end

    -- 1º Split arguments in two: item name and limit hours
	local args = input:match("%s*(.*)"); -- Regex <space><args>
    local itemName, hours = strsplit(",", args);
	-- Hour limit is optional. By default, use 1 hour.
	if(hours == nil) then 
		hours = 1
	end
	-- 24 hour max.
	if(tonumber(hours) > 24) then 
		hours = 24
	end

    -- 2º Getting raid member names.
    local raidMembers = {}
    for raidIndex = 1, MAX_RAID_MEMBERS do 
        local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(raidIndex);
        if (name ~= nil) then  
            table.insert(raidMembers, name);
        end 
    end
    
    -- 3º Getting names of the users that have made a deposit of the item in the last hours
    local depositMembers = {}
    -- For each one of the tabs in guild bank
    for tabIndex = 1, GetNumGuildBankTabs() do
        -- For each one of the transactions
        for transactionIndex = 1, GetNumGuildBankTransactions(tabIndex) do
            local transactionType, characterName, itemLink, count, tab1, tab2, year, month, day, hour = GetGuildBankTransaction(tabIndex, transactionIndex);
            local bankItemName = GetItemInfo(itemLink);
			-- Check if the user has made the deposit in the last hours
			if(itemName == bankItemName and characterName ~= nil and transactionType == 'deposit' and year == 0 and month == 0 and day == 0 and hour <= tonumber(hours)) then
                table.insert(depositMembers, characterName);
            end            
        end
    end
    
    -- 4º Check users that have not made the deposit
    local defaulterMembers = {}
    for _,raidMember in pairs(raidMembers) do
        local flag = false;
        for _,depositMember in pairs(depositMembers) do
            if(raidMember == depositMember) then
                flag = true;
            end
        end
        if(flag == false) then
            table.insert(defaulterMembers,raidMember);
        end
    end

    -- 5º Point out users that have not made the deposit
    DEFAULT_CHAT_FRAME:AddMessage('[CheckGuildBankDeposit] People that did not make a deposit of '..itemName..' in the last '..hours..' hour(s)', 1,1,0)
    for _,defaulter in pairs(defaulterMembers) do
        DEFAULT_CHAT_FRAME:AddMessage(defaulter, 1,1,0)
    end
    DEFAULT_CHAT_FRAME:AddMessage('[CheckGuildBankDeposit] End of list', 1,1,0)

end

local evFrame = CreateFrame("Frame","evFrame",UIParent);
evFrame:SetScript( "OnEvent", onEvent );
evFrame:RegisterEvent( "GUILDBANKBAGSLOTS_CHANGED" );
evFrame:RegisterEvent( "GUILDBANKLOG_UPDATE" );
evFrame:RegisterEvent( "GUILDBANKFRAME_OPENED" );

SlashCmdList["CHECKGUILDBANKDEPOSIT"] = CheckGuildBankDeposit 
