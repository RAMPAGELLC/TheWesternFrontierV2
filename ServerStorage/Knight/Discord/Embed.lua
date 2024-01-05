--[[

setAuthor(name, imgurl, url);
setTitle(value)
setUrl(value)
setDescription(value);
setFooter(value, icon);
setTimestamp(value) * ISO8601
addField(name, value, inline);
setColor('');
setThumbnail('url', width, height);
setImage('url', width, height);


]]


return function()
	local datatable = {
		['type'] = 'rich',
		['fields'] = {},
		['customembed'] = true
	};
	local prox = {
		['lol'] = true
	};
	setmetatable(prox, {
		__index = function(self, ...)
			local args = {...};
			
			local method = tostring(args[1]);
			if (method == "setAuthor") then
				return function(name, imgurl, url)
					assert(name, "Invalid properties provided for method \"" .. tostring(method) .. "\"");
					datatable['author'] = {
						name = name,
						icon_url = imgurl,
						url = url
					};
					return prox; 
				end
			end
			if (method == "setTitle") then
				return function(title)
					assert(title, "Invalid properties provided for method \"" .. tostring(method) .. "\"");
					datatable['title'] = title;
					return prox;
				end
			end
			if (method == "setUrl") then
				return function(url)
					assert(url, "Invalid properties provided for method \"" .. tostring(method) .. "\"");
					datatable['url'] = url;
					return prox; 
				end
			end
			if (method == "setDescription") then
				return function(desc)
					assert(desc, "Invalid properties provided for method \"" .. tostring(method) .. "\"");
					datatable['description'] = desc;
					return prox;
				end
			end
			if (method == "setFooter") then
				return function(footer, icon)
					assert(footer, "Invalid properties provided for method \"" .. tostring(method) .. "\"");
					datatable['footer'] = {
						text = footer, 
						icon_url = icon
					};
					return prox; 
				end
			end
			if (method == "setTimestamp") then
				return function(timestamp, parser)
					assert(timestamp, "Invalid properties provided for method \"" .. tostring(method) .. "\"");
					if (parser) then
						-- rogchamp for ISO8601 parser 
						local function format(num, digits) return string.format("%0" .. digits .. "i", num) end
						local year, mon, day, hour, min, sec = timestamp["year"], timestamp["month"], timestamp["day"],timestamp["hour"], timestamp["min"], timestamp["sec"]
						timestamp = year .. "-" .. format(mon, 2) .. "-" .. format(day, 2) .. "T" .. format(hour, 2) .. ":" .. format(min, 2) .. ":" .. format(sec, 2) .. "Z"
					end
					datatable['timestamp'] = timestamp;
					return prox;
				end
			end
			if (method == "addField") then
				return function(name, value, inline)
					assert(name and value, "Invalid properties provided for method \"" .. tostring(method) .. "\"");
					table.insert(datatable['fields'],
						{
							name = name, 
							value = value, 
							inline = inline 
						}
					);
					return prox;
				end
			end
			if (method == "setColor") then
				return function(color)
					assert(color, "Invalid properties provided for method \"" .. tostring(method) .. "\"");
					assert(tostring(color):sub(1,1) == "#", "Invalid property \"color\" provided for method \"" .. tostring(method) .. "\"");
					datatable['color'] = tonumber(color:sub(2),16);
					return prox;
				end
			end
			if (method == "setThumbnail") then
				return function(url, width, height)
					assert(url, "Invalid properties provided for method \"" .. tostring(method) .. "\"");
					datatable['thumbnail'] = {
						url = url, 
						width = width, 
						height = height 
					}
					return prox;
				end
			end
			if (method == "setImage") then
				return function(url, width, height)
					assert(url, "Invalid properties provided for method \"" .. tostring(method) .. "\"");
					datatable['image'] = {
						url = url, 
						width = width, 
						height = height 
					}
					return prox;
				end
			end
			if (method == "getAllValues") then 
				return function()
					return datatable;
				end
			end
			
			return datatable[method];
		end,
	})	
	return prox;
end