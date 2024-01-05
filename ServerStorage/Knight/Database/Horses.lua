local database = {}

function database.search(key, value)
	local suc, data = false, {}
	
	for i,v in pairs(database.get()) do
		if v[key] == value then
			suc, data = true, v;
			break;
		end
	end
	
	return suc, data;
end

function database.get()
	local DefaultColors = {
		Color3.fromRGB(212, 181, 101),
		Color3.fromRGB(216, 160, 99),
		Color3.fromRGB(170, 154, 139),
		Color3.fromRGB(246, 246, 246),
		Color3.fromRGB(171, 171, 171),
		Color3.fromRGB(121, 62, 30),
		Color3.fromRGB(140, 74, 40),
		Color3.fromRGB(58, 37, 18),
		Color3.fromRGB(24, 24, 24),
		Color3.fromRGB(246, 233, 192),
		Color3.fromRGB(102, 73, 59),
		Color3.fromRGB(192, 191, 196),
	}
	
	return {
		{
			Name = "Mule",
			Price = 500,
			Image = 0,

			CanFly = false,
			ForSale = true,

			DefaultSpeed = 20,
			MaxSpeed = 30, -- basic math, DefaultSpeed + 10.

			Kicks = 0, -- Boosts
			KicksLastFor = 4, -- How long kick last for in x seconds.
			KickRegenTime = 20, -- How long kick regenerates, withs x seconds for Kick Last For then it waits x amount of seconds specified before regen.
			KickSpeed = 10, -- How much additional walk-speed is added from using the kick boost? (under 10 feels slow - vq9o)

			Upgrades = {
				Speed = {
					[1] = {
						Cost = 4000,
					},

				},

				Saddle = {
					Enabled = true,
					Fee = 1000,
					Colors = DefaultColors
				},

				Blanket = {
					Enabled = false,
					Fee = 500,
					Colors = DefaultColors
				},

				Eye = {
					Enabled = true,
					Fee = 500,
					Colors = DefaultColors
				},

				Coat = {
					Enabled = false,
					Fee = 200,
					Colors = DefaultColors
				}
			}
		},
		{
			Name = "Regular Horse",
			Price = 2500,
			Image = 0,

			CanFly = false,
			ForSale = true,

			DefaultSpeed = 20,
			MaxSpeed = 30, -- basic math, DefaultSpeed + 10.

			Kicks = 0, -- Boosts
			KicksLastFor = 10, -- How long kick last for in x seconds.
			KickRegenTime = 10, -- How long kick regenerates, withs x seconds for Kick Last For then it waits x amount of seconds specified before regen.
			KickSpeed = 12, -- How much additional walk-speed is added from using the kick boost? (under 10 feels slow - vq9o)

			Upgrades = {
				Speed = {
					[1] = {
						Cost = 2000,
					},
					[2] = {
						Cost = 4000,
					},
					[3] = {
						Cost = 9000,
					},
					[4] = {
						Cost = 12400,
					},
					[5] = {
						Cost = 24400,
					},
					[6] = {
						Cost = 36400,
					},

				},

				Saddle = {
					Enabled = true,
					Fee = 1000,
					Colors = DefaultColors
				},

				Blanket = {
					Enabled = true,
					Fee = 500,
					Colors = DefaultColors
				},

				Eye = {
					Enabled = true,
					Fee = 500,
					Colors = DefaultColors
				},

				Coat = {
					Enabled = true,
					Fee = 200,
					Colors = DefaultColors
				}
			}
		},

		{
			Name = "Pegasus",
			Price = 1,
			Image = 0,

			CanFly = true,
			ForSale = false,

			DefaultSpeed = 40,
			MaxSpeed = 50, -- basic math, DefaultSpeed + 10.

			Kicks = 6, -- Boosts
			KicksLastFor = 8, -- How long kick last for in x seconds.
			KickRegenTime = 5, -- How long kick regenerates, withs x seconds for Kick Last For then it waits x amount of seconds specified before regen.
			KickSpeed = 25, -- How much additional walk-speed is added from using the kick boost? (under 10 feels slow - vq9o)

			Upgrades = {
				Speed = {
				},

				Saddle = {
					Enabled = true,
					Fee = 250,
					Colors = DefaultColors
				},

				Blanket = {
					Enabled = true,
					Fee = 250,
					Colors = DefaultColors
				},

				Eye = {
					Enabled = true,
					Fee = 35,
					Colors = DefaultColors
				},

				Coat = {
					Enabled = true,
					Fee = 200,
					Colors = DefaultColors
				}
			}
		} 
	}
end

return database