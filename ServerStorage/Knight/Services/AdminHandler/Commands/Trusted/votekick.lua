return {
	Name = "votekick";
	Aliases = {"vk"};
	Description = "Start in-game vote-kick";
	Group = "Trusted";
	Args = {		
		{
			Type = "player";
			Name = "user";
			Description = "The player to change";
		},
		{
			Type = "string";
			Name = "reason";
			Description = "Reason for init of kick";
		},
	};
}