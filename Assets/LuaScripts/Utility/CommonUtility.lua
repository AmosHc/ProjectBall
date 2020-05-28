local CommonUtility = class("CommonUtility")

function CommonUtility:ctor()
    self.openAPM = true
    self.dataAPM = {}
    self.APMCategory = {"category-1"}
	self.cfgShield = {}
	self.userID = ""
	self.blankESCStr = "##n"
end

--返回登录
function CommonUtility:ReturnLogin()
	GameData.charDataMgr.isGaming = false
	if LoginManager.Instance.channelId == LoginTypeData.ChannelType.Tencent then
        -- 回到SDK登录界面
		LoginManager.Instance:SwitchLoginScene()
		SceneMgr:SwitchScene(SceneID.Initialize)
	else
		SceneMgr:SwitchScene(SceneID.LoginWithNetworkScene)
	end
    LoginMgr:disconnectGameGate()
end

--CommonUtility.bit = require "bit"
--使组件关联逻辑屏幕根节点居中：多用于策划需求在非全屏页面加全屏模糊，
--com 组件 restraint 是否添加约束
function CommonUtility:ComponentRelationRootCenter(component,restraint)
	local root = GRoot.inst
	component:SetXY(((root.width - component.width) / 2),((root.height - component.height) / 2), true)
	if restraint then
		component:AddRelation(root, RelationType.Center_Center);
		component:AddRelation(root, RelationType.Middle_Middle);
	end
end

function CommonUtility:CalUserID()
	local userid = GameData.charDataMgr:getSelectedChar().UserID
	self.userID = tostring(userid)
end

--获取货币的数量（此货币也可能是道具）
function CommonUtility:GetCurrency(id)
	if id < 100 then
		return GameData.playerData.currencys[id] or 0
	else
		return BagMgr:GetCountByConfig(id) or 0
	end
end

--获取货币的小图标
function CommonUtility:GetCurrencyMinIcon(id)
	local currencyCfg = utable.getRow(ConstTable.CurrencyIcon,id)
	if currencyCfg then
		return currencyCfg.Looks
	else
		local config = StdItemsConfig[id]
		if config then
			return config.Looks
		else
			return ""
		end
	end
end

--获取当前的北京时间，用于与策划配置的北京时间做对比。
--不管客户端在哪儿，不管服务器在哪儿，策划的配置都是北京时间！
function CommonUtility:GetBJT()
	--local gmt = os.date("!*t", os.time())
	local bjt = os.date("!*t", Game.GetSvrTime()+8*3600)
	return bjt
end

--将date.wday转为策划配置的周几
--wday 周日为1
--result 周一为1
function CommonUtility:SwitchWeekDay(wday)
	local result = (wday + 5) % 7 + 1
	return result
end

--对比两数组LuaTable的相同项的数目
function CommonUtility:GetTableAvaCnt(arr1, arr2)
	local result = 0
	for k,v in pairs(arr1) do
		if table.IndexOf(arr2, v) > 0 then
			result = result + 1
		end
	end
	return result
end
--arr1为元表，arr2为数组
function CommonUtility:GetTableAvaCnt2(arr1, arr2)
	local result = 0
	for k,v in pairs(arr1) do
		if table.IndexOf(arr2, k) > 0 then
			result = result + 1
		end
	end
	return result
end

--计算可合成数量
--ic [itempairs]所需道具
--cc [itempairs]所需货币
function CommonUtility:CalMaterialMax(ic, cc)
	local result = -1
	local num = 0
	for k,v in pairs(ic) do
		num = math.floor(BagMgr:GetCountByConfig(v.k) / v.v)
		if num == 0 then
			return 0
		elseif result == -1 or num < result then
			result = num
		end
	end
	for k,v in pairs(cc) do
		num = math.floor(GameData.playerData.currencys[v.k] / v.v)
		if num == 0 then
			return 0
		elseif result == -1 or num < result then
			result = num
		end
	end
	return result
end

--刷新货币按钮灰置状态
--btnConfirm. 通用货币按钮：common/btnBuy
--price. [itempairs[1]]策划配置的货币需求
--defaultEnable. 先决条件灰置状态
function CommonUtility:RefreshCurrencyButton(btnConfirm, price, defaultEnable,times)
	local priceType = price.k
	self.times = times or 1
	local priceCount = price.v*self.times
	btnConfirm.icon = UIPackage.GetItemURL("Icons", self:GetCurrencyMinIcon(priceType))
	local currency = GameData.playerData.currencys[priceType] or 0
	local color = (currency<priceCount) and CONST_COLOR_NEGATIVE or CONST_COLOR_HIGH_LIGHT
	btnConfirm:GetChild("txtValue").text = CommonUtility:SetColor2(priceCount, color)
	local available = defaultEnable
	if currency < priceCount then
		available = false
	end
	btnConfirm.enabled = available
end

--按位取值：主要应用在服务器数据
--array. [LuaTable] 数组中每个数字为32位
--index. 从0开始
function CommonUtility:GetBitInArray(array, index)
	local x = math.floor(index/32)
	local y = index % 32
	return GetBit(array[x+1] or 0, y)
end
--设置bit值
function CommonUtility:SetBitInArray(array, index, bitValue)
	local x = math.floor(index/32)
	local y = index % 32
	local cnt = #array
	if cnt < x+1 then
		for i=cnt,x do
			table.insert(array, 0)
		end
	end
	array[x+1] = SetBit(array[x+1], index, bitValue)
end

--读取文字显示
function CommonUtility:GetText(key)
	local configs = {
		DramaTextConfig,
		InterFaceConfig,
		MessageTextConfig,
		StoryTextConfig,
		SystemInfoConfig,
		TaskTextConfig,
		TextsConfig,
		ErrorCodeConfig,
		NpcTalkConfig,
        SEventTextConfig,
        TimelineTextConfig,
		PlayerIdentityTextConfig,
		DialogTextConfig,
	}
	for k,v in pairs(configs) do
		if v[key] ~= nil then
			return v[key].Text
		end
	end

	return key
end

function CommonUtility:GetColorName(quality)
     local color = {[0] = GameString.ColorWhite,
                    [1] = GameString.ColorGreen,
                    [2] = GameString.ColorBlue,
                    [3] = GameString.ColorViolet,
                    [4] = GameString.ColorOrange }
    return color[quality]
end

--根据品质设置颜色
function CommonUtility:SetColorByQuality(txtCom, quality)
	self:SetColor(txtCom,CONST_COLOR_QUALITY[quality])
end

--设置字体颜色
function CommonUtility:SetColor(txtLine, color)
	if color == nil then
		return
	end
	if string.find(txtLine.text, "color") == nil then
		txtLine.text = "[color=" .. color .. "]" .. txtLine.text .. "[/color]"
	else
		local ci = string.find(txtLine.text, "color=#") + 6
		local ori = string.sub(txtLine.text, ci, ci+6)
		txtLine.text = string.gsub(txtLine.text, ori, color)
	end
end

function CommonUtility:SetColor2(strLine, color)
	return "[color=" .. color .. "]" .. strLine .. "[/color]"
end

--根据状态位设置字体为消极颜色或者积极颜色，默认消极颜色为红色，积极为绿色，多用于按钮变色(注意文本控件需要支持UBB语法)
function CommonUtility:SetColorByState( textComponent, state, activeColor, passiveColor )
	if not activeColor then
		activeColor = CONST_COLOR_POSITIVE
	end
	if not passiveColor then
		passiveColor = CONST_COLOR_NEGATIVE
	end
	local color = state and activeColor or passiveColor
	textComponent.text = "[color=" .. color .. "]" .. textComponent.text .. "[/color]"
end

--获取字体颜色
function CommonUtility:GetColor(strLine)
	local ci = string.find(strLine, "color=#")
	if string.find(strLine, "color=#") == nil then
		return ""
	else
		return string.sub(strLine, ci+6, ci+12)
	end
end

--判断属性是否为空
function CommonUtility:isNil(data)
	if data == nil then
		return true
	elseif type(data) == "table" and next(data) == nil then
		return true
	else
		return false
	end
end

--判断string否为空
function CommonUtility:IsNilString(str)
	if str == nil or str == "" then
		return true
	else
		return false
	end
end

--获取表中元素的个数
function CommonUtility:TableNums(t)
     local count = 0
     for k,v in pairs(t) do
         count = count + 1
	 end
     return count
end

--用亿万记录数值
function CommonUtility:GetMoneyString(value)
	if math.floor(value / 100000000) > 0 then
		return math.floor(value / 100000000) .. "亿"
	elseif math.floor(value / 10000) > 0 then
		return math.floor(value / 10000) .. "万"
	else
		return value
	end
end

--对Int64的数进行数量转换
--小于1000000显示常规 1000000~100000000显示int(A/10000)万 大于100000000显示(A/100000000)亿
function CommonUtility:parseInt64Num( num )
    local int64_100w = int64.new(1000000,0) --100
    local int64_1y = int64.new(0,1) --1亿

    if(num<int64_100w)then return tostring(num)
    elseif(num >= int64_100w and num < int64_1y)then return tostring(num/int64.new(10000,0)).."万"
    else return tostring(num/int64_1y).."亿" end
end



--输入秒，返回天时分秒字符串
--duration 时间（秒）
--brief 输出格式：
	--[默认]省略头尾的零值单位
	--1.只显示两个最大的非零单位
	--2.始终只显示天和小时
	--3.只显示两个最大的非零单位，且始终省略秒，且向上取整
	--4.始终显示时分秒，冒号分隔，补齐两位数
	--5.有天显示天，有时小时小时
    --6.当时间大于1天时仅显示天，当时间大于1小时时仅显示小时，当时间大于1分钟时仅显示分钟，当时间不足1分钟时，显示秒
--color 配色方案：
	--[默认]无配色
	--1.数字为积极颜色
function CommonUtility:GetTimeString(args)
	if args.brief == 3 then
		args.duration = args.duration + 59
	end
	local days = math.floor(args.duration / (24*60*60))
	local hours = math.floor((args.duration % (24*60*60)) / (60*60))
	local minutes = math.floor((args.duration % (60*60)) / 60)
	local seconds = args.duration % 60
	local values = {}
	if args.brief==4 then
		values = {
	    	{ value=days, des="" },
	    	{ value=hours, des=":" },
	    	{ value=minutes, des=":" },
	    	{ value=seconds, des="" },
	    }
	else
		values = {
	    	{ value=days, des="天" },
	    	{ value=hours, des="小时" },
	    	{ value=minutes, des="分" },
	    	{ value=seconds, des="秒" },
	    }
	end
	local showValues = {}
	local result = ""
	local cnt = #values
	if args.brief == 2 then --固定显示天时
		table.insert(showValues, values[1])
		table.insert(showValues, values[2])
	elseif args.brief == 4 then --固定显示时分秒
		table.insert(showValues, values[2])
		table.insert(showValues, values[3])
		table.insert(showValues, values[4])
	elseif args.brief == 5 then
		if values[1].value>0 then
		 table.insert(showValues, values[1])
		elseif values[2].value > 0 then
		 table.insert(showValues, values[2])
		elseif values[3].value > 0 then
		 table.insert(showValues, values[3])
		end
	elseif args.brief == 6 then
		if values[1].value > 0 then
			table.insert(showValues, values[1])
		elseif values[2].value > 0 then
			table.insert(showValues, values[2])
		elseif values[3].value>0 then
			table.insert(showValues, values[3])
		elseif values[4].value > 0 then
			table.insert(showValues, values[4])
		end
	elseif args.brief == 7 then --正常显示
        if values[1].value > 0 then
        	table.insert(showValues, values[1])
        	table.insert(showValues, values[2])
        	table.insert(showValues, values[3])
        	table.insert(showValues, values[4])
        elseif values[2].value > 0 then
        	table.insert(showValues, values[2])
        	table.insert(showValues, values[3])
        	table.insert(showValues, values[4])
        elseif values[3].value > 0 then
        	table.insert(showValues, values[3])
        	table.insert(showValues, values[4])
        elseif values[4].value > 0 then
        	table.insert(showValues, values[4])
        end
	else --省略头尾
		--从左边第一个非零单位开始，往右全部收录
		for i=1,cnt do
    		if values[i].value > 0 or #showValues > 0 then
    			table.insert(showValues, values[i])
    		end
		end
		--从右往左，删除所有零值单位，直到遇到第一个非零单位不再操作
		for i=#showValues,1,-1 do
    		if showValues[i].value == 0 then
    			table.remove(showValues, i)
    		else
    			break
    		end
		end
		--最右边的单位
		if args.brief == 3 then --省略秒
			if showValues[#showValues].des == "秒" then
				table.remove(showValues, #showValues)
			end
		end
	end
	cnt = #showValues
	if args.brief == 1 then --只取两个单位
		cnt = math.min(cnt, 2)
	end
	if cnt == 0 then
		return "-"
	else
		for i=1,cnt do
            if args.brief == 4 and i == 1 and days > 0 then --这里时间大于24小已经转成天数了，如果显示小时的话要加上天数
                showValues[i].value = showValues[i].value + days * 24
            end
			local value = tostring(showValues[i].value)
			--补齐两位数
			if args.brief == 4 and #value == 1 then
				value = "0" .. value
			end
			--控制颜色
			if args.color == 1 then
    			result = result .. CommonUtility:SetColor2(value, CONST_COLOR_POSITIVE) .. showValues[i].des
			else
    			result = result .. value .. showValues[i].des
			end
		end
	end
	return result
end

--输入秒，返回天时分秒字符串
function CommonUtility:GetTimeStr(sec)
	local second = tonumber(sec)
	local days = math.floor(second / (3600 * 24))
	local hours = math.floor(second % (3600 * 24) / 3600)
	local minutes = math.floor(second % 3600 / 60)
	local seconds = second % 60
	local timeStr = ""
	if days > 0 then
		timeStr = timeStr..string.format("%s天", days)
	end
	if hours > 0 then
		timeStr = timeStr..string.format("%s小时", hours)
	end
	if minutes > 0 then
		timeStr = timeStr..string.format("%s分钟", minutes)
	end
	if seconds > 0 then
		timeStr = timeStr..string.format("%s秒", seconds)
	end
	return timeStr
end

--把秒转换为00:00的分秒形式
function CommonUtility:parseSecond( sec )
	local seconds = math.floor(sec) % 60
	local minutes = (math.floor(sec) % (60*60) - seconds) / 60
    return string.format("%02d:%02d",minutes,seconds)
end

--获取排行榜皇冠资源
function CommonUtility:GetRankURL(rank, style)
	return rank>3 and "" or UIPackage.GetItemURL("Icons", string.format("rank_%s_style_%s", rank, style))
end
--此方法准备删除！！！！
--为了方便以后icon分开打AB包
function CommonUtility:GetIconByFolderName(folder, name)
	local res = nil
	local spFolder = { "items", "enchant", "Skill","CustomFace","shenyu","Quality","gonghui","head","Story" } --直接读取（配置表记录资源名）
	if table.IndexOf(spFolder, folder) > 0 then
		res = UIPackage.GetItemURL("Icons", name)
	else
		res = UIPackage.GetItemURL("Icons", folder .. "_" .. name)
	end
	if res == nil then
		--log("CommonUtility:GetIconByFolderName missing " .. folder .. ":" .. name)
	end
	return res
end

local curFrameCount = 0
local curFrameTime = 0
function AsyncProcess(async)
	if async then
		if curFrameCount ~= Time.frameCount then
			curFrameCount = Time.frameCount
			curFrameTime = socket.gettime()
		end
		if socket.gettime() - curFrameTime > 0.02 then
			coroutine.step()
		end
	end
end
--刷新列表 示例：
--ActivityCalendarComponent 不带额外参数
--MaterialView 带额外参数
function CommonUtility:RefreshList(uiList, data, rendererHandler, args, async)
	if async then
		coroutine.start(CommonUtility.RefreshListCoroutine, nil, uiList, data, rendererHandler, args, async)
	else
		CommonUtility:RefreshListCoroutine(uiList, data, rendererHandler, args, async)
	end
end

function CommonUtility:RefreshListCoroutine(uiList, data, rendererHandler, args, async)
	local cnt = #data
	local oldCnt = uiList.numChildren
	for i=oldCnt,1,-1 do
		if i>cnt then
			uiList:RemoveChildToPoolAt(i-1)
		elseif rendererHandler then
			rendererHandler(i, uiList:GetChildAt(i-1), data[i], args)
		end
	end
	AsyncProcess(async)
	for i=oldCnt+1,cnt do
		local line = uiList:AddItemFromPool()
		if rendererHandler then
			rendererHandler(i, line, data[i], args)
		end
		AsyncProcess(async)
	end
end

--将UI中使用过的GameObject返回对象池
function CommonUtility:ReturnUIPriviewToPool(entity)
	if not CommonUtility:isNil(entity) then
		--goPreview.gameObject.layer = LayerMask.NameToLayer("Default")
		entity:DestroyImmediate()
	end
end

--？？？
function CommonUtility:GetRotFromServerAngle(angle)
	-- 服务器是 0 x的正方向， pi/2 是Z的正方向
	-- -PI ~ PI 区间
	angle = -angle + Mathf.PI / 2
	local degree = 180 * angle / Mathf.PI
	return Quaternion.Euler(0, degree, 0)
end

function CommonUtility:GetServerAngleFromRot(degree)
	local angle = degree * Mathf.PI / 180
	angle = angle - Mathf.PI / 2
	if angle > Mathf.PI then
		angle = angle - Mathf.PI * 2
	end
	return -angle
end

--查询一个数值在这个数组中的梯度：在一个递增数组中，有多少个数值不大于给定数值。
function CommonUtility:GetArrayLevel(upArray, value)
	local level = 0
	for k,v in pairs(upArray) do
		if v > value then
			level = level + 1
		else
			break
		end
	end
	return level
end

--将策划配置的奖励列表中可用的道具提取出来
--输入：Rewards配置表的主键的数组
--输出：可用的Rewards配置表的行数据的数组
--规则：
--1.职业限定
function CommonUtility:GetRewardItems(source)
	local result = {}
	for k1,v1 in pairs(source) do
		for k2,v2 in pairs(RewardsConfig[v1]) do --subkeys
			if CommonUtility:isNil(v2.Jobs) or table.IndexOf(v2.Jobs, GameData.playerData.job)>0 then --职业限定
				table.insert(result, v2)
			end
		end
	end
	dump(result, "CommonUtility:GetRewardItems", 10)
	return result
end

--解析聊天富文本
function CommonUtility:GetURLText(str)
	if self:isNil(str) then
		return nil
	end
	
	local str1=string.find(str,"<a href='")
	local str2=string.find(str,"'>")
	local str3=string.find(str,"</a>")
	-- str=string.match(str,"<a href=")
	
	if str1~=nil and str2~=nil and str3~=nil then
		str=string.sub(str,str1 + 9,str2-1)
		return string.split(str,":")
	end
	return nil
end

function CommonUtility:HandleBlankESC(str)
	if type(str) ~= "string" or string.len(str) <= 0 then
	   return
	end
	return string.gsub(str,"\n",self.blankESCStr)
end

function CommonUtility:ParseBlanKESC(str)
	if type(str) ~= "string" or string.len(str) <= 0 then
	   return
	end
	return string.gsub(str,self.blankESCStr,"\n")
end

function CommonUtility:ParseEmoji(msg,scale,isShowEmoji)
	if type(msg) ~= "string" or string.len(msg) <= 0 then
	   return msg
    end
	msg = string.gsub(msg,self.blankESCStr,"\n")
	local emojiTab = {}
	local emojisCfg = utable.getAll(ConstTable.EmojisConfig)
	for i in string.gmatch(msg,"&%d+") do
	   table.insert(emojiTab,i)
    end
	if CommonUtility:isNil(emojiTab) then
		return msg
	end
	local msgStr = ""
	local len = string.len(msg)
	local tabLen = #emojiTab
	local Msg = {}
	for i  =1,tabLen do
		local str = emojiTab[i]
	    local index,endIndex = string.find(msg,str,#msgStr)
		local emojiNum = tonumber(string.match(str,"%d+"))
		if i == 1 and index ~= 1 then
		   local str1 = string.sub(msg,1,index-1)
		   table.insert(Msg,str1)
		   msgStr = msgStr..str1
 		end
		if emojisCfg[emojiNum] then
           if isShowEmoji then 
		      table.insert(Msg,string.format("<img src='%s'width='%d'height='%d'/>",emojisCfg[emojiNum].Url,scale,scale))
		   else
			  local str =  utable.getRow(ConstTable.Texts,emojisCfg[emojiNum].Name)
			  if str then
			     table.insert(Msg,string.format("[%s]", str.Text))
			  end
		   end
		else
		   table.insert(Msg,str)
		end
		msgStr = msgStr..str
		if i < tabLen then
		   local nextStr = emojiTab[i+1]
		   local nextIndex = string.find(msg,nextStr,#msgStr)
		   if endIndex+1 < nextIndex  then
			  local str2 = string.sub(msg,endIndex+1,nextIndex-1)
			  table.insert(Msg,str2)
			  msgStr = msgStr..str2
		   end
		elseif endIndex < len then
		   table.insert(Msg,string.sub(msg,endIndex + 1,len))
		end
	end
	return table.concat(Msg,"")
end

--取字符串长度（任意单字符长度为1)
function CommonUtility:GetStringLen(str)
	if type(str)~="string" or #str<=0 then
		return 0
	end
	local arr={0,0xc0,0xe0,0xf0,0xf8,0xfc}
	local strLen=string.len(str)
	local index=strLen
	local len=0
	while index~=0 do
		local curByte=string.byte(str,-index)
		local i=#arr
		while arr[i] do
			if curByte>=arr[i] then
				index=index-i
				break
			end
			i=i-1
	    end
		len=len+1
	end
	return len
end

function CommonUtility:VecReadOnly(tb)
	-- 生产版本直接使用原来的数据
	-- 不做readonly 判断
	if not DebugVersion then
		return tb
	end
	local tbReadOnly = {__ro = true}
	local mt = {
		__index = tb,
		__newindex = function(t, k, v)
			if t.__ro then
				WLog(".................table is read only................")
			else
				tb[k] = v
			end
		end
	}
	mt.__tostring = tb.__tostring
	mt.__div = tb.__div
	mt.__mul = tb.__mul
	mt.__add = tb.__add
	mt.__sub = tb.__sub
	mt.__unm = tb.__unm
	mt.__eq = tb.__eq
	setmetatable(tbReadOnly, mt)
	return tbReadOnly
end
--[[function CommonUtility:HasShieldWord(str)
	if type(str)~="string" or str=="" then
		return false
	end
	for i,v in pairs(ShieldWordConfig) do
	    if string.len(str)>=string.len(i) then
	       if string.find(str,i,1) then
			  return true
		   end
		end
	end
	return false
end]]--


-------------------准备整理之后删除-------------------
function CommonUtility:GetAttrIcon(id)
	if id ==10 then
		return UIPackage.GetItemURL("role","JS_role_icon10@2x")
	else
		return UIPackage.GetItemURL("role",string.format("JS_role_icon0%d@2x",id))
	end
	-- body
end

function CommonUtility:GetRaceIcon(id)
	return UIPackage.GetItemURL("role",string.format("icon_Race_talent0%d@2x",id))
end

function CommonUtility:GetJobIconBg(id)
	return UIPackage.GetItemURL("hud",string.format("team_blood_0%dbg@2x",id))
end

function CommonUtility:GetJobIcon(id)
	return UIPackage.GetItemURL("hud",string.format("team_blood_0%d@2x",id))
end

function CommonUtility:GetCoinIcon(id)
	return UIPackage.GetItemURL("role",string.format("COM_icon_coin%d@2x",id))
end
function CommonUtility:GetHeroJobIcon(jobId)
	return UIPackage.GetItemURL("common",string.format("com_Heroes_icon_%d",jobId))
end
function CommonUtility:GetHeroJobSelectIcon(jobId)
	return UIPackage.GetItemURL("common",string.format("com_Heroes_icon_%d_select",jobId))
end

function CommonUtility:Vec3ToString(v)
	return "(" .. v.x .. ", " .. v.y .. ", " .. v.z .. ")"
end

function CommonUtility:TableContainsKey(table, element)
	for k, v in pairs(table) do
		if (k == element) then
			return true
		end
	end
	return false
end

function CommonUtility:TableContainsValue(table, element)
	for _, v in pairs(table) do
		if (v == element) then
			return true
		end
	end
	return false
end

function CommonUtility:DeserializeFaceIdent(faceIdent)
	local equipFaceArray = {}

	local str = tostring(faceIdent)
	local len = string.len(str)
	if (len == 8) then
		for i = 0, 3 do
			local identStr = string.sub(str, i * 2 + 1, i * 2 + 2)
			if (i == 0) then
				identStr = string.format("%s000000", identStr)
			elseif (i == 1) then
				identStr = string.format("%s0000", identStr)
			elseif (i == 2) then
				identStr = string.format("%s00", identStr)
			end
			local ident = tonumber(identStr)
			local config = ModelRelationConfig[ident]
			if (config ~= nil) then
				table.insert(equipFaceArray, config.ModelID)
			end
		end
	elseif (len == 6) then
		for i = 0, 2 do
			local identStr = string.sub(str, i * 2 + 1, i * 2 + 2)
			if (i == 0) then
				identStr = string.format("%s0000", identStr)
			elseif (i == 1) then
				identStr = string.format("%s00", identStr)
			end
			local ident = tonumber(identStr)
			local config = ModelRelationConfig[ident]
			if (config ~= nil) then
				table.insert(equipFaceArray, config.ModelID)
			end
		end
	elseif (len == 4) then
		for i = 0, 1 do
			local identStr = string.sub(str, i * 2 + 1, i * 2 + 2)
			if (i == 0) then
				identStr = string.format("%s00", identStr)
			end
			local ident = tonumber(identStr)
			local config = ModelRelationConfig[ident]
			if (config ~= nil) then
				table.insert(equipFaceArray, config.ModelID)
			end
		end
	else
		local identStr = str
		local ident = tonumber(identStr)
		local config = ModelRelationConfig[ident]
		if (config ~= nil) then
			table.insert(equipFaceArray, config.ModelID)
		end
	end

	return equipFaceArray
end

function CommonUtility:GetFileNameFromPath(path, postfixLen)
	if postfixLen == nil then
		postfixLen = 0
	end
	if path == nil then
		return nil
	end
	local _, pos = string.find(path, ".*/")
	if pos == nil then
		pos = 1
	end
	local toPos = string.len(path) - postfixLen  --去掉结尾的".prefab"
	local result = nil
	result = string.sub(path, pos + 1, toPos)
	return result
end

function CommonUtility:SendAPM(id)
	if self:isNil(self.dataAPM) then
	   return
	end
	if self.openAPM then
	   if not testbit(self.dataAPM,id) then
	      LuaHelper.PostStepEvent(self.APMCategory[1],id,true,0,"","")
	      local low,high = int64.tonum2(self.dataAPM)
	      if id > 32 then
			  high = SetBit(high,id,1)
	      else
		     low = SetBit(low,id,1)
	      end
          local data = int64.new(low, high)
		  self.dataAPM = data
		  if data == 2097151 then
			 LuaHelper.ReleaseStepEventContext()
			 self.openAPM = false
		  end
	      ServerAgent:SendAPM(data)
	   end
	end
end

function CommonUtility:HasShieldWord(str)
	--[[if type(str)~="string" or str=="" then
		return false
	end
	if self:isNil(self.cfgShield) then
	   self.cfgShield = utable.getAll(ConstTable.ShieldWordConfig)
	end
	for i,v in pairs(self.cfgShield) do
	    if string.len(str)>=string.len(i) then
	       if string.find(str,i,1) then
			  return true
		   end
		end
	end]]
	return false
end

function CommonUtility:TestBit(val, index)
	local bit1 = 1 << index
	local test = val & bit1
	return test ~= 0
end

function CommonUtility:SetBit(val, index)
	local bit1 = 1 << index
	local test = val | bit1
	return test
end


-- global function
function DistanceWithoutSqrt(x1, z1, x2, z2)
	return (x1 - x2)^2 + (z1 - z2)^2
end

function Int64AddNum(v64, num)
	local tmp64 = int64.new(tostring(num))
	return v64 + tmp64
end

function Int64SubNum(v64, num)
	local tmp64 = int64.new(tostring(num))
	return v64 - tmp64
end

function Int64EqualNum(v64, num)
	local tmp64 = int64.new(tostring(num))
	return v64 == tmp64
end

function Int64LessEqualNum(v64, num)
	local tmp64 = int64.new(tostring(num))
	return v64 <= tmp64
end

function Int64LessNum(v64, num)
	local tmp64 = int64.new(tostring(num))
	return v64 < tmp64
end

function GetNavIdFromMapId(mapId)
	local mapInfo = MapInfoConfig[mapId]
	if mapInfo ~= nil and mapInfo.Navmesh ~= nil and mapInfo.Navmesh ~= "" then
		return mapInfo.Navmesh
	end
	return tostring(mapId)
end

function EmptyFunc()
end

function CommonUtility:EnableSkillAreaChange(enable)
	local hud = UIMgr:GetUI("HUDUI")
	hud:EnableSwitchFightState(enable)
end

function CommonUtility:ResetPreCharData()
	HeroSystemMgr:ResetData()
	ChatDataMgr:ClearData()
	ArtifactMgr:ResetData()
	DungeonMgr:ResetData()
	TeamMgr:ResetData()
	MazeMgr:ResetData()
	PetMgr:ResteData()
	PalaceMgr:ResetData()
	FriendMgr:ClearData()
	TitleMgr:ClearData()
	AchievementMgr:ClearData()
	GuideMgr:ResetData()
	FashionMgr:ClearData()
	AttrAndCeMgr:ClearData()
end

--拷贝一个值而不是引用
function CommonUtility:DeepCopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key,orig_value in next,orig,nil do
			copy[self:DeepCopy(orig_key)] = self:DeepCopy(orig_value)
		end
		setmetatable(copy,self:DeepCopy(getmetatable(orig)))
	else
		copy = orig
	end
	return copy
end

function CommonUtility:IsAspectRatio()
	local isLandScape = Screen.width > Screen.height;
	if isLandScape then
		return Screen.width / Screen.height
	else
		return Screen.height / Screen.width
	end
end

function CommonUtility:IsPadResolution()
	local aspect = self:IsAspectRatio()
	return aspect > (4.0 / 3 - 0.05) and aspect < (4.0 / 3 + 0.12);
end

function CommonUtility:SetBgLoaderFillTypeAspect(loader)
	if not loader then return end
	local aspect = self:IsAspectRatio()
	local isPad = self:IsPadResolution()
	local boundary = isPad and UIAdaptiveEnum.PadBoundary or UIAdaptiveEnum.PhoneBoundary
	if aspect < boundary then
		loader.fill = FillType.ScaleMatchHeight
	else
		loader.fill = FillType.ScaleMatchWidth
	end
end

function CommonUtility:PlayVoice(show, vo)
	if not CommonUtility:IsNilString(show) then
		WWiseManager.Instance:PlayFairyGUI(show)
	end
	
	if not CommonUtility:IsNilString(vo) then
		WWiseManager.Instance:PlayFairyGUI(vo)
	end
end

return CommonUtility