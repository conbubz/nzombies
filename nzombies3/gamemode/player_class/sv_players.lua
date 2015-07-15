//

function nz.Players.Functions.PlayerNoClip( ply, desiredState )
	if ply:Alive() and nz.Rounds.Data.CurrentState == ROUND_CREATE then
		return ply:IsSuperAdmin()
	end
end

function nz.Players.Functions.FullSync( ply )
	//Electric
	nz.Elec.Functions.SendSync()
	//PowerUps
	nz.PowerUps.Functions.SendSync()
	//Doors
	nz.Doors.Functions.SendSync()
	//Perks
	nz.Perks.Functions.SendSync()
	//Rounds
	nz.Rounds.Functions.SendSync()
end

function nz.Players.Functions.PlayerInitialSpawn( ply )
	timer.Simple(1, function() 
		//Fully Sync
		nz.Players.Functions.FullSync( ply )
	end)
end

function nz.Players.Functions.FriendlyFire( ply, ent )
	if ent:IsPlayer() then
		if ply:Team() == ent:Team() then
			return false
		end
	end
end

GM.PlayerNoClip = nz.Players.Functions.PlayerNoClip
hook.Add( "PlayerInitialSpawn", "nz.PlayerInitialSpawn", nz.Players.Functions.PlayerInitialSpawn )
hook.Add( "PlayerShouldTakeDamage", "nz.FriendlyFire", nz.Players.Functions.FriendlyFire )