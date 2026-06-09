setDefaultTab("Main")

--==================================================
-- STORAGE FIXO DOS ICONES
--==================================================

storage.lnsIconsPanel = storage.lnsIconsPanel or {}
local iconsStorage = storage.lnsIconsPanel

--==================================================
-- HELPERS BASE
--==================================================

local function later(ms, fn)
  if type(schedule) == "function" then return schedule(ms, fn) end
  if type(scheduleEvent) == "function" then return scheduleEvent(fn, ms) end
  if g_dispatcher and type(g_dispatcher.scheduleEvent) == "function" then return g_dispatcher:scheduleEvent(fn, ms) end
  return fn()
end

local function clamp(v, a, b)
  v = tonumber(v) or 0
  if v < a then return a end
  if v > b then return b end
  return v
end

local function pctTo01(v)
  return clamp(v, 0, 100) / 100
end

local function normalizeText(s)
  s = tostring(s or ""):lower()
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  return s
end

local function getConfigNameSafe()
  local botPanel = modules.game_bot and modules.game_bot.contentsPanel
  local config = botPanel and botPanel.config and botPanel.config:getCurrentOption()
  return (config and config.text) or "default"
end

local MyConfigName = getConfigNameSafe()

local function saveIcons()
  storage.lnsIconsPanel = iconsStorage
end

local function getItemId(widget)
  if widget and widget.getItemId then
    local ok, id = pcall(function() return widget:getItemId() end)
    if ok and tonumber(id) then return tonumber(id) end
  end

  if widget and widget.getItem then
    local ok, item = pcall(function() return widget:getItem() end)
    if ok and item and item.getId then
      local ok2, id = pcall(function() return item:getId() end)
      if ok2 and tonumber(id) then return tonumber(id) end
    end
  end

  return 0
end

local function setBotItemId(widget, itemId)
  if not widget then return end
  itemId = tonumber(itemId) or 0

  if widget.setItemId then
    widget:setItemId(itemId)
    return
  end

  if widget.setItem and Item and Item.create then
    if itemId > 0 then
      widget:setItem(Item.create(itemId, 1))
    else
      pcall(function() widget:setItem(nil) end)
    end
  end
end

local function applyIconItem(icon, itemId)
  if not icon or not icon.item then return end
  itemId = tonumber(itemId) or 0

  if icon.creature and icon.creature.setVisible then
    icon.creature:setVisible(false)
  end

  if icon.item.setVisible then
    icon.item:setVisible(true)
  end

  if icon.item.setItemId then
    icon.item:setItemId(itemId)
    return
  end

  if icon.item.setItem and Item and Item.create then
    if itemId > 0 then
      icon.item:setItem(Item.create(itemId, 1))
    else
      pcall(function() icon.item:setItem(nil) end)
    end
  end
end

local function applyRelativePos(widget, st)
  if not widget or not st then return end

  local parent = widget:getParent()
  if not parent then return end

  local r = parent:getRect()
  local w = r.width - widget:getWidth()
  local h = r.height - widget:getHeight()

  local x = pctTo01(st.x or 0)
  local y = pctTo01(st.y or 0)

  widget:setMarginLeft(w * (-0.5 + x))
  widget:setMarginTop(math.max(h * (-0.5) - parent:getMarginTop(), h * (-0.5 + y)))
end

--==================================================
-- PAINEL
--==================================================

iconesInterface = setupUI([=[
iconesRow < Panel
  height: 43
  margin-top: 2
  margin-left: 3
  margin-right: 3
  border: 1 #696969

  BotItem
    id: itemIcone
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5

  Button
    id: listaIcone
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    width: 20
    text: L
    tooltip: Lista de items

  TextEdit
    id: textIcone
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    width: 90

  Label
    id: lblX
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 10
    width: 14
    color: #d7c08a
    text: X:

  BotTextEdit
    id: editX
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 2
    width: 38
    height: 22
    text-align: center
    color: white
    text: 0

  Label
    id: lblY
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 3
    width: 14
    color: #d7c08a
    text: Y:

  BotTextEdit
    id: editY
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 2
    width: 38
    height: 22
    text-align: center
    color: white
    text: 0

  BotSwitch
    id: ativarIcone
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    margin-top: -1
    height: 22
    width: 38
    image-source: ""
    font: verdana-11px-rounded
    $on:
      text: HIDE
      color: red
    $!on:
      text: SHOW
      color: green

MainWindow
  id: mainPanel
  size: 367 400
  text: Panel Icones
  margin-top: -50

  Label
    text: Search Icones:
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 2
    margin-left: -5
    text-auto-resize: true

  TextEdit
    id: pesquisaIcons
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: parent.right
    margin-right: -5
    margin-top: 2
    placeholder: Search icon name
    phantom: true

  FlatPanel
    id: flatp
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.bottom: closePanel.top
    margin-bottom: 5
    margin-top: 8

    TextList
      id: lista
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin: 3
      margin-right: 16
      vertical-scrollbar: scrollLista

    VerticalScrollBar
      id: scrollLista
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      width: 13
      margin-top: 3
      margin-bottom: 3
      margin-right: 3
      step: 43
      pixels-scroll: true
      visible: true

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

iconesInterface:hide()

if modules._G.g_app.isMobile() then
  equipInterface:setSize("367 420")
end

local buticon = addButton("", "Icones", function()
  iconesInterface:show()
  iconesInterface:raise()
  iconesInterface:focus()
end)
buticon:setMarginTop(0)

iconesInterface.closePanel.onClick = function()
  iconesInterface:hide()
end

--==================================================
-- LISTA DE ITEMS COM PESQUISA POR NOME / ID
--==================================================

local idPicker = {
  win = nil,
  itemList = nil,
  pageLabel = nil,
  btnBack = nil,
  btnNext = nil,
  btnClose = nil,
  searchEdit = nil,
  target = nil,
  lootList = {},
  filteredList = {},
  itemIndex = 1,
  pageSize = 104,
  query = ""
}

local function safeRead(path)
  if not g_resources or type(g_resources.readFileContents) ~= "function" then return nil end
  local ok, content = pcall(function() return g_resources.readFileContents(path) end)
  if not ok or not content or content == "" then return nil end
  return content
end

local function loadLootItems()
  local content =
    safeRead("/bot/" .. MyConfigName .. "/loot_items.lua") or
    safeRead("/bot/" .. MyConfigName .. "/loot_items") or
    safeRead("loot_items.lua")

  if not content then
    warn("[LNS Icones] Nao achei loot_items.lua em /bot/" .. MyConfigName .. "/")
    return {}
  end

  local list, seen = {}, {}
  for name, idStr in content:gmatch('%["(.-)"%]%s*=%s*(%d+)') do
    local id = tonumber(idStr)
    if id and not seen[id] then
      seen[id] = true
      table.insert(list, { name = tostring(name), id = id })
    end
  end

  table.sort(list, function(a, b) return normalizeText(a.name) < normalizeText(b.name) end)
  return list
end

local function pickerW(win, id)
  if win and win.recursiveGetChildById then return win:recursiveGetChildById(id) end
  if win and win.getChildById then return win:getChildById(id) end
  return nil
end

local function refreshPickerFilter()
  local q = normalizeText(idPicker.query)
  idPicker.filteredList = {}

  for _, it in ipairs(idPicker.lootList or {}) do
    local n = normalizeText(it.name)
    local sid = tostring(it.id or "")
    if q == "" or n:find(q, 1, true) or sid:find(q, 1, true) then
      table.insert(idPicker.filteredList, it)
    end
  end

  idPicker.itemIndex = 1
end

local function renderItemPicker()
  if not idPicker.itemList then return end
  idPicker.itemList:destroyChildren()

  local list = idPicker.filteredList or {}
  local total = #list

  if total == 0 then
    if idPicker.pageLabel then idPicker.pageLabel:setText("0/0") end
    return
  end

  if idPicker.itemIndex < 1 then idPicker.itemIndex = 1 end
  if idPicker.itemIndex > total then idPicker.itemIndex = total end

  local toIndex = idPicker.itemIndex + idPicker.pageSize - 1
  if toIndex > total then toIndex = total end

  for i = idPicker.itemIndex, toIndex do
    local entry = list[i]
    if entry then
      local w = UI.createWidget("LnsIconItemPickerEntry", idPicker.itemList)
      w.item:setSize({ width = 50, height = 50 })
      w.item:setItemId(entry.id)
      w.item:setTooltip(tostring(entry.name or "") .. " (" .. tostring(entry.id) .. ")")

      w.onDoubleClick = function()
        local t = idPicker.target
        if not t or not t.key then return end

        iconsStorage[t.key].itemId = tonumber(entry.id) or 0

        if t.row and t.row.itemIcone then
          setBotItemId(t.row.itemIcone, iconsStorage[t.key].itemId)
        end

        saveIcons()
        updateIcon(t.key)

        if idPicker.win then idPicker.win:hide() end
      end
    end
  end

  if idPicker.pageLabel then
    idPicker.pageLabel:setText(idPicker.itemIndex .. " - " .. toIndex .. " / " .. total)
  end
end

local function buildItemPickerUI()
  if idPicker.win then return end

  g_ui.loadUIFromString([[
LnsIconItemPickerWindow < MainWindow
  size: 685 520
  anchors.centerIn: parent
  margin-top: -60
  text: Panel Select Icone x Item
  @onEscape: self:hide()

  TextEdit
    id: searchItem
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 2
    margin-left: 0
    margin-right: 0
    height: 22
    placeholder: Search item by name or ID
    phantom: true

  Panel
    id: itemList
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    anchors.bottom: separator.top
    margin-left: -5
    margin-top: 5
    layout:
      type: grid
      cell-size: 50 50
      flow: true

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    margin-bottom: 45

  Button
    id: backButton
    !text: tr('Previous')
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-left: 0
    margin-top: 4
    width: 200

  Label
    id: page
    text: 0/0
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.left: prev.right
    anchors.top: prev.top
    width: 220
    margin-top: 2
    font: terminus-14px-bold
    text-align: center

  Button
    id: nextButton
    !text: tr('Next')
    margin-right: 0
    anchors.left: page.right
    anchors.top: backButton.top
    margin-top: 0
    width: 200

  Button
    id: closePanel
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    text: Close

LnsIconItemPickerEntry < UIWidget
  size: 40 40
  margin-left: 6
  margin-top: 0

  Item
    id: item
    size: 20 20
    phantom: false
    anchors.top: parent.top
    anchors.left: parent.left
    padding: 5
    border: 1 alpha
    $hover:
      border: 1 white
  ]])

  idPicker.win = UI.createWindow("LnsIconItemPickerWindow", g_ui.getRootWidget())
  idPicker.win:hide()

  idPicker.itemList = pickerW(idPicker.win, "itemList")
  idPicker.pageLabel = pickerW(idPicker.win, "page")
  idPicker.btnBack = pickerW(idPicker.win, "backButton")
  idPicker.btnNext = pickerW(idPicker.win, "nextButton")
  idPicker.btnClose = pickerW(idPicker.win, "closePanel")
  idPicker.searchEdit = pickerW(idPicker.win, "searchItem")

  if idPicker.btnClose then
    idPicker.btnClose.onClick = function()
      idPicker.win:hide()
    end
  end

  if idPicker.searchEdit then
    idPicker.searchEdit.onTextChange = function(_, text)
      idPicker.query = tostring(text or "")
      refreshPickerFilter()
      renderItemPicker()
    end
  end

  if idPicker.btnBack then
    idPicker.btnBack.onClick = function()
      idPicker.itemIndex = idPicker.itemIndex - idPicker.pageSize
      if idPicker.itemIndex < 1 then idPicker.itemIndex = 1 end
      renderItemPicker()
    end
  end

  if idPicker.btnNext then
    idPicker.btnNext.onClick = function()
      local total = #(idPicker.filteredList or {})
      idPicker.itemIndex = idPicker.itemIndex + idPicker.pageSize
      if idPicker.itemIndex > total then idPicker.itemIndex = total end
      renderItemPicker()
    end
  end
end

local function openItemPicker(key, row)
  buildItemPickerUI()
  idPicker.target = { key = key, row = row }
  idPicker.lootList = loadLootItems()
  idPicker.query = ""

  if idPicker.searchEdit then
    idPicker.searchEdit:setText("")
  end

  refreshPickerFilter()

  if idPicker.win then
    idPicker.win:show()
    idPicker.win:raise()
    idPicker.win:focus()
  end

  renderItemPicker()
end

--==================================================
-- CORE ICONES
--==================================================

local LNS_ICON = {
  icons = {},
  rows = {}
}

function updateIcon(key)
  local pack = LNS_ICON.icons[key]
  if not pack or not pack.icon then return end

  local st = iconsStorage[key]
  local def = pack.def
  local icon = pack.icon
  if not st then return end

  applyIconItem(icon, st.itemId)

  if icon.text then
    icon.text:setText(st.text or def.text or key)
    icon.text:setFont(def.font or "verdana-9px")
    icon.text:setColor("white")
  end

  icon.onMousePress = function(widget, mousePos, button)
    return true
  end

  icon.onMouseRelease = function(widget, mousePos, button)
    return true
  end

  if icon.status then
    icon.status:show()
    local ok, state = false, false
    if def.getState then
      ok, state = pcall(def.getState)
    end
    icon.status:setOn(ok and state == true)
  end

  if modules._G.g_app.isMobile() then
    icon:setSize('50 50')
  else
    icon:setSize('65 50')
  end
  
  icon:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
  icon:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)

  applyRelativePos(icon, st)

  if st.show == true then
    icon:show()
    icon:raise()
  else
    icon:hide()
  end
end

local function createIcon(key)
  local pack = LNS_ICON.icons[key]
  if not pack then return end

  if pack.icon then
    updateIcon(key)
    return
  end

  local panel = modules.game_interface.gameMapPanel
  if not panel then
    warn("LNS ICON: gameMapPanel nao encontrado.")
    return
  end

  local icon = g_ui.createWidget("BotIcon", panel)
  icon.botWidget = true
  icon.botIcon = true

  icon.onDragEnter = function(widget, mousePos)
    if not modules.corelib.g_keyboard.isCtrlPressed() then return false end

    widget:breakAnchors()
    widget.movingReference = {
      x = mousePos.x - widget:getX(),
      y = mousePos.y - widget:getY()
    }

    return true
  end

  icon.onDragMove = function(widget, mousePos)
    local parent = widget:getParent()
    if not parent or not widget.movingReference then return false end

    local pr = parent:getRect()
    local x = mousePos.x - widget.movingReference.x
    local y = mousePos.y - widget.movingReference.y

    x = clamp(x, pr.x, pr.x + pr.width - widget:getWidth())
    y = clamp(y, pr.y - parent:getMarginTop(), pr.y + pr.height - widget:getHeight())

    widget:move(x, y)
    return true
  end

  icon.onDragLeave = function(widget)
    local st = iconsStorage[key]
    local row = LNS_ICON.rows[key]
    local parent = widget:getParent()
    if not st or not parent then return true end

    local pr = parent:getRect()
    local x = widget:getX() - pr.x
    local y = widget:getY() - pr.y
    local width = pr.width - widget:getWidth()
    local height = pr.height - widget:getHeight()

    st.x = math.floor(clamp((x / math.max(1, width)) * 100, 0, 100) + 0.5)
    st.y = math.floor(clamp((y / math.max(1, height)) * 100, 0, 100) + 0.5)

    widget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
    widget:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
    applyRelativePos(widget, st)

    if row then
      row.editX._lnsBlock = true
      row.editY._lnsBlock = true
      row.editX:setText(tostring(st.x))
      row.editY:setText(tostring(st.y))
      row.editX._lnsBlock = false
      row.editY._lnsBlock = false
    end

    saveIcons()
    return true
  end

  icon.onClick = function()
    if pack.def and pack.def.onClick then
      pcall(pack.def.onClick)
    end
    updateIcon(key)
  end

  icon.onGeometryChange = function(widget)
    if widget:isDragging() then return end
    local st = iconsStorage[key]
    if st then applyRelativePos(widget, st) end
  end

  pack.icon = icon
  updateIcon(key)
end

local function bindRow(key, row)
  local pack = LNS_ICON.icons[key]
  local def = pack.def
  local st = iconsStorage[key]

  setBotItemId(row.itemIcone, tonumber(st.itemId) or def.itemId or 3555)
  row.textIcone:setText(st.text or def.text or key)
  row.editX:setText(tostring(st.x or 0))
  row.editY:setText(tostring(st.y or 0))
  row.ativarIcone:setOn(st.show == true)

  row.listaIcone.onClick = function()
    openItemPicker(key, row)
  end

  row.itemIcone.onItemChange = function(widget)
    local id = getItemId(widget)
    if id <= 0 then return end

    st.itemId = id
    saveIcons()
    updateIcon(key)
  end

  row.itemIcone.onItemIdChange = row.itemIcone.onItemChange

  row.textIcone.onTextChange = function(_, text)
    st.text = tostring(text or "")
    saveIcons()
    updateIcon(key)
  end

  row.editX.onTextChange = function(w, text)
    if w._lnsBlock then return end
    local n = tonumber(text)
    if not n then return end
    st.x = clamp(n, 0, 100)
    saveIcons()
    updateIcon(key)
  end

  row.editY.onTextChange = function(w, text)
    if w._lnsBlock then return end
    local n = tonumber(text)
    if not n then return end
    st.y = clamp(n, 0, 100)
    saveIcons()
    updateIcon(key)
  end

  row.ativarIcone.onClick = function(widget)
    local state = not widget:isOn()
    widget:setOn(state)
    st.show = state == true
    saveIcons()
    createIcon(key)
    updateIcon(key)
  end
end

local function registerIcon(def)
  local key = def.key
  if not key then return end

  iconsStorage[key] = iconsStorage[key] or {
    show = def.show == true,
    itemId = def.itemId or 3555,
    text = def.text or key,
    x = def.x or 0,
    y = def.y or 0
  }

  local st = iconsStorage[key]
  st.x = clamp(st.x or 0, 0, 100)
  st.y = clamp(st.y or 0, 0, 100)
  st.itemId = tonumber(st.itemId) or def.itemId or 3555
  st.text = st.text or def.text or key
  st.show = st.show == true

  LNS_ICON.icons[key] = {
    def = def,
    icon = nil
  }

  local row = g_ui.createWidget("iconesRow", iconesInterface.flatp.lista)
  row:setId("row_" .. key)

  LNS_ICON.rows[key] = row

  bindRow(key, row)
  createIcon(key)
  saveIcons()
end

local function updateAllIcons()
  for key in pairs(LNS_ICON.icons) do
    updateIcon(key)
  end
end

--==================================================
-- AUTO ICONS MODEL
--==================================================

local boundStates = {}

local function callSave(saveFn)
  if type(saveFn) == "function" then
    pcall(saveFn)
  elseif type(saveCharStorage) == "function" and type(charStorage) == "table" then
    pcall(function() saveCharStorage(charStorage) end)
  end
  saveIcons()
end

local function getToggle(def)
  if type(def.getButton) ~= "function" then return nil end
  local ok, res = pcall(def.getButton)
  if ok then return res end
  return nil
end

local function readToggle(toggle)
  if not toggle then return nil end

  if toggle.isOn then
    local ok, res = pcall(function() return toggle:isOn() end)
    if ok then return res == true end
  end

  if toggle.isChecked then
    local ok, res = pcall(function() return toggle:isChecked() end)
    if ok then return res == true end
  end

  return nil
end

local function setToggle(toggle, state)
  if not toggle then return end
  state = state == true

  if toggle.setOn then
    pcall(function() toggle:setOn(state) end)
    return
  end

  if toggle.setChecked then
    pcall(function() toggle:setChecked(state) end)
    return
  end
end

local function safeStoreTable(store)
  if type(store) == "table" then return store end
  if type(charStorage) == "table" then return charStorage end
  return storage
end

local function readStorage(def)
  local store = safeStoreTable(type(def.store) == "function" and def.store() or nil)
  local key = def.storageKey or def.switch or def.button or def.key

  if type(store[key]) == "table" then
    if store[key].enabled ~= nil then return store[key].enabled == true end
    if store[key].active ~= nil then return store[key].active == true end
    if store[key].isOn ~= nil then return store[key].isOn == true end
    if store[key].value ~= nil then return store[key].value == true end
    return false
  end

  return store[key] == true
end

local function writeStorage(def, state)
  local store = safeStoreTable(type(def.store) == "function" and def.store() or nil)
  local key = def.storageKey or def.switch or def.button or def.key
  state = state == true

  if type(store[key]) == "table" then
    if store[key].enabled ~= nil then
      store[key].enabled = state
    elseif store[key].active ~= nil then
      store[key].active = state
    elseif store[key].isOn ~= nil then
      store[key].isOn = state
    elseif store[key].value ~= nil then
      store[key].value = state
    else
      store[key].enabled = state
    end
  else
    store[key] = state
  end
end

local function readState(def)
  if type(def.read) == "function" then
    local ok, res = pcall(def.read)
    if ok and res ~= nil then return res == true end
  end

  local toggle = getToggle(def)
  local tState = readToggle(toggle)
  if tState ~= nil then return tState end

  return readStorage(def)
end

local function applyVisual(def, state, toggle)
  boundStates[def.key] = state == true
  setToggle(toggle, state)

  local pack = LNS_ICON.icons[def.key]
  local icon = pack and pack.icon

  if icon and icon.status then
    icon.status:show()
    icon.status:setOn(state == true)
  end

  callSave(def.save)
end

local function setState(def, state, toggle)
  state = state == true

  if type(def.write) == "function" then
    pcall(def.write, state)
  else
    writeStorage(def, state)
  end

  applyVisual(def, state, toggle)
end

local function clickRealButton(def, toggle)
  if not toggle then
    setState(def, not readState(def), nil)
    return
  end

  if type(toggle.onClick) == "function" then
    pcall(toggle.onClick, toggle)
  else
    local current = readToggle(toggle)
    setToggle(toggle, not (current == true))
  end

  local state = readToggle(toggle)
  if state == nil then
    state = readState(def)
  end

  if type(def.write) == "function" then
    pcall(def.write, state == true)
  else
    writeStorage(def, state == true)
  end

  applyVisual(def, state == true, toggle)
end

local function makeAutoIcon(def)
  return {
    key = def.key,
    itemId = def.itemId or 3555,
    text = def.text or def.key,
    font = def.font or "verdana-9px",
    x = def.x or 0,
    y = def.y or 0,
    show = def.show == true,

    getState = function()
      return readState(def)
    end,

    onClick = function()
      clickRealButton(def, getToggle(def))
    end,

    _autoBind = def
  }
end

local function bindAutoIcon(def)
  local tries = 0
  local maxTries = 200
  local lock = false

  local function tryBind()
    tries = tries + 1

    local pack = LNS_ICON.icons[def.key]
    local icon = pack and pack.icon
    local toggle = getToggle(def)

    if not icon then
      if tries < maxTries then later(100, tryBind) end
      return
    end

    applyVisual(def, readState(def), toggle)

    if toggle then
      local oldClick = toggle.onClick

      toggle.onClick = function(widget, ...)
        if lock then return end
        lock = true

        if type(oldClick) == "function" then
          pcall(oldClick, widget, ...)
        else
          local current = readToggle(widget)
          setToggle(widget, not (current == true))
        end

        local state = readToggle(widget)
        if state == nil then state = readState(def) end

        applyVisual(def, state == true, widget)

        lock = false
      end
    end

    icon.onClick = function()
      if lock then return end

      clickRealButton(def, getToggle(def))
      updateIcon(def.key)
    end
  end

  tryBind()
end

--==================================================
-- HELPERS CONDITIONS
--==================================================

local function getConditionsSwitch(id)
  if not conditionsInterface then return nil end
  if conditionsInterface.recursiveGetChildById then
    return conditionsInterface:recursiveGetChildById(id)
  end
  return nil
end

local function readConditionSwitch(id)
  if type(charStorage) ~= "table" then return false end
  charStorage.conditionsInterface = charStorage.conditionsInterface or {}
  charStorage.conditionsInterface.switches = charStorage.conditionsInterface.switches or {}
  return charStorage.conditionsInterface.switches[id] == true
end

local function writeConditionSwitch(id, state)
  if type(charStorage) ~= "table" then return end
  charStorage.conditionsInterface = charStorage.conditionsInterface or {}
  charStorage.conditionsInterface.switches = charStorage.conditionsInterface.switches or {}
  charStorage.conditionsInterface.switches[id] = state == true
end

local function saveConditionsIcon()
  if type(saveConditionsChar) == "function" then
    saveConditionsChar()
  elseif type(saveCharStorage) == "function" and type(charStorage) == "table" then
    saveCharStorage(charStorage)
  end
end

--==================================================
-- AUTO_ICONS
--==================================================

local AUTO_ICONS = {
  {
    key = "attackbot",
    storageKey = "comboButton",
    itemId = 3555,
    text = "ATK",
    store = function() return charStorage end,
    getButton = function() return comboButton and comboButton.title end,
    save = function() if type(saveAttackBotChar) == "function" then saveAttackBotChar() end end
  },

  {
    key = "healing",
    storageKey = "healingButton",
    itemId = 7643,
    text = "HEALING",
    store = function()
      if type(charStorage) == "table" and charStorage.healingButton ~= nil then return charStorage end
      return storage
    end,
    getButton = function() return healingButton and healingButton.title end,
    save = function() if type(saveHealingChar) == "function" then saveHealingChar() end end
  },

  {
    key = "conditions",
    storageKey = "conditionsButton",
    itemId = 4115,
    text = "CONDITIONS",
    store = function() return charStorage end,
    getButton = function() return conditionsButton and conditionsButton.title end,
    save = function() if type(saveConditionsChar) == "function" then saveConditionsChar() end end
  },

  {
    key = "cond_haste",
    itemId = 3079,
    text = "HASTE",
    show = false,
    read = function() return readConditionSwitch("spellHaste") end,
    write = function(state) writeConditionSwitch("spellHaste", state) end,
    getButton = function() return getConditionsSwitch("spellHaste") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_buff",
    itemId = 3411,
    text = "BUFF",
    show = false,
    read = function() return readConditionSwitch("spellBuff") end,
    write = function(state) writeConditionSwitch("spellBuff", state) end,
    getButton = function() return getConditionsSwitch("spellBuff") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_antilyze",
    itemId = 3160,
    text = "ANTI LYZE",
    show = false,
    read = function() return readConditionSwitch("spellAntilyze") end,
    write = function(state) writeConditionSwitch("spellAntilyze", state) end,
    getButton = function() return getConditionsSwitch("spellAntilyze") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_utura",
    itemId = 3160,
    text = "UTURA",
    show = false,
    read = function() return readConditionSwitch("spellUtura") end,
    write = function(state) writeConditionSwitch("spellUtura", state) end,
    getButton = function() return getConditionsSwitch("spellUtura") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_utamo",
    itemId = 3051,
    text = "UTAMO",
    show = false,
    read = function() return readConditionSwitch("spellUtamo") end,
    write = function(state) writeConditionSwitch("spellUtamo", state) end,
    getButton = function() return getConditionsSwitch("spellUtamo") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_utana",
    itemId = 3086,
    text = "UTANA",
    show = false,
    read = function() return readConditionSwitch("spellUtana") end,
    write = function(state) writeConditionSwitch("spellUtana", state) end,
    getButton = function() return getConditionsSwitch("spellUtana") end,
    save = saveConditionsIcon
  },

  {
    key = "cond_cure_status",
    itemId = 3153,
    text = "CURE",
    show = false,
    read = function() return readConditionSwitch("cureStatus") end,
    write = function(state) writeConditionSwitch("cureStatus", state) end,
    getButton = function() return getConditionsSwitch("cureStatus") end,
    save = saveConditionsIcon
  },

  {
    key = "healingfriend",
    storageKey = "sioButton",
    itemId = 3160,
    text = "HEALFRIEND",
    store = function() return charStorage end,
    getButton = function() return sioButton and sioButton.title end,
    save = function() if type(saveHealFriendChar) == "function" then saveHealFriendChar() end end
  },

  {
    key = "follow",
    storageKey = "followButton",
    itemId = 10798,
    text = "FOLLOW",
    store = function() return charStorage end,
    getButton = function() return followButton and followButton.title end,
    save = function() if type(saveFollow2) == "function" then saveFollow2() end end
  },

  {
    key = "eqmanager",
    storageKey = "eqManagerButton",
    itemId = 28719,
    text = "EQ MANAGER",
    store = function() return charStorage end,
    getButton = function() return eqManagerButton and eqManagerButton.title end,
    save = function() if type(saveEqManagerChar) == "function" then saveEqManagerChar() end end
  },

  {
    key = "swap",
    storageKey = "swapButton",
    itemId = 3081,
    text = "SWAP",
    store = function() return charStorage end,
    getButton = function() return swapButton and swapButton.title end,
    save = function() if type(saveSmartSwapChar) == "function" then saveSmartSwapChar() end end
  },

  {
    key = "prey",
    storageKey = "preyButton",
    itemId = 9056,
    text = "AUTO PREY",
    store = function() return charStorage end,
    getButton = function() return preyButton and preyButton.title end,
    save = function() if type(savePreyChar) == "function" then savePreyChar() end end
  },

  {
    key = "money",
    storageKey = "exchangeButton",
    itemId = 3043,
    text = "EXCHANGE",
    store = function() return charStorage end,
    getButton = function() return exchangeButton and exchangeButton.exchangeMoney end,
    save = function() if type(saveMoneyTrade) == "function" then saveMoneyTrade() end end
  },

  {
    key = "trade",
    itemId = 3232,
    text = "TRADE",
    read = function() return charStorage.moneySystem and charStorage.moneySystem.sendTrade == true end,
    write = function(state)
      charStorage.moneySystem = charStorage.moneySystem or {}
      charStorage.moneySystem.sendTrade = state
    end,
    getButton = function() return sendTrade and sendTrade.title end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "dropper",
    itemId = 2526,
    text = "DROPPER",
    read = function() return charStorage.moneySystem and charStorage.moneySystem.dropperEnabled == true end,
    write = function(state)
      charStorage.moneySystem = charStorage.moneySystem or {}
      charStorage.moneySystem.dropperEnabled = state
    end,
    getButton = function() return dropper and dropper.title end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "autoPT",
    storageKey = "autopartyui",
    itemId = 3435,
    text = "PARTY",
    store = function() return charStorage end,
    getButton = function() return autopartyui and autopartyui.status end,
    save = function() if type(saveAutoParty) == "function" then saveAutoParty() end end
  },

  {
    key = "food",
    storageKey = "eatFood",
    itemId = 6279,
    text = "FOOD",
    store = function() return charStorage end,
    getButton = function() return eatFood and eatFood.eatFood end,
    save = function() if type(saveEatFood) == "function" then saveEatFood() end end
  },

  {
    key = "stamina",
    itemId = 11372,
    text = "STAMINA",
    read = function() return charStorage.staminaUse and charStorage.staminaUse.enabled == true end,
    write = function(state)
      charStorage.staminaUse = charStorage.staminaUse or {}
      charStorage.staminaUse.enabled = state
    end,
    getButton = function() return stamina and stamina.staminacheck end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "comboLeader",
    storageKey = "comboLeaderButton",
    itemId = 3546,
    text = "ATK-LEADER",
    store = function() return charStorage end,
    getButton = function() return comboLeaderButton and comboLeaderButton.title end,
    save = function() if type(saveComboLeaderChar) == "function" then saveComboLeaderChar() end end
  },

  {
    key = "mwsystem",
    itemId = 10181,
    text = "MW/WG",
    read = function() return charStorage.holdMwWgPanel and charStorage.holdMwWgPanel.enabled == true end,
    write = function(state)
      charStorage.holdMwWgPanel = charStorage.holdMwWgPanel or {}
      charStorage.holdMwWgPanel.enabled = state
    end,
    getButton = function() return mwButton and mwButton.title end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "pushmax",
    itemId = 5090,
    text = "PUSHMAX",
    getButton = function() return mainUI and mainUI.switch end,
    save = function() if type(saveConfig) == "function" then saveConfig() end end
  },

  {
    key = "dropFlower",
    storageKey = "dropFlorButton",
    itemId = 2981,
    text = "DROP FLOWER",
    store = function() return charStorage end,
    getButton = function() return dropFlorButton and dropFlorButton.title end,
    save = function() if type(saveDropFlorChar) == "function" then saveDropFlorChar() end end
  },

  {
    key = "antipush",
    storageKey = "AntiPushButton",
    itemId = 3492,
    text = "ANTI PUSH",
    store = function() return charStorage end,
    getButton = function() return AntiPushButton and AntiPushButton.title end,
    save = function() if type(saveThisCharStorage) == "function" then saveThisCharStorage() end end
  },

  {
    key = "pickup",
    storageKey = "PickUpButton",
    itemId = 3217,
    text = "PICK ITEMS",
    store = function() return charStorage end,
    getButton = function() return PickUpButton and PickUpButton.title end,
    save = function() if type(savepickUp) == "function" then savepickUp() end end
  },

  {
    key = "pullall",
    storageKey = "pushAllButton",
    itemId = 34079,
    text = "PULL ITEMS",
    store = function() return charStorage end,
    getButton = function() return pushAllButton and pushAllButton.title end,
    save = function() if type(saveThisCharStorage) == "function" then saveThisCharStorage() end end
  },

  {
    key = "war_full_equip",
    storageKey = "lnsFullTank",
    itemId = 21435,
    text = "FULL EQ",
    store = function()
      return charStorage
    end,
    getButton = function()
      return ui and ui.enable
    end,
    save = function()
      if type(saveCharStorage) == "function" then
        saveCharStorage(charStorage)
      end
    end
  },

  {
    key = "war_double_ue_click",
    itemId = 21463,
    text = "DOUBLE UE",
    show = false,

    -- sempre falso porque esse icone nao é switch, é botao de ação
    read = function()
      return false
    end,

    -- ao clicar no icone, executa a Double UE direto
    write = function()
      if lnsDoubleUE and lnsDoubleUE.iconExecute then
        lnsDoubleUE.iconExecute()
      else
        warn("[Icon Double UE] lnsDoubleUE.iconExecute nao encontrada. Verifique se o bloco foi colado no war.lua.")
      end
    end
  },

  {
    key = "exivaTarget",
    storageKey = "exivaTargetSwitch",
    itemId = 29342,
    text = "EXIVA TARGET",
    store = function() return charStorage end,
    getButton = function() return exivaInterface and exivaInterface.exivaTarget end,
    save = function() if type(saveExivaChar) == "function" then saveExivaChar() end end
  },

  {
    key = "exivax",
    storageKey = "xExivaSwitch",
    itemId = 29343,
    text = "xEXIVA",
    store = function() return charStorage end,
    getButton = function() return exivaInterface and exivaInterface.xExiva end,
    save = function() if type(saveExivaChar) == "function" then saveExivaChar() end end
  },

  {
    key = "targetbot",
    itemId = 3283,
    text = "TARGETBOT",
    show = false,
    read = function() return TargetBot and TargetBot.isOn and TargetBot.isOn() end,
    write = function(state)
      if not TargetBot then return end
      if state then
        if TargetBot.setOn then TargetBot.setOn() end
      else
        if TargetBot.setOff then TargetBot.setOff() end
      end
    end
  },

  {
    key = "cavebot",
    itemId = 9196,
    text = "CAVEBOT",
    show = false,
    read = function() return CaveBot and CaveBot.isOn and CaveBot.isOn() end,
    write = function(state)
      if not CaveBot then return end
      if state then
        if CaveBot.setOn then CaveBot.setOn() end
      else
        if CaveBot.setOff then CaveBot.setOff() end
      end
    end
  },

  {
    key = "chase_mode",
    itemId = 52662,
    text = "CHASE",
    show = false,

    read = function()
      return g_game and g_game.getChaseMode and g_game.getChaseMode() == 1
    end,

    write = function(state)
      if not g_game or not g_game.setChaseMode or not g_game.getChaseMode then return end

      if state == true then
        if g_game.getChaseMode() ~= 1 then
          g_game.setChaseMode(1)
        end
      else
        if g_game.getChaseMode() ~= 0 then
          g_game.setChaseMode(0)
        end
      end
    end
  },

  {
    key = "util_open_next_bp",
    storageKey = "proximaBp",
    itemId = 2854,
    text = "NEXT BP",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp and utilityInterface.flatp.proximaBp end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_loot_chest",
    storageKey = "LootChest",
    itemId = 19250,
    text = "LOOT CHEST",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp and utilityInterface.flatp.LootChest end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_hold_target",
    storageKey = "HoldTarget",
    itemId = 3409,
    text = "HOLD TARGET",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.HoldTarget end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_super_dash",
    storageKey = "SuperDash",
    itemId = 3079,
    text = "DASH",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.SuperDash end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_dancing",
    storageKey = "Dancing",
    itemId = 6576,
    text = "DANCING",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.Dancing end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_hold_position",
    storageKey = "HoldPosition",
    itemId = 2025,
    text = "HOLD POS",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.HoldPosition end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_sleep_mode",
    storageKey = "SleepMode",
    itemId = 694,
    text = "SLEEP",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.SleepMode end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_hide_sprites",
    storageKey = "EsconderSprites",
    itemId = 3248,
    text = "HIDE SPRITE",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.EsconderSprites end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_hide_texts",
    storageKey = "EsconderTextos",
    itemId = 3509,
    text = "HIDE TXT",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.EsconderTextos end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_auto_mount",
    storageKey = "AutoMount",
    itemId = 9196,
    text = "FULL MOUNT",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.AutoMount end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_auto_ban",
    storageKey = "AutoBan",
    itemId = 3547,
    text = "BAN CAST",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.AutoBan end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_auto_summon",
    storageKey = "SummonF",
    itemId = 38677,
    text = "SUMMON",
    store = function()
      charStorage.utilityPanel = charStorage.utilityPanel or {}
      return charStorage.utilityPanel
    end,
    getButton = function()
      return utilityInterface
        and utilityInterface.flatp2
        and utilityInterface.flatp2.SummonF
    end,
    save = function()
      if type(saveCharStorage) == "function" then
        saveCharStorage(charStorage)
      end
    end
  },

  {
    key = "util_exeta_res",
    storageKey = "ExetaRes",
    itemId = 3077,
    text = "EXETA RES",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.ExetaRes end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_exeta_loot",
    storageKey = "ExetaLoot",
    itemId = 3031,
    text = "EXETA LOOT",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.ExetaLoot end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_amp_res",
    storageKey = "AmpRes",
    itemId = 3160,
    text = "AMP RES",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.AmpRes end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_wall_hugger",
    storageKey = "WallHugger",
    itemId = 10455,
    text = "WALL HUGGER",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.WallHugger end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_auto_aol",
    storageKey = "autoAol",
    itemId = 3057,
    text = "AUTO AOL",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.autoAol end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_esconder_andares",
    storageKey = "esconderAndares",
    itemId = 20478,
    text = "HIDE FLOOR",
    store = function() return charStorage.utilityPanel end,
    getButton = function()
      return utilityInterface
        and utilityInterface.flatp2
        and utilityInterface.flatp2.esconderAndares
    end,
    save = function()
      if type(saveCharStorage) == "function" then
        saveCharStorage(charStorage)
      end
    end
  },

  {
    key = "util_dash_mouse",
    storageKey = "dashMouse",
    itemId = 3079,
    text = "DASH MOUSE",
    store = function() return charStorage.utilityPanel end,
    getButton = function()
      return utilityInterface
        and utilityInterface.flatp2
        and utilityInterface.flatp2.dashMouse
    end,
    save = function()
      if type(saveCharStorage) == "function" then
        saveCharStorage(charStorage)
      end
    end
  },

  {
    key = "util_utevo_lux",
    storageKey = "utevoLux",
    itemId = 3241,
    text = "UTEVO LUX",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.utevoLux end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_mana_train",
    storageKey = "manaTrain",
    itemId = 3160,
    text = "MANA TRAIN",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.manaTrain end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  },

  {
    key = "util_mana_train_mage",
    storageKey = "manaTrainMage",
    itemId = 23373,
    text = "TRAIN MAGE",
    store = function() return charStorage.utilityPanel end,
    getButton = function() return utilityInterface and utilityInterface.flatp2 and utilityInterface.flatp2.manaTrainMage end,
    save = function() if type(saveCharStorage) == "function" then saveCharStorage(charStorage) end end
  }
}

local ICON_DEFS = {}
for _, def in ipairs(AUTO_ICONS) do
  table.insert(ICON_DEFS, makeAutoIcon(def))
end

for _, def in ipairs(ICON_DEFS) do
  registerIcon(def)
end

for _, def in ipairs(AUTO_ICONS) do
  bindAutoIcon(def)
end

--==================================================
-- PESQUISA DE ICONES
--==================================================

iconesInterface.pesquisaIcons.onTextChange = function(_, text)
  local q = normalizeText(text)

  for _, def in ipairs(ICON_DEFS) do
    local row = LNS_ICON.rows[def.key]
    if row then
      local a = normalizeText(def.key)
      local b = normalizeText(def.text)

      if q == "" or a:find(q, 1, true) or b:find(q, 1, true) then
        row:show()
      else
        row:hide()
      end
    end
  end
end

macro(500, function()
  updateAllIcons()
end)

updateAllIcons()
saveIcons()
