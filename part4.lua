
setDefaultTab("Main")

settingsButton = setupUI([[
Panel
  height: 19
  
  Button
    id: settings
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 0
    height: 18
    text: Settings and Tools
]])
settingsButton:setId(switchTravel)

settingsInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 220 250
  anchors.centerIn: parent
  margin-top: -50
  text: Panel Settings
  opacity: 1.00

  FlatPanel
    id: panel
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin: -3
    margin-bottom: 20

    Button
      id: PlayerList
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      height: 22
      margin-left: 4
      margin-right: 4
      margin-top: 5
      text: PLAYER LIST
      font: cipsoftFont

    Button
      id: vBotSettings
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      height: 22
      text: VBOT SETTINGS
      font: cipsoftFont

    Button
      id: FastTravel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      height: 22
      text: FAST TRAVEL
      font: cipsoftFont

    Button
      id: BuyMarket
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      height: 22
      text: BUYING MARKET
      font: cipsoftFont

    Button
      id: AutoImbue
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      height: 22
      text: AUTO IMBUEMENT
      font: cipsoftFont

    Button
      id: HUD
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      height: 22
      text: HUD
      font: cipsoftFont

  Button
    id: closePanel
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    margin-left: -1
    margin-top: 5
    text: Close
    color: gray

]=], g_ui.getRootWidget())
settingsInterface:hide()

if modules._G.g_app.isMobile() then
  settingsInterface:setSize("220 270")
end

settingsButton.settings.onClick = function()
  if settingsInterface:isVisible() then
    settingsInterface:hide()
  else
    settingsInterface:show()
    settingsInterface:raise()
    settingsInterface:focus()
  end
end
settingsInterface.panel.FastTravel.onClick = function()
  travelInterface:show()
  travelInterface:raise()
  travelInterface:focus()
end
settingsInterface.panel.vBotSettings.onClick = function()
  extrasWindow:show()
  extrasWindow:raise()
  extrasWindow:focus()
end
settingsInterface.panel.PlayerList.onClick = function()
  ListWindow:show()
  ListWindow:raise()
  ListWindow:focus()
end
settingsInterface.panel.AutoImbue.onClick = function()
  rebuildMainList()
  panelImbuiment:show()
  panelImbuiment:raise()
  panelImbuiment:focus()
end
settingsInterface.panel.BuyMarket.onClick = function()
  marketInterface:show()
  marketInterface:raise()
  marketInterface:focus()
end
settingsInterface.panel.HUD.onClick = function()
  hudInterface:show()
  hudInterface:raise()
  hudInterface:focus()
end
settingsInterface.closePanel.onClick = function()
  settingsInterface:hide()
end


------------------------------
--------UTILITARIOS
------------------------------

settingsButton = setupUI([[
Panel
  height: 19
  
  Button
    id: settings
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 0
    height: 18
    text: Utilitys Scripts
]])
settingsButton:setId(switchTravel)

-- ============================================================
-- UTILITYS PANEL + CHAR STORAGE
-- ============================================================

charStorage = charStorage or loadCharStorage()

local UTILITY_STORAGE = "utilityPanel"

charStorage[UTILITY_STORAGE] = charStorage[UTILITY_STORAGE] or {
  proximaBp = false,

  HoldTarget = false,
  SummonF = false,
  SuperDash = false,
  Dancing = false,
  HoldPosition = false,
  SleepMode = false,
  EsconderSprites = false,
  EsconderTextos = false,
  AutoMount = false,
  AutoBan = false,
  ExetaRes = false,
  ExetaLoot = false,
  AmpRes = false,
  WallHugger = false,
  autoAol = false,
  esconderAndares = false,
  dashMouse = false,
  utevoLux = false,
  manaTrain = false,
  manaTrainMage = false,

  textutevoLux = "Utevo Lux",
  textManaTrain = "",
  textManaTrainMage = "23373",

  proximaBpID = {{id = 2854}},

  LootChest = false,
  lootAll = false,
  lootBackpackId = 2854,
  rewardChestId = 19250,
  rewardContainerId = 19202,
  maxOpennedContainers = 5,
  lootRewardDelay = 50,
  itemsToLoot = {3031, 3043}
}

local utilCfg = charStorage[UTILITY_STORAGE]

local function saveUtilitys()
  saveCharStorage(charStorage)
end

local function normalizeContainerItems(t)
  local r = {}
  for _, entry in pairs(t or {}) do
    local id = type(entry) == "table" and entry.id or entry
    id = tonumber(id)
    if id and id > 0 then
      table.insert(r, {id = id})
    end
  end
  return r
end

local function properTable(t)
  local r = {}
  for _, entry in pairs(t or {}) do
    local id = type(entry) == "table" and entry.id or entry
    id = tonumber(id)
    if id and id > 0 then
      table.insert(r, id)
    end
  end
  return r
end

local function safeSetItem(widget, id)
  if not widget then return end
  id = tonumber(id) or 0
  if id > 0 and widget.setItemId then
    widget:setItemId(id)
  elseif id > 0 and widget.setItem then
    widget:setItem(id)
  end
end

local function safeGetItem(widget)
  if not widget then return 0 end
  if widget.getItemId then
    return tonumber(widget:getItemId()) or 0
  end
  if widget.getItem then
    local it = widget:getItem()
    if it and it.getId then
      return tonumber(it:getId()) or 0
    end
  end
  return 0
end

-- ============================================================
-- UI
-- ============================================================

utilityInterface = setupUI([[
MainWindow
  id: mainPanel
  size: 478 335
  border: 1 black
  anchors.centerIn: parent
  margin-top: -50
  text: LNS Custom | Utilitys

  FlatPanel
    id: flatp2
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.bottom: closePanel.top
    width: 292
    margin: -5
    margin-top: 2
    margin-bottom: 6
    padding: 6

    BotSwitch
      id: HoldTarget
      anchors.top: parent.top
      anchors.left: parent.left
      size: 135 18
      text: Hold Target
      margin-top: 2

    BotSwitch
      id: SummonF
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Summon Familiar
      margin-top: 5

    BotSwitch
      id: SuperDash
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Super Dash
      margin-top: 5

    BotSwitch
      id: Dancing
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Dancing
      margin-top: 5

    BotSwitch
      id: HoldPosition
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Hold Position
      margin-top: 5

    BotSwitch
      id: SleepMode
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Sleep Mode
      margin-top: 5

    BotSwitch
      id: EsconderSprites
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Hide Sprites
      margin-top: 5

    BotSwitch
      id: EsconderTextos
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Hide Texts
      margin-top: 5

    BotSwitch
      id: AutoMount
      anchors.top: parent.top
      anchors.left: HoldTarget.right
      size: 135 18
      text: Auto Mount
      margin-left: 10
      margin-top: 2

    BotSwitch
      id: AutoBan
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Ban Cast
      margin-top: 5

    BotSwitch
      id: ExetaRes
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Exeta Res
      margin-top: 5

    BotSwitch
      id: ExetaLoot
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Exeta Loot
      margin-top: 5

    BotSwitch
      id: AmpRes
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Amp Res
      margin-top: 5

    BotSwitch
      id: WallHugger
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Wall Hugger
      margin-top: 5

    BotSwitch
      id: esconderAndares
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Hide Floors
      margin-top: 5

    BotSwitch
      id: dashMouse
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Dash Mouse
      margin-top: 5

    BotSwitch
      id: autoAol
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Auto Aol
      margin-top: 5

    BotSwitch
      id: utevoLux
      anchors.top: autoAol.bottom
      anchors.left: autoAol.left
      size: 135 18
      text: Utevo Lux
      margin-top: 5

    BotTextEdit
      id: textutevoLux
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      margin-top: 2
      text: Utevo Lux

    BotSwitch
      id: manaTrain
      anchors.top: EsconderTextos.bottom
      anchors.left: EsconderTextos.left
      size: 135 18
      text: Mana Train
      margin-top: 5

    BotTextEdit
      id: textManaTrain
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      margin-top: 2
      tooltip: Exura gran san

    BotSwitch
      id: manaTrainMage
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      text: Trainer ED/MS
      margin-top: 5

    BotTextEdit
      id: textManaTrainMage
      anchors.top: prev.bottom
      anchors.left: prev.left
      size: 135 18
      margin-top: 2
      text: 23373

  FlatPanel
    id: flatp
    anchors.top: parent.top
    anchors.left: flatp2.right
    anchors.right: parent.right
    anchors.bottom: closePanel.top
    margin-top: 2
    margin-left: 8
    margin-right: -5
    margin-bottom: 6
    padding: 6

    BotSwitch
      id: proximaBp
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      height: 18
      text: Open Next BP
      margin-top: 2
      text-align: center

    Panel
      id: containersBp
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: 70
      margin-top: 5
      border: 1 #444444
      background-color: #111111
      opacity: 0.85

    HorizontalSeparator
      id: hsep
      anchors.top: prev.bottom
      anchors.left: proximaBp.left
      anchors.right: proximaBp.right
      margin-top: 5

    BotSwitch
      id: LootChest
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      height: 18
      margin-right: 40
      text: Loot Chest
      margin-top: 8
      text-align: center

    BotSwitch
      id: lootAll
      anchors.top: prev.top
      anchors.left: prev.right
      anchors.right: hsep.right
      height: 18
      text: All
      margin-top: 0
      margin-left: 2
      text-align: center

    Label
      id: idlootbp
      anchors.top: prev.bottom
      anchors.left: LootChest.left
      text: ID Backpack:
      margin-top: 10
      text-auto-resize: true

    BotItem
      id: lootBp
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: lootAll.right
      margin-top: 2
      size: 30 30

    Label
      id: idReward
      anchors.top: idlootbp.bottom
      anchors.left: idlootbp.left
      text: ID Reward Bag:
      margin-top: 18
      text-auto-resize: true

    BotItem
      id: rewardChest
      anchors.verticalCenter: prev.verticalCenter
      anchors.right: lootAll.right
      margin-top: 2
      size: 30 30

    Panel
      id: containerItemstoloot
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: 68
      margin-top: 2
      border: 1 #444444
      background-color: #111111
      opacity: 0.85

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
    color: gray
]], g_ui.getRootWidget())

utilityInterface:hide()

if modules._G.g_app.isMobile() then
  utilityInterface:setSize("478 355")
end

utilityInterface.closePanel.onClick = function()
  utilityInterface:hide()
end

settingsButton.settings.onClick = function()
  utilityInterface:show()
  utilityInterface:raise()
  utilityInterface:focus()
end

-- ============================================================
-- BINDS
-- ============================================================

local function bindSwitch(widget, key)
  if not widget then return end
  utilCfg[key] = utilCfg[key] == true
  widget:setOn(utilCfg[key])

  widget.onClick = function(w)
    utilCfg[key] = not utilCfg[key]
    w:setOn(utilCfg[key])
    saveUtilitys()
  end
end

local function bindText(widget, key, defaultText)
  if not widget then return end
  if utilCfg[key] == nil then utilCfg[key] = defaultText or "" end
  widget:setText(tostring(utilCfg[key] or ""))

  widget.onTextChange = function(_, text)
    utilCfg[key] = tostring(text or "")
    saveUtilitys()
  end
end

local function bindBotItem(widget, key, defaultId)
  if not widget then return end

  local id = tonumber(utilCfg[key] or 0) or 0
  if id <= 0 then
    id = tonumber(defaultId or 0) or 0
    utilCfg[key] = id
    saveUtilitys()
  end

  safeSetItem(widget, id)

  widget.onItemChange = function(w)
    utilCfg[key] = safeGetItem(w)
    saveUtilitys()
  end
end

bindSwitch(utilityInterface.flatp.proximaBp, "proximaBp")
bindSwitch(utilityInterface.flatp.LootChest, "LootChest")
bindSwitch(utilityInterface.flatp.lootAll, "lootAll")

bindSwitch(utilityInterface.flatp2.HoldTarget, "HoldTarget")
bindSwitch(utilityInterface.flatp2.SummonF, "SummonF")
bindSwitch(utilityInterface.flatp2.SuperDash, "SuperDash")
bindSwitch(utilityInterface.flatp2.Dancing, "Dancing")
bindSwitch(utilityInterface.flatp2.HoldPosition, "HoldPosition")
bindSwitch(utilityInterface.flatp2.SleepMode, "SleepMode")
bindSwitch(utilityInterface.flatp2.EsconderSprites, "EsconderSprites")
bindSwitch(utilityInterface.flatp2.EsconderTextos, "EsconderTextos")
bindSwitch(utilityInterface.flatp2.AutoMount, "AutoMount")
bindSwitch(utilityInterface.flatp2.AutoBan, "AutoBan")
bindSwitch(utilityInterface.flatp2.ExetaRes, "ExetaRes")
bindSwitch(utilityInterface.flatp2.ExetaLoot, "ExetaLoot")
bindSwitch(utilityInterface.flatp2.AmpRes, "AmpRes")
bindSwitch(utilityInterface.flatp2.WallHugger, "WallHugger")
bindSwitch(utilityInterface.flatp2.autoAol, "autoAol")
bindSwitch(utilityInterface.flatp2.esconderAndares, "esconderAndares")
bindSwitch(utilityInterface.flatp2.dashMouse, "dashMouse")
bindSwitch(utilityInterface.flatp2.utevoLux, "utevoLux")
bindSwitch(utilityInterface.flatp2.manaTrain, "manaTrain")
bindSwitch(utilityInterface.flatp2.manaTrainMage, "manaTrainMage")

bindText(utilityInterface.flatp2.textutevoLux, "textutevoLux", "Utevo Lux")
bindText(utilityInterface.flatp2.textManaTrain, "textManaTrain", "")
bindText(utilityInterface.flatp2.textManaTrainMage, "textManaTrainMage", "23373")

bindBotItem(utilityInterface.flatp.lootBp, "lootBackpackId", 2854)
bindBotItem(utilityInterface.flatp.rewardChest, "rewardContainerId", 19202)

-- ============================================================
-- CONTAINER: OPEN NEXT BP
-- ============================================================

utilCfg.proximaBpID = normalizeContainerItems(utilCfg.proximaBpID or {{id = 2854}})

local nextBpContainer = UI.ContainerEx(function(_, items)
  utilCfg.proximaBpID = normalizeContainerItems(items)
  saveUtilitys()
end, true, utilityInterface.flatp.containersBp)

nextBpContainer:setHeight(46)
nextBpContainer:setItems(utilCfg.proximaBpID)
nextBpContainer:setParent(utilityInterface.flatp.containersBp)
nextBpContainer:fill('parent')

local function getNextBpIdList()
  return properTable(utilCfg.proximaBpID or {})
end

-- ============================================================
-- CONTAINER: ITEMS TO LOOT
-- ============================================================

utilCfg.itemsToLoot = normalizeContainerItems(utilCfg.itemsToLoot or {3031, 3043})

local itemsToLootContainer = UI.ContainerEx(function(_, items)
  utilCfg.itemsToLoot = normalizeContainerItems(items)
  saveUtilitys()
end, true, utilityInterface.flatp.containerItemstoloot)

itemsToLootContainer:setHeight(55)
itemsToLootContainer:setItems(utilCfg.itemsToLoot)
itemsToLootContainer:setParent(utilityInterface.flatp.containerItemstoloot)
itemsToLootContainer:fill('parent')

local function getLootItemsIds()
  return properTable(utilCfg.itemsToLoot or {})
end

-- ============================================================
-- MACRO: OPEN NEXT BP
-- ============================================================
macro(1000, function()
  if utilCfg.proximaBp ~= true then return end

  local containerIds = getNextBpIdList()
  if #containerIds == 0 then return end

  for _, container in pairs(getContainers()) do
    local containerItem = container:getContainerItem()
    if containerItem and table.contains(containerIds, containerItem:getId()) then
      if container:getCapacity() == #container:getItems() then
        for _, item in ipairs(container:getItems()) do
          if table.contains(containerIds, item:getId()) then
            g_game.open(item, container)
            delay(200)
            return
          end
        end
      end
    end
  end
end)

-- ============================================================
-- LOOT REWARD CHEST
-- ============================================================

local containerItemlist = {}

local function printMessage(msg)
  modules.game_textmessage.displayGameMessage(msg)
end

local function closeAll()
  for _, container in pairs(getContainers()) do
    g_game.close(container)
  end
end

local function getRewardChestContainer()
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == tonumber(utilCfg.rewardChestId or 19250) then
      return container
    end
  end
  return nil
end

local function pushContainer(containerItem)
  table.insert(containerItemlist, containerItem)
end

local function popContainer()
  table.remove(containerItemlist, 1)
end

local function openNext()
  local cItem = containerItemlist[1]
  if cItem then
    popContainer()
    g_game.open(cItem)
    return true
  end
  return false
end

local function isContainerInLastPage(container)
  if not container then return true end
  local currentPage = 1 + math.floor(container:getFirstIndex() / container:getCapacity())
  local pages = 1 + math.floor(math.max(0, (container:getSize() - 1)) / container:getCapacity())
  return currentPage == pages
end

local function nextContainerPage(container)
  if not container or not container.window then return end
  local nextPageButton = container.window:recursiveGetChildById('nextPageButton')
  if nextPageButton and nextPageButton.onClick then
    nextPageButton.onClick()
  end
end

local function canCloseRewardContainer(container)
  local lootItemsIds = getLootItemsIds()

  if utilCfg.lootAll == true then
    if #container:getItems() >= 1 then
      return false
    end
  end

  for _, item in ipairs(container:getItems()) do
    if table.find(lootItemsIds, item:getId()) then
      return false
    end
  end

  if container:hasPages() and not isContainerInLastPage(container) then
    nextContainerPage(container)
    return false
  end

  container:getContainerItem().isChecked = true
  container:getContainerItem():hide()
  return true
end

local function closeCheckedContainers()
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == tonumber(utilCfg.rewardContainerId or 19202) and canCloseRewardContainer(container) then
      g_game.close(container)
    end
  end
end

local function addContainersTolist()
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == tonumber(utilCfg.rewardChestId or 19250) then
      for _, item in ipairs(container:getItems()) do
        if item:isContainer() and not item.isAdded then
          item.isAdded = true
          pushContainer(item)
        end
      end
    end
  end
end

local function hasLootedAll()
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == tonumber(utilCfg.rewardContainerId or 19202) then
      if utilCfg.lootAll == true and #container:getItems() > 1 then
        return false
      else
        for _, item in ipairs(container:getItems()) do
          if table.find(getLootItemsIds(), item:getId()) then
            return false
          end
        end
      end
    end
  end
  return true
end

local function finished()
  return #containerItemlist == 0 and hasLootedAll()
end

local function isRewardChestOpen()
  return getRewardChestContainer()
end

local function findAndOpenRewardChest()
  for _, tile in ipairs(g_map.getTiles(posz())) do
    local topT = tile:getTopThing()
    if topT and topT.getId and topT:getId() == tonumber(utilCfg.rewardChestId or 19250) then
      g_game.open(topT)
      return true
    end
  end
  return false
end

local function openBack()
  if getBack() then
    g_game.open(getBack())
  end
end

local function getMainBPId()
  local back = getBack()
  return back and back:getId() or 0
end

local function isContainerOpen(id)
  id = tonumber(id) or 0
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == id then
      return true
    end
  end
  return false
end

local function openContainerId(id)
  id = tonumber(id) or 0
  for _, container in pairs(getContainers()) do
    for _, item in ipairs(container:getItems()) do
      if item:getId() == id then
        return g_game.open(item)
      end
    end
  end
end

local function isContainerFull(id)
  id = tonumber(id) or 0
  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == id then
      return #container:getItems() == container:getCapacity()
    end
  end
  return false
end

local function openNextBag()
  local lootBp = tonumber(utilCfg.lootBackpackId or 2854) or 2854

  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == lootBp then
      for _, item in ipairs(container:getItems()) do
        if item:getId() == lootBp then
          g_game.open(item)
          schedule(100, function()
            g_game.close(container)
          end)
          return true
        end
      end
    end
  end

  return false
end

local lootMainDelay = 1000 + (g_game.getPing and g_game.getPing() or 0)

local m_lootReward = macro(lootMainDelay, function(m)
  if utilCfg.LootChest ~= true then return end

  local lootBp = tonumber(utilCfg.lootBackpackId or 2854) or 2854
  local maxOpen = tonumber(utilCfg.maxOpennedContainers or 5) or 5

  if not isRewardChestOpen() then
    closeAll()
    findAndOpenRewardChest()
    delay(2000)
    return
  end

  local mainBpId = getMainBPId()
  if mainBpId > 0 and not isContainerOpen(mainBpId) then
    return openBack()
  end

  if not isContainerOpen(lootBp) then
    return openContainerId(lootBp)
  end

  if isContainerFull(lootBp) then
    if not openNextBag() then
      utilCfg.LootChest = false
      utilityInterface.flatp.LootChest:setOn(false)
      saveUtilitys()
      printMessage("Finished Looting!.")
    end
    return
  end

  closeCheckedContainers()
  addContainersTolist()

  if #getContainers() >= maxOpen then
    return
  end

  if openNext() then
    return
  elseif not isContainerInLastPage(getRewardChestContainer()) then
    return nextContainerPage(getRewardChestContainer())
  end

  if finished() then
    closeAll()
    utilCfg.LootChest = false
    utilityInterface.flatp.LootChest:setOn(false)
    saveUtilitys()
    printMessage("Finished Looting!")
  end
end)

onContainerOpen(function(container, previousContainer)
  if utilCfg.LootChest == true and container and container.window then
    container.window:setHeight(55)
  end
end)

macro(tonumber(utilCfg.lootRewardDelay or 50) or 50, function()
  if utilCfg.LootChest ~= true then return end

  local lootBp = tonumber(utilCfg.lootBackpackId or 2854) or 2854
  local rewardBag = tonumber(utilCfg.rewardContainerId or 19202) or 19202
  local lootItemsIds = getLootItemsIds()

  local itemToMove = nil

  for _, container in pairs(getContainers()) do
    local cItem = container:getContainerItem()
    if cItem and cItem:getId() == rewardBag then
      for _, item in ipairs(container:getItems()) do
        if utilCfg.lootAll == true then
          itemToMove = item
          break
        elseif table.find(lootItemsIds, item:getId()) then
          itemToMove = item
          break
        end
      end
    end
    if itemToMove then break end
  end

  if itemToMove then
    for _, container in pairs(getContainers()) do
      local cItem = container:getContainerItem()
      if cItem and cItem:getId() == lootBp then
        g_game.move(itemToMove, container:getSlotPosition(container:getItemsCount()), itemToMove:getCount())
        return
      end
    end
  end
end)

macro(50, function()
  if utilCfg.dashMouse ~= true then return end

  local tile = getTileUnderCursor()
  if not tile then return end

  local player = g_game.getLocalPlayer()
  if tile:getTopThing() == player then
    return
  end

  local thing = tile:getTopUseThing()
  if thing then
    g_game.use(thing)
  end
end)


local lastEsconderAndaresState = nil

local function getMapPanelSafe()
  if modules and modules.game_interface then
    if modules.game_interface.getMapPanel then
      return modules.game_interface.getMapPanel()
    end

    if modules.game_interface.gameMapPanel then
      return modules.game_interface.gameMapPanel
    end
  end

  return nil
end

local function applyEsconderAndares()
  local gameMapPanel = getMapPanelSafe()
  if not gameMapPanel then return end

  if utilCfg.esconderAndares == true then
    gameMapPanel:lockVisibleFloor(posz())
  else
    gameMapPanel:unlockVisibleFloor()
  end
end

onPlayerPositionChange(function(pos)
  if utilCfg.esconderAndares ~= true then return end

  local gameMapPanel = getMapPanelSafe()
  if gameMapPanel then
    gameMapPanel:lockVisibleFloor(pos.z)
  end
end)

macro(250, function()
  if lastEsconderAndaresState == utilCfg.esconderAndares then return end

  lastEsconderAndaresState = utilCfg.esconderAndares
  applyEsconderAndares()
end)

macro(30000, function()
  if utilCfg.utevoLux ~= true then return end

  local spell = tostring(utilCfg.textutevoLux or "")
  if spell == "" then return end

  say(spell)
end)

macro(500, function()
  if utilCfg.Dancing ~= true then return end
  turn(math.random(0,3))
end)

local posToHold = nil

macro(500, function()
  posToHold = posToHold or pos()
  schedule(50, function() if utilCfg.HoldPosition ~= true then posToHold = nil end end)
  if utilCfg.HoldPosition ~= true then return end
  if table.equals(posToHold, pos()) then return end
  autoWalk(posToHold, 127, {ignoreNonPathable=true, precision=2, ignoreStairs=true})
end)

local function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function parseTwoSpells(text)
  text = tostring(text or "")
  local a, b = text:match("^%s*([^,]+)%s*,%s*([^,]+)%s*$")
  if a then
    return trim(a), trim(b or "")
  end
  return trim(text), ""
end

local mtStep = 1
macro(1000, function()
  if utilCfg.manaTrain ~= true then return end

  local s1, s2 = parseTwoSpells(utilCfg.textManaTrain)
  if s1 == "" then return end

  if s2 == "" then
    say(s1)
    delay(500)
    return
  end

  if mtStep == 1 then
    say(s1)
    mtStep = 2
    delay(500)
  else
    say(s2)
    mtStep = 1
    delay(500)
  end
end)

local manaPercent = 30
local heal1 = "Utana Vid"
local heal2 = "Exura vita"

local train = macro(200, function()
  if utilCfg.manaTrainMage ~= true then return end

  local manaPotionId = tonumber(utilCfg.textManaTrainMage or 0) or 0
  if manaPotionId <= 0 then return end

  for i, npc in ipairs(getSpectators()) do
    if npc:isNpc() and (getDistanceBetween(pos(), npc:getPosition()) <= 5) then
      say(heal1)
      say(heal2)
    end

    if manapercent() <= manaPercent then
      usewith(manaPotionId, player)
    end
  end
end)

onTextMessage(function(mode, text)
  if train.isOff() then return end

  local mp = 'Using one of ([0-9]*)'
  local re1 = regexMatch(text, mp)
  local tmp = ""

  if #re1 ~= 0 then
    tmp = tonumber(re1[1][2])

    for i, npc2 in ipairs(getSpectators()) do
      if npc2:isNpc() and (getDistanceBetween(pos(), npc2:getPosition()) <= 3) then
        if tmp <= 10 then
          local manaPotionId = tonumber(utilCfg.textManaTrainMage or 0) or 0
          if manaPotionId <= 0 then return end

          NPC.say("hi")
          schedule(1000, function() NPC.say("trade") end)
          schedule(1000, function() NPC.say("potions") end)
          schedule(1500, function() NPC.buy(manaPotionId, 300) end)
          schedule(2000, function() NPC.say("bye") end)
          schedule(2500, function() NPC.closeTrade() end)
        end
      end
    end
  end
end)

local targetID = nil

onKeyPress(function(keys)
  if keys == "Escape" and targetID then
    targetID = nil
  end
end)

macro(100, function()
  if utilCfg.HoldTarget ~= true then return end

  if target() and target():getPosition().z == posz() and not target():isNpc() then
    targetID = target():getId()
  elseif not target() then
    if not targetID then return end

    for i, spec in ipairs(getSpectators()) do
      local sameFloor = spec:getPosition().z == posz()
      local oldTarget = spec:getId() == targetID

      if sameFloor and oldTarget then
        attack(spec)
      end
    end
  end
end)

local vocationsMap = {
  [1] = "Knight", [2] = "Paladin", [3] = "Sorcerer", [4] = "Druid",
  [5] = "Monk",
  [6] = "Elite Knight", [7] = "Royal Paladin", [8] = "Master Sorcerer", [9] = "Elder Druid",
  [10] = "Exalted Monk"
}

local function getVocationType(playerObj)
  if not playerObj then return "knight" end
  local vocId = playerObj:getVocation()
  local vocName = vocationsMap[vocId] or "Unknown"

  if vocName == "Knight" or vocName == "Elite Knight" then
    return "knight"
  elseif vocName == "Paladin" or vocName == "Royal Paladin" then
    return "paladin"
  elseif vocName == "Sorcerer" or vocName == "Master Sorcerer" then
    return "sorcerer"
  elseif vocName == "Druid" or vocName == "Elder Druid" then
    return "druid"
  elseif vocName == "Monk" or vocName == "Exalted Monk" then
    return "monk"
  end

  return "knight"
end

local familiarSpellByVoc = {
  knight   = "utevo gran res eq",
  paladin  = "utevo gran res sac",
  sorcerer = "utevo gran res ven",
  druid    = " utevo gran res dru",
  monk     = "utevo gran res tio"
}

local lastSummon = 0
local summonCooldown = 1 * 60 * 1000

macro(500, function()
  if utilCfg.SummonF ~= true then return end
  if isInPz() then return end

  local playerObj = g_game.getLocalPlayer()
  if not playerObj then return end

  local vocType = getVocationType(playerObj)
  local spell = familiarSpellByVoc[vocType]
  if not spell or spell == "" then return end

  say(spell)
  delay(10000)
end)

macro(500, function()
  if utilCfg.AutoMount ~= true then return end
  if isInPz() then return end

  local outfit = player:getOutfit()
  local isMounted = outfit.mount ~= nil and outfit.mount > 0

  if not isMounted then
    player:mount()
  end
end)

local secondsToIdle = 5
local activeFPS = 60
local afkFPS = 5

function botPrintMessage(message)
  modules.game_textmessage.displayGameMessage(message)
end

local function isSameMousePos(p1, p2)
  return p1.x == p2.x and p1.y == p2.y
end

local function setAfk()
  modules.client_options.setOption("backgroundFrameRate", afkFPS)
  modules.game_interface.gameMapPanel:hide()
end

local function setActive()
  modules.client_options.setOption("backgroundFrameRate", activeFPS)
  modules.game_interface.gameMapPanel:show()
end

local lastMousePos = nil
local finalMousePos = nil
local idleCount = 0
local maxIdle = secondsToIdle * 4

macro(250, function()
  if utilCfg.SleepMode ~= true then return end

  local currentMousePos = g_window.getMousePosition()

  if finalMousePos then
    if isSameMousePos(finalMousePos, currentMousePos) then return end
    setActive()
    finalMousePos = nil
  end

  if lastMousePos and isSameMousePos(lastMousePos, currentMousePos) then
    idleCount = idleCount + 1
  else
    lastMousePos = currentMousePos
    idleCount = 0
  end

  if idleCount == maxIdle then
    setAfk()
    finalMousePos = currentMousePos
    idleCount = 0
  end
end)

onAddThing(function(tile, thing)
  if utilCfg.EsconderSprites ~= true then return end
  if thing:isEffect() then
    thing:hide()
  end
end)

onStaticText(function(thing, text)
  if utilCfg.EsconderTextos ~= true then return end
  if not text:find('says:') then
    g_map.cleanTexts()
  end
end)

onTextMessage(function(mode, text)
  if utilCfg.EsconderTextos ~= true then return end
  modules.game_textmessage.clearMessages()
  g_map.cleanTexts()
end)

macro(5000, function()
  if utilCfg.AutoBan ~= true then return end

  for _, child in ipairs(g_ui.getRootWidget():recursiveGetChildren()) do
    if child:getId() and child:getId():find("consoleLabel") then
      local text = child:getText():lower()
      text = string.sub(text, 6, #text)

      if text:find("spectator") and text:find("joined") then
        talkChannel(9, "!cast ban," .. getFirstNumberInText(text))
        child:destroy()
      end
    end
  end
end)

local wallHuggerConfig = {
  mobs = 2,
  mobDist = 7,
  chase = true,
  wallDist = 8,
  maxNearWalkableTiles = 3,

  ignoreIds = {
    [1949] = true,
  }
}

local function isIgnoredTile(tile)
  if not tile then return false end

  local things = tile:getThings()
  if not things then return false end

  for _, thing in ipairs(things) do
    if wallHuggerConfig.ignoreIds[thing:getId()] then
      return true
    end
  end

  return false
end

local s = {}

s.getNearTiles = function(pos)
  if type(pos) ~= "table" then pos = pos:getPosition() end

  local tiles = {}
  local dirs = {
      {-1, 1}, {0, 1}, {1, 1}, {-1, 0}, {1, 0}, {-1, -1}, {0, -1}, {1, -1}
  }

  for i = 1, #dirs do
      local tile = g_map.getTile({
          x = pos.x - dirs[i][1],
          y = pos.y - dirs[i][2],
          z = pos.z
      })
      if tile then table.insert(tiles, tile) end
  end

  return tiles
end

s.getMonsters = function(pos, range)
  if not pos or not range then return 0 end

  local monsters = 0
  for _, spec in pairs(getSpectators()) do
    if spec:isMonster() and getDistanceBetween(pos, spec:getPosition()) < range then
      monsters = monsters + 1
    end
  end

  return monsters
end

s.getWallTiles = function()
  local tiles = {}

  for _, t in ipairs(g_map.getTiles(posz())) do
    local tPos = t:getPosition()
    local dist = getDistanceBetween(pos(), tPos)

    if dist <= wallHuggerConfig.wallDist and not t:isWalkable() and not isIgnoredTile(t) then
      table.insert(tiles, t)
    end
  end

  return tiles
end

s.getNearWalkableTilesCount = function(tile)
  local c = 0

  for _, t in ipairs(s.getNearTiles(tile:getPosition())) do
    if t and t:isWalkable() then
      c = c + 1
    end
  end

  return c
end

s.getActualWalkPos = function(tile)
  local madeByVivoDibra = true
  if not tile then return nil end

  local tiles = {}
  if not madeByVivoDibra then return end

  for _, tt in ipairs(s.getNearTiles(tile:getPosition())) do
    local ttPos = tt:getPosition()

    if tt and tt:isWalkable() and not tt:getCreatures()[1] and findPath(pos(), ttPos, 50) then
      for _, t in ipairs(s.getNearTiles(ttPos)) do
        if t and t:isWalkable() then
          tt.sqmCount = (tt.sqmCount and tt.sqmCount + 1) or 1
        end
      end

      table.insert(tiles, tt)
    end
  end

  table.sort(tiles, function(x, y)
    return x.sqmCount < y.sqmCount
  end)

  local p = tiles[1] and tiles[1]:getPosition()

  for _, t in ipairs(tiles) do
    t.sqmCount = nil
  end

  return p
end

s.currentGotoPos = nil

s.setCurrentGotoPos = function()
  if s.currentGotoPos then return end

  local wallTiles = s.getWallTiles()

  for i, t in ipairs(wallTiles) do
    local c = s.getNearWalkableTilesCount(t)
    if c > wallHuggerConfig.maxNearWalkableTiles then
      table.remove(wallTiles, i)
    end
  end

  table.sort(wallTiles, function(x, y)
    local distX = getDistanceBetween(x:getPosition(), pos())
    local distY = getDistanceBetween(y:getPosition(), pos())
    return distX < distY
  end)
  
  s.currentGotoPos = s.getActualWalkPos(wallTiles[1])
end

s.walkToGoto = function()
  if s.currentGotoPos then
    local t = g_map.getTile(s.currentGotoPos)
    if t then
      t:setTimer(1000, "yellow")
    end

    autoWalk(s.currentGotoPos, 20, {precision=0, ignoreLastCreature=true})
  end
end

s.setChase = function(on)
  if wallHuggerConfig.chase then
    g_game.setChaseMode(on and 1 or 0)
  end
end

s.gotoWall = function()
  s.setChase(false)
  s.setCurrentGotoPos()
  s.walkToGoto()
end

s.proceedHunting = function()
  s.setChase(true)
  s.currentGotoPos = nil
end

s.reset = function(m)
  schedule(1000, function()
    if m.isOff() then
      s.currentGotoPos = nil
    end
  end)
end

macro(1000, function(m)
  if utilCfg.WallHugger ~= true then
    s.currentGotoPos = nil
    return
  end

  local mobs = s.getMonsters(pos(), wallHuggerConfig.mobDist)

  if mobs >= wallHuggerConfig.mobs then
    s.gotoWall()
  else
    s.proceedHunting()
  end

  s.reset(m)
end)

local exetaLootDelay = 1000
local nextExeta = 0

onCreatureDisappear(function(creature)
  if utilCfg.ExetaLoot ~= true then return end
  if nextExeta > now then return end
  if isInPz() then return end
  if not creature:isMonster() then return end

  local pos = player:getPosition()
  local mpos = creature:getPosition()

  if pos.z ~= mpos.z or getDistanceBetween(pos, mpos) > 1 then return end

  schedule(100, function()
    local tile = g_map.getTile(mpos)
    if not tile then return end

    local container = tile:getTopUseThing()
    if not container or not container:isContainer() then return end

    nextExeta = now + exetaLootDelay
    say("exeta loot")
  end)
end)

local autoAolConfig = {
  AOLId = 3057
}

macro(200, function()
  if utilCfg.autoAol ~= true then return end

  local hasAol = getNeck() and getNeck():getId() == autoAolConfig.AOLId
  if hasAol then return end

  local aol = findItem(autoAolConfig.AOLId)
  if aol then
    moveToSlot(aol, SlotNeck, 1)
  else
    say("!aol")
    delay(1000)
  end
end)


local pushKina = 0
local pushPallyMonk = 0
local exetaCD = 0

local function getVocType()
  local vocId = player:getVocation()
  if vocId == 1 or vocId == 6 then
    return "knight"
  elseif vocId == 2 or vocId == 7 then
    return "paladin"
  elseif vocId == 5 or vocId == 10 then
    return "monk"
  end

  return ""
end
local vocType = getVocType()

macro(200, function()
  if utilCfg.AmpRes ~= true then return end
  if isInPz() then return end
  if g_game.isAttacking() then

    if vocType == "knight" and (not pushKina or pushKina <= now) and mana() >= 200 then
      say("exeta amp res")
    elseif vocType == "paladin" and (not pushPallyMonk or pushPallyMonk <= now) and mana() >= 200 then
      say("exana amp res")
    elseif vocType == "monk" and (not pushPallyMonk or pushPallyMonk <= now) and mana() >= 200 then
      say("exori mas res")
    end
  end
end)

macro(200, function()
  if utilCfg.ExetaRes ~= true then return end
  if not g_game.isAttacking() then return end

  local target = g_game.getAttackingCreature()
  if not target then return end

  if distanceFromPlayer(target:getPosition()) <= 1 and manapercent() > 30 and (not exetaCD or exetaCD <= now) then
    say("exeta res")
  end
end)

onTalk(function(name, _, _, text)
  if name ~= player:getName() then return end
  text = tostring(text or ""):lower()
  if text == "exeta amp res" then
    pushKina = now + 6100
  end
  if text == "exana amp res" or text == "exori mas res" then
    pushPallyMonk = now + 15200
  end
  if text == "exeta res" or text == "Exeta Res" then
    exetaCD = now + 2500
  end
end)

BugMap = {}

local consoleTextEdit = g_ui.getRootWidget():recursiveGetChildById('consoleTextEdit')

local availableKeys = {
  ['W'] = { 0, -3 },
  ['S'] = { 0, 3 },
  ['A'] = { -3, 0 },
  ['D'] = { 3, 0 },
  ['C'] = { 3, 3 },
  ['Z'] = { -3, 3 },
  ['Q'] = { -3, -3 },
  ['E'] = { 3, -3 }
}

local function safeIsMobile()
  if g_app and type(g_app.isMobile) == "function" then
    local ok, res = pcall(function() return g_app:isMobile() end)
    if ok then return res == true end
  end
  return false
end

local isMobile = safeIsMobile()

macro(100, function()
  if utilCfg.SuperDash ~= true or isMobile then return end
  if modules.game_console:isChatEnabled() then return end

  local playerPos = pos()
  local tile

  for key, value in pairs(availableKeys) do
    if modules.corelib.g_keyboard.isKeyPressed(key) then
      playerPos.x = playerPos.x + value[1]
      playerPos.y = playerPos.y + value[2]
      tile = g_map.getTile(playerPos)
      break
    end
  end

  if not tile then return end

  g_game.use(tile:getTopUseThing())

  local item = tile:getTopUseThing()
  if item then
    g_game.useWith(item, g_game.getLocalPlayer())
    g_game.use(item)
  end
end)

local function checkPos(x, y)
  local xyz = g_game.getLocalPlayer():getPosition()
  xyz.x = xyz.x + x
  xyz.y = xyz.y + y

  local tile = g_map.getTile(xyz)
  if tile then
    return g_game.use(tile:getTopUseThing())
  end

  return false
end

macro(200, function()
  if utilCfg.SuperDash ~= true then return end

  if modules.corelib.g_keyboard.isKeyPressed('W') then
    turn(0)
  elseif modules.corelib.g_keyboard.isKeyPressed('S') then
    turn(2)
  elseif modules.corelib.g_keyboard.isKeyPressed('A') then
    turn(3)
  elseif modules.corelib.g_keyboard.isKeyPressed('D') then
    turn(1)
  end
end)

local cursorWidget = g_ui.getRootWidget():recursiveGetChildById('pointer')
if cursorWidget then
  local initialPos = {
    x = cursorWidget:getPosition().x / cursorWidget:getWidth(),
    y = cursorWidget:getPosition().y / cursorWidget:getHeight()
  }

  local availableKeys2 = {
    Up    = { 0, -6 },
    Down  = { 0,  6 },
    Left  = { -7, 0 },
    Right = { 7,  0 }
  }

  macro(100, function()
    if utilCfg.SuperDash ~= true then return end

    local myPos = pos()
    if not myPos then return end

    local keypadPos = {
      x = cursorWidget:getPosition().x / cursorWidget:getWidth(),
      y = cursorWidget:getPosition().y / cursorWidget:getHeight()
    }

    local diffPos = {
      x = initialPos.x - keypadPos.x,
      y = initialPos.y - keypadPos.y
    }

    if diffPos.y < 0.46 and diffPos.y > -0.46 then
      if diffPos.x > 0 then
        myPos.x = myPos.x + availableKeys2.Left[1]
      elseif diffPos.x < 0 then
        myPos.x = myPos.x + availableKeys2.Right[1]
      else
        return
      end
    elseif diffPos.x < 0.46 and diffPos.x > -0.46 then
      if diffPos.y > 0 then
        myPos.y = myPos.y + availableKeys2.Up[2]
      elseif diffPos.y < 0 then
        myPos.y = myPos.y + availableKeys2.Down[2]
      else
        return
      end
    else
      return
    end

    local tile = g_map.getTile(myPos)
    if not tile then return end

    local top = tile:getTopUseThing()
    if not top then return end

    g_game.use(top)
  end)
end


----------------- TOOLS
setDefaultTab("Tools")

UI.Separator():setMarginTop(0)

charStorage = charStorage or loadCharStorage()

local function saveMoneyTrade()
  saveCharStorage(charStorage)
end
local function saveTradeMsg()
  saveCharStorage(charStorage)
end
local function saveDropperItens()
  saveCharStorage(charStorage)
end

charStorage.moneySystem = charStorage.moneySystem or {
  exchangeMoney = false,
  sendTrade = false,
  dropperEnabled = false,
  moneyItems = {3031, 3035, 3043},
  autoTradeMessage = "I'm using LNS CUSTOM | Disc: https://discord.gg/6xUheuXSak",
  dropper = {
    trashItems = {283, 284, 285},
    useItems = {21203, 14758},
    capItems = {21175}
  }
}

local cfg = charStorage.moneySystem

cfg.moneyItems = type(cfg.moneyItems) == "table" and cfg.moneyItems or {3031, 3035, 3043}
cfg.autoTradeMessage = cfg.autoTradeMessage or "I'm using LNS CUSTOM | Disc: https://discord.gg/6xUheuXSak"
cfg.dropper = cfg.dropper or {}
cfg.dropper.trashItems = type(cfg.dropper.trashItems) == "table" and cfg.dropper.trashItems or {283, 284, 285}
cfg.dropper.useItems = type(cfg.dropper.useItems) == "table" and cfg.dropper.useItems or {21203, 14758}
cfg.dropper.capItems = type(cfg.dropper.capItems) == "table" and cfg.dropper.capItems or {21175}

-- =========================
-- EXCHANGE MONEY
-- =========================
exchangeButton = setupUI([[
Panel
  height: 19

  BotSwitch
    id: exchangeMoney
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Exchange Money
    height: 18
    color: white
]])

exchangeButton.exchangeMoney:setOn(cfg.exchangeMoney)

exchangeButton.exchangeMoney.onClick = function(widget)
  cfg.exchangeMoney = not widget:isOn()
  widget:setOn(cfg.exchangeMoney)
  saveMoneyTrade()
end

macro(20, function()
  if not cfg.exchangeMoney then return end
  if not cfg.moneyItems[1] then return end

  for _, container in pairs(g_game.getContainers()) do
    if not container.lootContainer then
      for _, item in ipairs(container:getItems()) do
        if item:getCount() == 100 then
          for _, moneyId in ipairs(cfg.moneyItems) do
            local id = type(moneyId) == "table" and moneyId.id or moneyId
            if item:getId() == tonumber(id) then
              return g_game.use(item)
            end
          end
        end
      end
    end
  end
end)

local moneyContainer = UI.Container(function(widget, items)
  cfg.moneyItems = items
  saveMoneyTrade()
end, true)

moneyContainer:setHeight(35)
moneyContainer:setItems(cfg.moneyItems)

UI.Separator()

-- =========================
-- SEND TRADE MESSAGE
-- =========================
sendTrade = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Send message on trade
    height: 18
    color: white
]])

sendTrade.title:setOn(cfg.sendTrade)

sendTrade.title.onClick = function(widget)
  cfg.sendTrade = not widget:isOn()
  widget:setOn(cfg.sendTrade)
  saveTradeMsg()
end

macro(1000, function()
  if not cfg.sendTrade then return end

  local msg = tostring(cfg.autoTradeMessage or "")
  if msg:len() <= 0 then return end

  local trade = getChannelId("advertising")
  if not trade then
    trade = getChannelId("trade")
  end

  if trade then
    sayChannel(trade, msg)
    delay(30000)
  end
end)

UI.TextEdit(cfg.autoTradeMessage, function(widget, text)
  cfg.autoTradeMessage = text
  saveTradeMsg()
end)

UI.Separator()

-- =========================
-- DROPPER
-- =========================
dropper = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Dropper
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

local edit = setupUI([[
Panel
  height: 150
    
  Label
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    text-align: center
    text: Trash:

  BotContainer
    id: TrashItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 32

  Label
    anchors.top: prev.bottom
    margin-top: 5
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Use:

  BotContainer
    id: UseItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 32

  Label
    anchors.top: prev.bottom
    margin-top: 5
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Drop if below 150 cap:

  BotContainer
    id: CapItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 32   
]])

edit:hide()

local showEdit = false
dropper.settings.onClick = function(widget)
  showEdit = not showEdit
  if showEdit then
    edit:show()
  else
    edit:hide()
  end
end

dropper.title:setOn(cfg.dropperEnabled)

dropper.title.onClick = function(widget)
  cfg.dropperEnabled = not widget:isOn()
  widget:setOn(cfg.dropperEnabled)
  saveDropperItens()
end

UI.Container(function()
  cfg.dropper.trashItems = edit.TrashItems:getItems()
  saveDropperItens()
end, true, nil, edit.TrashItems)
edit.TrashItems:setItems(cfg.dropper.trashItems)

UI.Container(function()
  cfg.dropper.useItems = edit.UseItems:getItems()
  saveDropperItens()
end, true, nil, edit.UseItems)
edit.UseItems:setItems(cfg.dropper.useItems)

UI.Container(function()
  cfg.dropper.capItems = edit.CapItems:getItems()
  saveDropperItens()
end, true, nil, edit.CapItems)
edit.CapItems:setItems(cfg.dropper.capItems)

local function properTable(t)
  local r = {}

  for _, entry in pairs(t or {}) do
    local id = type(entry) == "table" and entry.id or entry
    id = tonumber(id)
    if id and id > 0 then
      table.insert(r, id)
    end
  end

  return r
end

macro(200, function()
  if not cfg.dropperEnabled then return end

  local tables = {
    properTable(cfg.dropper.capItems),
    properTable(cfg.dropper.useItems),
    properTable(cfg.dropper.trashItems)
  }

  local containers = getContainers()
  for i = 1, 3 do
    for _, container in pairs(containers) do
      for _, item in ipairs(container:getItems()) do
        for _, userItem in ipairs(tables[i]) do
          if item:getId() == userItem then
            return i == 1 and freecap() < 150 and dropItem(item) or
                   i == 2 and use(item) or
                   i == 3 and dropItem(item)
          end
        end
      end
    end
  end
end)

UI.Separator()

-- =========================
-- PARTY
-- =========================
setDefaultTab("Tools")

local panelPartyName = "autoParty"

charStorage = charStorage or loadCharStorage()

charStorage[panelPartyName] = charStorage[panelPartyName] or {
  leaderName = "Leader",
  autoPartyList = {},
  enabled = false,
  onMove = false,
  soulider = false,
  autoShare = false,

  palavraInvite = "",
  soulider2 = false,
  minLevel = "",
  maxLevel = "",
  palavraPedirPT = "",
  pedirParty = false,
  aceitarParty = false,
  banListPlayers = {}
}

local cfgParty = charStorage[panelPartyName]

local function saveAutoParty()
  saveCharStorage(charStorage)
end

if cfgParty.onMove == nil then cfgParty.onMove = false end
if cfgParty.soulider == nil then cfgParty.soulider = false end
if cfgParty.autoShare == nil then cfgParty.autoShare = false end
if cfgParty.leaderName == nil then cfgParty.leaderName = "" end
if not cfgParty.autoPartyList then cfgParty.autoPartyList = {} end
if cfgParty.enabled == nil then cfgParty.enabled = true end

if cfgParty.palavraInvite == nil then cfgParty.palavraInvite = "" end
if cfgParty.soulider2 == nil then cfgParty.soulider2 = false end
if cfgParty.minLevel == nil then cfgParty.minLevel = "" end
if cfgParty.maxLevel == nil then cfgParty.maxLevel = "" end
if cfgParty.palavraPedirPT == nil then cfgParty.palavraPedirPT = "" end
if cfgParty.pedirParty == nil then cfgParty.pedirParty = false end
if cfgParty.aceitarParty == nil then cfgParty.aceitarParty = false end
if not cfgParty.banListPlayers then cfgParty.banListPlayers = {} end

saveAutoParty()

autopartyui = setupUI([[
Panel
  height: 18

  BotSwitch
    id: status
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    height: 18
    margin-right: 45
    text: Auto Party
    color: white

  Button
    id: editPlayerList
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 0
    height: 18
    text: Config
    color: white

]], parent)

g_ui.loadUIFromString([[
AutoPartyName < Label
  height: 18
  focusable: true
  background-color: alpha
  opacity: 1.00
  margin-left: 3

  $hover:
    background-color: #696969
    opacity: 0.75

  $focus:
    background-color: #404040
    opacity: 0.90

  Button
    id: remove
    anchors.right: parent.right
    width: 18
    height: 18
    margin-right: 12  
    text: X
    color: #FF4040


AutoPartyListWindow < MainWindow
  text: Panel Auto Party
  size: 450 315
  anchors.centerIn: parent
  margin-top: -60

  FlatPanel
    id: flatP
    anchors.fill: parent
    margin: -6
    margin-top: 2
    margin-bottom: 20

  Label
    id: labeltxtLeader
    text: Party [Invite List]
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 6
    margin-left: 10
    font: verdana-11px-rounded
    text-auto-resize: true

  HorizontalSeparator
    anchors.top: labeltxtLeader.bottom
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    margin-top: 4
    margin-left: 8
    margin-right: 8

  TextEdit
    id: txtLeader
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    margin-top: 5
    margin-left: 8
    margin-right: 8
    height: 20
    placeholder: Leader name

  CheckBox
    id: soulider
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 5
    margin-left: 8
    text: I'm Leader
    text-auto-resize: true

  TextList
    id: lstAutoParty
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    margin-top: 6
    margin-left: 8
    margin-right: 8
    height: 120
    padding: 1
    vertical-scrollbar: AutoPartyListListScrollBar

  VerticalScrollBar
    id: AutoPartyListListScrollBar
    anchors.top: lstAutoParty.top
    anchors.bottom: lstAutoParty.bottom
    anchors.right: lstAutoParty.right
    step: 14
    pixels-scroll: true

  TextEdit
    id: playerName
    anchors.top: lstAutoParty.bottom
    anchors.left: parent.left
    margin-top: 5
    margin-left: 8
    width: 150
    height: 20
    placeholder: Player Name

  Button
    id: addPlayer
    text: +
    anchors.left: playerName.right
    anchors.top: playerName.top
    width: 40
    height: 18
    margin-left: 5

  CheckBox
    id: creatureMove
    anchors.top: playerName.bottom
    anchors.left: parent.left
    margin-top: 6
    margin-left: 8
    text: Automatic Invite
    text-auto-resize: true

  CheckBox
    id: autoShare
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 6
    margin-left: 8
    text: Auto Sharear
    text-auto-resize: true

  VerticalSeparator
    anchors.top: parent.top
    anchors.bottom: flatP.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    margin-top: 6
    margin-bottom: 6

  Label
    text: Party [Say "PT"]
    anchors.top: parent.top
    anchors.left: parent.horizontalCenter
    margin-top: 6
    margin-left: 10
    font: verdana-11px-rounded
    text-auto-resize: true

  HorizontalSeparator
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    margin-top: 4
    margin-left: 8
    margin-right: 8

  TextEdit
    id: palavraInvite
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    margin-top: 5
    margin-left: 8
    margin-right: 8
    height: 20
    placeholder: Keyword

  CheckBox
    id: soulider2
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    margin-top: 5
    margin-left: 8
    text: I'm Leader
    text-auto-resize: true

  Label
    text: Level Minimo:
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    margin-top: 8
    margin-left: 8

  TextEdit
    id: textMinLevel
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    margin-top: 2
    margin-left: 8
    margin-right: 8
    height: 20
    placeholder: Level Minimum

  Label
    text: Level Maximo:
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    margin-top: 5
    margin-left: 8

  TextEdit
    id: textMaxLevel
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    margin-top: 2
    margin-left: 8
    margin-right: 8
    height: 20
    placeholder: Level Maximum

  Button
    id: banList
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    margin-top: 5
    margin-left: 8
    margin-right: 8
    height: 18
    text: Players Ban
    text-auto-resize: true

  TextEdit
    id: palavraPedirPT
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    margin-top: 6
    margin-left: 8
    margin-right: 8
    height: 20
    placeholder: Ask for party

  CheckBox
    id: pedirParty
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    margin-top: 6
    margin-left: 8
    text: Request Party
    text-auto-resize: true

  CheckBox
    id: aceitarParty
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    margin-top: 6
    margin-left: 8
    text: Accept Party
    text-auto-resize: true

  Button
    id: closePanel
    anchors.left: flatP.left
    anchors.right: flatP.right
    anchors.top: flatP.bottom
    margin-top: 5
    height: 20
    text: Close
]])

local rootWidget = g_ui.getRootWidget()
if rootWidget then
  tcAutoParty = autopartyui.status

  autoPartyListWindow = UI.createWindow("AutoPartyListWindow", rootWidget)
  autoPartyListWindow:hide()

  if modules._G.g_app.isMobile() then
    autoPartyListWindow:setSize("450 335")
  end
    
  autopartyui.status.onMouseRelease = function(widget, mousePos, mouseButton)
    if mouseButton == 2 then
      if not autoPartyListWindow:isVisible() then
        autoPartyListWindow:show()
        autoPartyListWindow:raise()
        autoPartyListWindow:focus()
      else
        autoPartyListWindow:hide()
      end
    end
  end

  autopartyui.editPlayerList.onClick = function()
    autoPartyListWindow:show()
    autoPartyListWindow:raise()
    autoPartyListWindow:focus()
  end

  autoPartyListWindow.closePanel.onClick = function()
    autoPartyListWindow:hide()
  end

  -- =========================
  -- LISTA
  -- =========================
  if cfgParty.autoPartyList and #cfgParty.autoPartyList > 0 then
    for _, pName in ipairs(cfgParty.autoPartyList) do
      local label = g_ui.createWidget("AutoPartyName", autoPartyListWindow.lstAutoParty)
      label.remove.onClick = function()
        table.removevalue(cfgParty.autoPartyList, label:getText())
        label:destroy()
        saveAutoParty()
      end
      label:setText(pName)
    end
  end

  autoPartyListWindow.addPlayer.onClick = function()
    local pName = autoPartyListWindow.playerName:getText()
    if pName:len() > 0 and not (table.contains(cfgParty.autoPartyList, pName, true) or cfgParty.leaderName == pName) then
      table.insert(cfgParty.autoPartyList, pName)
      saveAutoParty()

      local label = g_ui.createWidget("AutoPartyName", autoPartyListWindow.lstAutoParty)
      label.remove.onClick = function()
        table.removevalue(cfgParty.autoPartyList, label:getText())
        label:destroy()
        saveAutoParty()
      end
      label:setText(pName)
      autoPartyListWindow.playerName:setText("")
    end
  end

  autoPartyListWindow.playerName.onKeyPress = function(_, keyCode)
    if keyCode ~= 5 then return false end
    autoPartyListWindow.addPlayer.onClick()
    return true
  end

  autoPartyListWindow.playerName.onTextChange = function(_, text)
    if table.contains(cfgParty.autoPartyList, text, true) then
      autoPartyListWindow.addPlayer:setColor("#FF0000")
    else
      autoPartyListWindow.addPlayer:setColor("#FFFFFF")
    end
  end

  -- =========================
  -- ENABLE
  -- =========================
  tcAutoParty:setOn(cfgParty.enabled == true)
  tcAutoParty.onClick = function(widget)
    cfgParty.enabled = not (cfgParty.enabled == true)
    widget:setOn(cfgParty.enabled)
    saveAutoParty()
  end

  -- =========================
  -- AUTOMATIC INVITE
  -- =========================
  autoPartyListWindow.creatureMove:setChecked(cfgParty.onMove == true)
  autoPartyListWindow.creatureMove.onClick = function(widget)
    cfgParty.onMove = not (cfgParty.onMove == true)
    widget:setChecked(cfgParty.onMove)
    saveAutoParty()
  end

  -- =========================
  -- TXT LEADER
  -- =========================
  autoPartyListWindow.txtLeader.onTextChange = function(_, text)
    cfgParty.leaderName = text
    saveAutoParty()
  end
  autoPartyListWindow.txtLeader:setText(cfgParty.leaderName or "")

  -- =========================
  -- SOU LIDER
  -- =========================
  autoPartyListWindow.soulider:setChecked(cfgParty.soulider == true)

  local function applySouLider()
    if cfgParty.soulider then
      local myName = player:getName()
      cfgParty.leaderName = myName
      autoPartyListWindow.txtLeader:setText(myName)
    else
      cfgParty.leaderName = ""
      autoPartyListWindow.txtLeader:setText("")
    end
    saveAutoParty()
  end

  autoPartyListWindow.soulider.onClick = function(widget)
    cfgParty.soulider = not (cfgParty.soulider == true)
    widget:setChecked(cfgParty.soulider)
    applySouLider()
  end

  applySouLider()

  -- =========================
  -- AUTO SHAREAR
  -- =========================
  autoPartyListWindow.autoShare:setChecked(cfgParty.autoShare == true)
  autoPartyListWindow.autoShare.onClick = function(widget)
    cfgParty.autoShare = not (cfgParty.autoShare == true)
    widget:setChecked(cfgParty.autoShare)
    saveAutoParty()
  end

  macro(2000, function()
    if not tcAutoParty:isOn() then return end
    if cfgParty.autoShare then
      if player:isPartyLeader() then
        if not player:isPartySharedExperienceActive() then
          g_game.partyShareExperience(true)
        end
      end
    end
  end)

  -- =========================
  -- LADO DIREITO
  -- =========================
  autoPartyListWindow.palavraInvite:setText(cfgParty.palavraInvite or "")
  autoPartyListWindow.palavraInvite.onTextChange = function(_, text)
    cfgParty.palavraInvite = text or ""
    saveAutoParty()
  end

  autoPartyListWindow.soulider2:setChecked(cfgParty.soulider2 == true)
  autoPartyListWindow.soulider2.onClick = function(widget)
    cfgParty.soulider2 = not (cfgParty.soulider2 == true)
    widget:setChecked(cfgParty.soulider2)
    saveAutoParty()
  end

  autoPartyListWindow.textMinLevel:setText(tostring(cfgParty.minLevel or ""))
  autoPartyListWindow.textMinLevel.onTextChange = function(_, text)
    cfgParty.minLevel = text or ""
    saveAutoParty()
  end

  autoPartyListWindow.textMaxLevel:setText(tostring(cfgParty.maxLevel or ""))
  autoPartyListWindow.textMaxLevel.onTextChange = function(_, text)
    cfgParty.maxLevel = text or ""
    saveAutoParty()
  end

  autoPartyListWindow.palavraPedirPT:setText(cfgParty.palavraPedirPT or "")
  autoPartyListWindow.palavraPedirPT.onTextChange = function(_, text)
    cfgParty.palavraPedirPT = text or ""
    saveAutoParty()
  end

  autoPartyListWindow.pedirParty:setChecked(cfgParty.pedirParty == true)
  autoPartyListWindow.pedirParty.onClick = function(widget)
    cfgParty.pedirParty = not (cfgParty.pedirParty == true)
    widget:setChecked(cfgParty.pedirParty)
    saveAutoParty()
  end

  autoPartyListWindow.aceitarParty:setChecked(cfgParty.aceitarParty == true)
  autoPartyListWindow.aceitarParty.onClick = function(widget)
    cfgParty.aceitarParty = not (cfgParty.aceitarParty == true)
    widget:setChecked(cfgParty.aceitarParty)
    saveAutoParty()
  end

  -- =========================
  -- BAN LIST
  -- =========================
  g_ui.loadUIFromString([[
AutoPartyBanName < Label
  height: 18
  focusable: true
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #696969
    opacity: 0.75

  $focus:
    background-color: #404040
    opacity: 0.90

  Button
    id: remove
    anchors.right: parent.right
    width: 16
    height: 16
    margin-right: 4
    text: X
    color: #FF4040


AutoPartyBanWindow < MainWindow
  text: Panel Party-Bans
  size: 280 290
  anchors.centerIn: parent

  FlatPanel
    id: flatP
    anchors.fill: parent
    margin: -2
    margin-top: 2
    margin-bottom: 20

  Label
    text: Players Banidos
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    margin-top: 6
    font: verdana-11px-rounded
    text-auto-resize: true

  HorizontalSeparator
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 4
    margin-left: 8
    margin-right: 8

  TextList
    id: lstBan
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    margin-left: 8
    margin-right: 8
    height: 165
    padding: 1

  TextEdit
    id: txtBan
    anchors.left: parent.left
    anchors.top: lstBan.bottom
    margin-top: 6
    margin-left: 8
    width: 205
    height: 20
    placeholder: Player Name

  Button
    id: btnAdd
    text: +
    anchors.left: txtBan.right
    anchors.right: parent.right
    anchors.top: txtBan.top
    height: 20
    margin-left: 5
    margin-right: 8

  Button
    id: closePanel
    anchors.left: flatP.left
    anchors.right: flatP.right
    anchors.top: flatP.bottom
    margin-top: 5
    height: 20
    text: Close
]])

  local banWindow = UI.createWindow("AutoPartyBanWindow", rootWidget)
  banWindow:hide()

  local function reloadBanList()
    banWindow.lstBan:destroyChildren()
    for _, name in ipairs(cfgParty.banListPlayers or {}) do
      local row = g_ui.createWidget("AutoPartyBanName", banWindow.lstBan)
      row:setText(name)
      row.remove.onClick = function()
        table.removevalue(cfgParty.banListPlayers, row:getText())
        row:destroy()
        saveAutoParty()
      end
    end
  end

  reloadBanList()

  banWindow.btnAdd.onClick = function()
    local name = banWindow.txtBan:getText()
    if not name or name:len() == 0 then return end

    if not table.contains(cfgParty.banListPlayers, name, true) then
      table.insert(cfgParty.banListPlayers, name)
      saveAutoParty()
      reloadBanList()
    end

    banWindow.txtBan:setText("")
  end

  banWindow.txtBan.onKeyPress = function(_, keyCode)
    if keyCode ~= 5 then return false end
    banWindow.btnAdd.onClick()
    return true
  end

  banWindow.closePanel.onClick = function()
    banWindow:hide()
  end

  autoPartyListWindow.banList.onClick = function()
    reloadBanList()
    banWindow:show()
    banWindow:raise()
    banWindow:focus()
  end

  -- =========================
  -- MENSAGENS
  -- =========================
  onTextMessage(function(mode, text)
    if not tcAutoParty:isOn() then return end
    if mode ~= 20 then return end

    if text:find("has joined the party") then
      local data = regexMatch(text, "([a-z A-Z-]*) has joined the party")[1][2]
      if data and table.contains(cfgParty.autoPartyList, data, true) then
        if cfgParty.autoShare and not player:isPartySharedExperienceActive() then
          g_game.partyShareExperience(true)
        end
      end
      return
    end

    if text:find("has invited you") then
      if player:getName():lower() == (cfgParty.leaderName or ""):lower() then
        return
      end

      local data = regexMatch(text, "([a-z A-Z-]*) has invited you")[1][2]
      if data and (cfgParty.leaderName or ""):lower() == data:lower() then
        local leader = getCreatureByName(data, true)
        if leader then
          g_game.partyJoin(leader:getId())
          return
        end
      end
    end
  end)

  -- =========================
  -- INVITES
  -- =========================
  local function creatureInvites(creature)
    if not creature:isPlayer() or creature == player then return end

    if creature:getName():lower() == (cfgParty.leaderName or ""):lower() then
      if creature:getShield() == 1 then
        g_game.partyJoin(creature:getId())
        return
      end
    end

    if player:getName():lower() ~= (cfgParty.leaderName or ""):lower() then return end
    if not table.contains(cfgParty.autoPartyList, creature:getName(), true) then return end
    if creature:isPartyMember() or creature:getShield() == 2 then return end

    g_game.partyInvite(creature:getId())
  end

  onCreatureAppear(function(creature)
    if tcAutoParty:isOn() then
      creatureInvites(creature)
    end
  end)

  onCreaturePositionChange(function(creature)
    if tcAutoParty:isOn() and cfgParty.onMove then
      creatureInvites(creature)
    end
  end)
end

-- =====================================================
-- == LÓGICA COMPLETA AUTO PARTY
-- =====================================================
local infoTime = 0
local talkTime = 0
local justForInfo = true
local canSeeInfo = true
local partyMembersCount = 0

local lastInfoAt = 0
local lastUnlockAt = 0

local lastCloseAt = 0

macro(1000, function()
  if not cfgParty.enabled then return end

  local now = os.time()

  if fecharPaineis and fecharPaineis > 0 and now <= fecharPaineis then
    if lastCloseAt == 0 or (now - lastCloseAt) >= 3 then
      local root = g_ui.getRootWidget()
      if root then
        for _, widget in ipairs(root:recursiveGetChildren()) do
          if widget:getStyleName() == 'MessageBoxLabel' then
            local parent = widget:getParent()
            if parent and parent.destroy then
              parent:destroy()
            end
            lastCloseAt = now
            break
          end
        end
      end
    end
  end

  if not cfgParty.soulider2 then
    justForInfo = true
    partyMembersCount = 0
    infoTime = 0
    lastInfoAt = 0
    canSeeInfo = true
    return
  end

  if not player:isPartyLeader() then
    justForInfo = true
    partyMembersCount = 0
    infoTime = 0
    lastInfoAt = 0
    canSeeInfo = true
    return
  end

  if not canSeeInfo then
    if lastUnlockAt == 0 then lastUnlockAt = now end
    if (now - lastUnlockAt) >= 3 then
      canSeeInfo = true
      lastUnlockAt = 0
    end
  end

  if justForInfo and canSeeInfo then
    local partyId = getChannelId("party")
    if partyId then
      sayChannel(partyId, "!party info")
    else
      say("!party info")
    end

    fecharPaineis = now + 5
    lastInfoAt = now
    return
  end

  if canSeeInfo and (lastInfoAt == 0 or (now - lastInfoAt) >= 15) then
    local partyId = getChannelId("party")
    if partyId then
      sayChannel(partyId, "!party info")
    else
      say("!party info")
    end

    fecharPaineis = now + 5
    lastInfoAt = now
    return
  end

  if talkTime > 0 then
    talkTime = talkTime - 1
  end
end)

onLoginAdvice(function(text)
  if not cfgParty.enabled or not cfgParty.soulider2 then return end
  if not player:isPartyLeader() then return end

  local explode1 = string.explode(text, "*")
  local explode2 = string.explode(explode1[8], ":")[2]

  local rawMax = tonumber(string.explode(explode1[4], ":")[2]) or 0
  local rawMin = tonumber(string.explode(explode1[3], ":")[2]) or 0
  
  local calcMax = math.ceil(rawMax * 1.5)
  local calcMin = math.ceil(rawMin * 0.66)

  cfgParty.maxLevel = tostring(calcMax)
  cfgParty.minLevel = tostring(calcMin)
  saveAutoParty()

  autoPartyListWindow.textMaxLevel:setText(cfgParty.maxLevel)
  autoPartyListWindow.textMinLevel:setText(cfgParty.minLevel)

  partyMembersCount = tonumber(string.explode(explode1[2], ":")[2])
  if justForInfo then
    justForInfo = false
    return
  end

  if explode2:find(",") then
    local names = string.explode(explode2, ",")
    for i = 1, #names do
      canSeeInfo = false
      schedule(10 * i, function()
        if i == #names then
          canSeeInfo = true
        end
        sayChannel(getChannelId("party"), "!party kick," .. names[i])
      end)
    end
  elseif explode2 ~= "" then
    schedule(10, function() sayChannel(getChannelId("party"), "!party kick," .. explode2) end)
  end
end)

onTalk(function(name, level, mode, text, channelId, pos)
  if not cfgParty.enabled or not cfgParty.soulider2 then return end
  if name == player:getName() then return end

  local keyword = cfgParty.palavraInvite:lower()
  if keyword == "" then return end

  if text:lower():find(keyword) then
    if table.contains(cfgParty.banListPlayers, name, true) then
      g_game.talkPrivate(5, name, "You are banned from my party.")
      return
    end

    local minL = tonumber(cfgParty.minLevel) or 0
    local maxL = tonumber(cfgParty.maxLevel) or 9999
    if level < minL or level > maxL then
      g_game.talkPrivate(5, name, "Min level: " .. minL .. " | Max level: " .. maxL)
      return
    end

    if partyMembersCount >= 30 then
      g_game.talkPrivate(5, name, "Party is full (30 members).")
      return
    end

    local spec = getCreatureByName(name)
    if spec then
      if spec:isPartyMember() or spec:getShield() == 2 then return end
      g_game.partyInvite(spec:getId())
    end
  end
end)

local lastAppearTalk = 0
onCreatureAppear(function(creature)
  if not cfgParty.enabled or not cfgParty.soulider2 then return end
  if not creature:isPlayer() or creature:isLocalPlayer() then return end

  if creature:isPartyMember() or creature:getShield() == 2 then return end

  local now = os.time()

  if partyMembersCount < 30 and (lastAppearTalk == 0 or (now - lastAppearTalk) >= 10) then
    local key = cfgParty.palavraInvite
    if key and key ~= "" then
      say("Fale '" .. key .. "' para ser invitado na party!")
      lastAppearTalk = now
    end
  end
end)

onTextMessage(function(mode, text)
  if not cfgParty.enabled or not cfgParty.soulider2 then return end
  
  local t = text:lower()
  if t:find("you are now the leader") or t:find("has joined the party") or (t:find("has left the party") and canSeeInfo) then
    justForInfo = true
  end

  if t:find("level para compartilhamento") then
    local lMax, lMin = text:match("de (%d+) até (%d+)")
    if lMin and lMax then
      cfgParty.minLevel = lMin
      cfgParty.maxLevel = lMax
      saveAutoParty()

      autoPartyListWindow.textMinLevel:setText(lMin)
      autoPartyListWindow.textMaxLevel:setText(lMax)
    end
  end
end)

local lastsayparty = 0
macro(200, function()
  if not cfgParty.enabled then return end
  if not cfgParty.pedirParty then return end

  if player:getShield() > 2 then return end

  local frase = cfgParty.palavraPedirPT
  if not frase or frase == "" then return end

  local now = os.time()

  if (lastsayparty == 0 or (now - lastsayparty) >= 10) then
    say(frase)
    lastsayparty = now
  end
end)

macro(200, function()
  if not cfgParty.enabled then return end
  if not cfgParty.aceitarParty then return end

  if player:getShield() > 2 then return end

  for _, spec in pairs(getSpectators(false)) do
    if spec:isPlayer() and spec:getShield() == 1 then
      g_game.partyJoin(spec:getId())
      return
    end
  end
end)

UI.Separator()

charStorage = charStorage or loadCharStorage()

local function saveEatFood()
  saveCharStorage(charStorage)
end

charStorage.eatFoodSystem = charStorage.eatFoodSystem or {
  enabled = false,
  foodItems = {3582, 3577}
}

local foodCfg = charStorage.eatFoodSystem

if type(foodCfg.foodItems) ~= "table" then
  foodCfg.foodItems = {3582, 3577}
  saveEatFood()
end

eatFood = setupUI([[
Panel
  height: 19

  BotSwitch
    id: eatFood
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: Eat Food
    height: 18
    color: white
]])

eatFood.eatFood:setOn(foodCfg.enabled)

eatFood.eatFood.onClick = function(widget)
  foodCfg.enabled = not widget:isOn()
  widget:setOn(foodCfg.enabled)
  saveEatFood()
end

local foodContainer = UI.Container(function(widget, items)
  foodCfg.foodItems = items
  saveEatFood()
end, true)

foodContainer:setHeight(35)
foodContainer:setItems(foodCfg.foodItems)

local function getFoodIds()
  local ids = {}

  for _, entry in pairs(foodCfg.foodItems or {}) do
    local id = nil

    if type(entry) == "table" then
      id = tonumber(entry.id)
    else
      id = tonumber(entry)
    end

    if id and id > 0 then
      table.insert(ids, id)
    end
  end

  return ids
end

local nextFoodUse = 0

macro(500, function()
  if not foodCfg.enabled then return end

  local isOldClient = g_game.getClientVersion() <= 960

  if isOldClient then
    if nextFoodUse > now then
      return
    end
  else
    if player:getRegenerationTime() > 400 then
      return
    end
  end

  local foodIds = getFoodIds()
  if #foodIds == 0 then return end

  for _, foodId in ipairs(foodIds) do
    use(foodId)

    -- fallback antigo
    local item = findItem(foodId)
    if item then
      use(item)

      if isOldClient then
        nextFoodUse = now + 60000
      end

      return
    end
  end
end)

----------------------------------
--------STAMINA
----------------------------------
UI.Separator()

charStorage = charStorage or loadCharStorage()

charStorage.staminaUse = charStorage.staminaUse or {
  enabled = false,
  itemId = 0,
  value = 1
}

local staminaCfg = charStorage.staminaUse

local function saveStaminaUse()
  saveCharStorage(charStorage)
end

stamina = setupUI([[
Panel
  height: 55

  BotItem
    id: staminaId
    anchors.top: parent.top
    anchors.left: parent.left

  Label
    id: Labelstamina
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 8
    height: 18
    text-align: center
    text: Stamina: 1h
    color: gray

  HorizontalScrollBar
    id: stamina
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 2
    minimum: 1
    maximum: 43

  BotSwitch
    id: staminacheck
    anchors.top: staminaId.bottom
    anchors.left: staminaId.left
    anchors.right: prev.right
    height: 18
    text: Use Stamina
    color: white
    margin-top: 5
]])

local function updateStaminaLabel()
  stamina.Labelstamina:setText("Stamina: " .. tostring(staminaCfg.value or 1) .. "h")
end

if stamina.staminaId.setItemId then
  stamina.staminaId:setItemId(staminaCfg.itemId or 0)
end

stamina.staminaId.onItemChange = function(widget)
  staminaCfg.itemId = widget:getItemId()
  saveStaminaUse()
end

stamina.stamina:setValue(staminaCfg.value or 1)
updateStaminaLabel()

stamina.stamina.onValueChange = function(widget, value)
  staminaCfg.value = value
  updateStaminaLabel()
  saveStaminaUse()
end

stamina.staminacheck:setOn(staminaCfg.enabled == true)

stamina.staminacheck.onClick = function(widget)
  staminaCfg.enabled = not widget:isOn()
  widget:setOn(staminaCfg.enabled)
  saveStaminaUse()
end

macro(1000, function()
  if staminaCfg.enabled ~= true then return end

  local itemId = tonumber(staminaCfg.itemId or 0)
  if itemId <= 0 then return end

  local minStamina = (tonumber(staminaCfg.value) or 1) * 60

  if player:getStamina() <= minStamina then
    use(itemId)
    delay(5000)
  end
end)

------------------------------
--- VIPWARD / WARN DISCORD
------------------------------
UI.Separator()

charStorage = charStorage or loadCharStorage()

charStorage.warnDiscord = charStorage.warnDiscord or {
  enabled = false,
  location = "",
  webhook = "",
  warnGuild = false,
  warnPlayer = false,
  delayWarn = 5,
  sayGuild = false,
  discordWarn = false,
  guildList = "",
  playerList = ""
}

local warnCfg = charStorage.warnDiscord

warnCfg.enabled = warnCfg.enabled == true
warnCfg.location = tostring(warnCfg.location or "")
warnCfg.webhook = tostring(warnCfg.webhook or "")
warnCfg.warnGuild = warnCfg.warnGuild == true
warnCfg.warnPlayer = warnCfg.warnPlayer == true
warnCfg.delayWarn = tonumber(warnCfg.delayWarn) or 5
warnCfg.sayGuild = warnCfg.sayGuild == true
warnCfg.discordWarn = warnCfg.discordWarn == true
warnCfg.guildList = tostring(warnCfg.guildList or "")
warnCfg.playerList = tostring(warnCfg.playerList or "")

local function saveWarn()
  saveCharStorage(charStorage)
end

local cachedPlayerList = {}
local cachedGuildList = {}

local function trimWarn(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function splitList(text)
  local t = {}
  for v in tostring(text or ""):gmatch("[^,]+") do
    v = trimWarn(v):lower()
    if v ~= "" then
      t[v] = true
    end
  end
  return t
end

local function rebuildLists()
  cachedPlayerList = splitList(warnCfg.playerList)
  cachedGuildList = splitList(warnCfg.guildList)
end

rebuildLists()

warnButton = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Warn Discord
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

warnInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 260 315
  text: Warn Discord
  margin-top: -50

  FlatPanel
    id: flatp
    anchors.fill: parent
    margin: -6
    margin-top: 2
    margin-bottom: 20

    Label
      id: labelLocation
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 5
      text: Location to Warn:

    BotTextEdit
      id: Location
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-right: 5
      margin-top: 5
      placeholder: Insert Text Location
      text-align: left

    Label
      id: labelDiscord
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      text: Link Webhook:

    BotTextEdit
      id: Webhook
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      placeholder: Insert Link Discord Webhook
      text-align: left
      
    HorizontalSeparator
      id: sep1
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5

    Button
      id: filtroGuild
      anchors.top: prev.bottom
      margin-top: 5
      anchors.left: prev.left
      anchors.right: prev.right
      text: List Guilds
      height: 18

    Button
      id: filtroPlayers
      anchors.top: prev.bottom
      margin-top: 2
      anchors.left: prev.left
      anchors.right: prev.right
      text: List Players
      height: 18

    BotSwitch
      id: WarnGuild
      anchors.top: prev.bottom
      anchors.left: prev.left
      margin-top: 5
      width: 115
      text: Warn Guild

    BotSwitch
      id: WarnPlayer
      anchors.top: filtroPlayers.bottom
      anchors.right: filtroPlayers.right
      margin-top: 5
      width: 115
      text: Warn Players

    HorizontalSeparator
      id: sep2
      anchors.top: prev.bottom
      anchors.left: filtroPlayers.left
      anchors.right: filtroPlayers.right
      margin-top: 5

    Label
      id: LabelDelay
      anchors.top: prev.bottom
      margin-top: 5
      anchors.left: prev.left
      anchors.right: prev.right
      text: Delay to Warn: 5s
      text-align: center

    HorizontalScrollBar
      id: delayWarn
      anchors.top: prev.bottom
      margin-top: 5
      anchors.left: prev.left
      anchors.right: prev.right
      step: 1
      minimum: 1
      maximum: 30

    BotSwitch
      id: ativarGuild
      anchors.top: prev.bottom
      anchors.right: prev.right
      anchors.left: prev.left
      margin-top: 5
      text: Say Guild Chat

    BotSwitch
      id: ativarDiscord
      anchors.top: prev.bottom
      anchors.right: prev.right
      anchors.left: prev.left
      margin-top: 5
      text: Active Discord Warn
    
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

warnInterface:hide()

if modules._G.g_app.isMobile() then
  warnInterface:setSize("260 335")
end

local function updateDelay()
  warnInterface.flatp.LabelDelay:setText("Delay to Warn: " .. tostring(warnCfg.delayWarn or 5) .. "s")
end

warnInterface.flatp.Location:setText(warnCfg.location)
warnInterface.flatp.Webhook:setText(warnCfg.webhook)
warnInterface.flatp.delayWarn:setValue(warnCfg.delayWarn)
warnInterface.flatp.WarnGuild:setOn(warnCfg.warnGuild)
warnInterface.flatp.WarnPlayer:setOn(warnCfg.warnPlayer)
warnInterface.flatp.ativarGuild:setOn(warnCfg.sayGuild)
warnInterface.flatp.ativarDiscord:setOn(warnCfg.discordWarn)
warnButton.title:setOn(warnCfg.enabled)

updateDelay()

warnInterface.flatp.Location.onTextChange = function(_, text)
  warnCfg.location = tostring(text or "")
  saveWarn()
end

warnInterface.flatp.Webhook.onTextChange = function(_, text)
  warnCfg.webhook = tostring(text or "")
  saveWarn()
end

warnInterface.flatp.delayWarn.onValueChange = function(_, value)
  warnCfg.delayWarn = tonumber(value) or 5
  updateDelay()
  saveWarn()
end

warnInterface.flatp.WarnGuild.onClick = function(widget)
  warnCfg.warnGuild = not widget:isOn()
  widget:setOn(warnCfg.warnGuild)
  saveWarn()
end

warnInterface.flatp.WarnPlayer.onClick = function(widget)
  warnCfg.warnPlayer = not widget:isOn()
  widget:setOn(warnCfg.warnPlayer)
  saveWarn()
end

warnInterface.flatp.ativarGuild.onClick = function(widget)
  warnCfg.sayGuild = not widget:isOn()
  widget:setOn(warnCfg.sayGuild)
  saveWarn()
end

warnInterface.flatp.ativarDiscord.onClick = function(widget)
  warnCfg.discordWarn = not widget:isOn()
  widget:setOn(warnCfg.discordWarn)
  saveWarn()
end

warnButton.title.onClick = function(widget)
  warnCfg.enabled = not widget:isOn()
  widget:setOn(warnCfg.enabled)
  saveWarn()
end

warnButton.settings.onClick = function()
  if warnInterface:isVisible() then
    warnInterface:hide()
  else
    warnInterface:show()
    warnInterface:raise()
    warnInterface:focus()
  end
end

warnInterface.closePanel.onClick = function()
  warnInterface:hide()
end

g_ui.loadUIFromString([[
LnsWarnListWindow < MainWindow
  id: mainPanel
  size: 420 300
  text: Setup List
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
      font: verdana-11px-rounded
      text: Lista

    Label
      id: descLabel
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 8
      margin-right: 8
      text-align: center
      text-wrap: true
      height: 30
      text: Insira os nomes separados por virgula ou um por linha.

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

local warnListWindow = nil

local function cleanListText(text)
  text = tostring(text or "")
  text = text:gsub("\r", "")
  text = text:gsub("\n", ",")
  text = text:gsub(",+", ",")
  text = text:gsub("^,", "")
  text = text:gsub(",$", "")
  return text
end

local function storageListToText(text)
  return tostring(text or ""):gsub(",", "\n")
end

local function openWarnListWindow(title, desc, storageKey)
  if warnListWindow then
    warnListWindow:destroy()
    warnListWindow = nil
  end

  warnListWindow = UI.createWindow("LnsWarnListWindow", g_ui.getRootWidget())
  warnListWindow:setText(title)
  warnListWindow.flatp.titleLabel:setText(title)
  warnListWindow.flatp.descLabel:setText(desc)
  warnListWindow.flatp.listText:setText(storageListToText(warnCfg[storageKey]))

  warnListWindow:show()
  warnListWindow:raise()
  warnListWindow:focus()

  warnListWindow.ok.onClick = function()
    warnCfg[storageKey] = cleanListText(warnListWindow.flatp.listText:getText())
    rebuildLists()
    saveWarn()

    warnListWindow:destroy()
    warnListWindow = nil

    if modules.game_textmessage then
      modules.game_textmessage.displayBroadcastMessage(title .. " salva com sucesso!", "#00FF00")
    end
  end

  warnListWindow.cancel.onClick = function()
    warnListWindow:destroy()
    warnListWindow = nil
  end
end

warnInterface.flatp.filtroGuild.onClick = function()
  openWarnListWindow(
    "LIST GUILDS",
    "Insira uma guild por linha ou separada por virgula.",
    "guildList"
  )
end

warnInterface.flatp.filtroPlayers.onClick = function()
  openWarnListWindow(
    "LIST PLAYERS",
    "Insira um player por linha ou separado por virgula.",
    "playerList"
  )
end

local playerInfos = {}
local lastWarnCheck = 0
local lastLookCheck = 0
local foundLook = 0

local function getVoc(text)
  text = tostring(text or ""):lower()

  if text:find("sorcerer") then return "MS" end
  if text:find("druid") then return "ED" end
  if text:find("knight") then return "EK" end
  if text:find("paladin") then return "RP" end
  if text:find("monk") then return "EM" end

  return ""
end

local function getWarnPlayersOnScreen()
  local list = {}

  for _, spec in ipairs(getSpectators() or {}) do
    if spec and spec:isPlayer() and spec ~= player and spec:getPosition().z == posz() then
      table.insert(list, spec)
    end
  end

  return list
end

local function requestLookPlayers(force)
  if not force and now - lastLookCheck < 3000 then return end
  lastLookCheck = now

  for _, spec in ipairs(getWarnPlayersOnScreen()) do
    local name = spec:getName()
    if name then
      local info = playerInfos[name:lower()]
      if force or not info or now - (info.updated or 0) > 10000 then
        g_game.look(spec)
        foundLook = now
      end
    end
  end
end

local lookRegex = [[You see ([^\(]*) \(Level ([0-9]*)\)((?:.)* of the ([\w ]*),|)]]

onTextMessage(function(mode, text)
  if not warnCfg.enabled then return end

  local re = regexMatch(text, lookRegex)
  if #re == 0 then return end

  local name = trimWarn(re[1][2])
  local level = trimWarn(re[1][3])
  local guild = trimWarn(re[1][5] or "")
  local voc = getVoc(text)

  if name == "" then return end

  playerInfos[name:lower()] = {
    name = name,
    level = level,
    guild = guild,
    voc = voc,
    updated = now
  }

  local creature = getCreatureByName(name)
  if creature then
    local showGuild = guild
    if showGuild:len() > 10 then
      showGuild = showGuild:sub(1, 10) .. "..."
    end
    creature:setText("\n" .. level .. voc .. "\n" .. showGuild)
  end

  if foundLook and now - foundLook < 500 and modules.game_textmessage then
    modules.game_textmessage.clearMessages()
  end
end)

onCreatureAppear(function(creature)
  if not warnCfg.enabled then return end
  if not creature or not creature:isPlayer() then return end
  if creature == player then return end
  if creature:getPosition().z ~= posz() then return end

  schedule(200, function()
    if creature and creature:isPlayer() and creature:getPosition().z == posz() then
      local name = creature:getName()
      if name and not playerInfos[name:lower()] then
        g_game.look(creature)
        foundLook = now
      end
    end
  end)
end)

onPlayerPositionChange(function(newPos, oldPos)
  if not warnCfg.enabled then return end
  if not newPos or not oldPos then return end

  if newPos.z ~= oldPos.z then
    schedule(500, function()
      requestLookPlayers(true)
    end)
  end
end)

local function isTarget(info)
  if not info then return false end

  local name = tostring(info.name or ""):lower()
  local guild = tostring(info.guild or ""):lower()

  if warnCfg.warnPlayer == true and cachedPlayerList[name] then return true end
  if warnCfg.warnGuild == true and cachedGuildList[guild] then return true end

  return false
end

local function sendDiscord(data)
  if tostring(warnCfg.webhook or "") == "" then return end
  if not HTTP or not HTTP.postJSON then return end

  local payload = {
    username = "LNS Custom",
    embeds = {{
      title = "[LNS] Player Detection",
      color = 10038562,
      fields = {
        { name = "Local:", value = tostring(data.location or "-") },
        { name = "Amount Players on Screen:", value = tostring(data.amountScreen or 0) },
        { name = "Amount Players list:", value = tostring(data.amountList or 0) },
        { name = "Name:", value = tostring(data.name or "-") },
        { name = "Guild:", value = tostring(data.guild or "-") },
        { name = "Level:", value = tostring(data.level or "-") },
        { name = "Voc:", value = tostring(data.voc or "-") }
      },
      footer = {
        text = "LNS Custom"
      }
    }}
  }

  HTTP.postJSON(warnCfg.webhook, payload, function(_, err)
    if err then
      print("Discord Webhook Error: " .. tostring(err))
    end
  end)
end

macro(1000, function()
  if warnCfg.enabled ~= true then return end

  local delaySec = tonumber(warnCfg.delayWarn) or 5
  if now - lastWarnCheck < delaySec * 1000 then return end
  lastWarnCheck = now

  requestLookPlayers(false)

  local players = getWarnPlayersOnScreen()
  local amountScreen = #players
  local matched = {}

  for _, creature in ipairs(players) do
    local name = creature:getName()
    local info = name and playerInfos[name:lower()]

    if info and isTarget(info) then
      matched[name:lower()] = info
    end
  end

  local amountList = 0
  for _ in pairs(matched) do
    amountList = amountList + 1
  end

  if amountList <= 0 then return end

  for _, info in pairs(matched) do
    if warnCfg.discordWarn == true then
      sendDiscord({
        location = warnCfg.location,
        amountScreen = amountScreen,
        amountList = amountList,
        name = info.name,
        guild = info.guild ~= "" and info.guild or "-",
        level = info.level,
        voc = info.voc ~= "" and info.voc or "-"
      })
    end

    if warnCfg.sayGuild == true then
      local ch = getChannelId and getChannelId("guild")
      if ch then
        sayChannel(ch, "[LNS] Player Detection: " .. info.name .. " | Guild: " .. (info.guild ~= "" and info.guild or "-") .. " | Level: " .. info.level .. " | Voc: " .. (info.voc ~= "" and info.voc or "-"))
      end
    end
  end
end)

macro(30000, function()
  local fresh = {}
  for k, info in pairs(playerInfos) do
    if info.updated and now - info.updated < 60000 then
      fresh[k] = info
    end
  end
  playerInfos = fresh
end)

UI.Separator()

if not loadCharStorage or not saveCharStorage then
  return print("[Dummy Train] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function saveDummyChar()
  saveCharStorage(charStorage)
end

local panelName = "Dummy Train"

charStorage[panelName] = charStorage[panelName] or {
  id = 28557,
  id2 = 28559,
  enabled = false,
  training = false,
  lastStart = 0,
  lastTry = 0,
  lastUsePos = nil
}

local cfg = charStorage[panelName]

cfg.training = false
cfg.lastStart = 0
cfg.lastTry = 0
cfg.lastUsePos = nil

local ui = setupUI([[
Panel
  height: 80

  Label
    id: itemLabel
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 5
    margin-left: 2
    text: Exercise
    text-auto-resize: true
    font: verdana-11px-rounded
    color: lightGray

  Label
    id: targetLabel
    anchors.top: parent.top
    anchors.right: parent.right
    margin-top: 5
    margin-right: 12
    text: Dummy
    font: verdana-11px-rounded
    color: lightGray

  BotItem
    id: item
    anchors.top: itemLabel.bottom
    anchors.left: itemLabel.left
    margin-top: 3
    margin-left: 9

  BotItem
    id: Target
    anchors.top: targetLabel.bottom
    anchors.right: targetLabel.right
    margin-top: 3
    margin-right: 6

  BotSwitch
    id: title
    anchors.top: item.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    height: 18
    text-align: center
    !text: tr('Dummy Train')
]], parent)

ui:setId(panelName)

ui.title:setOn(cfg.enabled)

ui.title.onClick = function(widget)
  cfg.enabled = not cfg.enabled
  widget:setOn(cfg.enabled)

  if not cfg.enabled then
    cfg.training = false
    cfg.lastStart = 0
    cfg.lastTry = 0
  end

  saveDummyChar()
end

ui.item:setItemId(cfg.id)

ui.item.onItemChange = function(widget)
  cfg.id = widget:getItemId()
  saveDummyChar()
end

ui.Target:setItemId(cfg.id2)

ui.Target.onItemChange = function(widget)
  cfg.id2 = widget:getItemId()
  saveDummyChar()
end

function setDummyOff()
  cfg.enabled = false
  cfg.training = false
  cfg.lastStart = 0
  cfg.lastTry = 0

  ui.title:setOn(false)

  saveDummyChar()
end

function setDummyOn()
  cfg.enabled = true

  ui.title:setOn(true)

  saveDummyChar()
end

local function safeLower(s)
  return tostring(s or ""):lower()
end

local function isDummyTile(tile)
  if not tile then return false end

  local top = tile:getTopUseThing()
  if not top then return false end

  return top:getId() == cfg.id2
end

local function getClosestDummy()
  local playerPos = pos()
  if not playerPos then return nil end

  local bestTile = nil
  local bestDist = 999

  for _, tile in ipairs(g_map.getTiles(posz())) do
    if isDummyTile(tile) then
      local tPos = tile:getPosition()

      if tPos and tPos.z == playerPos.z then
        local dist = getDistanceBetween(playerPos, tPos)

        if dist <= 7 and dist < bestDist then
          bestDist = dist
          bestTile = tile
        end
      end
    end
  end

  return bestTile
end

local function tryStartTraining()
  local tile = getClosestDummy()
  if not tile then return false end

  local top = tile:getTopUseThing()
  if not top then return false end

  cfg.lastTry = now
  cfg.lastUsePos = tile:getPosition()

  useWith(cfg.id, top)

  return true
end

onTextMessage(function(mode, text)
  if not cfg.enabled then return end

  local msg = safeLower(text)

  if msg:find("you started your training", 1, true) then
    cfg.training = true
    cfg.lastStart = now
    return
  end

  if msg:find("your training has stopped", 1, true)
  or msg:find("your training has been canceled", 1, true)
  or msg:find("training has ended", 1, true)
  or msg:find("you are not training", 1, true)
  or msg:find("there is no dummy", 1, true)
  or msg:find("not possible", 1, true)
  or msg:find("you are too far away", 1, true) then
    cfg.training = false
    cfg.lastStart = 0
    cfg.lastTry = now
    return
  end
end)

macro(500, function()
  if not cfg.enabled then return end

  local tile = getClosestDummy()

  if not tile then
    cfg.training = false
    return
  end

  -- se ja iniciou o treino, NAO USA MAIS O ITEM NO DUMMY
  -- isso evita cancelar/reativar em loop
  if cfg.training then
    return
  end

  -- tenta iniciar somente quando realmente nao esta treinando
  if now - (cfg.lastTry or 0) > 3000 then
    tryStartTraining()
  end
end)


-----------------------------------
---------- HUD
-----------------------------------
if not loadCharStorage or not saveCharStorage then
  return print("[HUD] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local switchHud = "hudButton"
local panelName = "hudInterface"

charStorage[switchHud] = charStorage[switchHud] or {
  enabled = false
}

charStorage[panelName] = charStorage[panelName] or {
  switches = {},
  targetInfoPos = nil
}

charStorage[panelName].switches = charStorage[panelName].switches or {}

local function saveHudChar()
  saveCharStorage(charStorage)
end

local hudCfg = charStorage[panelName]

charStorage[switchHud].enabled = true

--==================================================
-- HUD INTERFACE
--==================================================

hudInterface = setupUI([[
MainWindow
  id: mainPanel
  size: 260 230
  border: 1 black
  anchors.centerIn: parent
  margin-top: -60
  text: HUD Settings

  TextList
    id: panelMain
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    margin-bottom: 25
    margin-top: 0
    margin-right: 7
    margin-left: -3
    height: 235
    vertical-scrollbar: spellListScrollBar
    layout: verticalBox

    BotSwitch
      id: barLifeMana
      margin-top: 10
      margin-right: 5
      width: 25
      text: Life/Mana Bar Edited
      font: verdana-11px-rounded
      image-source: ""
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: white
        opacity: 0.80

    BotSwitch
      id: targetInfo
      margin-top: 10
      margin-right: 5
      width: 25
      text: Target Info
      font: verdana-11px-rounded
      image-source: ""
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: white
        opacity: 0.80

    BotSwitch
      id: taskTracker
      margin-top: 10
      margin-right: 5
      width: 25
      text: Task Ragnar
      font: verdana-11px-rounded
      image-source: ""
      tooltip: Temporariamente Desativado
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: red
        opacity: 0.80

    BotSwitch
      id: comboManager
      margin-top: 10
      margin-right: 5
      width: 25
      text: Manager Attackbot
      font: verdana-11px-rounded
      image-source: ""
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: white
        opacity: 0.80

    BotSwitch
      id: autoBoss
      margin-top: 10
      margin-right: 5
      width: 25
      text: Auto Boss
      font: verdana-11px-rounded
      tooltip: Temporariamente Desativado
      image-source: ""
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: red
        opacity: 0.80
      
  VerticalScrollBar
    id: spellListScrollBar
    anchors.top: panelMain.top
    anchors.bottom: panelMain.bottom
    anchors.left: panelMain.right
    pixels-scroll: true
    image-color: #363636
    margin-top: 0
    margin-bottom: 0
    step: 10

  Button
    id: closePanel
    anchors.left: panelMain.left
    anchors.right: spellListScrollBar.right
    anchors.top: panelMain.bottom
    margin-left: 0
    margin-top: 5
    text: Close
    color: gray
]], g_ui.getRootWidget())

hudInterface:hide()

local function getHudWidget(id)
  if not hudInterface then return nil end
  return hudInterface:recursiveGetChildById(id)
end

local function bindHudSwitch(id)
  local widget = getHudWidget(id)
  if not widget then
    warn("[HUD] Widget nao encontrado: " .. tostring(id))
    return
  end

  if hudCfg.switches[id] == nil then
    hudCfg.switches[id] = false
    saveHudChar()
  end

  widget:setOn(hudCfg.switches[id] == true)

  widget.onClick = function(w)
    local state = not w:isOn()
    w:setOn(state)
    hudCfg.switches[id] = state
    saveHudChar()
  end
end

bindHudSwitch("barLifeMana")
bindHudSwitch("targetInfo")
bindHudSwitch("taskTracker")
bindHudSwitch("comboManager")
bindHudSwitch("autoBoss")

hudInterface.closePanel.onClick = function()
  hudInterface:hide()
end



--==================================================
-- HELPERS HUD
--==================================================

local function hudMasterOn()
  return true
end

local function hudSwitchOn(id)
  return charStorage[panelName]
    and charStorage[panelName].switches
    and charStorage[panelName].switches[id] == true
end

--==================================================
-- LIFE / MANA BAR
--==================================================

local function hpColor(p)
  return "red"
end

local function mpColor(p)
  if p <= 35 then return "#000099" end
  if p <= 75 then return "#3333CC" end
  return "#4D4DFF"
end

local HP_UI = [[
ProgressBar
  id: barHp
  anchors.centerIn: parent
  margin-top: -255
  margin-left: -20
  height: 11
  width: 320
  border: 1 black
  opacity: 0.60
  text-align: center
  background-color: red
]]

local MP_UI = [[
ProgressBar
  id: barMp
  anchors.centerIn: parent
  margin-top: -243
  margin-left: -20
  height: 11
  width: 240
  border: 1 black
  opacity: 0.60
  text-align: center
  background-color: blue
]]

local bars = {
  hp = nil,
  mp = nil
}

local function ensureBars()
  if bars.hp and not bars.hp:isDestroyed() and bars.mp and not bars.mp:isDestroyed() then
    return
  end

  bars.hp = setupUI(HP_UI, g_ui.getRootWidget())
  bars.mp = setupUI(MP_UI, g_ui.getRootWidget())

  bars.hp:hide()
  bars.mp:hide()
end

local function setBarsVisible(v)
  ensureBars()

  if v then
    bars.hp:show()
    bars.mp:show()
  else
    bars.hp:hide()
    bars.mp:hide()
  end
end

local function updateBars()
  if not bars.hp or not bars.mp then return end

  local hp = hppercent()
  local mp = manapercent()

  bars.hp:setPercent(hp)
  bars.hp:setText(string.format("HP: %d%%", hp))
  bars.hp:setBackgroundColor(hpColor(hp))

  bars.mp:setPercent(mp)
  bars.mp:setText(string.format("MP: %d%%", mp))
  bars.mp:setBackgroundColor(mpColor(mp))
end

macro(100, function()
  if not hudMasterOn() or not hudSwitchOn("barLifeMana") then
    setBarsVisible(false)
    return
  end

  setBarsVisible(true)
  updateBars()
end)

--==================================================
-- TARGET INFO
--==================================================

local targetLifeColors = {
  { percent = 35, color = "red" },
  { percent = 75, color = "yellow" },
  { percent = 100, color = "green" }
}

local function getTargetColor(percent)
  for i = 1, #targetLifeColors do
    if percent <= targetLifeColors[i].percent then
      return targetLifeColors[i].color
    end
  end
  return "green"
end

local targetUI = setupUI([[
UIWindow
  id: targetInfoHUD
  anchors.centerIn: parent
  height: 62
  width: 260
  opacity: 1.00
  padding: 4
  background-color: alpha

  UICreature
    id: targetSprite
    width: 70
    height: 80
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: -18
    margin-top: -4

  Label
    id: targetName
    anchors.left: targetSprite.right
    anchors.right: parent.right
    anchors.top: parent.top
    margin-left: 5
    margin-top: 3
    font: verdana-11px-rounded
    color: white
    text: TARGET

  Label
    id: targetDistance
    anchors.left: targetName.left
    anchors.right: targetName.right
    anchors.top: targetName.bottom
    margin-top: 2
    font: verdana-11px-rounded
    color: white
    text: Distance:

  ProgressBar
    id: targetHpBar
    anchors.left: targetName.left
    anchors.right: parent.right
    anchors.top: targetDistance.bottom
    margin-top: 4
    height: 13
    border: 1 black
    opacity: 0.85
    text-align: center
    background-color: red
]], g_ui.getRootWidget())

targetUI:hide()

local function isMoveKeyPressed()
  if modules._G.g_app.isMobile() then
    return true
  end

  return g_keyboard and g_keyboard.isCtrlPressed and g_keyboard.isCtrlPressed()
end

local function applyTargetPos()
  local p = charStorage[panelName].targetInfoPos

  targetUI:breakAnchors()

  if not p or not p.x or not p.y or (p.x == 0 and p.y == 0) then
    targetUI:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
    targetUI:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
    return
  end

  targetUI:setPosition({ x = p.x, y = p.y })
end

local function saveTargetPos()
  local p = targetUI:getPosition()
  if not p then return end

  charStorage[panelName].targetInfoPos = {
    x = p.x,
    y = p.y
  }

  saveHudChar()
end

local function disableDrag()
  targetUI.onDragEnter = nil
  targetUI.onDragMove = nil
  targetUI:setFocusable(false)
  targetUI:setPhantom(true)
  targetUI:setDraggable(false)
  targetUI:setOpacity(1.00)
end

local function enableDrag()
  targetUI:setFocusable(true)
  targetUI:setPhantom(false)
  targetUI:setDraggable(true)
  targetUI:setOpacity(1.00)

  targetUI.onDragEnter = function(widget, mousePos)
    widget:breakAnchors()
    widget.movingReference = {
      x = mousePos.x - widget:getX(),
      y = mousePos.y - widget:getY()
    }
    return true
  end

  targetUI.onDragMove = function(widget, mousePos)
    local parent = widget:getParent()
    if not parent or not parent.getRect then return true end

    local r = parent:getRect()
    local ref = widget.movingReference or { x = 0, y = 0 }

    local x = mousePos.x - ref.x
    local y = mousePos.y - ref.y

    x = math.min(math.max(r.x, x), r.x + r.width - widget:getWidth())
    y = math.min(math.max(r.y, y), r.y + r.height - widget:getHeight())

    widget:move(x, y)

    charStorage[panelName].targetInfoPos = {
      x = x,
      y = y
    }

    saveHudChar()
    return true
  end
end

local function sqmDistance(a, b)
  if not a or not b then return 0 end

  local dx = math.abs((a.x or 0) - (b.x or 0))
  local dy = math.abs((a.y or 0) - (b.y or 0))

  return math.max(dx, dy)
end

applyTargetPos()

local lastPressed = nil
local lastSavePos = 0

if g_app and type(g_app.isMobile) == "function" and g_app:isMobile() then
  enableDrag()
  lastPressed = true
else
  disableDrag()
end

macro(100, function()
  if not hudMasterOn() or not hudSwitchOn("targetInfo") then
    if targetUI:isVisible() then targetUI:hide() end
    return
  end

  if not g_game.isAttacking() then
    if targetUI:isVisible() then targetUI:hide() end
    return
  end

  if not targetUI:isVisible() then
    targetUI:show()
    applyTargetPos()
  end

  local pressed = isMoveKeyPressed()
  if pressed ~= lastPressed then
    if pressed then
      enableDrag()
    else
      disableDrag()
      saveTargetPos()
    end
    lastPressed = pressed
  end

  if pressed and now - lastSavePos > 500 then
    saveTargetPos()
    lastSavePos = now
  end

  local target = g_game.getAttackingCreature and g_game.getAttackingCreature() or nil
  if not target then
    targetUI:hide()
    return
  end

  if target.getOutfit then
    targetUI.targetSprite:setOutfit(target:getOutfit())
  end

  local name = target.getName and target:getName() or "-"
  local hp = target.getHealthPercent and target:getHealthPercent() or 0

  local myPos = pos and pos() or nil
  local targetPos = target.getPosition and target:getPosition() or nil
  local dist = sqmDistance(myPos, targetPos)

  targetUI.targetName:setText(name)
  targetUI.targetDistance:setText("Distance: " .. dist)

  targetUI.targetHpBar:setPercent(hp)
  targetUI.targetHpBar:setText(hp .. "%")
  targetUI.targetHpBar:setBackgroundColor(getTargetColor(hp))
end)

--==================================================
-- MANAGER ATTACKBOT - LISTA SPELL/RUNE + CD
--==================================================

charStorage[panelName].managerAttackbotPos = charStorage[panelName].managerAttackbotPos or { x = 0, y = 0 }
charStorage[panelName].managerAttackbotMinimized = charStorage[panelName].managerAttackbotMinimized or false

local managerAttackUI = setupUI([[
MiniWindow
  id: managerAttackbotHUD
  size: 270 160
  opacity: 1.00
  text: Manager AttackBot
  icon: /images/topbuttons/combatcontrols
  icon-size: 18 18

  TextList
    id: list
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-left: 7
    margin-top: 22
    margin-right: 15
    margin-bottom: 5
    vertical-scrollbar: scroll
    layout: verticalBox

  VerticalScrollBar
    id: scroll
    anchors.top: list.top
    anchors.bottom: list.bottom
    anchors.right: parent.right
    width: 12
    margin-right: 6
    pixels-scroll: true
    step: 24
]], g_ui.getRootWidget())

managerAttackUI:hide()
local managerAttackRow = [[
Panel
  height: 25
  margin-top: 1
  background-color: alpha
  focusable: true
  $hover:
    background-color: #242424

  BotSwitch
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 2
    size: 21 21
    text: ""
    $on:
      image-color: green
    $!on:
      image-color: #202020

  UIItem
    id: icon
    anchors.left: enabled.right
    anchors.verticalCenter: enabled.verticalCenter
    margin-left: 5
    size: 20 20
    visible: false

  Label
    id: name
    anchors.left: icon.right
    anchors.right: status.left
    anchors.verticalCenter: enabled.verticalCenter
    margin-left: 8
    margin-right: 5
    font: verdana-11px-rounded
    color: white
    text: -
    phantom: false

  Label
    id: status
    anchors.right: parent.right
    anchors.verticalCenter: enabled.verticalCenter
    margin-right: -2
    width: 42
    font: verdana-11px-rounded
    text-align: center
    color: green
    text: ON
]]

local function managerAtkSave()
  if type(saveAttackBotChar) == "function" then
    saveAttackBotChar()
  elseif type(saveCharStorage) == "function" then
    saveCharStorage(charStorage)
  end
end


local function managerAtkProfile()
  charStorage.attackBotProfiles = charStorage.attackBotProfiles or {
    activeProfile = 1,
    profiles = {}
  }

  local idx = math.max(1, math.min(5, tonumber(charStorage.attackBotProfiles.activeProfile) or 1))

  charStorage.attackBotProfiles.profiles[idx] =
    charStorage.attackBotProfiles.profiles[idx] or {
      main = {},
      attacks = {}
    }

  local p = charStorage.attackBotProfiles.profiles[idx]
  p.main = p.main or {}
  p.attacks = p.attacks or {}

  return p
end

local function managerAtkClear()
  local children = managerAttackUI.list:getChildren()
  for i = #children, 1, -1 do
    children[i]:destroy()
  end
end

local function setRowItem(widget, itemId)
  itemId = tonumber(itemId) or 0
  if not widget then return end

  if itemId <= 0 then
    widget:setVisible(false)
    return
  end

  widget:setVisible(true)

  if widget.setItemId then
    widget:setItemId(itemId)
  elseif widget.setItem and Item and Item.create then
    widget:setItem(Item.create(itemId, 1))
  end
end

local function managerAtkName(data)
  if not data then return "-" end

  if data.type == "spell" then
    return tostring(data.spell or "-")
  end

  if data.type == "rune" then
    return "Rune: [" .. tostring(data.id or 0) .. "]"
  end

  return "-"
end

local function managerAtkCooldownText(data)
  local cd = tonumber(data.nextCast) or 0
  if cd > now then
    local left = math.ceil((cd - now) / 1000)
    return tostring(left) .. "s"
  end

  return nil
end

local function managerAtkUpdateRow(row, data)
  local enabled = data and data.enabled == true
  local cdText = managerAtkCooldownText(data)

  row.enabled:setOn(enabled)

  if cdText then
    row.status:setText(cdText)
    row.status:setColor("yellow")
  elseif enabled then
    row.status:setText("ON")
    row.status:setColor("green")
  else
    row.status:setText("OFF")
    row.status:setColor("red")
  end
end


local function managerAtkToggle(index, row)
  local p = managerAtkProfile()
  local atk = p.attacks and p.attacks[index]
  if not atk then return end

  atk.enabled = not (atk.enabled == true)

  managerAtkUpdateRow(row, atk)
  managerAtkSave()

  if type(rebuildAttackList) == "function" then
    rebuildAttackList()
  end
end

local managerRows = {}

local function managerAtkRefresh()
  managerAtkClear()
  managerRows = {}

  local profile = managerAtkProfile()

  for index, attack in ipairs(profile.attacks or {}) do
    local row = setupUI(managerAttackRow, managerAttackUI.list)

    row.name:setText(managerAtkName(attack))

    if attack.type == "rune" then
      setRowItem(row.icon, attack.id)
      row.name:setMarginLeft(5)
    else
      setRowItem(row.icon, 0)
      row.icon:setVisible(false)
      row.name:setMarginLeft(-15)
    end

    managerAtkUpdateRow(row, attack)

    local tip =
      "Distance: " .. tostring(attack.distance or 1) ..
      "\nMobs: " .. tostring(attack.mobs or 1) ..
      "\nSafe: " .. ((attack.safe and "Yes") or "No")

    row:setTooltip(tip)
    row.enabled:setTooltip(tip)
    row.icon:setTooltip(tip)
    row.name:setTooltip(tip)
    row.status:setTooltip(tip)

    local function clickLine()
      managerAtkToggle(index, row)
    end

    row.onClick = clickLine
    row.enabled.onClick = clickLine
    row.icon.onClick = clickLine
    row.name.onClick = clickLine
    row.status.onClick = clickLine

    table.insert(managerRows, {
      row = row,
      index = index
    })
  end
  lastManagerAttackCount = #(profile.attacks or {})
end

local function managerAtkUpdateCooldowns()
  local p = managerAtkProfile()

  for _, data in ipairs(managerRows) do
    local atk = p.attacks and p.attacks[data.index]
    if data.row and atk then
      managerAtkUpdateRow(data.row, atk)
    end
  end
end

local function managerAtkApplyPos()
  local p = charStorage[panelName].managerAttackbotPos

  managerAttackUI:breakAnchors()

  if not p or not p.x or not p.y or (p.x == 0 and p.y == 0) then
    managerAttackUI:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
    managerAttackUI:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
    managerAttackUI:setMarginTop(80)
    return
  end

  managerAttackUI:setPosition({ x = p.x, y = p.y })
end

local function managerAtkSavePos()
  local p = managerAttackUI:getPosition()
  if not p then return end

  charStorage[panelName].managerAttackbotPos = {
    x = p.x,
    y = p.y
  }

  saveHudChar()
end

managerAttackUI.onDragEnter = function(widget, mousePos)
  widget:breakAnchors()
  widget.movingReference = {
    x = mousePos.x - widget:getX(),
    y = mousePos.y - widget:getY()
  }

  return true
end

managerAttackUI.onDragMove = function(widget, mousePos)
  local parent = widget:getParent()
  if not parent or not parent.getRect then return true end

  local r = parent:getRect()
  local ref = widget.movingReference or { x = 0, y = 0 }

  local x = mousePos.x - ref.x
  local y = mousePos.y - ref.y

  x = math.min(math.max(r.x, x), r.x + r.width - widget:getWidth())
  y = math.min(math.max(r.y, y), r.y + r.height - widget:getHeight())

  widget:move(x, y)
  return true
end

managerAttackUI.onDragLeave = function()
  managerAtkSavePos()
  return true
end

managerAtkApplyPos()
managerAtkRefresh()

local managerNormalHeight = 160
local managerMinimizedHeight = 25

local function managerAtkSetMinimized(state)
  state = state == true

  charStorage[panelName].managerAttackbotMinimized = state

  if state then
    managerNormalHeight = managerAttackUI:getHeight() > managerMinimizedHeight and managerAttackUI:getHeight() or managerNormalHeight

    if managerAttackUI.list then managerAttackUI.list:hide() end
    if managerAttackUI.scroll then managerAttackUI.scroll:hide() end
    if managerAttackUI.title then managerAttackUI.title:hide() end

    managerAttackUI:setHeight(managerMinimizedHeight)
  else
    managerAttackUI:setHeight(managerNormalHeight)

    if managerAttackUI.list then managerAttackUI.list:show() end
    if managerAttackUI.scroll then managerAttackUI.scroll:show() end
    if managerAttackUI.title then managerAttackUI.title:hide() end

    managerAtkRefresh()
  end

  managerAtkSave()
end

schedule(100, function()
  managerAtkSetMinimized(charStorage[panelName].managerAttackbotMinimized == true)
end)

local miniScroll = managerAttackUI:getChildById("miniwindowScrollBar")
if miniScroll then miniScroll:hide() end

if managerAttackUI.closeButton then
  managerAttackUI.closeButton:hide()
end

if managerAttackUI.lockButton then
  managerAttackUI.lockButton:hide()
end

if managerAttackUI.minimizeButton then
  managerAttackUI.minimizeButton:setMarginRight(-13)
  managerAttackUI.minimizeButton.onClick = function()
    managerAtkSetMinimized(not (charStorage[panelName].managerAttackbotMinimized == true))
  end
end

macro(300, function()
  if not hudSwitchOn("comboManager") then
    if managerAttackUI:isVisible() then
      managerAttackUI:hide()
    end
    return
  end

  if not managerAttackUI:isVisible() then
    managerAttackUI:show()
    managerAtkApplyPos()
    managerAtkSetMinimized(charStorage[panelName].managerAttackbotMinimized == true)

    if not charStorage[panelName].managerAttackbotMinimized then
      managerAtkRefresh()
    end
  end

  if not charStorage[panelName].managerAttackbotMinimized then
    managerAtkUpdateCooldowns()
  end
end)

local lastManagerAttackCount = 0

macro(1000, function()
  if not managerAttackUI:isVisible() then return end
  if charStorage[panelName].managerAttackbotMinimized then return end

  local p = managerAtkProfile()
  local count = #(p.attacks or {})

  if count ~= lastManagerAttackCount then
    lastManagerAttackCount = count
    managerAtkRefresh()
  else
    managerAtkUpdateCooldowns()
  end
end)
