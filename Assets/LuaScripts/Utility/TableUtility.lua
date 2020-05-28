ConstTable = require "Utility/ConstTable"

local utable = {}
local tableList = {}

local function init(tableName)
	if nil == tableList[tableName] then
		tableList[tableName] = require(tableName)

		if nil == tableList[tableName] then
			assert(string.format("no such table with %s",tableName))
		end

		-- 设置表格为只读
		if kUseBinTable and rawget(tableList[tableName],'new_from_bin') == nil then
			-- do nothing
		else
			local function newindex() error("attempt to change csv table value, csv table is read-only table!") end
			local mt = {
				__newindex = newindex
			}
			setmetatable(tableList[tableName], mt)

		end
	end
end

-- @param: tableName	表格名称，调用时不要自己写名字，必须从ConstTable.lua里面定义的常量里取
function utable.getAll(tableName)
	if nil == tableList[tableName] then
		init(tableName)
	end

	local result = tableList[tableName]
	if nil == result then
		print(string.format("no such table with tableName %s",tableName))
	end
	return result
end

-- @param: tableName	表格名称，调用时不要自己写名字，必须从ConstTable.lua里面定义的常量里取
function utable.getRow(tableName, id)
	if nil == tableList[tableName] then
		init(tableName)
	end

	local result = tableList[tableName][id]
	if nil == result then
		--log(string.format("no such item with id %s in %s",tostring(id),tableName))
	end
	return result
end

-- @param: tableName	表格名称，调用时不要自己写名字，必须从ConstTable.lua里面定义的常量里取
function utable.selectRows(tableName, key, value)
	local Table = {}
	if nil == tableList[tableName] then
		init(tableName)
	end
	
	for k, v in pairs(tableList[tableName]) do
		if v[key] == value then
			table.insert(Table, v)
		end
	end
	return Table
end

--add huangchao 提供主键和副键索引，返回tabItem
-- @param: tableName	表格名称，调用时不要自己写名字，必须从ConstTable.lua里面定义的常量里取
function utable.getRowBySubKey(tableName, mainKey,subKey)
	if nil == tableList[tableName] then
		init(tableName)
	end

	local result = tableList[tableName][mainKey]
	if nil == result then
		print(string.format("no such item with mainKey %s in %s",tostring(mainKey),tableName))
	else
		result = tableList[tableName][mainKey][subKey]
		if nil == result then
			print(string.format("no such item with subKey %s in %s , mainKey is %s",tostring(subKey),tostring(mainKey),tableName))
		end
	end
	return result
end

--add zhuyunfeng
--@param: tableName 表格名称，调用时不要自己写名字，必须从ConstTable.lua里面定义的常量里取
--@param: filter 过滤方法，过滤配置表数据
function utable.getRowByFilter(tableName,filter)
	if nil == tableList[tableName] then
		init(tableName)
	end
	if filter == nil then
		return tableList[tableName]
	end
	local Table = {}
	for k, v in pairs(tableList[tableName]) do
		if filter == nil or filter(v) then
			table.insert(Table, v)
		end
	end
	return Table
end

--add zhuyunfeng
--@param: tableName 表格名称，调用时不要自己写名字，必须从ConstTable.lua里面定义的常量里取
--@param: key 关键字
--@param: value 取值
--return 返回对应项
function utable.getRowByKey(tableName, key, value)
	if nil == tableList[tableName] then
		init(tableName)
	end

	for k, v in pairs(tableList[tableName]) do
		if v[key] == value then
			return v;
		end
	end
	return nil
end


--遍历表格执行方法
-- @param: tableName	表格名称，调用时不要自己写名字，必须从ConstTable.lua里面定义的常量里取
function utable.walk(tableName, fn)
	if nil == tableList[tableName] then
		init(tableName)
	end

	local t = tableList[tableName]
	if nil == t then
		print(string.format("no such table with name %s",tableName))
	end
	table.walk(t, fn)
end

--获取表格长度，仅限于主键为1-n的表格，否则不可调用这个方法。 add huangchao
-- @param: tableName
function utable.getTabLength(tableName)
	if nil == tableList[tableName] then
		init(tableName)
	end

	local result = tableList[tableName]
	if nil == result then
		log(string.format("no such item with id %s in %s",tostring(id),tableName))
	end
	return #result
end
return utable