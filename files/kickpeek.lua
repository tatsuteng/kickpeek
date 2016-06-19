#!/usr/bin/lua

function get_station_info(iface)
	local iw_f = io.popen("iw dev " .. iface .. " station dump | grep -e Station -e signal: | awk '{print $2}' | awk 'NR%2{printf $0 ;next;}1'")
	local iw_l = iw_f:read("*a")
	iw_f:close()
	return iw_l
end

function kick(mac)
	os.execute("hostapd_cli deauthenticate " .. mac)
end

function kick_peak(iface, threshold, timeout, whitelist)
	local station = {}

	for k,v in pairs(whitelist) do
		v = string.lower(v)
		station[v] = 0
	end

	while true do
		-- Scan for stations
		local info = get_station_info(iface)

		-- Store the vadlidated station info
		for d in string.gmatch(info, "%S+") do
			local mac = string.lower(string.match(d, '^..:..:..:..:..:..'))
			local sig = tonumber(string.match(d, '-.*$'))

			if sig >= threshold then
				if station[mac] == nil then
					station[mac] = os.time()
				elseif station[mac] ~= 0 then
					station[mac] = os.time()
				end
			end
		end

		-- Kick the invalid station
		for d in string.gmatch(info, "%S+") do
			local mac = string.match(d, '^..:..:..:..:..:..')
			if station[mac] == nil then
				print("kick", mac)
				kick(mac)
			elseif station[mac] ~= 0 and os.time()-station[mac] > timeout then
				station[mac] = nil
				print("kick", mac)
				kick(mac)
			else
				print("not kicking", mac, " remaining:", timeout-(os.time()-station[mac]));
			end
		end

		os.execute("sleep 1")
	end
end

function usage()
	print("Usage: kick-peak [-i interface] [-t timeout] [-w mac_address]")
	os.exit()
end

function main()
	local iface = "wlan0"
	local threshold = -20
	local timeout = 3600
	local whitelist = {}

	-- Read wireless interface, timeout, and mac addresses
	-- of whitelist
	local n = table.getn(arg)
	while n >= 2 do
		if arg[n-1] == '-i' then
			iface = arg[n]
		elseif arg[n-1] == '-s' then
			threshold = tonumber(arg[n])
		elseif arg[n-1] == '-t' then
			timeout = tonumber(arg[n])
		elseif arg[n-1] == '-w' then
			table.insert(whitelist, 1, arg[n])
		else
			usage()
		end
		n = n - 2
	end

	-- Enter main loop
	kick_peak(iface, threshold, timeout, whitelist)
end

main()
