local HttpService = game:GetService("HttpService")

return function(link)
	local ret = {}
	
	function ret.send(body, emb)
		if (typeof(body) == "table") then 
			emb = body; 
			body = ""
		end
		if (emb) then 
			if (emb['customembed']) then 
				emb = emb.getAllValues();
			end
		end
		local data = {
			["embeds"] = {
				emb
			},
			["content"] = body
		}
		return HttpService:PostAsync(link, HttpService:JSONEncode(data))
		
	end
	
	return ret;
end