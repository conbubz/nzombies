--

function nzRandomBox.Spawn(exclude)
	--Get all spawns
	local all = ents.FindByClass("random_box_spawns")
	if IsValid(exclude) then
		table.RemoveByValue(all, exclude)
		--print("Excluded ", exclude)
		if table.Count(all) <= 0 then
			all = {exclude} -- Should there be nothing left, reuse the old excluded one
		end
	end

	local rand = all[ math.random( #all ) ]

	if rand != nil and !rand.HasBox then
		local box = ents.Create( "random_box" )
		box:SetPos( rand:GetPos() )
		box:SetAngles( rand:GetAngles() )
		box:Spawn()
		--box:PhysicsInit( SOLID_VPHYSICS )
		box.SpawnPoint = rand
		rand.HasBox = true

		local phys = box:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end
	else
		print("No random box spawns have been set.")
	end
end

function nzRandomBox.Remove()
	--Get all spawns
	local all = ents.FindByClass("random_box")
	--Loop just incase
	for k,v in pairs(all) do
		v.SpawnPoint.HasBox = false
		v:Remove()
	end
end

function nzRandomBox.DecideWep(ply)

	local teddychance = math.random(1, 15)
	if teddychance <= 1 and !nzPowerUps:IsPowerupActive("firesale") and table.Count(ents.FindByClass("random_box_spawns")) > 1 then
		return "nz_box_teddy"
	end

	local guns = {}
	local blacklist = table.Copy(nzConfig.WeaponBlackList)

	--Add all our current guns to the black list
	if IsValid(ply) and ply:IsPlayer() then
		for k,v in pairs( ply:GetWeapons() ) do
			if v.ClassName then
				blacklist[v.ClassName] = true
			end
		end
	end

	--Add all guns with no model or wonder weapons that are out to the blacklist
	for k,v in pairs( weapons.GetList() ) do
		if !blacklist[v.ClassName] then
			if v.WorldModel == nil or nz.Weps.Functions.IsWonderWeaponOut(v.ClassName) then
				blacklist[v.ClassName] = true
			end
		end
	end

	if GetConVar("nz_randombox_maplist"):GetBool() and nzMapping.Settings.rboxweps then
		for k,v in pairs(nzMapping.Settings.rboxweps) do
			if !blacklist[v] then
				table.insert(guns, v)
			end
		end
	elseif GetConVar("nz_randombox_whitelist"):GetBool() then
		-- Load only weapons that have a prefix from the whitelist
		for k,v in pairs( weapons.GetList() ) do
			if !blacklist[v.ClassName] and !v.NZPreventBox then
				for k2,v2 in pairs(nzConfig.WeaponWhiteList) do
					if string.sub(v.ClassName, 1, #v2) == v2 then
						table.insert(guns, v.ClassName)
						break
					end
				end
			end
		end
	else
		-- No weapon list and not using whitelist only, add all guns
		for k,v in pairs( weapons.GetList() ) do
			if !blacklist[v.ClassName] and !v.NZPreventBox then
				table.insert(guns, v.ClassName)
			end
		end
	end

	return table.Random(guns)
end