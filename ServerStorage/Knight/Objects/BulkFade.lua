--[[
	/ Bulk Fade / 
	
	About: 
		This module was created to make bulk tweening much easier.
		Bulk tweening is when you tween all the elements together for a better transition.

	Version:
		- 1.6
		- 9/11/2022

	Author(s):
		kingerman88
		xxkeithx
]]

-- / Types / --
type ArrayList<T> = {[number]:T};
type IndexArray<I,V> = {[I]:V};

-- / Services / --
local TweenService = game:GetService("TweenService");

-- / Variables / --
local DefaultTweenConfiguration = TweenInfo.new(1, Enum.EasingStyle.Cubic)

-- Class Definitions
local ImageElements = {
	["ImageButton"] = true,
	["ImageLabel"] = true,
}
local TextElements = {
	["TextLabel"] = true,
	["TextButton"] = true,
	["TextBox"] = true,
}
local ScrollingElements = {
	["ScrollingFrame"] = true
}

-- / Functions / --
local function getAttributesAtValue(attributes: IndexArray<string, number>, val)
	local temp = {};
	for i in pairs(attributes) do
		temp[i] = val;
	end
	return temp;
end

local function addElement(self, element: Instance, tweenConfig: TweenInfo|nil)

	local attributes = {};

	-- Specialized UI stroke elements
	if element:IsA("UIStroke") then
		attributes["Transparency"] = element.Transparency;
		table.insert(self.UiElements, element);
		self.AppearTweens[element] = TweenService:Create(element, tweenConfig or DefaultTweenConfiguration, attributes);
		self.DisappearTweens[element] = TweenService:Create(element, tweenConfig or DefaultTweenConfiguration, {Transparency = 1});
		return;
	elseif not element:IsA("GuiObject") then
		return;
	end

	attributes["BackgroundTransparency"] = element.BackgroundTransparency;
	if ImageElements[element.ClassName] then
		attributes["ImageTransparency"] = element.ImageTransparency;
	end if TextElements[element.ClassName] then
		attributes["TextTransparency"] = element.TextTransparency;
		attributes["TextStrokeTransparency"] = element.TextStrokeTransparency;
	end if ScrollingElements[element.ClassName] then
		attributes["ScrollBarImageTransparency"] = element.ScrollBarImageTransparency;
	end
	table.insert(self.UiElements, element);
	self.AppearTweens[element] = TweenService:Create(element, tweenConfig or DefaultTweenConfiguration, attributes);
	self.DisappearTweens[element] = TweenService:Create(element, tweenConfig or DefaultTweenConfiguration, getAttributesAtValue(attributes, 1));
end

local function removeElement(self, element)
	table.remove(self.UiElements, element);
	self.AppearTweens[element] = nil;
	self.DisappearTweens[element] = nil;
end

-- / BulkFade.lua / --
local BulkFade = {}
BulkFade.__index = BulkFade;

BulkFade.TweenIn = BulkFade.FadeIn;
BulkFade.TweenOut = BulkFade.FadeOut;

-- Creates a new tween group
-- @param elements:ArrayList<Instance> - An arraylist of instances (not nessesarily UI objects)
-- @param tweenConfig:TweenInfo:optional - a custom tweenInfo that will override the default tweenInfoConfig
-- @return BulkFadeGroup
function BulkFade.CreateGroup(elements:ArrayList<Instance>, tweenConfig:TweenInfo?)
	local self = {};
	self.Faded = false;
	self.UiElements = {};
	self.AppearTweens = {};
	self.DisappearTweens = {};

	for _, element in ipairs(elements) do
		addElement(self, element, tweenConfig);
	end

	return setmetatable(self, BulkFade);
end

-- Calls all the tweens (in)
function BulkFade:FadeIn()
	self.Faded = true;
	for element, tween in pairs(self.AppearTweens) do
		tween:Play();
	end
end

-- Calls all the tweens (out)
function BulkFade:FadeOut()
	self.Faded = false;
	for element, tween in pairs(self.DisappearTweens) do
		tween:Play();
	end
end

function BulkFade:Fade()
	if self.Faded then
		self:FadeOut();
	else
		self:FadeIn();
	end
end

-- Simply returns all the elements in the tweengroup
-- @return ArrayList<GuiObject> - A table of UI elements
function BulkFade:GetElements()
	return self.UiElements;
end

return BulkFade