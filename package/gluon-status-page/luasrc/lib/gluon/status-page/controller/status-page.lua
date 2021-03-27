local json = require 'jsonc'
local site = require 'gluon.site'
local util = require 'gluon.util'

local function parse_ip(addr)
	if not addr then return end

	local ip4 = {addr:match('(%d+)%.(%d+)%.(%d+)%.(%d+)')}
	if ip4[1] then
		local ret = {}

		for i, part in ipairs(ip4) do
			ret[i] = tonumber(part)
		end
		return ret
	end

	if not addr:match('^[:%x]+$') then
		return
	end

	if addr:sub(0, 2) == '::' then
		addr = '0' .. addr
	end
	if addr:sub(-2) == '::' then
		addr = addr .. '0'
	end

	addr = addr .. ':'

	local groups, groups1 = {}, {}
	for part in addr:gmatch('([^:]*):') do
		if part == '' then
			groups1 = groups
			groups = {}
		else
			groups[#groups+1] = tonumber(part, 16)
		end
	end

	while #groups + #groups1 < 8 do
		groups1[#groups1+1] = 0
	end
	for _, group in ipairs(groups) do
		groups1[#groups1+1] = group
	end

	return groups1
end

local function match(a, b, n)
	if not a or not b then return false end

	for i = 1, n do
		if a[i] ~= b[i] then
			return false
		end
	end

	return true
end

entry({}, call(function(http, renderer)
	local nodeinfo = json.parse(util.exec('exec gluon-neighbour-info -d ::1 -p 1001 -t 3 -c 1 -r nodeinfo'))

	-- TODO: Add a redirect to a local v6 addr for parker

	renderer.render('status-page', { nodeinfo = nodeinfo, site = site }, 'gluon-status-page')
end))
