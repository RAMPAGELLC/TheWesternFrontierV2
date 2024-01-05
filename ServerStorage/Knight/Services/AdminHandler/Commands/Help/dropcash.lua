return {
	Name = "dropcash";
	Aliases = {"dc", "dm", "dropmoney"};
	Description = "Drop cash";
	Group = "Help";
	Args = {
		{
			Type = "number";
			Name = "amount";
			Description = "Cash amount.";
		},
	};
}