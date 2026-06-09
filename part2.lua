warning = function() 
    return  
end
warn = function() 
    return  
end
error = function() 
    return  
end

if not loadCharStorage or not saveCharStorage then
  return print("[Heal Friend] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function saveHealFriendChar()
  saveCharStorage(charStorage)
end

local function trimText(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function lowerTrim(s)
  return trimText(s):lower()
end

local function getBotItemId(widget)
  if not widget then return 0 end
  if widget.getItemId then
    local ok, id = pcall(function() return widget:getItemId() end)
    if ok and id and id > 0 then return id end
  end
  if widget.getItem then
    local ok, item = pcall(function() return widget:getItem() end)
    if ok and item and item.getId then
      local ok2, id = pcall(function() return item:getId() end)
      if ok2 and id and id > 0 then return id end
    end
  end
  return 0
end

-- ===============================
-- BUTTON
-- ===============================
switchSio = "sioButton"
charStorage[switchSio] = charStorage[switchSio] or { enabled = false }

sioButton = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Healing Friend
    height: 18
    color: white

  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Config
    opacity: 1.00
    color: white
]])
sioButton:setId(switchSio)
sioButton.title:setOn(charStorage[switchSio].enabled)

sioButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  charStorage[switchSio].enabled = newState
  saveHealFriendChar()
end

local prioRowTemplate = [[
UIWidget
  height: 19
  margin-top: 1
  background-color: #2a2a2a
  border: 1 #3a3a3a

  Label
    id: voc
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    color: white
    text: ""

  Button
    id: down
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 2
    text: v
    color: white

  Button
    id: up
    anchors.right: down.left
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 2
    text: ^
    color: white
]]

sioInterface = setupUI([[
MainWindow
  id: mainPanel
  size: 380 390
  border: 1 black
  text: Panel Heal-Friend
  anchors.centerIn: parent
  margin-top: -50

  Panel
    id: infolist1
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    size: 270 200
    image-source: /images/ui/miniwindow
    image-border: 20
    margin-left: -4
    margin-right: -4

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Settings for Heal Friend
      margin-top: 2

  Label
    id: labelSelectType
    anchors.top: infolist1.top
    anchors.left: infolist1.left
    margin-top: 25
    margin-left: 10
    text: Mode Healing:
    text-auto-resize: true

  BotSwitch
    id: UseSpell
    anchors.verticalCenter: labelSelectType.verticalCenter
    anchors.left: labelSelectType.right
    margin-left: 10
    size: 125 19
    text: Health Spell

  BotSwitch
    id: UsePotion
    anchors.verticalCenter: labelSelectType.verticalCenter
    anchors.left: UseSpell.right
    margin-left: 1
    size: 125 19
    text: Health Item

  Label
    id: hpCura
    anchors.top: UseSpell.bottom
    anchors.left: labelSelectType.left
    text: Friend HP%:
    margin-top: 6

  HorizontalScrollBar
    id: percentHp
    anchors.verticalCenter: hpCura.verticalCenter
    anchors.left: UseSpell.left
    anchors.right: parent.right
    margin-right: 5
    minimum: 1
    maximum: 100

  Label
    id: percentHpValue
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.left
    anchors.right: prev.right
    text-align: center
    text: 80%
    color: white

  Label
    id: distancePotion
    anchors.top: hpCura.bottom
    anchors.left: labelSelectType.left
    text: Distance Item:
    margin-top: 8

  HorizontalScrollBar
    id: distUsePot
    anchors.verticalCenter: distancePotion.verticalCenter
    anchors.left: UseSpell.left
    anchors.right: parent.right
    margin-right: 5
    minimum: 1
    maximum: 10

  Label
    id: distUsePotValue
    anchors.verticalCenter: distUsePot.verticalCenter
    anchors.left: prev.left
    anchors.right: prev.right
    text-align: center
    text: 3 Sqm
    color: white

  Label
    id: labelSolicitar
    anchors.top: distancePotion.bottom
    anchors.left: labelSelectType.left
    text: Ask Mana:
    margin-top: 8

  HorizontalScrollBar
    id: percentMp
    anchors.verticalCenter: labelSolicitar.verticalCenter
    anchors.left: UseSpell.left
    anchors.right: parent.right
    margin-right: 5
    minimum: 1
    maximum: 100

  Label
    id: percentMpValue
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.left
    anchors.right: prev.right
    text-align: center
    text: 50%
    color: white

  HorizontalSeparator
    id: sepHor
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5

  Label
    id: HealingSpells
    anchors.top: sepHor.bottom
    anchors.left: distancePotion.left
    margin-top: 10
    text: Healing Spells:

  CheckBox
    id: exuraSio
    anchors.top: HealingSpells.bottom
    anchors.left: HealingSpells.left
    margin-top: 5
    text: Exura Sio
    text-auto-resize: true
    color: gray
    $checked:
      color: green

  CheckBox
    id: masRes
    anchors.top: exuraSio.bottom
    anchors.left: exuraSio.left
    margin-top: 8
    text: Mas Res
    text-auto-resize: true
    color: gray
    $checked:
      color: green

  CheckBox
    id: checkOtherSpell
    anchors.top: masRes.bottom
    anchors.left: masRes.left
    margin-top: 8

  TextEdit
    id: otherSpell
    anchors.verticalCenter: checkOtherSpell.verticalCenter
    anchors.left: checkOtherSpell.right
    size: 110 19
    margin-left: 7
    placeholder: Other Spell

  Label
    id: labelPotion
    anchors.top: HealingSpells.top
    anchors.left: otherSpell.right
    margin-left: 40
    text: Health Potion:

  BotItem
    id: potionID
    anchors.left: prev.right
    anchors.verticalCenter: prev.verticalCenter
    margin-left: 58
    margin-top: 2

  Label
    id: labelPotionMP
    anchors.top: labelPotion.top
    anchors.left: labelPotion.left
    margin-top: 45
    text: Mana Potion:

  BotItem
    id: potionMPID
    anchors.left: potionID.left
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 3

  Panel
    id: infolist2
    anchors.top: infolist1.bottom
    anchors.left: infolist1.left
    size: 200 130
    image-source: /images/ui/miniwindow
    image-border: 20
    margin-top: 5

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Heal Toggles
      margin-top: 2

  BotSwitch
    id: friendList
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    margin: 10
    margin-top: 22
    width: 18
    text: Friend List

  BotSwitch
    id: partyMembers
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 4
    width: 18
    text: Party Members

  BotSwitch
    id: guildMembers
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 4
    width: 18
    text: Guild Members

  BotSwitch
    id: cureMPFriend
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 4
    width: 18
    text: Request Mana

  ComboBox
    id: selectChat
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 4
    height: 20
    @onSetup: |
      self:addOption("Default")
      self:addOption("Party Channel")

  Panel
    id: infolist3
    anchors.top: infolist2.top
    anchors.left: infolist2.right
    anchors.right: parent.right
    margin-right: -4
    margin-left: 7
    image-source: /images/ui/miniwindow
    image-border: 20
    height: 130

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Priority List
      margin-top: 2

  TextList
    id: prioList
    anchors.top: infolist3.top
    anchors.left: infolist3.left
    anchors.right: infolist3.right
    margin-top: 20
    margin-left: 5
    margin-right: 5
    height: 105
    image-source: ""

  BotSwitch
    id: listPrio
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    width: 18
    margin-top: 83
    text: Priority Vocation

  Button
    id: closePanel
    anchors.left: infolist2.left
    anchors.right: infolist3.right
    anchors.top: prioList.bottom
    size: 35 20
    margin-top: 9
    text: Close
]], g_ui.getRootWidget())

sioInterface:hide()

if modules._G.g_app.isMobile() then
  sioInterface:setSize("380 410")
end

sioInterface.closePanel.onClick = function()
  sioInterface:hide()
end

sioButton.settings.onClick = function()
  if sioInterface:isVisible() then
    sioInterface:hide()
  else
    sioInterface:show()
    sioInterface:raise()
    sioInterface:focus()
  end
end

-- ===============================
-- MIGRACAO STORAGE ANTIGO -> CHARSTORAGE
-- ===============================
if storage and storage.healFriend and not charStorage.healFriendMigrated then
  charStorage.healFriend = charStorage.healFriend or {}
  for k, v in pairs(storage.healFriend) do
    if charStorage.healFriend[k] == nil then
      charStorage.healFriend[k] = v
    end
  end
  charStorage.healFriendMigrated = true
  saveHealFriendChar()
end

if storage and storage[switchSio] and not charStorage.sioButtonMigrated then
  charStorage[switchSio] = charStorage[switchSio] or {}
  if charStorage[switchSio].enabled == nil then
    charStorage[switchSio].enabled = storage[switchSio].enabled == true
  end
  charStorage.sioButtonMigrated = true
  saveHealFriendChar()
end

if not charStorage.healFriend then
  charStorage.healFriend = {
    useSpell = false,
    usePotion = false,
    percentHp = 80,
    distUsePot = 3,
    percentMp = 50,
    exuraSio = true,
    masRes = false,
    checkOtherSpell = false,
    otherSpell = "",
    potionID = 0,
    potionMPID = 0,
    friendList = false,
    partyMembers = false,
    guildMembers = false,
    listPrio = false,
    cureMPFriend = false,
    selectChat = "Default",
    prioOrder = { "Knight", "Paladin", "Monk", "Mage" }
  }
end

local config = charStorage.healFriend
config.prioOrder = config.prioOrder or { "Knight", "Paladin", "Monk", "Mage" }

local function saveConfig()
  saveHealFriendChar()
end

sioInterface.selectChat:setCurrentOption(config.selectChat)

sioInterface.selectChat.onOptionChange = function(widget, option)
  config.selectChat = option
  saveConfig()
end

local function setScrollLabel(label, value, suffix)
  label:setText(tostring(value) .. (suffix or ""))
end

local function clearChildren(w)
  if not w then return end
  local ch = w:getChildren() or {}
  for i = #ch, 1, -1 do
    local c = ch[i]
    if c and not c:isDestroyed() then c:destroy() end
  end
end

local function swap(t, i, j)
  if type(t) ~= "table" then return end
  if i < 1 or j < 1 or i > #t or j > #t then return end
  t[i], t[j] = t[j], t[i]
end

local function rebuildPrioList()
  clearChildren(sioInterface.prioList)

  local fixed = { "Knight", "Paladin", "Monk", "Mage" }

  if type(config.prioOrder) ~= "table" or #config.prioOrder ~= 4 then
    config.prioOrder = fixed
    saveConfig()
  end

  for i = 1, #config.prioOrder do
    local voc = config.prioOrder[i]
    local row = setupUI(prioRowTemplate, sioInterface.prioList)

    row.voc:setText(voc)

    row.up.onClick = function()
      swap(config.prioOrder, i, i - 1)
      saveConfig()
      rebuildPrioList()
    end

    row.down.onClick = function()
      swap(config.prioOrder, i, i + 1)
      saveConfig()
      rebuildPrioList()
    end

    if i == 1 then row.up:setEnabled(false) end
    if i == #config.prioOrder then row.down:setEnabled(false) end
  end
end

rebuildPrioList()

sioInterface.UseSpell.onClick = function(widget)
  config.useSpell = not config.useSpell
  widget:setOn(config.useSpell)
  if config.useSpell then
    config.usePotion = false
    sioInterface.UsePotion:setOn(false)
  end
  saveConfig()
end
sioInterface.UseSpell:setOn(config.useSpell)

sioInterface.UsePotion.onClick = function(widget)
  config.usePotion = not config.usePotion
  widget:setOn(config.usePotion)
  if config.usePotion then
    config.useSpell = false
    sioInterface.UseSpell:setOn(false)
  end
  saveConfig()
end
sioInterface.UsePotion:setOn(config.usePotion)

sioInterface.percentHp.onValueChange = function(scroll, value)
  config.percentHp = value
  setScrollLabel(sioInterface.percentHpValue, value, "%")
  saveConfig()
end
sioInterface.percentHp:setValue(config.percentHp)
setScrollLabel(sioInterface.percentHpValue, config.percentHp, "%")

sioInterface.distUsePot.onValueChange = function(scroll, value)
  config.distUsePot = value
  setScrollLabel(sioInterface.distUsePotValue, value, " Sqm")
  saveConfig()
end
sioInterface.distUsePot:setValue(config.distUsePot)
setScrollLabel(sioInterface.distUsePotValue, config.distUsePot, " Sqm")

sioInterface.percentMp.onValueChange = function(scroll, value)
  config.percentMp = value
  setScrollLabel(sioInterface.percentMpValue, value, "%")
  saveConfig()
end
sioInterface.percentMp:setValue(config.percentMp)
setScrollLabel(sioInterface.percentMpValue, config.percentMp, "%")

sioInterface.exuraSio.onClick = function(widget)
  config.exuraSio = not config.exuraSio
  widget:setChecked(config.exuraSio)
  saveConfig()
end
sioInterface.exuraSio:setChecked(config.exuraSio)

sioInterface.masRes.onClick = function(widget)
  config.masRes = not config.masRes
  widget:setChecked(config.masRes)
  saveConfig()
end
sioInterface.masRes:setChecked(config.masRes)

sioInterface.checkOtherSpell.onClick = function(widget)
  config.checkOtherSpell = not config.checkOtherSpell
  widget:setChecked(config.checkOtherSpell)
  saveConfig()
end
sioInterface.checkOtherSpell:setChecked(config.checkOtherSpell)

sioInterface.otherSpell.onTextChange = function(widget, text)
  config.otherSpell = text
  saveConfig()
end
sioInterface.otherSpell:setText(config.otherSpell)

sioInterface.potionID.onItemChange = function(widget)
  config.potionID = getBotItemId(widget)
  saveConfig()
end
sioInterface.potionID:setItemId(config.potionID)

sioInterface.potionMPID.onItemChange = function(widget)
  config.potionMPID = getBotItemId(widget)
  saveConfig()
end
sioInterface.potionMPID:setItemId(config.potionMPID)

local toggles = {"friendList", "partyMembers", "guildMembers", "listPrio", "cureMPFriend"}
for _, id in ipairs(toggles) do
  sioInterface[id].onClick = function(widget)
    config[id] = not config[id]
    widget:setOn(config[id])
    saveConfig()
  end
  sioInterface[id]:setOn(config[id])
end

saveConfig()

-----------------------------
-- MACRO DE PEDIR MP
-----------------------------
macro(200, function()
  if not charStorage[switchSio] or not charStorage[switchSio].enabled then
    return
  end
  if not config or not config.cureMPFriend then
    return
  end

  local manaPercent = config.percentMp
  local chatSelecionado = config.selectChat
  if manapercent() <= manaPercent then
    if chatSelecionado == "Default" then
      say("p")
      delay(4000)
    elseif chatSelecionado == "Party Channel" then
      sayChannel(1, "p")
      delay(4000)
    end
  end
end)

macro(100, function()
  if pauseFriendHeal and pauseFriendHeal > now then return end
  if not charStorage[switchSio] or not charStorage[switchSio].enabled then return end

  local player = g_game.getLocalPlayer()
  if not player then return end

  local spectators = getSpectators()
  if not spectators then return end

  local targets = {}
  local minHp = config.percentHp or 80

  -- =========================
  -- COLETA PLAYERS
  -- =========================
  for _, creature in ipairs(spectators) do
    if creature:isPlayer() and creature:getName() ~= player:getName() then
      local hp = 100
      if creature.getHealthPercent then
        hp = creature:getHealthPercent()
      end

      if hp and hp > 0 and hp <= minHp then
        table.insert(targets, {
          creature = creature,
          hp = hp
        })
      end
    end
  end

  if #targets == 0 then return end

  -- =========================
  -- FILTRO (SAFE)
  -- =========================
  local function isFriendName(n)
    if storage.playerList and type(storage.playerList.friendList) == "table" then
      for _, fName in ipairs(storage.playerList.friendList) do
        if lowerTrim(fName) == lowerTrim(n) then return true end
      end
    end
    return false
  end

  local function canHeal(creature)
    local name = creature:getName()

    if config.friendList and isFriend and isFriend(name) then return true end
    if config.friendList and isFriendName(name) then return true end
    if config.partyMembers and creature.isPartyMember and creature:isPartyMember() then return true end
    if config.guildMembers and creature.isGuildMember and creature:isGuildMember() then return true end

    if not config.friendList and not config.partyMembers and not config.guildMembers then
      return true
    end

    return false
  end

  local valid = {}
  for _, t in ipairs(targets) do
    if canHeal(t.creature) then
      table.insert(valid, t)
    end
  end

  if #valid == 0 then return end

  -- =========================
  -- PRIORIDADE
  -- =========================
  local rankMap = {}
  if config.listPrio then
    local order = config.prioOrder or { "Knight", "Paladin", "Monk", "Mage" }
    for i = 1, #order do
      rankMap[order[i]:upper()] = i
    end
  end

  local function getVocCodeFromCheckText(creature)
    if not creature or not creature.getText then return nil end
    local t = creature:getText() or ""
    if t == "" then return nil end

    local code = t:match("%d+%s*(%u%u)")
    if not code then code = t:match("(%u%u)") end
    return code
  end

  local function vocGroupFromCode(code)
    if code == "EK" then return "KNIGHT" end
    if code == "RP" then return "PALADIN" end
    if code == "EM" then return "MONK" end
    if code == "MS" or code == "ED" then return "MAGE" end
    return nil
  end

  local function getPrioRankForCreature(creature)
    local code = getVocCodeFromCheckText(creature)
    local group = vocGroupFromCode(code)
    if not group then return 9999 end
    return rankMap[group] or 9999
  end

  table.sort(valid, function(a, b)
    if not config.listPrio then
      return a.hp < b.hp
    end

    local pa = getPrioRankForCreature(a.creature)
    local pb = getPrioRankForCreature(b.creature)

    if pa == pb then
      return a.hp < b.hp
    end

    return pa < pb
  end)

  local target = valid[1]
  if not target then return end

  local t = target.creature
  local tName = t:getName()

  -- =========================
  -- SPELL HEAL
  -- =========================
  if config.useSpell then
    if config.exuraSio then
      if (not pauseFriendHeal or pauseFriendHeal <= now) then
        say('exura sio "' .. tName)
      end
      delay(500)
      return
    end

    if config.masRes then
      if (not pauseFriendHeal or pauseFriendHeal <= now) then
        say("exura gran mas res")
      end
      delay(500)
      return
    end

    if config.checkOtherSpell and trimText(config.otherSpell) ~= "" then
      if (not pauseFriendHeal or pauseFriendHeal <= now) then
        say(config.otherSpell .. ' "' .. tName)
      end
      delay(500)
      return
    end
  end

  -- =========================
  -- POTION HEAL
  -- =========================
  if config.usePotion and config.potionID and config.potionID > 0 then
    local dist = getDistanceBetween(player:getPosition(), t:getPosition())

    if dist <= (config.distUsePot or 3) then
      if g_game.useInventoryItemWith then
        g_game.useInventoryItemWith(config.potionID, t)
      else
        useWith(config.potionID, t)
      end
      return
    end
  end
end)

-- =========================================
-- LISTENER: DAR MANA PARA QUEM PEDIR "P"
-- =========================================
onTalk(function(name, level, mode, text, channelId, pos)
  text = lowerTrim(text)
  if text ~= "p" then return end

  if not charStorage[switchSio] or not charStorage[switchSio].enabled then
    warn("[Mana Help] Bloqueado: O painel geral (Healing Friend) esta desligado.")
    return
  end

  local mpId = config.potionMPID
  if not mpId or mpId <= 100 then
    warn("[Mana Help] Bloqueado: Nenhuma Potion MP configurada no painel. ID lido: " .. tostring(mpId))
    return
  end

  local player = g_game.getLocalPlayer()
  if not player or name == player:getName() then return end

  local targetCreature = nil
  for _, creature in ipairs(getSpectators()) do
    if creature:isPlayer() and lowerTrim(creature:getName()) == lowerTrim(name) then
      targetCreature = creature
      break
    end
  end

  if not targetCreature then
    warn("[Mana Help] Bloqueado: O player " .. name .. " pediu mana mas nao esta na sua tela.")
    return
  end

  local dist = getDistanceBetween(player:getPosition(), targetCreature:getPosition())
  if dist > 1 then
    warn("[Mana Help] Bloqueado: O player " .. name .. " pediu mana mas esta longe. Distancia: " .. dist)
    return
  end

  local function isFriendName(n)
    if storage.playerList and type(storage.playerList.friendList) == "table" then
      for _, fName in ipairs(storage.playerList.friendList) do
        if lowerTrim(fName) == lowerTrim(n) then return true end
      end
    end
    return false
  end

  local validTarget = false
  if config.friendList and isFriend and isFriend(name) then validTarget = true end
  if config.friendList and isFriendName(name) then validTarget = true end
  if config.partyMembers and targetCreature.isPartyMember and targetCreature:isPartyMember() then validTarget = true end

  if config.guildMembers then
    if targetCreature.isGuildMember and targetCreature:isGuildMember() then validTarget = true end
    if targetCreature.getEmblem and targetCreature:getEmblem() == 1 then validTarget = true end
    if targetCreature.getShield and targetCreature:getShield() == 1 then validTarget = true end
  end

  if validTarget then
    warn("[Mana Help] Sucesso! Usando Potion no player: " .. name)

    schedule(50, function()
      if g_game.useInventoryItemWith then
        g_game.useInventoryItemWith(mpId, targetCreature)
      else
        useWith(mpId, targetCreature)
      end
    end)
  else
    warn("[Mana Help] Bloqueado: O player " .. name .. " esta colado, mas nao eh seu amigo, party ou guild ativo no painel.")
  end
end)

---------------------- FOLLOW
setDefaultTab("Main")

PANEL_NAME = "lnsFollow"
SWITCH_FOLLOW = "followButton"

charStorage = charStorage or loadCharStorage()

local function trim(str)
  str = tostring(str or "")
  return str:match("^%s*(.-)%s*$")
end

local defaultStrings = {386, 12202, 21965, 21966}
local defaultUse = {1948, 5542, 7771, 20475, 20573, 31262, 21297, 1968, 31130, 31129, 435, 21298}
local defaultDoors = {8265, 7727, 5111, 8261, 8259, 5113, 1646, 9567, 9558, 5287, 5289, 6260, 22506, 5122, 1112, 7712, 7721, 7723, 6258}

local function copyList(t)
  local r = {}
  for i, v in ipairs(t or {}) do r[i] = v end
  return r
end

local function applyDefaultIfEmpty(target, default)
  if type(target) ~= "table" or #target == 0 then
    return copyList(default)
  end
  return target
end

charStorage.follow2Panel = charStorage.follow2Panel or {
  leaderName = "",
  followerName = "",
  ueSpell = "",
  openPt = false,
  commandAttack = false,
  selectChat = "Default",
  routeFallback = true,
  mcList = "",
  idsToFollow = {
    strings = {},
    use = {},
    doorsClosed = {}
  }
}

followCfg = charStorage.follow2Panel
followCfg.leaderName = tostring(followCfg.leaderName or "")
followCfg.followerName = tostring(followCfg.followerName or "")
followCfg.ueSpell = tostring(followCfg.ueSpell or "")
followCfg.openPt = followCfg.openPt == true
followCfg.commandAttack = followCfg.commandAttack == true
followCfg.selectChat = tostring(followCfg.selectChat or "Default")
followCfg.routeFallback = followCfg.routeFallback ~= false
followCfg.mcList = tostring(followCfg.mcList or "")
followCfg.enabled = followCfg.enabled == true
followCfg.isLeader = followCfg.isLeader == true
followCfg.idsToFollow = followCfg.idsToFollow or {}
followCfg.idsToFollow.strings = applyDefaultIfEmpty(followCfg.idsToFollow.strings, defaultStrings)
followCfg.idsToFollow.use = applyDefaultIfEmpty(followCfg.idsToFollow.use, defaultUse)
followCfg.idsToFollow.doorsClosed = applyDefaultIfEmpty(followCfg.idsToFollow.doorsClosed, defaultDoors)

storage[SWITCH_FOLLOW] = storage[SWITCH_FOLLOW] or {}
storage[SWITCH_FOLLOW].enabled = followCfg.enabled
storage[SWITCH_FOLLOW].leader = followCfg.isLeader

local S = followCfg
S.texts = S.texts or {}
S.switches = S.switches or {}
S.stairIDS = S.stairIDS or {484, 17394, 1977, 414}
S.buracoIDS = S.buracoIDS or {1959}

local function syncCompat()
  S.texts.navAttack = tostring(followCfg.leaderName or "")
  S.texts.navLeader = tostring(followCfg.followerName or "")
  S.texts.UESpell = tostring(followCfg.ueSpell or "")
  S.texts.ropeID = tostring(S.texts.ropeID or "3003")

  S.switches.attackCheck = followCfg.enabled == true
  S.switches.followCheck = followCfg.enabled == true
  S.switches.useUEcheck = S.switches.useUEcheck == true
  S.switches.abrirChatParty = followCfg.openPt == true
  S.switches.debug = S.switches.debug == true

  S.ropeIDS = followCfg.idsToFollow.strings or {}
  S.useIDS = followCfg.idsToFollow.use or {}
  S.doorsIDS = followCfg.idsToFollow.doorsClosed or {}

  storage[SWITCH_FOLLOW].enabled = followCfg.enabled == true
  storage[SWITCH_FOLLOW].leader = followCfg.isLeader == true
end

local function saveFollow2()
  syncCompat()
  saveCharStorage(charStorage)
end

syncCompat()

local State = {
  leader = nil,
  leaderPositions = {},
  leaderDirections = {},
  leaderUsePositions = {},
  lastLeaderFloor = nil,
  standTime = now,
  fecharChannel = 0,
  leaderWait = 0,
  lastTarget = nil,
  lastDoorUse = 0,
  lastRopeUse = 0,
  lastUseTry = 0,
  lastWalkTry = 0,
  lastFollowTry = 0,
  lastFloorTry = 0,
  lastLeaderSeenAt = 0,
}

-- FOLLOW AGRESSIVO ENQUANTO ATACA
-- Baseado na lógica da script 2: não usa g_game.follow(),
-- só autoWalk rápido para o melhor sqm em volta do leader.
local ATTACK_WALK_INTERVAL = 60

local AttackFollow = {
  lastWalk = 0,
  stuckCount = 0,
  lastPosKey = ""
}

local function dbg(msg)
  if S.switches.debug then
    print("[LNS FOLLOW] " .. msg)
  end
end

local function getLeaderName()
  return trim(tostring(followCfg.followerName or ""))
end

local function getAttackLeaderName()
  local n = trim(tostring(followCfg.leaderName or ""))
  if n ~= "" then return n end
  return trim(tostring(followCfg.followerName or ""))
end

local function saveFollowSetting(key, value)
  S.texts[key] = value
  saveFollow2()
end

local function safeText(id, default)
  if S.texts[id] == nil then
    S.texts[id] = default
  end
  return S.texts[id]
end

local function containsId(list, id)
  if not list then return false end
  local wanted = tonumber(id)
  if not wanted then return false end

  for _, entry in ipairs(list) do
    local entryId = nil
    if type(entry) == "table" then
      entryId = tonumber(entry.id)
    else
      entryId = tonumber(entry)
    end
    if entryId == wanted then
      return true
    end
  end
  return false
end

local function isPartyReady()
  return player:isPartyMember() or player:isPartyLeader() or player:getShield() > 2
end

local function canRetry(lastTime, delayMs)
  return now >= (lastTime + delayMs)
end

local function resetLeaderCache()
  State.leader = nil
  State.leaderPositions = {}
  State.leaderDirections = {}
  State.leaderUsePositions = {}
  State.lastLeaderFloor = nil
  State.lastLeaderSeenAt = 0
end

local function setFollowEnabled(value)
  storage[SWITCH_FOLLOW].enabled = value
  if not value then
    g_game.cancelFollow()
    resetLeaderCache()
    dbg("Follow desligado e cache resetado.")
  end
end

local function updateToolsScripts()
  if storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].leader then
    if toolsScripts then toolsScripts:show() end
  else
    if toolsScripts then toolsScripts:hide() end
  end
end

local function distanceManhattan(pos1, pos2)
  pos2 = pos2 or player:getPosition()
  return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end

local function matchPos(p1, p2)
  return p1 and p2 and p1.x == p2.x and p1.y == p2.y and p1.z == p2.z
end

local function getVisibleLeader()
  local name = getLeaderName()
  if name == "" then return nil end

  local c = getCreatureByName(name)
  if c and c:getPosition().z == posz() then
    return c
  end
  return nil
end

local function handleUse(pos)
  if not canRetry(State.lastUseTry, 200) then return false end
  State.lastUseTry = now

  local tile = g_map.getTile(pos)
  if tile and tile:getTopUseThing() then
    g_game.use(tile:getTopUseThing())
    dbg("Usando tile em " .. pos.x .. "," .. pos.y .. "," .. pos.z)
    return true
  end
  return false
end

local function handleRope(pos)
  if not canRetry(State.lastRopeUse, 300) then return false end
  State.lastRopeUse = now

  local ropeIdd = tonumber(S.texts.ropeID or "3003")
  local tile = g_map.getTile(pos)
  if tile and tile:getTopUseThing() and ropeIdd then
    useWith(ropeIdd, tile:getTopUseThing())
    dbg("Usando rope em " .. pos.x .. "," .. pos.y .. "," .. pos.z)
    return true
  end
  return false
end

local function handleStep(pos)
  if not canRetry(State.lastWalkTry, 200) then return false end
  State.lastWalkTry = now
  autoWalk(pos, 40, {ignoreNonPathable=true, precision=1})
  return true
end

local function executeClosest(possibilities)
  local referencePos = State.leaderPositions[posz()] or player:getPosition()
  local closest, closestDistance = nil, 99999

  for _, data in ipairs(possibilities) do
    local dist = distanceManhattan(data.pos, referencePos)
    if dist < closestDistance then
      closest = data
      closestDistance = dist
    end
  end

  if closest then
    return closest.action(closest.pos)
  end
  return false
end

local function handleFloorChange()
  if not canRetry(State.lastFloorTry, 250) then return false end
  State.lastFloorTry = now

  local p = player:getPosition()
  local possibleChangers = {}

  local actionMap = {
    { ids = S.useIDS,    action = handleUse  },
    { ids = S.ropeIDS,   action = handleRope },
    { ids = S.stairIDS,  action = handleStep },
    { ids = S.buracoIDS, action = handleStep }
  }

  for _, mapEntry in ipairs(actionMap) do
    if mapEntry.ids and #mapEntry.ids > 0 then
      for x = -2, 2 do
        for y = -2, 2 do
          local checkPos = {x = p.x + x, y = p.y + y, z = p.z}
          local tile = g_map.getTile(checkPos)
          if tile and tile:getTopUseThing() and containsId(mapEntry.ids, tile:getTopUseThing():getId()) then
            table.insert(possibleChangers, {action = mapEntry.action, pos = checkPos})
          end
        end
      end
    end
  end

  if #possibleChangers > 0 then
    dbg("Floor changer encontrado.")
    return executeClosest(possibleChangers)
  end

  return false
end

local function useRopeNear(pos)
  if not pos then return false end

  for x = -1, 1 do
    for y = -1, 1 do
      local tpos = {x = pos.x + x, y = pos.y + y, z = posz()}
      local tile = g_map.getTile(tpos)
      if tile and tile:getGround() and containsId(S.ropeIDS, tile:getGround():getId()) then
        if handleRope(tpos) then
          delay(getDistanceBetween(player:getPosition(), tpos) * 60)
          return true
        end
      end
    end
  end
  return false
end

local function handleUsing()
  local usePos = State.leaderUsePositions[posz()]
  if not usePos then return false end

  local useTile = g_map.getOrCreateTile(usePos)
  if useTile and useTile:getTopUseThing() then
    g_game.use(useTile:getTopUseThing())
    dbg("Usando posição do leader.")
    return true
  end
  return false
end

local function getStandTime()
  return now - State.standTime
end

local function levitate(dir)
  if not dir then return false end
  turn(dir)
  schedule(200, function()
    say('exani hur "down')
    say('exani hur "up')
  end)
  dbg("Tentando levitate.")
  return true
end

local function handleDoors()
  if not canRetry(State.lastDoorUse, 400) then return false end

  local doorIds = S.doorsIDS or {}
  local ppos = player:getPosition()
  local lpos = State.leader and State.leader:getPosition() or State.leaderPositions[posz()]
  local bestDoor = nil
  local bestLeaderDist = 99999
  local bestPlayerDist = 99999

  for x = ppos.x - 4, ppos.x + 4 do
    for y = ppos.y - 4, ppos.y + 4 do
      local pos = {x = x, y = y, z = ppos.z}
      local tile = g_map.getTile(pos)

      if tile and tile:getTopUseThing() and containsId(doorIds, tile:getTopUseThing():getId()) then
        local playerDist = getDistanceBetween(ppos, pos)
        if playerDist <= 4 then
          local leaderDist = lpos and getDistanceBetween(lpos, pos) or 99999

          if not bestDoor
            or leaderDist < bestLeaderDist
            or (leaderDist == bestLeaderDist and playerDist < bestPlayerDist) then
            bestDoor = {thing = tile:getTopUseThing(), pos = pos}
            bestLeaderDist = leaderDist
            bestPlayerDist = playerDist
          end
        end
      end
    end
  end

  if not bestDoor then return false end

  State.lastDoorUse = now
  g_game.use(bestDoor.thing)
  dbg("Abrindo porta em " .. bestDoor.pos.x .. "," .. bestDoor.pos.y .. "," .. bestDoor.pos.z)

  if lpos then
    local around = {
      {x = lpos.x + 1, y = lpos.y, z = lpos.z},
      {x = lpos.x - 1, y = lpos.y, z = lpos.z},
      {x = lpos.x, y = lpos.y + 1, z = lpos.z},
      {x = lpos.x, y = lpos.y - 1, z = lpos.z},
      {x = lpos.x + 1, y = lpos.y + 1, z = lpos.z},
      {x = lpos.x + 1, y = lpos.y - 1, z = lpos.z},
      {x = lpos.x - 1, y = lpos.y + 1, z = lpos.z},
      {x = lpos.x - 1, y = lpos.y - 1, z = lpos.z},
    }

    for i = 1, #around do
      local testPos = around[i]
      local path = findPath(player:getPosition(), testPos, 20, {ignoreNonPathable=true, precision=1, ignoreCreatures=false})
      if path then
        autoWalk(testPos, 200, {ignoreNonPathable=true, precision=1})
        break
      end
    end
  end

  delay(200)
  return true
end

local function handleLeaderInteraction()
  local l = State.leader
  if not l then return false end

  local lpos = l:getPosition()
  local useIds = S.useIDS or {}

  for x = -1, 1 do
    for y = -1, 1 do
      local tpos = {x = lpos.x + x, y = lpos.y + y, z = lpos.z}
      local tile = g_map.getTile(tpos)
      if tile and tile:getTopUseThing() and containsId(useIds, tile:getTopUseThing():getId()) then
        if handleUse(tpos) then
          delay(100)
          return true
        end
      end
    end
  end

  return false
end

local function tryRecoverLeaderPath()
  local leaderPos = State.leaderPositions[posz()]
  if leaderPos and getDistanceBetween(player:getPosition(), leaderPos) > 0 then
    autoWalk(leaderPos, 200, {ignoreNonPathable=true, precision=5})
    delay(300)
    dbg("Andando para última posição do leader.")
    return true
  end

  if handleLeaderInteraction() then return true end
  if handleFloorChange() then return true end

  local dir = State.leaderDirections[posz()]
  if dir then
    return levitate(dir)
  end

  if useRopeNear(leaderPos) then return true end
  if handleUsing() then return true end

  return false
end

local function ensureFollow(creature)
  if not creature then return false end
  if not canRetry(State.lastFollowTry, 250) then return false end
  State.lastFollowTry = now

  if g_game.isFollowing() then
    if g_game.getFollowingCreature() ~= creature then
      g_game.cancelFollow()
      g_game.follow(creature)
      dbg("Reiniciando follow no leader.")
      return true
    end
  else
    g_game.follow(creature)
    dbg("Iniciando follow no leader.")
    return true
  end
  return false
end

local function followVisibleLeader(creature)
  if not creature then return false end

  local lpos = creature:getPosition()
  local dist = getDistanceBetween(player:getPosition(), lpos)
  local parameters = {ignoreNonPathable=true, precision=1, ignoreCreatures=false}
  local path = nil
  if dist > 2 then
    path = findPath(player:getPosition(), lpos, 30, parameters)
  end

  ensureFollow(creature)

  if dist > 3 then
    if handleDoors() then return true end
  end

  if g_game.isFollowing() and dist > 1 and getStandTime() > 100 then
    autoWalk(lpos, 200, parameters)
    g_game.cancelFollow()
    g_game.follow(creature)
  end

  if dist > 2 and not path then
    if handleUsing() then return true end
    if handleDoors() then return true end
    if handleFloorChange() then return true end
  elseif dist > 7 then
    if getStandTime() > 100 then
      autoWalk(lpos, 200, parameters)
      dbg("Ajustando autowalk no leader.")
      return true
    end
  end

  return false
end

local function getBestAttackFollowPos(leaderPos)
  if not leaderPos or leaderPos.z ~= posz() then return nil end

  local myPos = player:getPosition()
  if not myPos then return leaderPos end

  local candidates = {
    leaderPos,
    {x = leaderPos.x + 1, y = leaderPos.y, z = leaderPos.z},
    {x = leaderPos.x - 1, y = leaderPos.y, z = leaderPos.z},
    {x = leaderPos.x, y = leaderPos.y + 1, z = leaderPos.z},
    {x = leaderPos.x, y = leaderPos.y - 1, z = leaderPos.z},
    {x = leaderPos.x + 1, y = leaderPos.y + 1, z = leaderPos.z},
    {x = leaderPos.x - 1, y = leaderPos.y - 1, z = leaderPos.z},
    {x = leaderPos.x + 1, y = leaderPos.y - 1, z = leaderPos.z},
    {x = leaderPos.x - 1, y = leaderPos.y + 1, z = leaderPos.z}
  }

  local best = nil
  local bestLen = 999

  for _, p in ipairs(candidates) do
    local tile = g_map.getTile(p)
    if tile and tile:isWalkable() then
      local path = findPath(myPos, p, 70, {
        ignoreNonPathable = true,
        ignoreCreatures = false,
        precision = 1
      })

      if path and #path < bestLen then
        best = p
        bestLen = #path
      end
    end
  end

  return best or leaderPos
end

local function attackDoWalkTo(targetPos, precision)
  local myPos = player:getPosition()
  if not myPos or not targetPos or myPos.z ~= targetPos.z then return false end

  precision = tonumber(precision) or 1

  if getDistanceBetween(myPos, targetPos) <= precision then
    AttackFollow.stuckCount = 0
    return true
  end

  if now - AttackFollow.lastWalk < ATTACK_WALK_INTERVAL then
    return true
  end

  AttackFollow.lastWalk = now

  local walkPos = getBestAttackFollowPos(targetPos) or targetPos

  autoWalk(walkPos, 70, {
    ignoreNonPathable = true,
    ignoreCreatures = false,
    precision = 1
  })

  return false
end

local function followVisibleLeaderWhileAttacking(creature)
  if not creature then return false end

  -- IMPORTANTE: atacando não usa follow nativo.
  -- Isso evita quebrar target e deixa o MC andar agressivo igual a script 2.
  if g_game.isFollowing() then
    g_game.cancelFollow()
  end

  local lpos = creature:getPosition()
  if not lpos or lpos.z ~= posz() then return false end

  local dist = getDistanceBetween(player:getPosition(), lpos)
  if dist > 3 then
    local path = findPath(player:getPosition(), lpos, 70, {
      ignoreNonPathable = true,
      ignoreCreatures = false,
      precision = 1
    })

    if not path then
      if handleDoors() then return true end
      if handleUsing() then return true end
      if handleFloorChange() then return true end
    end
  end

  attackDoWalkTo(lpos, 1)
  dbg("Attack follow agressivo no leader.")
  return true
end

local function runFollowLogicIdle()
  if not storage[SWITCH_FOLLOW] or storage[SWITCH_FOLLOW].enabled ~= true then return end
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true) then return end
  if g_game.isAttacking() then return end

  local leaderName = getLeaderName()
  if leaderName == "" then return end

  local c = getVisibleLeader()
  State.leader = c

  -- aqui pode usar follow normal
  if c then
    return followVisibleLeader(c)
  else
    return tryRecoverLeaderPath()
  end
end

local function runFollowLogicAttacking()
  if not storage[SWITCH_FOLLOW] or storage[SWITCH_FOLLOW].enabled ~= true then return end
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true) then return end
  if not g_game.isAttacking() then return end

  local leaderName = getLeaderName()
  if leaderName == "" then return end

  local c = getVisibleLeader()
  State.leader = c

  -- sem leader visível: tenta recuperar caminho / floor / door
  if not c then
    local leaderPos = State.leaderPositions[posz()]
    if leaderPos and getDistanceBetween(player:getPosition(), leaderPos) > 0 then
      attackDoWalkTo(leaderPos, 1)
      dbg("Andando para última posição do leader enquanto ataca.")
      return true
    end

    if handleDoors() then return true end
    if handleLeaderInteraction() then return true end
    if handleFloorChange() then return true end

    local dir = State.leaderDirections[posz()]
    if dir then
      return levitate(dir)
    end

    if useRopeNear(leaderPos) then return true end
    if handleUsing() then return true end

    return false
  end

  -- com leader visível, só reposiciona sem follow bruto
  return followVisibleLeaderWhileAttacking(c)
end


followButton = setupUI([[
Panel
  height: 35

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Follow
    color: white
    height: 18

  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Config
    opacity: 1.00
    color: white

  CheckBox
    id: lider
    anchors.left: title.left
    anchors.top: title.bottom
    margin-top: 2
    image-source: /images/ui/checkbox_round
    text: I'm Leader
    text-auto-resize: true
]])

followButton.title:setOn(followCfg.enabled)
followButton.lider:setChecked(followCfg.isLeader)

followButton.title.onClick = function(widget)
  followCfg.enabled = not widget:isOn()
  widget:setOn(followCfg.enabled)

  charStorage.follow2Panel.enabled = followCfg.enabled
  charStorage.followButton = charStorage.followButton or {}
  charStorage.followButton.enabled = followCfg.enabled
  storage[SWITCH_FOLLOW].enabled = followCfg.enabled

  if not followCfg.enabled then
    g_game.cancelFollow()
    if player and player.stopAutoWalk then
      pcall(function() player:stopAutoWalk() end)
    end
  end

  saveFollow2()
end

followButton.lider.onClick = function(widget)
  followCfg.isLeader = not widget:isChecked()
  widget:setChecked(followCfg.isLeader)

  if toolsScripts and not toolsScripts:isDestroyed() then
    if followCfg.isLeader then
      toolsScripts:show()
      toolsScripts:raise()
      toolsScripts:focus()
    else
      toolsScripts:hide()
    end
  end

  storage[SWITCH_FOLLOW].leader = followCfg.isLeader
  saveFollow2()
end

schedule(500, function()
  if toolsScripts and not toolsScripts:isDestroyed() then
    if followCfg.isLeader then
      toolsScripts:show()
    else
      toolsScripts:hide()
    end
  end
end)

followButton.settings.onClick = function()
  if follow2 then
    follow2:show()
    follow2:raise()
    follow2:focus()
  end
end

local function getContainerItems(widget)
  if not widget or not widget.getItems then return {} end
  local ok, items = pcall(function() return widget:getItems() end)
  if ok and type(items) == "table" then return items end
  return {}
end

--==================================================
-- MAIN FOLLOW PANEL
--==================================================

follow2 = setupUI([=[
MainWindow
  id: mainPanel
  size: 270 310
  text: Panel Follow
  margin-top: -50

  FlatPanel
    id: flatp
    anchors.fill: parent
    margin: -6
    margin-top: 2
    margin-bottom: 20

    Label
      id: liderLabel
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 5
      margin-right: 5
      text: Leader Name:  

    BotTextEdit
      id: lidername
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      placeholder: "#N/D Config..."
      text-align: left

    Label
      id: followLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      text: Follower Name:  

    BotTextEdit
      id: followname
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      placeholder: "#N/D Config..."
      text-align: left

    Label
      id: ueLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      text: UE Spell Name:  

    BotTextEdit
      id: uespell
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      placeholder: "#N/D Config..."
      text-align: left

    HorizontalSeparator
      id: sep1
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5

    BotSwitch
      id: abrirPt
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      text: Open PT Channel

    BotSwitch
      id: comandoAttack
      anchors.top: prev.bottom
      anchors.left: prev.left
      margin-top: 5
      width: 120
      text: Command Attack
      tooltip: Use this to send the attack command in the chat defined to the side (for knights or monks only).

    ComboBox
      id: selectChat
      anchors.top: prev.top
      anchors.left: prev.right
      anchors.right: abrirPt.right
      margin-top: -1
      margin-left: 1
      height: 18
      @onSetup: |
        self:addOption("Default")
        self:addOption("Party Channel")

    BotSwitch
      id: routeFallback
      anchors.top: prev.bottom
      anchors.left: abrirPt.left
      anchors.right: prev.right
      margin-top: 5
      text: Find Leader
      color: red
      image-color: red
      tooltip: Desativado Temporariamente

    HorizontalSeparator
      id: sep2
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5

    Button
      id: mcslist
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      text: List MCs
      height: 18

    Button
      id: idsConfigs
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      text: IDs to Follow
      height: 18

  Button
    id: closePanel
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: 20
    margin-left: -5
    margin-right: -5
    margin-bottom: -2
    text: Close
]=], g_ui.getRootWidget())
follow2:hide()

--==================================================
-- IDS TO FOLLOW WINDOW
--==================================================

idsFollowWindow = setupUI([=[
MainWindow
  id: mainPanel
  size: 398 290
  text: IDs to Follow
  margin-top: -50

  FlatPanel
    id: flatp
    anchors.fill: parent
    margin: -6
    margin-top: 2
    margin-bottom: 20

    FlatPanel
      id: stringsPanel
      anchors.top: parent.top
      anchors.left: parent.left
      width: 120
      height: 215
      margin-top: 5
      margin-left: 5

      Label
        id: labelStrings
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        margin-top: 4
        text-align: center
        color: #d7c08a
        font: verdana-11px-rounded
        text: Strings

      BotContainer
        id: stringsContainer
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        margin-top: 5
        margin-left: 5
        margin-right: 5
        margin-bottom: 5

    FlatPanel
      id: usePanel
      anchors.top: stringsPanel.top
      anchors.left: stringsPanel.right
      width: 120
      height: 215
      margin-left: 5

      Label
        id: labelUse
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        margin-top: 4
        text-align: center
        font: verdana-11px-rounded
        color: #d7c08a
        text: Use

      BotContainer
        id: useContainer
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        margin-top: 5
        margin-left: 5
        margin-right: 5
        margin-bottom: 5

    FlatPanel
      id: doorsPanel
      anchors.top: stringsPanel.top
      anchors.left: usePanel.right
      anchors.right: parent.right
      height: 215
      margin-left: 5
      margin-right: 5

      Label
        id: labelDoors
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        margin-top: 4
        text-align: center
        color: #d7c08a
        font: verdana-11px-rounded
        text: Doors Closed

      BotContainer
        id: doorsContainer
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        margin-top: 5
        margin-left: 5
        margin-right: 5
        margin-bottom: 5

  Button
    id: closePanel
    anchors.left: flatp.left
    anchors.right: flatp.right
    anchors.top: flatp.bottom
    margin-top: 5
    text: Close
]=], g_ui.getRootWidget())
idsFollowWindow:hide()

if modules and modules._G and modules._G.g_app and modules._G.g_app.isMobile and modules._G.g_app.isMobile() then
  follow2:setSize("270 330")
  idsFollowWindow:setSize("398 310")
end

--==================================================
-- BIND MAIN PANEL
--==================================================

follow2.flatp.lidername:setText(followCfg.leaderName)
follow2.flatp.followname:setText(followCfg.followerName)
follow2.flatp.uespell:setText(followCfg.ueSpell)
follow2.flatp.abrirPt:setOn(followCfg.openPt)
follow2.flatp.comandoAttack:setOn(followCfg.commandAttack)
follow2.flatp.routeFallback:setOn(followCfg.routeFallback)

if follow2.flatp.selectChat.setOption then
  follow2.flatp.selectChat:setOption(followCfg.selectChat)
end

follow2.flatp.lidername.onTextChange = function(_, text)
  followCfg.leaderName = tostring(text or "")
  saveFollow2()
end

follow2.flatp.followname.onTextChange = function(_, text)
  followCfg.followerName = tostring(text or "")
  saveFollow2()
end

follow2.flatp.uespell.onTextChange = function(_, text)
  followCfg.ueSpell = tostring(text or "")
  saveFollow2()
end

follow2.flatp.abrirPt.onClick = function(widget)
  followCfg.openPt = not widget:isOn()
  widget:setOn(followCfg.openPt)
  saveFollow2()
end

follow2.flatp.comandoAttack.onClick = function(widget)
  followCfg.commandAttack = not widget:isOn()
  widget:setOn(followCfg.commandAttack)
  saveFollow2()
end

follow2.flatp.routeFallback.onClick = function(widget)
  followCfg.routeFallback = not widget:isOn()
  widget:setOn(followCfg.routeFallback)
  saveFollow2()
end

follow2.flatp.selectChat.onOptionChange = function(_, option)
  followCfg.selectChat = tostring(option or "Default")
  saveFollow2()
end

follow2.closePanel.onClick = function()
  follow2:hide()
end

follow2.flatp.idsConfigs.onClick = function()
  idsFollowWindow:show()
  idsFollowWindow:raise()
  idsFollowWindow:focus()
end

idsFollowWindow.closePanel.onClick = function()
  idsFollowWindow:hide()
end

--==================================================
-- BIND IDS CONTAINERS
--==================================================

UI.ContainerEx(function(widget, items)
  followCfg.idsToFollow.strings = items or {}
  saveFollow2()
end, true, nil, idsFollowWindow.flatp.stringsPanel.stringsContainer)

idsFollowWindow.flatp.stringsPanel.stringsContainer:setItems(followCfg.idsToFollow.strings)


UI.ContainerEx(function(widget, items)
  followCfg.idsToFollow.use = items or {}
  saveFollow2()
end, true, nil, idsFollowWindow.flatp.usePanel.useContainer)

idsFollowWindow.flatp.usePanel.useContainer:setItems(followCfg.idsToFollow.use)


UI.ContainerEx(function(widget, items)
  followCfg.idsToFollow.doorsClosed = items or {}
  saveFollow2()
end, true, nil, idsFollowWindow.flatp.doorsPanel.doorsContainer)

idsFollowWindow.flatp.doorsPanel.doorsContainer:setItems(followCfg.idsToFollow.doorsClosed)

--==================================================
-- LIST MCS WINDOW
--==================================================

g_ui.loadUIFromString([[
LnsMCsListWindow < MainWindow
  id: mainPanel
  size: 420 300
  text: List MCs
  anchors.centerIn: parent
  margin-top: -50

  FlatPanel
    id: flatp
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: ok.top
    margin: -6
    margin-top: 2
    margin-bottom: 5

    Label
      id: titleLabel
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 7
      margin-left: 8
      margin-right: 8
      text-align: center
      color: #d7c08a
      height: 0
      text: ""

    Label
      id: descLabel
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 7
      margin-left: 55
      margin-right: 55
      text-align: center
      text-wrap: true
      height: 30
      text: [EN]: Enter the names separated by commas. [BR]: Insira os nomes separados por virgulas.

    TextEdit
      id: listText
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-top: 8
      margin-left: 8
      margin-right: 8
      margin-bottom: 8
      color: white
      text-wrap: true

  Button
    id: ok
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.bottom: parent.bottom
    height: 20
    margin-left: -5
    margin-right: 2
    margin-bottom: -2
    text: OK

  Button
    id: cancel
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: 20
    margin-left: 2
    margin-right: -5
    margin-bottom: -2
    text: Cancel
]])

local mcsListWindow = nil

local function cleanMCsListText(text)
  text = tostring(text or "")
  text = text:gsub("\r", "")
  text = text:gsub("\n", ",")
  text = text:gsub(",+", ",")
  text = text:gsub("^,", "")
  text = text:gsub(",$", "")
  return text
end

local function mcsStorageToText(text)
  return tostring(text or ""):gsub(",", "\n")
end

local function openMCsWindow()
  if mcsListWindow then
    mcsListWindow:destroy()
    mcsListWindow = nil
  end
  mcsListWindow = UI.createWindow("LnsMCsListWindow", g_ui.getRootWidget())
  mcsListWindow.flatp.listText:setText(mcsStorageToText(followCfg.mcList))
  mcsListWindow:show()
  mcsListWindow:raise()
  mcsListWindow:focus()

  mcsListWindow.ok.onClick = function()
    followCfg.mcList = cleanMCsListText(mcsListWindow.flatp.listText:getText())
    saveFollow2()
    mcsListWindow:destroy()
    mcsListWindow = nil
  end
  mcsListWindow.cancel.onClick = function()
    mcsListWindow:destroy()
    mcsListWindow = nil
  end
end

follow2.flatp.mcslist.onClick = function()
  openMCsWindow()
end

macro(200, function()
  syncCompat()
  runFollowLogicIdle()
end)

macro(50, function()
  syncCompat()
  runFollowLogicAttacking()
end)

onCreaturePositionChange(function(creature, newPos, oldPos)
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true) then return end

  if creature:getName() == player:getName() then
    State.standTime = now
    return
  end

  if creature:getName():lower() ~= getLeaderName():lower() then return end

  if newPos then
    State.leaderPositions[newPos.z] = newPos
    State.lastLeaderFloor = newPos.z
    State.lastLeaderSeenAt = now
    if newPos.z == posz() then
      State.leader = creature
      if storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true and g_game.isAttacking() then
        attackDoWalkTo(newPos, 1)
      end
    else
      State.leader = nil
    end
  else
    State.leader = nil
  end

  if oldPos and newPos and oldPos.z ~= newPos.z then
    State.leaderDirections[oldPos.z] = creature:getDirection()
  end
end)

onCreatureAppear(function(creature)
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true) then return end
  if creature:getName():lower() == getLeaderName():lower() and creature:getPosition().z == posz() then
    State.leader = creature
    State.lastLeaderSeenAt = now
  end
end)

onCreatureDisappear(function(creature)
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].enabled == true) then return end
  if creature:getName():lower() == getLeaderName():lower() then
    State.leader = nil
  end
end)

onMissle(function(missle)
  local src = missle:getSource()
  if src.z ~= posz() then return end

  local from = g_map.getTile(src)
  local to = g_map.getTile(missle:getDestination())
  if not from or not to then return end

  local fromCreatures = from:getCreatures()
  local toCreatures = to:getCreatures()
  if #fromCreatures ~= 1 or #toCreatures ~= 1 then return end

  local c1 = fromCreatures[1]
  local t1 = toCreatures[1]

  local navAttack = getAttackLeaderName():lower()
  if navAttack == "" then return end
  if t1:getName():lower() == navAttack then return end

  if c1:getName():lower() == navAttack then
      local currentTarget = g_game.getAttackingCreature()
      if not currentTarget or currentTarget ~= t1 then
        g_game.attack(t1)
      end
  end
end)

macro(1000, function()
  syncCompat()
  if S.switches.abrirChatParty ~= true then return end
  if not isPartyReady() then return end

  if not modules.game_console.getTab("Party") then
    g_game.requestChannels()
    g_game.joinChannel(1)
    State.fecharChannel = now + 2000
  end

  if State.fecharChannel > 0 and now >= State.fecharChannel then
    local w = nil

    if modules and modules.game_console then
      w = modules.game_console.channelsWindow
    end

    if not w then
      local root = g_ui.getRootWidget()
      if root and root.recursiveGetChildById then
        w = root:recursiveGetChildById("channelsWindow")
      end
    end

    if w then
      w:destroy()
      if modules and modules.game_console then
        modules.game_console.channelsWindow = nil
      end
    end

    State.fecharChannel = 0
  end
end)

local function encodeTargetId(id)
  local s = tostring(id)
  if #s >= 8 then
    local p1 = s:sub(1,1)
    local p2 = s:sub(2,3)
    local p3 = s:sub(4,4)
    local p4 = s:sub(5,6)
    local p5 = s:sub(7,8)
    local p6 = s:sub(9,10)
    return "." .. p1 .. "@" .. p2 .. "#" .. p3 .. "!" .. p4 .. "+" .. p5 .. "[" .. p6 .. "]"
  end
  return "." .. s
end

local function decodeTargetId(text)
  local digits = (text or ""):gsub("%D", "")
  if digits == "" then return nil end
  return tonumber(digits)
end

local function isKnight()
  local voc = player:getVocation()
  return voc == 1 or voc == 6
end

macro(500, function()
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].leader == true) then return end

  if followCfg.commandAttack ~= true then return end

  if not isKnight() then return end
  if not isPartyReady() then return end

  local t = g_game.getAttackingCreature()
  if not t then return end
  if t:getPosition().z ~= posz() then return end

  if State.leaderWait >= now and State.lastTarget == t then return end
  State.lastTarget = t

  local msg = "ATACAR: " .. encodeTargetId(t:getId())

  if tostring(followCfg.selectChat or "Default") == "Party Channel" then
    sayChannel(1, msg)
  else
    say(msg)
  end

  State.leaderWait = now + 8000
end)

onTalk(function(name, level, mode, text, channelId, pos)
  if channelId ~= 1 then return end

  local leaderName = getAttackLeaderName():lower()
  if leaderName == "" then return end
  if name:lower() ~= leaderName then return end

  local id = decodeTargetId(text)
  if not id then return end

  local target = getCreatureById(id)
  if not target then return end
  if target:getPosition().z ~= posz() then return end
  if g_game.getAttackingCreature() == target then return end

  g_game.attack(target)
end)

-------------------------- CONTROL FOLLOW
local PANEL_NAME = "lnsFollow"
local FOLLOW_SWITCH_ID = "followButton"

local category = "lns"
local MW_RUNE_ID = 3180
local WG_RUNE_ID = 3156
local SD_RUNE_ID = 3155
local ATTACKBOT_SWITCH_ID = "comboButton"
local MINI_WINDOW_NAME = "ingameScriptWindow"
local HOLD_STORAGE_KEY = "lnsLeaderHoldMwWg"

local leaderCommandDelay = 200
local lastLeaderCommand = 0

pausandoCombo = 0

charStorage = charStorage or loadCharStorage()

local function saveLeaderControl()
  saveCharStorage(charStorage)
end

charStorage[PANEL_NAME] = charStorage[PANEL_NAME] or {
  texts = {},
  switches = {}
}

charStorage.follow2Panel = charStorage.follow2Panel or {
  leaderName = "",
  followerName = "",
  ueSpell = ""
}

charStorage[HOLD_STORAGE_KEY] = charStorage[HOLD_STORAGE_KEY] or {
  enabled = { mw = false, wg = false },
  marks = {}
}

charStorage[MINI_WINDOW_NAME] = charStorage[MINI_WINDOW_NAME] or {}
charStorage[ATTACKBOT_SWITCH_ID] = charStorage[ATTACKBOT_SWITCH_ID] or { enabled = false }
charStorage[FOLLOW_SWITCH_ID] = charStorage[FOLLOW_SWITCH_ID] or { enabled = false }

if modules.game_interface and modules.game_interface.removeMenuHook then
  modules.game_interface.removeMenuHook(category)
end

local function normalizeText(s)
  s = tostring(s or "")
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  return s
end

local function lowerText(s)
  return normalizeText(s):lower()
end

local function getPanelDb()
  charStorage[PANEL_NAME] = charStorage[PANEL_NAME] or {}
  charStorage[PANEL_NAME].texts = charStorage[PANEL_NAME].texts or {}
  charStorage[PANEL_NAME].switches = charStorage[PANEL_NAME].switches or {}
  return charStorage[PANEL_NAME]
end

local function getFollow2Db()
  charStorage.follow2Panel = charStorage.follow2Panel or {}
  return charStorage.follow2Panel
end

local function getLeaderNameFromFollow2()
  return lowerText(getFollow2Db().leaderName or "")
end

local function getUeSpellFromFollow2()
  return normalizeText(getFollow2Db().ueSpell or "")
end

local function findWidgetById(id)
  local root = g_ui and g_ui.getRootWidget and g_ui.getRootWidget()
  if not root or not root.recursiveGetChildById then return nil end
  return root:recursiveGetChildById(id)
end

local function getHookPos(pos, lookThing, useThing, creatureThing)
  if pos and pos.x and pos.y and pos.z then return pos end

  for _, thing in ipairs({lookThing, useThing, creatureThing}) do
    if thing and thing.getPosition then
      local p = thing:getPosition()
      if p and p.x and p.y and p.z then return p end
    end
  end

  return nil
end

local function parseCommandPos(text, prefix)
  local pattern = "^" .. prefix .. "%s*:%s*(%-?%d+)%s*,%s*(%-?%d+)%s*,%s*(%-?%d+)%s*$"
  local x, y, z = normalizeText(text):match(pattern)
  if not x then return nil end
  return {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
end

local function sayHookPos(prefix, pos, lookThing, useThing, creatureThing)
  local p = getHookPos(pos, lookThing, useThing, creatureThing)
  if not p then return end
  sayChannel(1, string.format("%s: %d,%d,%d", prefix, p.x, p.y, p.z))
end

local function safeUseWithItem(itemId, target)
  if not itemId or not target then return false end

  local item = findItem(itemId)
  if not item then return false end

  return useWith(item, target) and true or false
end

local function useRuneOnPos(itemId, pos)
  if not itemId or not pos then return false end

  local tile = g_map.getTile(pos)
  if not tile then return false end

  local topThing = tile:getTopUseThing()
  if not topThing then return false end

  return safeUseWithItem(itemId, topThing)
end

local function syncSwitchVisual(panelGlobal, switchId, state)
  if panelGlobal and panelGlobal.title and panelGlobal.title.setOn then
    panelGlobal.title:setOn(state)
    return
  end

  local panel = findWidgetById(switchId)
  if not panel then return end

  local title = panel.getChildById and panel:getChildById("title")
  if not title then return end

  title:setOn(state)
end

local function setAttackBotState(state)
  state = state == true

  charStorage[ATTACKBOT_SWITCH_ID] = charStorage[ATTACKBOT_SWITCH_ID] or {}
  charStorage[ATTACKBOT_SWITCH_ID].enabled = state
  saveLeaderControl()

  if comboButton and comboButton.title and comboButton.title.setOn then
    comboButton.title:setOn(state)
  else
    syncSwitchVisual(comboButton, ATTACKBOT_SWITCH_ID, state)
  end
end

local function setFollowState(state)
  state = state == true

  charStorage.follow2Panel = charStorage.follow2Panel or {}
  charStorage.follow2Panel.enabled = state

  charStorage[FOLLOW_SWITCH_ID] = charStorage[FOLLOW_SWITCH_ID] or {}
  charStorage[FOLLOW_SWITCH_ID].enabled = state

  if not state then
    g_game.cancelFollow()

    if g_game.cancelAttack then
      -- não cancela ataque, só follow
    end

    if player and player.stopAutoWalk then
      pcall(function() player:stopAutoWalk() end)
    end
  end

  if followButton and followButton.title and followButton.title.setOn then
    followButton.title:setOn(state)
  else
    syncSwitchVisual(followButton, FOLLOW_SWITCH_ID, state)
  end

  saveLeaderControl()
end

local function getHoldDb()
  charStorage[HOLD_STORAGE_KEY] = charStorage[HOLD_STORAGE_KEY] or {}
  charStorage[HOLD_STORAGE_KEY].enabled = charStorage[HOLD_STORAGE_KEY].enabled or { mw = false, wg = false }
  charStorage[HOLD_STORAGE_KEY].marks = charStorage[HOLD_STORAGE_KEY].marks or {}
  return charStorage[HOLD_STORAGE_KEY]
end

local function holdPosKey(pos)
  return string.format("%d,%d,%d", pos.x, pos.y, pos.z)
end

local function splitHoldPosKey(key)
  local x, y, z = tostring(key):match("^(%-?%d+),(%-?%d+),(%-?%d+)$")
  if not x then return nil end
  return {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
end

local function isHoldMwEnabled()
  return getHoldDb().enabled.mw == true
end

local function isHoldWgEnabled()
  return getHoldDb().enabled.wg == true
end

local function addHoldMark(pos, text)
  if not pos or not text then return end
  getHoldDb().marks[holdPosKey(pos)] = text
  saveLeaderControl()
end

local function clearHoldMarksByText(text)
  local db = getHoldDb()
  local keep = {}

  for key, value in pairs(db.marks or {}) do
    local pos = splitHoldPosKey(key)
    local tile = pos and g_map.getTile(pos)

    if value == text then
      if tile and tile.getText and tile:getText() == text then
        pcall(function()
          tile:setText("")
        end)
      end
    else
      keep[key] = value
    end
  end

  db.marks = keep
  charStorage[HOLD_STORAGE_KEY].marks = keep
  saveLeaderControl()
end

local function setHoldMwState(state)
  local db = getHoldDb()
  db.enabled.mw = state == true

  if db.enabled.mw ~= true then
    clearHoldMarksByText("HOLD MW")
    db = getHoldDb()
    db.enabled.mw = false
    db.marks = db.marks or {}
  end

  saveLeaderControl()
end

local function setHoldWgState(state)
  local db = getHoldDb()
  db.enabled.wg = state == true

  if db.enabled.wg ~= true then
    clearHoldMarksByText("HOLD WG")
    db = getHoldDb()
    db.enabled.wg = false
    db.marks = db.marks or {}
  end

  saveLeaderControl()
end

local function tileHasHoldField(tile)
  if not tile then return false end

  local items = tile:getItems()
  if not items then return false end

  for i = 1, #items do
    local item = items[i]
    if item and item.getId then
      local id = item:getId()
      if id == 2129 or id == 2130 then
        return true
      end
    end
  end

  return false
end

local function canUseHoldOnTile(tile)
  if not tile then return false end
  if isInPz() then return false end
  if not tile:canShoot() then return false end
  if not tile:isWalkable() then return false end

  local top = tile:getTopUseThing()
  if not top then return false end
  if top:getId() == 2130 then return false end

  local ppos = player and player:getPosition()
  local tpos = tile:getPosition()
  if not ppos or not tpos then return false end
  if ppos.z ~= tpos.z then return false end
  if math.abs(ppos.x - tpos.x) >= 8 or math.abs(ppos.y - tpos.y) >= 6 then return false end

  return true
end

local HOLD_CAST_COOLDOWN_MS = 200
local HOLD_TILE_COOLDOWN_MS = 200
local HOLD_FAIL_COOLDOWN_MS = 100
local HOLD_REMOVE_DEBOUNCE_MS = 170
local lastHoldCastAt = 0
local lastHoldCastByTile = {}

local function tryUseHold(tile, holdText)
  if not tile or not holdText then return false end

  local runeId = nil

  if holdText == "HOLD MW" then
    if not isHoldMwEnabled() then return false end
    runeId = MW_RUNE_ID
  elseif holdText == "HOLD WG" then
    if not isHoldWgEnabled() then return false end
    runeId = WG_RUNE_ID
  else
    return false
  end

  if tileHasHoldField(tile) then return false end
  if not canUseHoldOnTile(tile) then return false end
  if now - lastHoldCastAt < HOLD_CAST_COOLDOWN_MS then return false end

  local pos = tile:getPosition()
  local key = holdPosKey(pos)
  local lastTileCast = lastHoldCastByTile[key] or 0

  if lastTileCast > now then return false end
  if now - lastTileCast < HOLD_TILE_COOLDOWN_MS then return false end

  local used = safeUseWithItem(runeId, tile:getTopUseThing())
  lastHoldCastAt = now

  if used then
    lastHoldCastByTile[key] = now
    return true
  end

  lastHoldCastByTile[key] = now + HOLD_FAIL_COOLDOWN_MS
  return false
end

--==================================================
-- COMBO SIMPLES
-- pause runtime: pausandoCombo = now + 3000
--==================================================

local comboExecutando = false

local function setComboPause(ms)
  pausandoCombo = now + (ms or 3000)
end

local function clearComboPause()
  pausandoCombo = 0
end

local function triggerComboUE()
  if comboExecutando then return false end

  local ueSpell = getUeSpellFromFollow2()
  if ueSpell == "" then return false end

  comboExecutando = true
  setComboPause(3000)

  if type(startComboCountdown) == "function" then
    startComboCountdown("ue")
  end

  schedule(3000, function()
    local spell = getUeSpellFromFollow2()

    if spell ~= "" then
      say(spell)
    end

    schedule(300, function()
      comboExecutando = false
      clearComboPause()
    end)
  end)

  return true
end

local function triggerComboSD()
  if comboExecutando then return false end

  local currentTarget = g_game.getAttackingCreature()
  if not currentTarget then return false end
  if not findItem(SD_RUNE_ID) then return false end

  local targetId = currentTarget:getId()

  comboExecutando = true
  setComboPause(3000)

  if type(startComboCountdown) == "function" then
    startComboCountdown("sd")
  end

  schedule(3000, function()
    if not findItem(SD_RUNE_ID) then
      comboExecutando = false
      clearComboPause()
      return
    end

    local target = getCreatureById(targetId) or g_game.getAttackingCreature()
    if target then
      useWith(SD_RUNE_ID, target)
    end

    schedule(300, function()
      comboExecutando = false
      clearComboPause()
    end)
  end)

  return true
end

local function executeLeaderCommand(text)
  local msg = normalizeText(text)
  local msgLower = msg:lower()

  if msgLower == "set: attackbot [on]" then
    setAttackBotState(true)
    return true
  end

  if msgLower == "set: attackbot [off]" then
    setAttackBotState(false)
    return true
  end

  if msgLower == "set: follow [on]" then
    setFollowState(true)
    return true
  end

  if msgLower == "set: follow [off]" then
    setFollowState(false)
    return true
  end

  if msgLower == "set: targetbot [on]" then
    if TargetBot and TargetBot.setOn then TargetBot.setOn() end
    return true
  end

  if msgLower == "set: targetbot [off]" then
    if TargetBot and TargetBot.setOff then TargetBot.setOff() end
    return true
  end

  if msgLower == "set: cavebot [on]" then
    if CaveBot and CaveBot.setOn then CaveBot.setOn() end
    return true
  end

  if msgLower == "set: cavebot [off]" then
    if CaveBot and CaveBot.setOff then CaveBot.setOff() end
    return true
  end

  if msgLower == "set: combo ue [on]" then
    triggerComboUE()
    return true
  end

  if msgLower == "set: combo sd [on]" then
    triggerComboSD()
    return true
  end

  if msgLower == "set: stop attack" then
    g_game.cancelAttack()
    oldTarget = nil
    targetID = nil
    return true
  end

  if msgLower == "set: hold mw [on]" or msgLower == "hold mw on" then
    setHoldMwState(true)
    return true
  end

  if msgLower == "set: hold mw [off]" or msgLower == "hold mw off" then
    setHoldMwState(false)
    return true
  end

  if msgLower == "set: hold wg [on]" or msgLower == "hold wg on" then
    setHoldWgState(true)
    return true
  end

  if msgLower == "set: hold wg [off]" or msgLower == "hold wg off" then
    setHoldWgState(false)
    return true
  end

  local movePos = parseCommandPos(msg, "MOVE POS")
  if movePos then
    if movePos.z ~= posz() then return true end
    autoWalk(movePos, 100, {ignoreNonPathable = true, ignoreCreatures = true, precision = 1})
    return true
  end

  local mwPos = parseCommandPos(msg, "MW IN")
  if mwPos then
    useRuneOnPos(MW_RUNE_ID, mwPos)
    return true
  end

  local wgPos = parseCommandPos(msg, "WG IN")
  if wgPos then
    useRuneOnPos(WG_RUNE_ID, wgPos)
    return true
  end

  local travelCity = msg:match("Travel to:%s*(.+)")
  if travelCity then
    travelCity = normalizeText(travelCity)

    schedule(200, function()
      NPC.say("hi")
      schedule(200, function()
        NPC.say(travelCity)
        schedule(200, function()
          NPC.say("yes")
          schedule(200, function()
            NPC.say("yes")
          end)
        end)
      end)
    end)

    return true
  end

  return false
end

local hooks = {
  {label = "LNS | MC Use Here", prefix = "USE TO"},
  {label = "LNS | Move Pos", prefix = "MOVE POS"},
  {label = "LNS | MC Use MW", prefix = "MW IN"},
  {label = "LNS | MC Use WG", prefix = "WG IN"},
}

for i = 1, #hooks do
  local hook = hooks[i]
  modules.game_interface.addMenuHook(category, hook.label, function(pos, lookThing, useThing, creatureThing)
    sayHookPos(hook.prefix, pos, lookThing, useThing, creatureThing)
  end, function() return true end)
end

--==================================================
-- MC LÊ COMANDOS SOMENTE DO LEADER NAME DO FOLLOW 2.0
--==================================================

onTalk(function(name, level, mode, text, channelId, pos)
  if channelId ~= 1 then return end

  local leaderName = getLeaderNameFromFollow2()
  if leaderName == "" then return end
  if lowerText(name) ~= leaderName then return end

  if now < lastLeaderCommand then return end
  lastLeaderCommand = now + leaderCommandDelay

  executeLeaderCommand(text)
end)

onUseWith(function(pos, itemId, target)
  if not target or not target.getPosition then return end

  if itemId == MW_RUNE_ID then
    if not isHoldMwEnabled() then return end

    local tpos = target:getPosition()
    if not tpos then return end

    local tile = g_map.getTile(tpos)
    if not tile then return end

    tile:setText("HOLD MW")
    addHoldMark(tpos, "HOLD MW")
    return
  end

  if itemId == WG_RUNE_ID then
    if not isHoldWgEnabled() then return end

    local tpos = target:getPosition()
    if not tpos then return end

    local tile = g_map.getTile(tpos)
    if not tile then return end

    tile:setText("HOLD WG")
    addHoldMark(tpos, "HOLD WG")
    return
  end
end)

onRemoveThing(function(tile, thing)
  if not tile or not thing or not thing.getId then return end

  local id = thing:getId()
  if id ~= 2129 and id ~= 2130 then return end

  local txt = tile:getText()
  if txt ~= "HOLD MW" and txt ~= "HOLD WG" then return end

  local pos = tile:getPosition()
  if not pos then return end

  local key = holdPosKey(pos)
  local current = lastHoldCastByTile[key] or 0
  lastHoldCastByTile[key] = math.max(current, now + HOLD_REMOVE_DEBOUNCE_MS)
end)

macro(20, function()
  local db = getHoldDb()

  for key, holdText in pairs(db.marks or {}) do
    local enabled = false

    if holdText == "HOLD MW" then
      enabled = isHoldMwEnabled()
    elseif holdText == "HOLD WG" then
      enabled = isHoldWgEnabled()
    end

    if enabled then
      local pos = splitHoldPosKey(key)
      if pos then
        local tile = g_map.getTile(pos)
        if tile then
          if tile:getText() ~= holdText then
            tile:setText(holdText)
          end

          if tryUseHold(tile, holdText) then
            return
          end
        end
      end
    end
  end
end)

toolsScripts = setupUI([[
MiniWindow
  id: toolsScripts
  text: Leader Control
  height: 270
  width: 175
  icon: /images/topbuttons/combatcontrols
  icon-size: 15 15

  Panel
    id: panelScripts
    anchors.fill: parent
    margin-top: 20
    margin-left: 5
    margin-right: 5
    margin-bottom: 5
    layout:
      type: verticalBox
]], g_ui.getRootWidget())
toolsScripts:hide()

g_ui.loadUIFromString([[
LeaderRow < Panel
  height: 22
  margin-top: 2

  HorizontalSeparator
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.left: parent.left

  Label
    id: label
    anchors.left: parent.left
    anchors.top: prev.top
    margin-top: 5
    width: 110
    color: white
    font: verdana-11px-rounded
    text: Command

  Button
    id: onBtn
    anchors.right: offBtn.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 1
    width: 40
    height: 18
    font: verdana-11px-rounded
    text: ON
    color: #98FB98

  Button
    id: offBtn
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 40
    height: 18
    font: verdana-11px-rounded
    text: OFF
    color: #CD5C5C
]])

local saved = charStorage[MINI_WINDOW_NAME]
saved.minimized = saved.minimized == true

if saved.x and saved.y then
  toolsScripts:setX(saved.x)
  toolsScripts:setY(saved.y)
end

local normalHeight = tonumber(saved.normalHeight) or 270
local minimizedHeight = 25

local function setLeaderWindowMinimized(state)
  state = state == true

  saved.minimized = state
  saved.normalHeight = normalHeight

  if state then
    normalHeight = toolsScripts:getHeight() > minimizedHeight and toolsScripts:getHeight() or normalHeight
    saved.normalHeight = normalHeight
    toolsScripts.panelScripts:hide()
    toolsScripts:setHeight(minimizedHeight)
  else
    toolsScripts:setHeight(saved.normalHeight or 270)
    toolsScripts.panelScripts:show()
  end

  saveLeaderControl()
end

toolsScripts.onGeometryChange = function(widget, oldRect, newRect)
  if oldRect.width == 0 and oldRect.height == 0 then return end

  saved.x = widget:getX()
  saved.y = widget:getY()

  if not saved.minimized then
    normalHeight = widget:getHeight()
    saved.normalHeight = normalHeight
  end

  saveLeaderControl()
end

schedule(100, function()
  setLeaderWindowMinimized(saved.minimized)
end)

local scrollBar = toolsScripts:getChildById("miniwindowScrollBar")
if scrollBar then scrollBar:hide() end

toolsScripts.closeButton.onClick = function()
  toolsScripts:hide()
end

toolsScripts.minimizeButton:setMarginLeft(23)
toolsScripts.minimizeButton.onClick = function()
  setLeaderWindowMinimized(not saved.minimized)
end

toolsScripts.lockButton:hide()

local scriptsLeaderControl = toolsScripts.panelScripts

local controls = {
  {text = "AttackBot", on = "set: AttackBot [ON]", off = "set: AttackBot [OFF]"},
  {text = "Follow",    on = "set: Follow [ON]",    off = "set: Follow [OFF]"},
  {text = "TargetBot", on = "set: TargetBot [ON]", off = "set: TargetBot [OFF]"},
  {text = "CaveBot",   on = "set: CaveBot [ON]",   off = "set: CaveBot [OFF]"},
  {text = "Hold MW",   on = "set: Hold MW [ON]",   off = "set: Hold MW [OFF]"},
  {text = "Hold WG",   on = "set: Hold WG [ON]",   off = "set: Hold WG [OFF]"},
  -- {text = "No Escape", on = "set: No Escape [ON]", off = "set: No Escape [OFF]"},
}

for i = 1, #controls do
  local cfg = controls[i]
  local row = g_ui.createWidget("LeaderRow", scriptsLeaderControl)

  row.label:setText(cfg.text)

  row.onBtn.onClick = function()
    sayChannel(1, cfg.on)
  end

  row.offBtn.onClick = function()
    sayChannel(1, cfg.off)
  end
end

local comboCountdownWidget = nil
local comboCountdownRunning = false

local function getComboCountdownWidget()
  if comboCountdownWidget and not comboCountdownWidget:isDestroyed() then
    return comboCountdownWidget
  end

  local root = g_ui.getRootWidget()
  if not root then return nil end

  comboCountdownWidget = g_ui.loadUIFromString([[
Panel
  id: comboCountdownWidget
  size: 90 21
  anchors.centerIn: parent
  margin-top: -180
  margin-left: -17

  Label
    id: text
    anchors.fill: parent
    text-align: center
    font: verdana-11px-rounded
    color: #EEC900
    text: COMBO
]], root)

  return comboCountdownWidget
end

local function showComboCountdownText(text, color)
  local widget = getComboCountdownWidget()
  if not widget then return end

  local label = widget:getChildById("text")
  if not label then return end

  label:setText(text)

  if color then
    label:setColor(color)
  end

  widget:show()
  widget:raise()
end

function startComboCountdown(kind)
  if comboCountdownRunning then return end
  comboCountdownRunning = true

  local prefix = kind == "sd" and "EXEC SD: " or "EXEC UE: "
  local lastText = kind == "sd" and "SD!!!" or "BUUUM!!!"
  local color = kind == "sd" and "#AAAAAA" or "#EEC900"
  local finalColor = kind == "sd" and "white" or "red"

  showComboCountdownText(prefix .. "3", color)

  schedule(1000, function()
    showComboCountdownText(prefix .. "2", color)

    schedule(1000, function()
      showComboCountdownText(prefix .. "1", color)

      schedule(1000, function()
        showComboCountdownText(lastText, finalColor)

        schedule(1200, function()
          if comboCountdownWidget and not comboCountdownWidget:isDestroyed() then
            comboCountdownWidget:hide()
          end
          comboCountdownRunning = false
        end)
      end)
    end)
  end)
end

local butSD = g_ui.createWidget("Button", scriptsLeaderControl)
butSD:setText("Combo SD")
butSD:setMarginTop(3)
butSD.onClick = function()
  sayChannel(1, "set: Combo SD [ON]")
  startComboCountdown("sd")
end
butSD:setHeight(22)
butSD:setFont("verdana-11px-rounded")
butSD:setColor("#696969")

local butUE = g_ui.createWidget("Button", scriptsLeaderControl)
butUE:setText("Combo UE")
butUE.onClick = function()
  sayChannel(1, "set: Combo UE [ON]")
  startComboCountdown("ue")
end
butUE:setHeight(22)
butUE:setMarginTop(1)
butUE:setFont("verdana-11px-rounded")
butUE:setColor("#EEC900")

local butCancelAtk = g_ui.createWidget("Button", scriptsLeaderControl)
butCancelAtk:setText("Stop Attack")
butCancelAtk.onClick = function()
  sayChannel(1, "set: Stop Attack")
end
butCancelAtk:setHeight(22)
butCancelAtk:setMarginTop(1)
butCancelAtk:setFont("verdana-11px-rounded")
butCancelAtk:setColor("white")

------------------------------- EQ MANAGER
if not loadCharStorage or not saveCharStorage then
  return print("[Eq Manager] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function saveEqManagerChar()
  saveCharStorage(charStorage)
end

UI.Separator()

local switchEqManager = "eqManagerButton"
charStorage[switchEqManager] = charStorage[switchEqManager] or { enabled = false }

eqManagerButton = setupUI([[
Panel
  height: 19
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: EQ Manager
    height: 18
    color: white
  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Config
    opacity: 1.00
    color: white
]])
eqManagerButton:setId(switchEqManager)
eqManagerButton.title:setOn(charStorage[switchEqManager].enabled)
eqManagerButton.title.onClick = function(widget)
  local state = not widget:isOn()
  widget:setOn(state)
  charStorage[switchEqManager].enabled = state
  saveEqManagerChar()
end

equipInterface = setupUI([=[
EQPanel < Panel
  size: 160 230
  padding-left: 10
  padding-right: 10
  padding-bottom: 10

  BotItem
    id: head
    image-source: /images/game/slots/head
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    margin-top: 10
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: body
    image-source: /images/game/slots/body
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: legs
    image-source: /images/game/slots/legs
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: feet
    image-source: /images/game/slots/feet
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: neck
    image-source: /images/game/slots/neck
    anchors.top: head.top
    margin-top: 13
    anchors.right: head.left
    margin-right: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: left-hand
    image-source: /images/game/slots/left-hand
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: finger
    image-source: /images/game/slots/finger
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: right-hand
    image-source: /images/game/slots/right-hand
    anchors.left: body.right
    margin-left: 5
    anchors.top: left-hand.top
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: ammo
    image-source: /images/game/slots/ammo
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

MainWindow
  id: mainPanel
  size: 453 420
  text: Panel EQ Manager
  margin-top: -50

  Panel
    id: infolist1
    anchors.top: parent.top
    anchors.left: parent.left
    size: 190 225
    image-source: /images/ui/miniwindow
    image-border: 23
    margin-left: -4
    margin-right: -4

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Settings EQ
      margin-top: 2

  EQPanel
    id: eqConfig
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 50
    margin-bottom: 30
    anchors.bottom: prev.bottom

  TextEdit
    id: nameConfig
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: -25
    margin-left: 6
    margin-right: 6
    placeholder: Profile Name

  Button
    id: cloneEq
    anchors.top: prev.bottom
    anchors.right: prev.right
    size: 35 18
    text: Clone
    margin-top: 2
    tooltip: Clone Current Equipments

  Panel
    id: panelRules
    anchors.top: infolist1.top
    anchors.left: infolist1.right
    margin-right: -8
    size: 230 225
    image-source: /images/ui/miniwindow
    image-border: 23
    margin-left: 10

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Rules to Equip
      margin-top: 2

    CheckBox
      id: hppercent
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 10
      margin-left: 10
      text: HP% below:
      $checked:
        color: #3CB371
        image-color: #3CB371
        
    SpinBox
      id: qtdHppercent
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-left: 15
      margin-right: 6
      size: 80 18
      minimum: 1
      maximum: 100
      text-align: center

    CheckBox
      id: mppercent
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 5
      margin-left: 10
      text: MP% below:
      $checked:
        color: #3CB371
        image-color: #3CB371

    SpinBox
      id: qtdMppercent
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-left: 15
      margin-right: 6
      size: 80 18
      minimum: 1
      maximum: 100
      text-align: center

    CheckBox
      id: safe
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 5
      margin-left: 10
      text: Safe (Anti-red)
      $checked:
        color: #3CB371
        image-color: #3CB371

    CheckBox
      id: targetisPlayer
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 8
      margin-left: 10
      text: Target is Player
      $checked:
        color: #3CB371
        image-color: #3CB371

    CheckBox
      id: creatures
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 8
      margin-left: 10
      text: Amount Creatures:
      $checked:
        color: #3CB371
        image-color: #3CB371

    SpinBox
      id: qtdCreatures
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-left: 15
      margin-right: 6
      size: 80 18
      minimum: 1
      maximum: 10
      text-align: center

    CheckBox
      id: noTarget
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 5
      margin-left: 10
      text: No Combat
      $checked:
        color: #3CB371
        image-color: #3CB371

    CheckBox
      id: nameCreature
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 9
      margin-left: 10
      text: Target Name
      $checked:
        color: #3CB371
        image-color: #3CB371

    Button
      id: listNameCreature
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-left: 15
      margin-right: 6
      size: 80 18
      text: List

    CheckBox
      id: distance
      anchors.top: prev.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-top: 6
      margin-left: 10
      text: Distance:
      $checked:
        color: #3CB371
        image-color: #3CB371

    SpinBox
      id: distsqm
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: parent.right
      margin-left: 15
      margin-right: 6
      size: 80 18
      minimum: 1
      maximum: 100
      text-align: center

    CheckBox
      id: setPrincipal
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      text-auto-resize: true
      margin-left: 10
      text: Default Set
      margin-bottom: 10
      $checked:
        color: #3CB371
        image-color: #3CB371

  Panel
    id: flatp
    anchors.top: eqConfig.bottom
    anchors.left: eqConfig.left
    anchors.right: panelRules.right
    anchors.bottom: parent.bottom
    image-source: /images/ui/miniwindow
    image-border: 23
    margin-top: 35
    margin-left: 1
    margin-right: 60

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: List Equipment Manager
      margin-top: 2

  TextList
    id: listSettingsEQ
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.bottom: prev.bottom
    margin: 5
    margin-top: 20
    margin-right: 17
    height: 120
    opacity: 0.95
    vertical-scrollbar: panelEQListScroll

  VerticalScrollBar
    id: panelEQListScroll
    anchors.top: listSettingsEQ.top
    anchors.bottom: listSettingsEQ.bottom
    anchors.left: listSettingsEQ.right
    width: 13
    step: 18
    pixels-scroll: true

  Button
    id: adicionar
    anchors.top: flatp.top
    anchors.left: flatp.right
    anchors.right: parent.right
    margin-right: -4
    margin-left: 5
    height: 73
    text: Add Settings
    text-wrap: true

  Button
    id: closePanel
    anchors.top: prev.bottom
    anchors.left: flatp.right
    anchors.right: parent.right
    margin-right: -4
    margin-left: 5
    height: 73
    margin-top: 4
    text: Close


]=], g_ui.getRootWidget())
equipInterface:hide()

if modules._G.g_app.isMobile() then
  equipInterface:setSize("453 440")
end

equipInterface.closePanel.onClick = function()
  equipInterface:hide()
end
eqManagerButton.settings.onClick = function()
  equipInterface:show()
end

local function W(parent, id)
  if not parent then return nil end
  return (parent.getChildById and parent:getChildById(id)) or
         (parent.recursiveGetChildById and parent:recursiveGetChildById(id))
end

local function trim(s)
  return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function clearChildren(w)
  if not w then return end
  local ch = w:getChildren()
  for i = #ch, 1, -1 do
    ch[i]:destroy()
  end
end

local SLOTS = { "head","neck","body","left-hand","right-hand","legs","feet","finger","ammo" }

charStorage.eqManagerProfiles = charStorage.eqManagerProfiles or {}
local eqProfiles = charStorage.eqManagerProfiles
local editingEqIndex = nil

local targetListPanelName = "eqManagerTargetNames"
charStorage[targetListPanelName] = charStorage[targetListPanelName] or { names = {} }

local eqRowTemplate = [[
UIWidget
  height: 24
  focusable: true
  draggable: true
  background-color: alpha
  border: 1 alpha
  opacity: 1.00
  margin-top: 0
  $hover:
    background-color: #2a2a2a
    border: 1 #3a3a3a
  $focus:
    background-color: #2a2a2a
    border: 1 #3a3a3a

  BotSwitch
    id: enabled
    anchors.left: parent.left
    margin-top: 0
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    width: 20
    height: 20
    text: ""
    image-source: /images/ui/button_rounded

  Label
    id: profileName
    anchors.left: enabled.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    text-auto-resize: true
    color: orange
    text: ""
    font: verdana-11px-rounded

  Panel
    id: itemsPanel
    anchors.left: profileName.right
    anchors.right: remove.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    margin-left: 4
    margin-top: -5
    margin-right: 4

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 20
    height: 20
    margin-right: 4
    text: X
    font: verdana-11px-rounded
    color: white
    $hover:
      image-color: red
      color: #ffd0d0
]]

local targetNameRowTemplate = [[
UIWidget
  height: 18
  focusable: true
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #2F2F2F
    opacity: 0.75

  $focus:
    background-color: #404040
    opacity: 0.90

  Label
    id: creatureName
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    font: verdana-11px-rounded
    color: white
    text: ""

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 2
    text: X
    color: #FF4040
    image-source: /images/ui/button_rounded
    image-color: #363636
]]

targetNameListWindow = setupUI([[
MainWindow
  id: mainPanel
  size: 250 315
  text: Target Name List
  anchors.centerIn: parent
  margin-top: -50

  Panel
    id: panelList
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 225
    margin: -6
    margin-bottom: 3
    margin-top: 1
    image-source: /images/ui/miniwindow
    image-border: 20

  TextList
    id: nameList
    anchors.top: panelList.top
    anchors.left: panelList.left
    anchors.right: panelList.right
    anchors.bottom: panelList.bottom
    margin-top: 21
    margin-left: 5
    margin-right: 17
    margin-bottom: 5
    vertical-scrollbar: nameListScroll

  VerticalScrollBar
    id: nameListScroll
    anchors.top: nameList.top
    anchors.bottom: nameList.bottom
    anchors.left: nameList.right
    width: 13
    step: 18
    pixels-scroll: true

  TextEdit
    id: inputName
    anchors.left: panelList.left
    anchors.right: addName.left
    anchors.bottom: closePanel.top
    margin-right: 3
    margin-bottom: 4
    height: 20
    placeholder: Creature name

  Button
    id: addName
    anchors.right: panelList.right
    anchors.bottom: closePanel.top
    margin-bottom: 4
    size: 35 20
    text: +

  Button
    id: closePanel
    anchors.left: panelList.left
    anchors.right: panelList.right
    anchors.bottom: parent.bottom
    height: 22
    text: Close
]], g_ui.getRootWidget())
targetNameListWindow:hide()

local function copyList(t)
  local out = {}
  for i, v in ipairs(t or {}) do out[i] = v end
  return out
end

local function getItemId(widget)
  if not widget then return 0 end
  if widget.getItemId then
    local ok, id = pcall(function() return widget:getItemId() end)
    if ok and id and id > 0 then return id end
  end
  if widget.getItem then
    local ok, item = pcall(function() return widget:getItem() end)
    if ok and item and item.getId then
      local ok2, id = pcall(function() return item:getId() end)
      if ok2 and id and id > 0 then return id end
    end
  end
  return 0
end

local function setBotItem(widget, itemId)
  itemId = tonumber(itemId) or 0
  if not widget then return end

  if widget.setItemId then
    widget:setItemId(itemId)
  elseif widget.setItem and Item and Item.create then
    if itemId > 0 then
      widget:setItem(Item.create(itemId, 1))
    else
      pcall(function() widget:setItem(nil) end)
    end
  end

  if widget.setOn then
    widget:setOn(itemId > 0)
  end
end

local function bindBotItemVisual(widget)
  if not widget then return end

  local old = widget.onItemChange
  widget.onItemChange = function(self, ...)
    if self and self.setOn then
      self:setOn(getItemId(self) > 0)
    end
    if old then old(self, ...) end
  end

  if widget.setOn then
    widget:setOn(getItemId(widget) > 0)
  end
end

local function bindEqPanelVisuals()
  local eqConfig = W(equipInterface, "eqConfig")
  if not eqConfig then return end
  for _, slot in ipairs(SLOTS) do
    local w = W(eqConfig, slot)
    if w then bindBotItemVisual(w) end
  end
end

local function normalizeTargetName(name)
  return trim(name):lower()
end

local function targetNameExists(name)
  local n = normalizeTargetName(name)
  for _, v in ipairs(charStorage[targetListPanelName].names or {}) do
    if normalizeTargetName(v) == n then
      return true
    end
  end
  return false
end

local function removeTargetName(name)
  local n = normalizeTargetName(name)
  local newList = {}
  for _, v in ipairs(charStorage[targetListPanelName].names or {}) do
    if normalizeTargetName(v) ~= n then
      table.insert(newList, v)
    end
  end
  charStorage[targetListPanelName].names = newList
  saveEqManagerChar()
end

local function refreshTargetNameList()
  local list = W(targetNameListWindow, "nameList")
  if not list then return end
  clearChildren(list)

  for _, name in ipairs(charStorage[targetListPanelName].names or {}) do
    local row = setupUI(targetNameRowTemplate, list)
    row.creatureName:setText(name)
    row.remove.onClick = function()
      removeTargetName(name)
      refreshTargetNameList()
    end
  end
end

local function addTargetNameFromInput()
  local input = W(targetNameListWindow, "inputName")
  if not input then return end

  local name = trim(input:getText())
  if name == "" then return end
  if targetNameExists(name) then
    input:setText("")
    return
  end

  table.insert(charStorage[targetListPanelName].names, name)
  saveEqManagerChar()
  input:setText("")
  refreshTargetNameList()
end

local function collectItems()
  local eqConfig = W(equipInterface, "eqConfig")
  local items = {}
  local hasAny = false

  if not eqConfig then return items, false end

  for _, slot in ipairs(SLOTS) do
    local id = getItemId(W(eqConfig, slot))
    if id > 0 then
      items[slot] = id
      hasAny = true
    end
  end

  return items, hasAny
end

local function applyItems(items)
  local eqConfig = W(equipInterface, "eqConfig")
  if not eqConfig then return end

  items = items or {}
  for _, slot in ipairs(SLOTS) do
    setBotItem(W(eqConfig, slot), tonumber(items[slot]) or 0)
  end
end

local function collectRules()
  local function checked(id)
    local w = W(equipInterface, id)
    return w and w:isChecked() or false
  end

  local function spin(id, def)
    local w = W(equipInterface, id)
    return w and w:getValue() or def
  end

  return {
    hppercent = checked("hppercent"),
    qtdHppercent = spin("qtdHppercent", 1),
    mppercent = checked("mppercent"),
    qtdMppercent = spin("qtdMppercent", 1),
    safe = checked("safe"),
    targetisPlayer = checked("targetisPlayer"),
    creatures = checked("creatures"),
    qtdCreatures = spin("qtdCreatures", 1),
    noTarget = checked("noTarget"),
    nameCreature = checked("nameCreature"),
    distance = checked("distance"),
    distsqm = spin("distsqm", 1),
    setPrincipal = checked("setPrincipal"),
    targetNames = copyList(charStorage[targetListPanelName].names or {})
  }
end

local function applyRules(rules)
  rules = rules or {}

  local function setCheck(id, val)
    local w = W(equipInterface, id)
    if w then w:setChecked(val == true) end
  end

  local function setSpin(id, val)
    local w = W(equipInterface, id)
    if w then w:setValue(tonumber(val) or 1) end
  end

  setCheck("hppercent", rules.hppercent)
  setSpin("qtdHppercent", rules.qtdHppercent)
  setCheck("mppercent", rules.mppercent)
  setCheck("safe", rules.safe)
  setSpin("qtdMppercent", rules.qtdMppercent)
  setCheck("targetisPlayer", rules.targetisPlayer)
  setCheck("creatures", rules.creatures)
  setSpin("qtdCreatures", rules.qtdCreatures)
  setCheck("noTarget", rules.noTarget)
  setCheck("nameCreature", rules.nameCreature)
  setCheck("distance", rules.distance)
  setSpin("distsqm", rules.distsqm)
  setCheck("setPrincipal", rules.setPrincipal)

  charStorage[targetListPanelName].names = copyList(rules.targetNames or {})
  refreshTargetNameList()
  saveEqManagerChar()
end

local function resetForm()
  local nameConfig = W(equipInterface, "nameConfig")
  if nameConfig then nameConfig:setText("") end

  applyItems({})
  applyRules({
    hppercent=false, qtdHppercent=1,
    mppercent=false, qtdMppercent=1,
    targetisPlayer=false,
    creatures=false, qtdCreatures=1,
    noTarget=false,
    nameCreature=false,
    distance=false, distsqm=1,
    setPrincipal=false,
    targetNames={}
  })

  editingEqIndex = nil
  local addButton = W(equipInterface, "adicionar")
  if addButton then
    addButton:setText("Add\nSettings")
  end
end

local function findProfileByName(name, ignoreIndex)
  name = trim(name):lower()
  if name == "" then return nil end

  for i, profile in ipairs(eqProfiles) do
    if i ~= ignoreIndex and trim(profile.name):lower() == name then
      return i
    end
  end
  return nil
end

local function getRowName(profile)
  return (trim(profile.name) ~= "" and profile.name or "Profile") .. ":"
end

local function orderedItemIds(items)
  local out = {}
  items = items or {}
  for _, slot in ipairs(SLOTS) do
    local id = tonumber(items[slot]) or 0
    if id > 0 then table.insert(out, id) end
  end
  return out
end

local function setupEqDragAndDrop(row)
  row.onDragEnter = function(self, mousePos)
    self:setOpacity(0.4)
    return true
  end

  row.onDragLeave = function(self, droppedWidget, mousePos)
    self:setOpacity(1.0)
  end

  row.onDrop = function(self, droppedWidget, mousePos)
    self:setOpacity(1.0)
    if droppedWidget and droppedWidget.setOpacity then
      droppedWidget:setOpacity(1.0)
    end

    local parent = self:getParent()
    if not parent then return true end

    local children = parent:getChildren()
    local fromIndex, toIndex = 0, 0

    for i, child in ipairs(children) do
      if child == droppedWidget then fromIndex = i end
      if child == self then toIndex = i end
    end

    if fromIndex > 0 and toIndex > 0 and fromIndex ~= toIndex then
      local moved = table.remove(eqProfiles, fromIndex)
      table.insert(eqProfiles, toIndex, moved)

      if editingEqIndex then
        if editingEqIndex == fromIndex then
          editingEqIndex = toIndex
        elseif fromIndex < editingEqIndex and toIndex >= editingEqIndex then
          editingEqIndex = editingEqIndex - 1
        elseif fromIndex > editingEqIndex and toIndex <= editingEqIndex then
          editingEqIndex = editingEqIndex + 1
        end
      end

      saveEqManagerChar()
      rebuildEqManagerList()
    end

    return true
  end
end

local function getEquippedSlotItemId(slotConst)
  local item = getSlot(slotConst)
  return item and item:getId() or 0
end

local function cloneCurrentEquip()
  local eqConfig = W(equipInterface, "eqConfig")
  if not eqConfig then return end

  setBotItem(W(eqConfig, "head"), getEquippedSlotItemId(SlotHead))
  setBotItem(W(eqConfig, "body"), getEquippedSlotItemId(SlotBody))
  setBotItem(W(eqConfig, "legs"), getEquippedSlotItemId(SlotLeg))
  setBotItem(W(eqConfig, "feet"), getEquippedSlotItemId(SlotFeet))
  setBotItem(W(eqConfig, "neck"), getEquippedSlotItemId(SlotNeck))
  setBotItem(W(eqConfig, "left-hand"), getEquippedSlotItemId(SlotLeft))
  setBotItem(W(eqConfig, "right-hand"), getEquippedSlotItemId(SlotRight))
  setBotItem(W(eqConfig, "finger"), getEquippedSlotItemId(SlotFinger))
  setBotItem(W(eqConfig, "ammo"), getEquippedSlotItemId(SlotAmmo))
end

function rebuildEqManagerList()
  local list = W(equipInterface, "listSettingsEQ")
  if not list then return end

  clearChildren(list)

  for index, profile in ipairs(eqProfiles) do
    local row = setupUI(eqRowTemplate, list)
    setupEqDragAndDrop(row)

    row.enabled:setOn(profile.enabled ~= false)
    row.enabled.onClick = function(widget)
      local state = not widget:isOn()
      widget:setOn(state)
      if eqProfiles[index] then
        eqProfiles[index].enabled = state
        saveEqManagerChar()
      end
    end

    row.profileName:setText(getRowName(profile))
    row.profileName:setColor(profile.rules and profile.rules.setPrincipal and "#00FF66" or "orange")

    local items = orderedItemIds(profile.items)
    for i, itemId in ipairs(items) do
      local item = setupUI(string.format([[
UIItem
  id: item%d
  size: 20 20
  focusable: false
  phantom: true
  anchors.left: parent.left
  anchors.top: parent.top
  margin-left: %d
  margin-top: 9
]], i, (i - 1) * 22), row.itemsPanel)
      setBotItem(item, itemId)
    end

    row.remove.onClick = function()
      table.remove(eqProfiles, index)
      if editingEqIndex == index then
        resetForm()
      elseif editingEqIndex and editingEqIndex > index then
        editingEqIndex = editingEqIndex - 1
      end
      saveEqManagerChar()
      rebuildEqManagerList()
    end

    row.onDoubleClick = function()
      local nameConfig = W(equipInterface, "nameConfig")
      if nameConfig then nameConfig:setText(profile.name or "") end
      applyItems(profile.items)
      applyRules(profile.rules)
      editingEqIndex = index
    
    local addButton = W(equipInterface, "adicionar")
      if addButton then
        addButton:setText("Add\nSettings")
      end
    end
  end
end

local function saveProfile()
  local nameConfig = W(equipInterface, "nameConfig")
  local profileName = trim(nameConfig and nameConfig:getText() or "")

  if profileName == "" then
    profileName = "Profile " .. tostring(editingEqIndex or (#eqProfiles + 1))
  end

  if findProfileByName(profileName, editingEqIndex) then
    return warn("Já existe um profile com esse nome.")
  end

  local items, hasAny = collectItems()
  if not hasAny then
    return warn("Selecione pelo menos 1 item no Settings EQ.")
  end

  local rules = collectRules()

  if #eqProfiles == 0 and editingEqIndex == nil and not rules.setPrincipal then
    return warn("Configure primeiro um Default Set.")
  end

  if rules.setPrincipal then
    for i = 1, #eqProfiles do
      eqProfiles[i].rules = eqProfiles[i].rules or {}
      eqProfiles[i].rules.setPrincipal = false
    end
  end

  local oldEnabled = true
  if editingEqIndex and eqProfiles[editingEqIndex] then
    oldEnabled = eqProfiles[editingEqIndex].enabled ~= false
  end

  local data = {
    enabled = oldEnabled,
    name = profileName,
    items = items,
    rules = rules
  }

  if editingEqIndex and eqProfiles[editingEqIndex] then
    eqProfiles[editingEqIndex].enabled = data.enabled
    eqProfiles[editingEqIndex].name = data.name
    eqProfiles[editingEqIndex].items = data.items
    eqProfiles[editingEqIndex].rules = data.rules
  else
    table.insert(eqProfiles, data)
  end

  charStorage.eqManagerProfiles = eqProfiles
  saveEqManagerChar()

  rebuildEqManagerList()
  resetForm()
end

local addButton = W(equipInterface, "adicionar")
if addButton then
  addButton.onClick = saveProfile
end

local cloneButton = W(equipInterface, "cloneEq")
if cloneButton then
  cloneButton.onClick = function()
    cloneCurrentEquip()
  end
end

local listNameCreatureButton = W(equipInterface, "listNameCreature")
if listNameCreatureButton then
  listNameCreatureButton.onClick = function()
    refreshTargetNameList()
    targetNameListWindow:show()
    targetNameListWindow:raise()
    targetNameListWindow:focus()
  end
end

targetNameListWindow.addName.onClick = function()
  addTargetNameFromInput()
end

targetNameListWindow.closePanel.onClick = function()
  targetNameListWindow:hide()
end

targetNameListWindow.inputName.onKeyPress = function(widget, keyCode)
  if keyCode == KeyEnter or keyCode == KeyReturn then
    addTargetNameFromInput()
    return true
  end
  return false
end

bindEqPanelVisuals()
refreshTargetNameList()
rebuildEqManagerList()

-----------------------------
local EQM_SLOT_CONST = {
  ["head"] = SlotHead,
  ["neck"] = SlotNeck,
  ["body"] = SlotBody,
  ["left-hand"] = SlotLeft,
  ["right-hand"] = SlotRight,
  ["legs"] = SlotLeg,
  ["feet"] = SlotFeet,
  ["finger"] = SlotFinger,
  ["ammo"] = SlotAmmo
}

local EQM_EQUIP_ORDER = {
  "neck", "head", "body", "legs", "feet", "right-hand", "left-hand", "finger", "ammo"
}

local EQM_IS_OLD_CLIENT = g_game.getClientVersion() < 960
local EQM_ACTION_DELAY = EQM_IS_OLD_CLIENT and 250 or 0
local eqmNextAction = 0

local function eqm_now()
  if g_clock and type(g_clock.millis) == "function" then return g_clock.millis() end
  if now then return now end
  return 0
end

local function eqm_getSlotItem(slotConst)
  return getSlot(slotConst)
end

local function eqm_getSlotId(slotConst)
  local it = eqm_getSlotItem(slotConst)
  return it and it:getId() or 0
end

local function eqm_getContainersSafe()
  if type(getContainers) == "function" then
    return getContainers() or {}
  end
  if g_game and type(g_game.getContainers) == "function" then
    return g_game.getContainers() or {}
  end
  return {}
end

local function eqm_findVisibleItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  if type(findItem) == "function" then
    local it = findItem(id)
    if it then return it end
  end

  for _, cont in pairs(eqm_getContainersSafe()) do
    for _, it in ipairs(cont:getItems() or {}) do
      if it and it.getId and tonumber(it:getId()) == id then
        return it
      end
    end
  end

  return nil
end

local function eqm_unequipSlot(slotConst)
  local item = eqm_getSlotItem(slotConst)
  if not item then return false end

  if EQM_IS_OLD_CLIENT then
    if moveToSlot then
      local ok = pcall(function()
        moveToSlot(item, SlotBack, item:getCount())
      end)
      if ok then return true end
    end
  end

  local ok = pcall(function()
    g_game.equipItemId(item:getId())
  end)
  return ok
end

local function eqm_equipToSlot(id, slotConst)
  id = tonumber(id) or 0
  if id <= 0 then return false end

  if not EQM_IS_OLD_CLIENT then
    local ok = pcall(function()
      g_game.equipItemId(id, slotConst)
    end)
    if ok then return true end

    ok = pcall(function()
      g_game.equipItemId(id)
    end)
    return ok
  end

  local it = eqm_findVisibleItemById(id)
  if not it then return false end

  local ok = pcall(function()
    g_game.move(it, {x = 65535, y = slotConst, z = 0}, 1)
  end)
  return ok
end

local function eqm_isPlayer(creature)
  return creature and creature.isPlayer and creature:isPlayer() or false
end

local function eqm_isMonster(creature)
  return creature and creature.isMonster and creature:isMonster() or false
end

local function eqm_localPlayer()
  return g_game.getLocalPlayer and g_game.getLocalPlayer() or nil
end

local function eqm_getTarget()
  return g_game.getAttackingCreature and g_game.getAttackingCreature() or nil
end

local function eqm_hasTarget()
  return eqm_getTarget() ~= nil
end

local function eqm_nameInList(name, list)
  local n = trim(name):lower()
  if n == "" then return false end

  for _, v in ipairs(list or {}) do
    if trim(v):lower() == n then
      return true
    end
  end

  return false
end

local function eqm_countCreatures()
  local me = pos()
  if not me then return 0 end

  local count = 0
  for _, spec in ipairs(getSpectators() or {}) do
    if eqm_isMonster(spec) then
      local sPos = spec:getPosition()
      if sPos and sPos.z == me.z then
        count = count + 1
      end
    end
  end
  return count
end

local function eqm_isCreatureAttackingMe(creature, me)
  if not creature or not me or creature == me then return false end

  if creature.getTarget then
    local ok, t = pcall(function() return creature:getTarget() end)
    if ok and t then
      if type(t) == "number" and me.getId and t == me:getId() then
        return true
      end
      if t == me then
        return true
      end
    end
  end

  return false
end

local function eqm_ruleMatches(profile)
  if not profile or profile.enabled == false then return false end
  local rules = profile.rules or {}

  if rules.hppercent and hppercent() > (tonumber(rules.qtdHppercent) or 1) then
    return false
  end

  if rules.mppercent and manapercent() > (tonumber(rules.qtdMppercent) or 1) then
    return false
  end

  if rules.targetisPlayer then
    local target = eqm_getTarget()
    if not eqm_isPlayer(target) then
      return false
    end
  end

  if rules.creatures and eqm_countCreatures() < (tonumber(rules.qtdCreatures) or 1) then
    return false
  end

  if rules.noTarget and eqm_hasTarget() then
    return false
  end

  if rules.nameCreature then
    local target = eqm_getTarget()
    local targetName = target and target:getName() or ""
    if targetName == "" then
      return false
    end
    if not eqm_nameInList(targetName, rules.targetNames or {}) then
      return false
    end
  end

  if rules.safe then
    if type(LNS_HAS_UNSAFE_CONDITION) == "function" then
      if LNS_HAS_UNSAFE_CONDITION() then
        return false
      end
    end
  end

  if rules.distance then
    local target = eqm_getTarget()
    if not target then
      return false
    end

    local tPos = target:getPosition()
    local pPos = pos()

    if not tPos or not pPos or tPos.z ~= pPos.z then
      return false
    end

    local dist = math.max(math.abs(tPos.x - pPos.x), math.abs(tPos.y - pPos.y))
    local maxDist = tonumber(rules.distsqm) or 1

    if dist > maxDist then
      return false
    end
  end

  return true
end

local function eqm_getDefaultProfile()
  for _, profile in ipairs(eqProfiles or {}) do
    if profile.enabled ~= false and profile.rules and profile.rules.setPrincipal then
      return profile
    end
  end
  return nil
end

local function eqm_buildResolvedItems(activeProfile)
  local resolved = {}
  local defaultProfile = eqm_getDefaultProfile()

  if defaultProfile and type(defaultProfile.items) == "table" then
    for _, slot in ipairs(EQM_EQUIP_ORDER) do
      local v = tonumber(defaultProfile.items[slot]) or 0
      if v > 0 then
        resolved[slot] = v
      end
    end
  end

  if activeProfile and type(activeProfile.items) == "table" then
    for _, slot in ipairs(EQM_EQUIP_ORDER) do
      local v = tonumber(activeProfile.items[slot]) or 0
      if v > 0 then
        resolved[slot] = v
      end
    end
  end

  return resolved
end

local function eqm_getMatchedProfileAndItems()
  for _, profile in ipairs(eqProfiles or {}) do
    if profile.enabled ~= false and not (profile.rules and profile.rules.setPrincipal) then
      if eqm_ruleMatches(profile) then
        return profile, eqm_buildResolvedItems(profile)
      end
    end
  end

  local defaultProfile = eqm_getDefaultProfile()
  if defaultProfile then
    return defaultProfile, eqm_buildResolvedItems(defaultProfile)
  end

  return nil, nil
end

local function eqm_prepareHands(resolvedItems)
  local wantLeft = tonumber(resolvedItems["left-hand"]) or 0
  local wantRight = tonumber(resolvedItems["right-hand"]) or 0

  -- slot nao configurado = NAO MEXE
  if wantLeft <= 0 and wantRight <= 0 then
    return false
  end

  local curLeft = eqm_getSlotId(SlotLeft)
  local curRight = eqm_getSlotId(SlotRight)

  -- se só configurou left-hand, não limpa right-hand
  if wantLeft > 0 and curLeft ~= wantLeft then
    -- só tira right se ele estiver bloqueando o left
    if curRight > 0 and curRight ~= wantRight and wantRight > 0 then
      if eqm_unequipSlot(SlotRight) then return true end
    end
  end

  -- se só configurou right-hand, não limpa left-hand
  if wantRight > 0 and curRight ~= wantRight then
    -- só tira left se ele estiver bloqueando o right
    if curLeft > 0 and curLeft ~= wantLeft and wantLeft > 0 then
      if eqm_unequipSlot(SlotLeft) then return true end
    end
  end

  return false
end

local function eqm_applyResolvedOldClient(resolvedItems)
  if not resolvedItems then return false end

  if eqm_prepareHands(resolvedItems) then
    return true
  end

  for _, part in ipairs(EQM_EQUIP_ORDER) do
    local wantedId = tonumber(resolvedItems[part]) or 0

    -- slot nao configurado = nao mexe
    if wantedId > 0 then
      local slotConst = EQM_SLOT_CONST[part]
      local currentId = eqm_getSlotId(slotConst)

      if currentId ~= wantedId then
        if eqm_equipToSlot(wantedId, slotConst) then
          return true
        end
      end
    end
  end

  return false
end

local function eqm_applyResolvedNewClient(resolvedItems)
  if not resolvedItems then return false end

  local changed = false

  for _, part in ipairs(EQM_EQUIP_ORDER) do
    local wantedId = tonumber(resolvedItems[part]) or 0

    -- slot nao configurado = nao mexe
    if wantedId > 0 then
      local slotConst = EQM_SLOT_CONST[part]
      local currentId = eqm_getSlotId(slotConst)

      if currentId ~= wantedId then
        pcall(function()
          g_game.equipItemId(wantedId)
        end)

        changed = true
      end
    end
  end

  return changed
end

macro(200, function()
  if not charStorage[switchEqManager] or charStorage[switchEqManager].enabled ~= true then return end
  if #eqProfiles == 0 then return end

  local t = eqm_now()
  if eqmNextAction > t then return end

  local profile, resolvedItems = eqm_getMatchedProfileAndItems()
  if not profile or not resolvedItems then return end

  local changed = false

  if EQM_IS_OLD_CLIENT then
    changed = eqm_applyResolvedOldClient(resolvedItems)
  else
    changed = eqm_applyResolvedNewClient(resolvedItems)
  end

  if changed then
    eqmNextAction = t + EQM_ACTION_DELAY
  end
end)
