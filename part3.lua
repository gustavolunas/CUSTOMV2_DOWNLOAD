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
  return print("[Swap] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function saveSmartSwapChar()
  saveCharStorage(charStorage)
end

setDefaultTab("Main")

local switchSwap = "swapButton"
charStorage[switchSwap] = charStorage[switchSwap] or { enabled = false }

swapButton = setupUI([[
Panel
  height: 19
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Smart Swap
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
swapButton:setId(switchSwap)
swapButton.title:setOn(charStorage[switchSwap].enabled)

swapButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  charStorage[switchSwap].enabled = newState
  saveSmartSwapChar()
end

panelSwap = setupUI([[  
RingConfig < Panel
  height: 244
  margin-top: 0
  phantom: false

  Label
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: "Normal Ring ID:"
    text-auto-resize: true

  BotItem
    id: ringNormal
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: title2
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left:3
    text: Custom Ring ID:
    text-auto-resize: true

  BotItem
    id: ringCustom
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: title3
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: Custom Equipped ID:
    text-auto-resize: true

  BotItem
    id: ringCustom2
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: labelHpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: Hp% to Equip:
    text-auto-resize: true
    
  HorizontalScrollBar
    id: hpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 5
    minimum: 1
    maximum: 100

  Label
    id: labelHpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8
    margin-left: 3
    text: Hp% to Unequip:
    text-auto-resize: true
    
  HorizontalScrollBar
    id: hpUnequip
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 5
    minimum: 1
    maximum: 100

  BotSwitch
    id: ativador
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-bottom: 5
    margin-left: 3
    margin-right: 5
    text: Smart Swap

AmuletConfig < Panel
  height: 244
  margin-top: 0
  phantom: false

  Label
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: "Normal Amulet ID:"
    text-auto-resize: true

  BotItem
    id: amuletNormal
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: title2
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left:3
    text: Custom Amulet ID:
    text-auto-resize: true

  BotItem
    id: amuletCustom
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: title3
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: Custom Equipped ID:
    text-auto-resize: true

  BotItem
    id: amuletCustom2
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    margin-top: 2
    margin-right: 5

  Label
    id: labelHpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 13
    margin-left: 3
    text: Hp% to Equip:
    text-auto-resize: true
    
  HorizontalScrollBar
    id: hpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 5
    minimum: 1
    maximum: 100

  Label
    id: labelHpEquip
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8
    margin-left: 3
    text: Hp% to Unequip:
    text-auto-resize: true
    
  HorizontalScrollBar
    id: hpUnequip
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    margin-left: 3
    margin-right: 5
    minimum: 1
    maximum: 100
    
  BotSwitch
    id: ativador
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-bottom: 5
    margin-left: 3
    margin-right: 5
    text: Smart Swap

EQPanel < Panel
  size: 155 190
  padding-left: 10
  padding-right: 10
  image-source: /images/ui/panel_flat
  image-border: 1
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

  BotTextEdit
    id: iconName
    anchors.top: feet.bottom
    anchors.left: parent.left
    size: 120 18
    margin-top: 10
    placeholder: Icon Name
    text-align: left
    
  Button
    id: iconShow
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-top: 0
    margin-left: 2
    height: 18
    text: I
    tooltip: Show/Hide Icone Swap
    $on:
      color: green

MainWindow
  id: panelSwap
  size: 560 355
  border: 1 #000000
  anchors.centerIn: parent
  margin-top: -40
  text: Panel Smart-Swap
  background-color: #101010

  FlatPanel
    id: panelBut
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 30
    background-color: #141414
    border-right: 1 #2a2a2a

  Button
    id: Ring
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.left
    margin-left: 5
    size: 100 20
    text: Ring
    color: #e6e6e6

  Button
    id: Amulet
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    margin-left: 5
    size: 100 20
    text: Amulet
    color: #e6e6e6

  Button
    id: swapSet
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    margin-left: 5
    size: 100 20
    text: Swap Sets
    color: #e6e6e6

  Button
    id: bpConfig
    anchors.verticalCenter: prev.verticalCenter
    anchors.right: panelBut.right
    margin-right: 5
    size: 100 20
    text: Bp Control
    tooltip: Control for open containers (necessary to tibia version < 9.60) [DESATIVED]
    color: #e6e6e6

  FlatPanel
    id: scriptsPanel
    anchors.top: panelBut.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-bottom: 20
    margin-top: 5

    FlatPanel
      id: ring1
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      margin: 5
      width: 167
      layout: verticalBox
      RingConfig
        id: ring1

    FlatPanel
      id: ring2
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: prev.right
      margin: 5
      margin-left: 10
      width: 167
      layout: verticalBox
      RingConfig
        id: ring2

    FlatPanel
      id: ring3
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: prev.right
      margin: 5
      margin-left: 10
      width: 167
      layout: verticalBox
      RingConfig
        id: ring3

    FlatPanel
      id: amulet1
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      margin: 5
      width: 167
      layout: verticalBox
      AmuletConfig
        id: amulet1

    FlatPanel
      id: amulet2
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: prev.right
      margin: 5
      margin-left: 10
      width: 167
      layout: verticalBox
      AmuletConfig
        id: amulet2

    FlatPanel
      id: amulet3
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: prev.right
      margin: 5
      margin-left: 10
      width: 167
      layout: verticalBox
      AmuletConfig
        id: amulet3
      
    ScrollablePanel
      id: content
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      vertical-scrollbar: contentScroll
      margin: 5
      image-source: /images/ui/panel_flat
      image-border: 1
      margin-right: 18

      EQPanel
        id: set1
        anchors.top: parent.top
        anchors.left: parent.left
        margin-top: 10
        margin-left: 10

      EQPanel
        id: set2
        anchors.top: prev.top
        anchors.left: prev.right
        margin-left: 10

      EQPanel
        id: set3
        anchors.top: prev.top
        anchors.left: prev.right
        margin-left: 10

      EQPanel
        id: set4
        anchors.top: set1.bottom
        anchors.left: parent.left
        margin-top: 10
        margin-left: 10

      EQPanel
        id: set5
        anchors.top: prev.top
        anchors.left: prev.right
        margin-left: 10

      EQPanel
        id: set6
        anchors.top: prev.top
        anchors.left: prev.right
        margin-left: 10


    VerticalScrollBar
      id: contentScroll
      anchors.top: prev.top
      anchors.left: prev.right
      anchors.bottom: prev.bottom
      step: 28
      pixels-scroll: true
      margin-left: 0

  Button
    id: closePanel
    anchors.left: scriptsPanel.left
    anchors.right: scriptsPanel.right
    anchors.top: scriptsPanel.bottom
    margin-left: -1
    margin-top: 5
    text: Close
    
]], g_ui.getRootWidget())
panelSwap.closePanel.onClick = function()
  panelSwap:hide()
end

if modules._G.g_app.isMobile() then
  panelSwap:setSize("560 375")
end

local SMART_SWAP_STORAGE = "lnsSmartSwapPanel"

charStorage[SMART_SWAP_STORAGE] = charStorage[SMART_SWAP_STORAGE] or {}
local ssCfg = charStorage[SMART_SWAP_STORAGE]

ssCfg.selectedTab = ssCfg.selectedTab or "ring"
ssCfg.rings = ssCfg.rings or {}
ssCfg.amulets = ssCfg.amulets or {}
ssCfg.sets = ssCfg.sets or {}

for i = 1, 3 do
  ssCfg.rings[i] = ssCfg.rings[i] or {
    normalId = 0,
    customId = 0,
    equippedId = 0,
    hpEquip = 90,
    hpUnequip = 95,
    enabled = false
  }

  ssCfg.amulets[i] = ssCfg.amulets[i] or {
    normalId = 0,
    customId = 0,
    equippedId = 0,
    hpEquip = 90,
    hpUnequip = 95,
    enabled = false
  }
end

for i = 1, 6 do
  ssCfg.sets[i] = ssCfg.sets[i] or {
    iconName = "",
    iconShow = false,
    slots = {
      head = 0,
      body = 0,
      legs = 0,
      feet = 0,
      neck = 0,
      ["left-hand"] = 0,
      finger = 0,
      ["right-hand"] = 0,
      ammo = 0
    }
  }
end

local function getBotItemId(widget)
  if not widget then return 0 end
  if widget.getItemId then
    return tonumber(widget:getItemId()) or 0
  elseif widget.getItem then
    local it = widget:getItem()
    if type(it) == "number" then return it end
    if type(it) == "table" and it.getId then return it:getId() end
  end
  return 0
end

local function updateBlessedState(widget)
  if not widget or not widget.setOn then return end
  widget:setOn(getBotItemId(widget) > 0)
end

local function setBotItemId(widget, itemId)
  itemId = tonumber(itemId) or 0
  if widget.setItemId then
    widget:setItemId(itemId)
  elseif widget.setItem then
    widget:setItem(itemId)
  end
  updateBlessedState(widget)
end

local function setScrollValue(scroll, value)
  value = tonumber(value) or 0
  if scroll.setValue then scroll:setValue(value) end
  if scroll.setText then scroll:setText(value .. "%") end
end

local function updateScrollText(scroll)
  if scroll and scroll.getValue and scroll.setText then
    scroll:setText(scroll:getValue() .. "%")
  end
end

local function styleTabButton(btn, active)
  if not btn then return end
  btn:setOpacity(active and 1 or 0.78)
  btn:setOn(active)
  btn:setTextOffset(active and {x = 0, y = -1} or {x = 0, y = 0})
  btn:setColor(active and "#ffffff" or "#bcbcbc")
  if btn.setBackgroundColor then
    btn:setBackgroundColor(active and "#1f1f1f" or "#141414")
  end
end

local function animateTabButton(btn)
  if not btn then return end
  local seq = {0.70, 0.82, 0.94, 1.00}
  for i, v in ipairs(seq) do
    schedule(100, function()
      if btn and not btn:isDestroyed() then
        btn:setOpacity(v)
      end
    end, i * 35)
  end
end

local function hideAllSwapSections()
  panelSwap.scriptsPanel.ring1:hide()
  panelSwap.scriptsPanel.ring2:hide()
  panelSwap.scriptsPanel.ring3:hide()
  panelSwap.scriptsPanel.amulet1:hide()
  panelSwap.scriptsPanel.amulet2:hide()
  panelSwap.scriptsPanel.amulet3:hide()
  panelSwap.scriptsPanel.content:hide()
  panelSwap.scriptsPanel.contentScroll:hide()
end

local function showSwapTab(tabName)
  hideAllSwapSections()

  styleTabButton(panelSwap.Ring, tabName == "ring")
  styleTabButton(panelSwap.Amulet, tabName == "amulet")
  styleTabButton(panelSwap.swapSet, tabName == "set")

  if tabName == "ring" then
    panelSwap.scriptsPanel.ring1:show()
    panelSwap.scriptsPanel.ring2:show()
    panelSwap.scriptsPanel.ring3:show()
    animateTabButton(panelSwap.Ring)

  elseif tabName == "amulet" then
    panelSwap.scriptsPanel.amulet1:show()
    panelSwap.scriptsPanel.amulet2:show()
    panelSwap.scriptsPanel.amulet3:show()
    animateTabButton(panelSwap.Amulet)

  elseif tabName == "set" then
    panelSwap.scriptsPanel.content:show()
    panelSwap.scriptsPanel.contentScroll:show()
    animateTabButton(panelSwap.swapSet)
  end

  ssCfg.selectedTab = tabName
  saveSmartSwapChar()
end

local function bindRingPanel(widget, index)
  local cfg = ssCfg.rings[index]

  setBotItemId(widget.ringNormal, cfg.normalId)
  setBotItemId(widget.ringCustom, cfg.customId)
  setBotItemId(widget.ringCustom2, cfg.equippedId)
  setScrollValue(widget.hpEquip, cfg.hpEquip)
  setScrollValue(widget.hpUnequip, cfg.hpUnequip)
  widget.ativador:setOn(cfg.enabled)

  updateScrollText(widget.hpEquip)
  updateScrollText(widget.hpUnequip)

  widget.ringNormal.onItemChange = function()
    cfg.normalId = getBotItemId(widget.ringNormal)
    saveSmartSwapChar()
  end

  widget.ringCustom.onItemChange = function()
    cfg.customId = getBotItemId(widget.ringCustom)
    saveSmartSwapChar()
  end

  widget.ringCustom2.onItemChange = function()
    cfg.equippedId = getBotItemId(widget.ringCustom2)
    saveSmartSwapChar()
  end

  widget.hpEquip.onValueChange = function(scroll, value)
    cfg.hpEquip = value
    updateScrollText(scroll)
    saveSmartSwapChar()
  end

  widget.hpUnequip.onValueChange = function(scroll, value)
    cfg.hpUnequip = value
    updateScrollText(scroll)
    saveSmartSwapChar()
  end

  widget.ativador.onClick = function(bt)
    local state = not bt:isOn()
    bt:setOn(state)
    cfg.enabled = state
    saveSmartSwapChar()
  end
end

local function bindAmuletPanel(widget, index)
  local cfg = ssCfg.amulets[index]

  setBotItemId(widget.amuletNormal, cfg.normalId)
  setBotItemId(widget.amuletCustom, cfg.customId)
  setBotItemId(widget.amuletCustom2, cfg.equippedId)
  setScrollValue(widget.hpEquip, cfg.hpEquip)
  setScrollValue(widget.hpUnequip, cfg.hpUnequip)
  widget.ativador:setOn(cfg.enabled)

  updateScrollText(widget.hpEquip)
  updateScrollText(widget.hpUnequip)

  widget.amuletNormal.onItemChange = function()
    cfg.normalId = getBotItemId(widget.amuletNormal)
    saveSmartSwapChar()
  end

  widget.amuletCustom.onItemChange = function()
    cfg.customId = getBotItemId(widget.amuletCustom)
    saveSmartSwapChar()
  end

  widget.amuletCustom2.onItemChange = function()
    cfg.equippedId = getBotItemId(widget.amuletCustom2)
    saveSmartSwapChar()
  end

  widget.hpEquip.onValueChange = function(scroll, value)
    cfg.hpEquip = value
    updateScrollText(scroll)
    saveSmartSwapChar()
  end

  widget.hpUnequip.onValueChange = function(scroll, value)
    cfg.hpUnequip = value
    updateScrollText(scroll)
    saveSmartSwapChar()
  end

  widget.ativador.onClick = function(bt)
    local state = not bt:isOn()
    bt:setOn(state)
    cfg.enabled = state
    saveSmartSwapChar()
  end
end

local function bindSetPanel(widget, index)
  local cfg = ssCfg.sets[index]

  local slotIds = {
    "head", "body", "legs", "feet", "neck",
    "left-hand", "finger", "right-hand", "ammo"
  }

  for _, slot in ipairs(slotIds) do
    if widget[slot] then
      setBotItemId(widget[slot], cfg.slots[slot] or 0)
      updateBlessedState(widget[slot])

      local oldOnItemChange = widget[slot].onItemChange
      widget[slot].onItemChange = function(self)
        cfg.slots[slot] = getBotItemId(self)
        updateBlessedState(self)
        saveSmartSwapChar()
        if oldOnItemChange then oldOnItemChange(self) end
      end
    end
  end

  if widget.iconName then
    widget.iconName:setText(cfg.iconName or "")
    widget.iconName.onTextChange = function(edit, text)
      cfg.iconName = text
      saveSmartSwapChar()
    end
  end

  if widget.iconShow then
    widget.iconShow:setOn(cfg.iconShow or false)
    widget.iconShow.onClick = function(bt)
      local state = not bt:isOn()
      bt:setOn(state)
      cfg.iconShow = state
      saveSmartSwapChar()
    end
  end
end

bindRingPanel(panelSwap.scriptsPanel.ring1.ring1, 1)
bindRingPanel(panelSwap.scriptsPanel.ring2.ring2, 2)
bindRingPanel(panelSwap.scriptsPanel.ring3.ring3, 3)

bindAmuletPanel(panelSwap.scriptsPanel.amulet1.amulet1, 1)
bindAmuletPanel(panelSwap.scriptsPanel.amulet2.amulet2, 2)
bindAmuletPanel(panelSwap.scriptsPanel.amulet3.amulet3, 3)

bindSetPanel(panelSwap.scriptsPanel.content.set1, 1)
bindSetPanel(panelSwap.scriptsPanel.content.set2, 2)
bindSetPanel(panelSwap.scriptsPanel.content.set3, 3)
bindSetPanel(panelSwap.scriptsPanel.content.set4, 4)
bindSetPanel(panelSwap.scriptsPanel.content.set5, 5)
bindSetPanel(panelSwap.scriptsPanel.content.set6, 6)

panelSwap.Ring.onClick = function()
  showSwapTab("ring")
end

panelSwap.Amulet.onClick = function()
  showSwapTab("amulet")
end

panelSwap.swapSet.onClick = function()
  showSwapTab("set")
end

showSwapTab(ssCfg.selectedTab or "ring")
panelSwap:hide()

swapButton.settings.onClick = function()
  if panelSwap:isVisible() then
    panelSwap:hide()
  else
    panelSwap:show()
    panelSwap:raise()
    panelSwap:focus()
    showSwapTab(ssCfg.selectedTab or "ring")
  end
end

local SMART_SWAP_COOLDOWN_MS = 350

local CD_MIGHT_RING = 3048
local CD_SSA_AMULET = 3081

local SMART_SLOT_FINGER = SlotFinger or 9
local SMART_SLOT_NECK   = SlotNeck or 2

local ringCdUntil = 0
local amuletCdUntil = { [1] = 0, [2] = 0, [3] = 0 }

local function smartNow()
  if g_clock and type(g_clock.millis) == "function" then return g_clock.millis() end
  if now then return now end
  return 0
end

local function smartItemId(it)
  if not it then return 0 end
  if it.getId then return tonumber(it:getId()) or 0 end
  return 0
end

local function smartGetFinger()
  if type(getFinger) == "function" then return getFinger() end
  return getSlot(SMART_SLOT_FINGER)
end

local function smartGetNeck()
  if type(getNeck) == "function" then return getNeck() end
  return getSlot(SMART_SLOT_NECK)
end

local function smartIsIdIn(id, a, b)
  id = tonumber(id) or 0
  a = tonumber(a) or 0
  b = tonumber(b) or 0
  if id <= 0 then return false end
  return (a > 0 and id == a) or (b > 0 and id == b)
end

local function smartUseCooldown(kind, item2, item3)
  item2 = tonumber(item2) or 0
  item3 = tonumber(item3) or 0

  if kind == "ring" then
    return item2 == CD_MIGHT_RING or item3 == CD_MIGHT_RING
  end

  if kind == "amulet" then
    return item2 == CD_SSA_AMULET or item3 == CD_SSA_AMULET
  end

  return false
end

local function smartGetContainers()
  if type(getContainers) == "function" then
    return getContainers() or {}
  end
  if g_game and type(g_game.getContainers) == "function" then
    return g_game.getContainers() or {}
  end
  return {}
end

local function smartFindItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  if type(findItem) == "function" then
    local it = findItem(id)
    if it then return it end
  end

  for _, c in ipairs(smartGetContainers()) do
    for _, it in ipairs(c:getItems() or {}) do
      if it and it.getId and tonumber(it:getId()) == id then
        return it
      end
    end
  end

  return nil
end

local function smartGetContainerCount(container)
  if not container then return 0 end
  if container.getItemsCount then return tonumber(container:getItemsCount()) or 0 end
  return #(container:getItems() or {})
end

local function smartGetContainerCapacity(container)
  if not container then return 0 end
  if container.getCapacity then return tonumber(container:getCapacity()) or 0 end
  return 0
end

local function smartGetFreeContainer()
  for _, container in ipairs(smartGetContainers()) do
    local name = (container.getName and container:getName() or ""):lower()
    local cap = smartGetContainerCapacity(container)
    local count = smartGetContainerCount(container)

    if (cap <= 0 or count < cap)
      and not name:find("dead")
      and not name:find("slain")
      and not name:find("depot")
      and not name:find("quiver") then
      return container
    end
  end

  return nil
end

local function smartUnequip(slot)
  local item = getSlot(slot)
  if not item then return false end

  if g_game.getClientVersion() >= 959 then
    g_game.equipItemId(item:getId())
    return true
  end

  local dest = smartGetFreeContainer()
  if not dest then return false end

  local pos = dest:getSlotPosition(smartGetContainerCount(dest))
  g_game.move(item, pos, item:getCount())
  return true
end

local function smartEquipToSlot(id, slot)
  id = tonumber(id) or 0
  if id <= 0 then return false end

  if g_game.getClientVersion() >= 959 then
    g_game.equipItemId(id)
    return true
  end

  local it = smartFindItemById(id)
  if not it then return false end

  g_game.move(it, {x = 65535, y = slot, z = 0}, 1)
  return true
end

local function smartEquipSpecial(id1, id2, slot)
  id1 = tonumber(id1) or 0
  id2 = tonumber(id2) or 0

  if g_game.getClientVersion() >= 959 then
    local pick = id1 > 0 and id1 or id2
    if pick <= 0 then return false end
    g_game.equipItemId(pick)
    return true
  end

  local it = smartFindItemById(id1) or smartFindItemById(id2)
  if not it then return false end

  g_game.move(it, {x = 65535, y = slot, z = 0}, 1)
  return true
end

local function getEnabledRingRows()
  local rows = {}
  if not ssCfg or not ssCfg.rings then return rows end

  for i = 1, 3 do
    local row = ssCfg.rings[i]
    if row and row.enabled == true then
      rows[#rows + 1] = {
        index = i,
        normalId = tonumber(row.normalId) or 0,
        customId = tonumber(row.customId) or 0,
        equippedId = tonumber(row.equippedId) or 0,
        hpEquip = tonumber(row.hpEquip) or 0,
        hpUnequip = tonumber(row.hpUnequip) or tonumber(row.hpEquip) or 0
      }
    end
  end

  table.sort(rows, function(a, b)
    if a.hpEquip == b.hpEquip then
      return a.index < b.index
    end
    return a.hpEquip < b.hpEquip
  end)

  return rows
end

local function getCurrentEquippedRingRow(equippedId, rows)
  equippedId = tonumber(equippedId) or 0
  if equippedId <= 0 then return nil end

  for _, row in ipairs(rows) do
    if smartIsIdIn(equippedId, row.customId, row.equippedId) then
      return row
    end
  end

  return nil
end

local function getBestRingRowToEquip(hp, rows)
  local best = nil

  for _, row in ipairs(rows) do
    if hp < row.hpEquip and (row.customId > 0 or row.equippedId > 0) then
      best = row
      break
    end
  end

  return best
end

local function getRingNormalId(rows)
  for _, row in ipairs(rows) do
    if row.normalId > 0 then
      return row.normalId
    end
  end
  return 0
end

local function processRingSwapSystem()
  local hp = hppercent()
  local t = smartNow()
  local finger = smartGetFinger()
  local equippedId = smartItemId(finger)
  local rows = getEnabledRingRows()

  if #rows == 0 then return false end

  local currentRow = getCurrentEquippedRingRow(equippedId, rows)
  local bestRow = getBestRingRowToEquip(hp, rows)
  local normalId = getRingNormalId(rows)
  local cdActive = ringCdUntil > t

  if currentRow then
    local currentIsCooldownRing = smartUseCooldown("ring", currentRow.customId, currentRow.equippedId)

    if bestRow and bestRow.index ~= currentRow.index and bestRow.hpEquip <= currentRow.hpEquip then
      if not (cdActive and currentIsCooldownRing) then
        if smartEquipSpecial(bestRow.customId, bestRow.equippedId, SMART_SLOT_FINGER) then
          if smartUseCooldown("ring", bestRow.customId, bestRow.equippedId) then
            ringCdUntil = t + SMART_SWAP_COOLDOWN_MS
          end
          delay(120)
          return true
        end
      end
      return false
    end

    if hp <= currentRow.hpUnequip then
      return false
    end
  end

  if bestRow then
    if not currentRow or currentRow.index ~= bestRow.index then
      if smartEquipSpecial(bestRow.customId, bestRow.equippedId, SMART_SLOT_FINGER) then
        if smartUseCooldown("ring", bestRow.customId, bestRow.equippedId) then
          ringCdUntil = t + SMART_SWAP_COOLDOWN_MS
        end
        delay(120)
        return true
      end
    end
    return false
  end

  if cdActive then
    return false
  end

  if normalId > 0 then
    if equippedId ~= normalId then
      if smartEquipToSlot(normalId, SMART_SLOT_FINGER) then
        delay(120)
        return true
      end
    end
    return false
  end

  if equippedId ~= 0 then
    if smartUnequip(SMART_SLOT_FINGER) then
      delay(120)
      return true
    end
  end

  return false
end

local function processAmuletSwap(index, row)
  if not row or row.enabled ~= true then return false end

  local hp = hppercent()
  local t = smartNow()

  local neck = smartGetNeck()
  local equippedId = smartItemId(neck)

  local normalId   = tonumber(row.normalId) or 0
  local specialId  = tonumber(row.customId) or 0
  local specialEq  = tonumber(row.equippedId) or 0
  local equipPct   = tonumber(row.hpEquip) or 0
  local unequipPct = tonumber(row.hpUnequip) or equipPct

  local hasNormal = normalId > 0
  local useCd = smartUseCooldown("amulet", specialId, specialEq)
  local cdActive = useCd and ((amuletCdUntil[index] or 0) > t) or false

  if hp < equipPct then
    if smartIsIdIn(equippedId, specialId, specialEq) then return false end

    if smartEquipSpecial(specialId, specialEq, SMART_SLOT_NECK) then
      if useCd then
        amuletCdUntil[index] = t + SMART_SWAP_COOLDOWN_MS
      end
      delay(120)
      return true
    end
    return false
  end

  if useCd and cdActive then
    if hp > unequipPct and equippedId ~= 0 then
      if smartUnequip(SMART_SLOT_NECK) then
        delay(120)
        return true
      end
    end
    return false
  end

  if hp > unequipPct then
    if hasNormal then
      if equippedId ~= normalId then
        if smartEquipToSlot(normalId, SMART_SLOT_NECK) then
          delay(120)
          return true
        end
      end
      return false
    end

    if equippedId ~= 0 then
      if smartUnequip(SMART_SLOT_NECK) then
        delay(120)
        return true
      end
    end
  end

  return false
end

local function fullTankIsOn()
  return charStorage
    and charStorage.lnsFullTank
    and charStorage.lnsFullTank.enabled == true
end

macro(50, function()
  if fullTankIsOn() then return end
  if not charStorage[switchSwap] or charStorage[switchSwap].enabled ~= true then return end
  if not ssCfg or not ssCfg.rings then return end
  processRingSwapSystem()
end)

macro(50, function()
  if fullTankIsOn() then return end
  if not charStorage[switchSwap] or charStorage[switchSwap].enabled ~= true then return end
  if not ssCfg or not ssCfg.amulets then return end

  for i = 1, 3 do
    if processAmuletSwap(i, ssCfg.amulets[i]) then
      return
    end
  end
end)

-- =========================
-- SWAP SET ICONS / EQUIP FAST
-- =========================

local SWAPSET_SLOT_CONST = {
  head = SlotHead,
  neck = SlotNeck,
  body = SlotBody,
  ["left-hand"] = SlotLeft,
  ["right-hand"] = SlotRight,
  legs = SlotLeg,
  feet = SlotFeet,
  finger = SlotFinger,
  ammo = SlotAmmo
}

local SWAPSET_ORDER = {
  "neck", "head", "body", "legs", "feet", "right-hand", "left-hand", "finger", "ammo"
}

local SWAPSET_IS_OLD_CLIENT = g_game.getClientVersion() < 960
local SWAPSET_ACTION_DELAY = SWAPSET_IS_OLD_CLIENT and 250 or 25

local swapSetIcons = {}
local swapSetRuntime = {}

local function sswapNow()
  if g_clock and type(g_clock.millis) == "function" then return g_clock.millis() end
  if now then return now end
  return 0
end

local function sswapTrim(s)
  return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function sswapGetSet(index)
  if not ssCfg or not ssCfg.sets then return nil end
  local cfg = ssCfg.sets[index]
  if type(cfg) ~= "table" then return nil end
  return cfg
end

local function sswapGetState(index)
  if not swapSetRuntime[index] then
    swapSetRuntime[index] = { active = false, nextAction = 0 }
  end
  return swapSetRuntime[index]
end

local function sswapGetSetName(index)
  local cfg = sswapGetSet(index) or {}
  local txt = sswapTrim(cfg.iconName or "")
  if txt == "" then txt = "SET" .. index end
  return txt
end

local function sswapGetIconItemId(index)
  local cfg = sswapGetSet(index) or {}
  local slots = cfg.slots or {}
  return tonumber(slots["left-hand"]) or 0
end

local function sswapSetIconItem(icon, itemId)
  itemId = tonumber(itemId) or 0
  if not icon then return end

  if icon.item and icon.item.setItemId then
    icon.item:setItemId(itemId)
    return
  end

  if icon.getChildById then
    local child = icon:getChildById("item")
    if child and child.setItemId then
      child:setItemId(itemId)
    end
  end
end

local function sswapGetSlotItem(slotConst)
  return getSlot(slotConst)
end

local function sswapGetSlotId(slotConst)
  local it = sswapGetSlotItem(slotConst)
  return it and it:getId() or 0
end

local function sswapGetContainers()
  if type(getContainers) == "function" then
    return getContainers() or {}
  end
  if g_game and type(g_game.getContainers) == "function" then
    return g_game.getContainers() or {}
  end
  return {}
end

local function sswapFindItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  if type(findItem) == "function" then
    local it = findItem(id)
    if it then return it end
  end

  for _, cont in pairs(sswapGetContainers()) do
    for _, it in ipairs(cont:getItems() or {}) do
      if it and it.getId and tonumber(it:getId()) == id then
        return it
      end
    end
  end

  return nil
end

local function sswapGetFreeContainer()
  for _, container in ipairs(sswapGetContainers()) do
    local name = (container.getName and container:getName() or ""):lower()
    local cap = container.getCapacity and tonumber(container:getCapacity()) or 0
    local count = container.getItemsCount and tonumber(container:getItemsCount()) or #(container:getItems() or {})

    if (cap <= 0 or count < cap)
      and not name:find("dead")
      and not name:find("slain")
      and not name:find("depot")
      and not name:find("locker")
      and not name:find("quiver") then
      return container
    end
  end
  return nil
end

local function sswapUnequipSlot(slotConst)
  local item = sswapGetSlotItem(slotConst)
  if not item then return false end

  if not SWAPSET_IS_OLD_CLIENT then
    local ok = pcall(function()
      g_game.equipItemId(item:getId())
    end)
    return ok
  end

  local dest = sswapGetFreeContainer()
  if not dest then return false end

  local pos = dest.getSlotPosition and dest:getSlotPosition(dest.getItemsCount and dest:getItemsCount() or #(dest:getItems() or {}))
  if not pos then return false end

  local ok = pcall(function()
    g_game.move(item, pos, item:getCount())
  end)
  return ok
end

local function sswapEquipToSlot(itemId, slotConst)
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return false end

  if not SWAPSET_IS_OLD_CLIENT then
    local ok = pcall(function()
      g_game.equipItemId(itemId, slotConst)
    end)
    if ok then return true end

    ok = pcall(function()
      g_game.equipItemId(itemId)
    end)
    return ok
  end

  local it = sswapFindItemById(itemId)
  if not it then return false end

  local ok = pcall(function()
    g_game.move(it, {x = 65535, y = slotConst, z = 0}, 1)
  end)
  return ok
end

local function sswapPrepareHands(slots)
  local wantLeft = tonumber(slots["left-hand"]) or 0
  local wantRight = tonumber(slots["right-hand"]) or 0

  local curLeft = sswapGetSlotId(SlotLeft)
  local curRight = sswapGetSlotId(SlotRight)

  if curLeft > 0 and wantLeft == 0 and wantRight > 0 then
    if sswapUnequipSlot(SlotLeft) then return true end
  end

  if curRight > 0 and wantRight == 0 and wantLeft > 0 then
    if sswapUnequipSlot(SlotRight) then return true end
  end

  if wantRight > 0 and curLeft > 0 and curLeft ~= wantLeft then
    if sswapUnequipSlot(SlotLeft) then return true end
  end

  if wantLeft > 0 and curRight > 0 and curRight ~= wantRight then
    if sswapUnequipSlot(SlotRight) then return true end
  end

  return false
end

local function sswapApplyOldClient(index)
  local cfg = sswapGetSet(index)
  if not cfg then return false, true end

  local slots = cfg.slots or {}

  if sswapPrepareHands(slots) then
    return true, false
  end

  for _, part in ipairs(SWAPSET_ORDER) do
    local wantedId = tonumber(slots[part]) or 0
    local slotConst = SWAPSET_SLOT_CONST[part]
    local currentId = sswapGetSlotId(slotConst)

    if wantedId <= 0 then
      if currentId > 0 then
        if sswapUnequipSlot(slotConst) then
          return true, false
        end
      end
    else
      if currentId ~= wantedId then
        if sswapEquipToSlot(wantedId, slotConst) then
          return true, false
        end
        return false, false
      end
    end
  end

  return false, true
end

local function sswapApplyNewClient(index)
  local cfg = sswapGetSet(index)
  if not cfg then return false, true end

  local slots = cfg.slots or {}
  local changed = false

  if sswapPrepareHands(slots) then
    changed = true
  end

  for _, part in ipairs(SWAPSET_ORDER) do
    local wantedId = tonumber(slots[part]) or 0
    local slotConst = SWAPSET_SLOT_CONST[part]
    local currentId = sswapGetSlotId(slotConst)

    if wantedId <= 0 then
      if currentId > 0 then
        if sswapUnequipSlot(slotConst) then
          changed = true
        end
      end
    else
      if currentId ~= wantedId then
        local ok = pcall(function()
          g_game.equipItemId(wantedId)
        end)

        if not ok then
          ok = pcall(function()
            g_game.equipItemId(wantedId)
          end)
        end

        if ok then
          changed = true
        end
      end
    end
  end

  for _, part in ipairs(SWAPSET_ORDER) do
    local wantedId = tonumber(slots[part]) or 0
    local slotConst = SWAPSET_SLOT_CONST[part]
    local currentId = sswapGetSlotId(slotConst)

    if wantedId > 0 and currentId ~= wantedId then
      return changed, false
    end

    if wantedId <= 0 and currentId > 0 then
      return changed, false
    end
  end

  return changed, true
end

local function sswapRefreshIcon(index)
  local icon = swapSetIcons[index]
  if not icon then return end

  local cfg = sswapGetSet(index)
  local state = sswapGetState(index)

  if not charStorage[switchSwap] or charStorage[switchSwap].enabled ~= true or not cfg or cfg.iconShow ~= true then
    state.active = false
    icon:hide()
    return
  end

  local iconItemId = sswapGetIconItemId(index)
  local name = sswapGetSetName(index)

  sswapSetIconItem(icon, iconItemId)

  if state.active then
    icon.text:setColoredText({name, "green"})
    icon.text:setFont("verdana-11px-rounded")
  else
    icon.text:setColoredText({name, "white"})
    icon.text:setFont("verdana-11px-rounded")
  end

  icon:show()
end

local function sswapRefreshAllIcons()
  for i = 1, 6 do
    sswapRefreshIcon(i)
  end
end

local function sswapStart(index)
  local cfg = sswapGetSet(index)
  if not cfg or cfg.iconShow ~= true then return end
  if not charStorage[switchSwap] or charStorage[switchSwap].enabled ~= true then return end

  local state = sswapGetState(index)
  state.active = true
  state.nextAction = 0
  sswapRefreshIcon(index)
end

local function sswapStop(index)
  local state = sswapGetState(index)
  state.active = false
  sswapRefreshIcon(index)
end

local function sswapCreateIcon(index)
  local icon = addIcon("LNS_SWAP_SET_ICON_" .. index, {
    item = {id = 0, count = 1},
    text = "SET" .. index,
    switchable = false,
    moveable = true
  }, function()
    sswapStart(index)
  end)

  icon:setSize({height = 50, width = 52})
  icon:hide()
  swapSetIcons[index] = icon
end

for i = 1, 6 do
  sswapCreateIcon(i)
end

macro(100, function()
  sswapRefreshAllIcons()
end)

macro(200, function()
  if fullTankIsOn() then return end
  if not charStorage[switchSwap] or charStorage[switchSwap].enabled ~= true then
    for i = 1, 6 do
      sswapGetState(i).active = false
    end
    sswapRefreshAllIcons()
    return
  end

  local t = sswapNow()

  for i = 1, 6 do
    local state = sswapGetState(i)

    if state.active and state.nextAction <= t then
      local changed, finished

      if SWAPSET_IS_OLD_CLIENT then
        changed, finished = sswapApplyOldClient(i)
      else
        changed, finished = sswapApplyNewClient(i)
      end

      if finished then
        sswapStop(i)
      elseif changed then
        state.nextAction = t + SWAPSET_ACTION_DELAY
      end
    end
  end
end)

-------------------- TRAVEL
setDefaultTab("Main")

switchTravel = "travelButton"
storage[switchTravel] = storage[switchTravel] or { enabled = false }

local STKEY = "lnsFastTravel"
storage[STKEY] = storage[STKEY] or {
  selectedNpc = "",
  npcs = {}
}
local st = storage[STKEY]

local function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function normalizeText(s)
  s = tostring(s or ""):lower()
  s = s:gsub("%s+", " ")
  return trim(s)
end

local function sameText(a, b)
  return normalizeText(a) == normalizeText(b)
end

local function containsText(hay, needle)
  hay = normalizeText(hay)
  needle = normalizeText(needle)
  if needle == "" then return true end
  return hay:find(needle, 1, true) ~= nil
end

local function ensureNpc(name)
  name = trim(name)
  if name == "" then return nil end
  st.npcs[name] = st.npcs[name] or { cities = {} }
  st.npcs[name].cities = st.npcs[name].cities or {}
  return name
end

local function cityExists(cities, cityName)
  for _, c in ipairs(cities) do
    if sameText(c, cityName) then return true end
  end
  return false
end

local function addCityToNpc(npcName, cityName)
  npcName = trim(npcName)
  cityName = trim(cityName)
  if npcName == "" or cityName == "" then return false end
  if not st.npcs[npcName] then return false end
  local cities = st.npcs[npcName].cities
  if cityExists(cities, cityName) then return false end
  table.insert(cities, cityName)
  return true
end

local defaultNpcs = {
  ["Captain Bluebear"] = { cities = { "Carlin", "Ab'dendriel", "Edron", "Venore", "Port Hope", "Liberty Bay", "Yalahar", "Roshamuul", "Krailos", "Oramond", "Rangiroa", "Svargrond", "Arcadia" } },
  ["Captain Fearless"] = { cities = { "Thais", "Carlin", "Ab'dendriel", "Port Hope", "Edron", "Darashia", "Liberty Bay", "Svargrond", "Yalahar", "Gray Island", "Ankrahmun", "Issavi", "Arcadia", "Rangiroa" } },
  ["Captain Greyhound"] = { cities = { "Thais", "Ab'dendriel", "Venore", "Svargrond", "Yalahar", "Rangiroa", "Arcadia", "Edron" } },
  ["Captain Seahorse"] = { cities = { "Thais", "Carlin", "Ab'dendriel", "Venore", "Port Hope", "Ankrahmun", "Liberty Bay", "Gray Island", "Cormaya" } },
  ["Karith"] = { cities = { "Thais", "Carlin", "Ab'dendriel", "Ankrahmun", "Darashia", "Venore", "Port Hope", "Liberty Bay", "Arcadia" } },
  ["Captain Sinbeard"] = { cities = { "Darashia", "Venore", "Liberty Bay", "Port Hope", "Yalahar", "Edron" } },
  ["Petros"] = { cities = { "Venore", "Port Hope", "Liberty Bay", "Ankrahmun", "Yalahar", "Issavi", "Gray Island" } },
  ["Charles"] = { cities = { "Thais", "Darashia", "Venore", "Liberty Bay", "Ankrahmun", "Yalahar", "Edron" } },
  ["Jack Fate"] = { cities = { "Edron", "Thais", "Venore", "Darashia", "Ankrahmun", "Yalahar", "Port Hope", "Goroma", "Liberty Bay" } },
  ["Captain Seagull"] = { cities = { "Thais", "Carlin", "Venore", "Yalahar", "Edron", "Gray Island" } },
  ["Scrutinon"] = { cities = { "Ab'dendriel", "Darashia", "Edron", "Venore" } },
  ["Captain Harava"] = { cities = { "Darashia", "Krailos", "Oramond", "Venore" } },
  ["Captain Gulliver"] = { cities = { "Thais", "Edron", "Venore", "Port Hope", "Issavi", "Krailos" } },
  ["Captain Pelagia"] = { cities = { "Venore", "Edron", "Oramond", "Issavi", "Darashia" } },
  ["Captain Chelop"] = { cities = { "Thais" } },
  ["Captain Breezelda"] = { cities = { "Carlin", "Thais", "Venore", "Arcadia" } },
  ["Captain Frank"] = { cities = { "Venore" } },
  ["Captain Grenald"] = { cities = { "Carlin", "Thais", "Venore", "Yalahar", "Svargrond" } },
  ["Pemaret"] = { cities = { "Edron" } },
  ["Maris"] = { cities = { "Fenrock", "Mistrock", "Yalahar" } },
  ["Captain Cookie"] = { cities = { "Liberty Bay" } },
  ["Chemar"] = { cities = { "Farmine" } },
  ["Melian"] = { cities = { "Darashia", "Femor Hills", "Svargrond", "Issavi", "Marapur", "Edron" } },
  ["Imbul"] = { cities = { "East" } },
  ["Lorek"] = { cities = { "Banuta", "West" } },
  ["Buddel"] = { cities = { "Helheim", "Svargrond" } },
  ["Gurbasch"] = { cities = { "Gnomprona" } },
  ["Urks The Mute"] = { cities = { "Cormaya" } },
  ["Thorgrin"] = { cities = { "Cormaya" } },
  ["Eustacio"] = { cities = { "Shortcut" } },
  ["Captain Jack Rat"] = { cities = { "Sail", "Safe" } },
  ["Harlow"] = { cities = { "Yalahar", "Vengoth" } },
}

st.npcs = st.npcs or {}

for npcName, data in pairs(defaultNpcs) do
  st.npcs[npcName] = st.npcs[npcName] or { cities = {} }
  st.npcs[npcName].cities = st.npcs[npcName].cities or {}

  for _, city in ipairs(data.cities or {}) do
    if not cityExists(st.npcs[npcName].cities, city) then
      table.insert(st.npcs[npcName].cities, city)
    end
  end
end


travelInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 388 322
  anchors.centerIn: parent
  margin-top: -50
  text: Panel Fast-Travel
  opacity: 1.00

  FlatPanel
    id: fpanel
    anchors.fill: parent
    margin: -3
    margin-bottom: 18

  TextEdit
    id: pesquisarNPC
    anchors.top: prev.top
    anchors.left: prev.left
    width: 170
    margin-left: 5
    margin-top: 5
    placeholder: Search Npc Name

  TextList
    id: panelMain
    anchors.top: prev.bottom
    anchors.right: prev.right
    anchors.left: prev.left
    margin-right: 10
    margin-top: 2
    height: 205
    opacity: 0.95
    vertical-scrollbar: panelMainScroll

  VerticalScrollBar
    id: panelMainScroll
    anchors.top: panelMain.top
    anchors.bottom: panelMain.bottom
    anchors.left: panelMain.right
    width: 13
    margin-top: 1
    margin-bottom: 1
    step: 18
    pixels-scroll: true

  TextEdit
    id: inserirNpcName
    anchors.top: panelMain.bottom
    anchors.left: panelMain.left
    width: 140
    margin-top: 2
    placeholder: Insert Npc Name
  
  Button
    id: buttonAdd
    anchors.top: prev.top
    anchors.right: panelMainScroll.right
    anchors.left: prev.right
    anchors.bottom: prev.bottom
    margin-left: 2
    text: +
    font: sans-bold-16px

  VerticalSeparator
    id: vertsep
    anchors.top: pesquisarNPC.top
    anchors.left: pesquisarNPC.right
    margin-left: 5
    anchors.bottom: buttonAdd.bottom

  TextList
    id: configLista
    anchors.top: pesquisarNPC.top
    anchors.right: fpanel.right
    anchors.left: prev.right
    margin-left: 3
    margin-top: 0
    margin-right: 17
    height: 230
    vertical-scrollbar: ConfigListaScroll

  VerticalScrollBar
    id: ConfigListaScroll
    anchors.top: configLista.top
    anchors.bottom: configLista.bottom
    anchors.left: configLista.right
    width: 13
    margin-top: 1
    margin-bottom: 1
    step: 18
    pixels-scroll: true

  TextEdit
    id: inserirCityName
    anchors.top: configLista.bottom
    anchors.left: configLista.left
    width: 140
    margin-top: 2
    placeholder: Insert City Name
  
  Button
    id: buttonCity
    anchors.top: prev.top
    anchors.right: ConfigListaScroll.right
    anchors.bottom: prev.bottom
    anchors.left: prev.right
    margin-left: 2
    text: +
    font: sans-bold-16px

  Button
    id: closePanel
    anchors.left: fpanel.left
    anchors.right: fpanel.right
    anchors.top: fpanel.bottom
    margin-top: 5
    text: Close

]=], g_ui.getRootWidget())
travelInterface:hide()

travelInterface.closePanel.onClick = function()
  travelInterface:hide()
end

local npcRowTemplate = [[
UIWidget
  id: root
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
    id: npcName
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
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
]]

local cityRowTemplate = [[
UIWidget
  id: root
  height: 18
  focusable: false
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #2F2F2F
    opacity: 0.75

  Label
    id: cityName
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
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
]]

local npcRows = {}
local cityRows = {}

local function sortNpcNames()
  local names = {}
  for npcName, _ in pairs(st.npcs) do
    table.insert(names, npcName)
  end
  table.sort(names, function(a, b)
    return normalizeText(a) < normalizeText(b)
  end)
  return names
end

local function refreshCitiesForSelectedNpc()
  local list = travelInterface.configLista
  if not list then return end

  if list.destroyChildren then list:destroyChildren() end
  cityRows = {}

  local npcName = trim(st.selectedNpc or "")
  if npcName == "" or not st.npcs[npcName] then return end

  local cities = st.npcs[npcName].cities or {}
  table.sort(cities, function(a, b)
    return normalizeText(a) < normalizeText(b)
  end)

  for _, cityName in ipairs(cities) do
    local row = g_ui.loadUIFromString(cityRowTemplate, list)
    row.cityName:setText(cityName)

    row.remove.onClick = function()
      local npc = st.npcs[npcName]
      if not npc or not npc.cities then return end

      for i = #npc.cities, 1, -1 do
        if sameText(npc.cities[i], cityName) then
          table.remove(npc.cities, i)
        end
      end

      refreshCitiesForSelectedNpc()
    end

    table.insert(cityRows, {
      root = row,
      nameLabel = row.cityName,
      removeBtn = row.remove
    })
  end
end

local function selectNpc(npcName)
  npcName = trim(npcName)
  if npcName == "" then
    st.selectedNpc = ""
    refreshCitiesForSelectedNpc()
    return
  end
  if not st.npcs[npcName] then return end

  st.selectedNpc = npcName
  refreshCitiesForSelectedNpc()

  for name, pack in pairs(npcRows) do
    if pack and pack.root and name == npcName then
      pack.root:focus()
    end
  end
end

local function bindNpcRowClick(row, npcName)
  row.onMouseRelease = function(widget, mousePos, button)
    if button ~= MouseLeftButton then return end
    selectNpc(npcName)
  end

  if row.npcName then
    row.npcName.onMouseRelease = function(widget, mousePos, button)
      if button ~= MouseLeftButton then return end
      selectNpc(npcName)
    end
  end

  row.onClick = function()
    selectNpc(npcName)
  end
end

local function matchesNpc(npcName, q)
  if q == "" then return true end
  return containsText(npcName, q)
end

local function filterNpcRows(query)
  local q = normalizeText(query)
  for npcName, pack in pairs(npcRows) do
    if pack and pack.root then
      if matchesNpc(npcName, q) then
        pack.root:show()
      else
        pack.root:hide()
      end
    end
  end
end

local function refreshNpcList()
  local list = travelInterface.panelMain
  if not list then return end

  if list.destroyChildren then list:destroyChildren() end
  npcRows = {}

  local names = sortNpcNames()
  for _, npcName in ipairs(names) do
    local row = g_ui.loadUIFromString(npcRowTemplate, list)
    row.npcName:setText(npcName)

    npcRows[npcName] = {
      root = row,
      nameLabel = row.npcName,
      removeBtn = row.remove
    }

    bindNpcRowClick(row, npcName)

    row.remove.onClick = function()
      if st.npcs[npcName] then st.npcs[npcName] = nil end
      if sameText(st.selectedNpc, npcName) then st.selectedNpc = "" end

      local currentFilter = travelInterface.pesquisarNPC and travelInterface.pesquisarNPC:getText() or ""
      refreshNpcList()
      filterNpcRows(currentFilter or "")
      refreshCitiesForSelectedNpc()
    end
  end

  if st.selectedNpc ~= "" and npcRows[st.selectedNpc] and npcRows[st.selectedNpc].root then
    npcRows[st.selectedNpc].root:focus()
  end
end

travelInterface.pesquisarNPC.onTextChange = function(_, text)
  filterNpcRows(text or "")
end

travelInterface.buttonAdd.onClick = function()
  local name = travelInterface.inserirNpcName:getText() or ""
  name = trim(name)
  if name == "" then return end

  ensureNpc(name)
  travelInterface.inserirNpcName:setText("")
  refreshNpcList()

  local q = travelInterface.pesquisarNPC:getText() or ""
  filterNpcRows(q)

  selectNpc(name)
end

travelInterface.buttonCity.onClick = function()
  local npcName = trim(st.selectedNpc or "")
  if npcName == "" then return end

  local cityName = travelInterface.inserirCityName:getText() or ""
  cityName = trim(cityName)
  if cityName == "" then return end

  local ok = addCityToNpc(npcName, cityName)
  if ok then
    travelInterface.inserirCityName:setText("")
    refreshCitiesForSelectedNpc()
  end
end

refreshNpcList()
refreshCitiesForSelectedNpc()

do
  local q = travelInterface.pesquisarNPC and travelInterface.pesquisarNPC:getText() or ""
  filterNpcRows(q or "")
end

local function nowMs()
  if g_clock and g_clock.millis then return g_clock.millis() end
  return os.time() * 1000
end

local function distSqm(a, b)
  if not a or not b then return 999 end
  if a.z ~= b.z then return 999 end
  return math.max(math.abs(a.x - b.x), math.abs(a.y - b.y))
end

local function sortCities(cities)
  table.sort(cities, function(a, b)
    return normalizeText(a) < normalizeText(b)
  end)
end

local function findNpcOnScreenByName(name)
  name = trim(name)
  if name == "" then return nil end

  local specs = getSpectators() or {}

  for _, cr in ipairs(specs) do
    if cr and cr.getName and cr.getPosition then
      if sameText(cr:getName(), name) then
        return cr
      end
    end
  end

  return nil
end

local function isNpcNear(name, maxDist)
  local me = g_game.getLocalPlayer()
  if not me then return false end
  local myPos = me:getPosition()
  if not myPos then return false end

  local npc = findNpcOnScreenByName(name)
  if not npc then return false end

  local npcPos = npc:getPosition()
  return distSqm(myPos, npcPos) <= (maxDist or 3)
end

local travelUII = setupUI([[
Panel
  id: travelUII
  size: 280 60
  anchors.horizontalCenter: parent.horizontalCenter
  anchors.top: parent.top
  margin-top: 100

  MainWindow
    id: panelTravelUII
    anchors.fill: parent
    text: Fast-Travel

    Label
      id: labelTraveUII
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      margin-top: 4
      margin-left: -5
      text: Select City:
      font: verdana-11px-rounded
      text-auto-resize: true

  ComboBox
    id: TravelOptions
    anchors.top: panelTravelUII.top
    anchors.right: panelTravelUII.right
    margin-right: 15
    margin-top: 25
    width: 155
    height: 22
    font: verdana-11px-rounded
]], g_ui.getRootWidget())
travelUII:hide()

local uiNpcName = ""
local lastCitiesKey = ""
local travelCooldownMs = 1200
local lastTravelAt = 0
local lockTravel = false

local function buildCitiesKey(cities)
  if not cities then return "" end
  local tmp = {}
  for i = 1, #cities do
    tmp[#tmp + 1] = normalizeText(cities[i])
  end
  table.sort(tmp)
  return table.concat(tmp, "|")
end

local function fillCitiesCombo(cities)
  travelUII.TravelOptions:clearOptions()
  travelUII.TravelOptions:addOption("")

  if cities and #cities > 0 then
    for i = 1, #cities do
      travelUII.TravelOptions:addOption(cities[i])
    end
  end

  if travelUII.TravelOptions.setCurrentOption then
    travelUII.TravelOptions:setCurrentOption(1)
  end
  if travelUII.TravelOptions.setText then
    travelUII.TravelOptions:setText("")
  end
end

local function showTravelUIForNpc(npcName)
  npcName = trim(npcName)
  if npcName == "" or not st.npcs[npcName] then return end

  local cities = st.npcs[npcName].cities or {}
  sortCities(cities)

  local key = buildCitiesKey(cities)
  if uiNpcName ~= npcName or lastCitiesKey ~= key then
    fillCitiesCombo(cities)
    uiNpcName = npcName
    lastCitiesKey = key
  end

  if not travelUII:isVisible() then
    travelUII:show()
  end
end

local function hideTravelUI()
  if travelUII:isVisible() then
    travelUII:hide()
  end
  uiNpcName = ""
  lastCitiesKey = ""
end

local function doNpcTravel(npcName, city)
  npcName = trim(npcName)
  city = trim(city)

  if npcName == "" or city == "" then return end
  if lockTravel then return end

  local t = nowMs()
  if (t - lastTravelAt) < travelCooldownMs then return end
  if not isNpcNear(npcName, 3) then return end

  lockTravel = true
  lastTravelAt = t

  local nameCopy = npcName
  local cityCopy = city

  NPC.say("hi")

  schedule(250, function()
    if not isNpcNear(nameCopy, 3) then lockTravel = false return end
    NPC.say(cityCopy)
    if (player:isPartyMember() or player:isPartyLeader() or player:getShield() > 2) then
      sayChannel(1, "Travel to: " .. cityCopy)
    end
  end)

  schedule(500, function()
    if not isNpcNear(nameCopy, 3) then lockTravel = false return end
    NPC.say("yes")
  end)

  schedule(750, function()
    if not isNpcNear(nameCopy, 3) then lockTravel = false return end
    NPC.say("yes")
    lockTravel = false
  end)
end

local function onCitySelected(_, text)
  local city = trim(text or "")
  if city == "" then return end
  if uiNpcName == "" then return end
  doNpcTravel(uiNpcName, city)
end

travelUII.TravelOptions.onOptionChange = onCitySelected
travelUII.TravelOptions.onSelectionChange = onCitySelected
travelUII.TravelOptions.onTextChange = onCitySelected

local function isKnownTravelNpc(creature)
  if not creature or not creature.getName or not creature.getPosition then return false end

  local cname = trim(creature:getName() or "")
  if cname == "" then return false end

  for npcName, _ in pairs(st.npcs or {}) do
    if sameText(cname, npcName) then
      return npcName
    end
  end

  return false
end

macro(200, function()
  local me = g_game.getLocalPlayer()
  if not me then
    hideTravelUI()
    return
  end

  local myPos = me:getPosition()
  if not myPos then
    hideTravelUI()
    return
  end

  local bestName = ""
  local bestDist = 999

  local specs = getSpectators() or {}

  for _, cr in ipairs(specs) do
    local npcName = isKnownTravelNpc(cr)

    if npcName then
      local d = distSqm(myPos, cr:getPosition())

      if d <= 4 and d < bestDist then
        bestDist = d
        bestName = npcName
      end
    end
  end

  if bestName ~= "" then
    showTravelUIForNpc(bestName)
  else
    hideTravelUI()
  end
end)

------------------------ AUTOPREY
if not loadCharStorage or not saveCharStorage then
  return print("[Auto Prey] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function savePreyChar()
  saveCharStorage(charStorage)
end

setDefaultTab("Main")

local switchPrey = "preyButton"

charStorage[switchPrey] = charStorage[switchPrey] or { enabled = false }

preyButton = setupUI([[
Panel
  height: 19
  margin-top: 0

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-right: 45
    text-align: center
    height: 18
    text: Auto Prey
    color: white
    tooltip: Auto Prey

  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    color: white
    text: Config
]])

preyButton:setId(switchPrey)
preyButton.title:setOn(charStorage[switchPrey].enabled)

preyButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  charStorage[switchPrey].enabled = newState
  savePreyChar()
end

preyInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 360 370
  text: Panel Auto Prey
  margin-top: -50

  Panel
    id: monstersBlock
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 170
    image-source: /images/ui/miniwindow
    image-border: 20
    margin-left: -4
    margin-right: -4

    Label
      id: infoPreyList1
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      margin-top: 2
      text: Monsters List
      text-auto-resize: true

  TextList
    id: panelPreyList1
    anchors.top: monstersBlock.top
    anchors.left: monstersBlock.left
    anchors.right: monstersBlock.right
    margin-top: 20
    margin-left: 8
    margin-right: 19
    height: 110
    padding: 1
    vertical-scrollbar: prey1Scroll
    opacity: 0.95

  VerticalScrollBar
    id: prey1Scroll
    anchors.top: panelPreyList1.top
    anchors.bottom: panelPreyList1.bottom
    anchors.left: panelPreyList1.right
    step: 18
    pixels-scroll: true
    visible: true
    opacity: 0.90
    margin-left: 0

  TextEdit
    id: inserirMobName1
    anchors.top: panelPreyList1.bottom
    anchors.left: panelPreyList1.left
    margin-top: 4
    width: 300
    height: 18
    color: #c0c0c0
    placeholder: Insert monster name

  Button
    id: buttonAdd
    anchors.top: inserirMobName1.top
    anchors.right: prey1Scroll.right
    width: 20
    height: 18
    text: +
    font: sans-bold-16px

  Panel
    id: slotsBlock
    anchors.top: monstersBlock.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 70
    image-source: /images/ui/miniwindow
    image-border: 20
    margin-top: 6
    margin-left: -4
    margin-right: -4

    Label
      id: slotsTitle
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      margin-top: 2
      text: Auto Reroll Slots
      text-auto-resize: true

  UIWidget
    id: ativarPrey1
    anchors.top: slotsBlock.top
    anchors.left: slotsBlock.left
    margin-top: 20
    margin-left: 18
    size: 35 35
    image-source: /images/game/prey/prey_select_blocked

  Label
    id: labelPrey1
    anchors.top: ativarPrey1.bottom
    anchors.horizontalCenter: ativarPrey1.horizontalCenter
    margin-top: 0
    font: verdana-11px-rounded
    text: Prey 1
    color: white
    text-auto-resize: true

  UIWidget
    id: ativarPrey2
    anchors.top: ativarPrey1.top
    anchors.horizontalCenter: slotsBlock.horizontalCenter
    size: 35 35
    image-source: /images/game/prey/prey_select_blocked

  Label
    id: labelPrey2
    anchors.top: ativarPrey2.bottom
    anchors.horizontalCenter: ativarPrey2.horizontalCenter
    margin-top: 0
    font: verdana-11px-rounded
    text: Prey 2
    color: white
    text-auto-resize: true

  UIWidget
    id: ativarPrey3
    anchors.top: ativarPrey1.top
    anchors.right: slotsBlock.right
    margin-right: 18
    size: 35 35
    image-source: /images/game/prey/prey_select_blocked

  Label
    id: labelPrey3
    anchors.top: ativarPrey3.bottom
    anchors.horizontalCenter: ativarPrey3.horizontalCenter
    margin-top: 0
    font: verdana-11px-rounded
    text: Prey 3
    color: white
    text-auto-resize: true

  Panel
    id: fundoconfigsprey
    anchors.top: slotsBlock.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 58
    image-source: /images/ui/miniwindow
    image-border: 20
    margin-top: 6
    margin-left: -4
    margin-right: -4

    Label
      id: retryTitle
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      margin-top: 2
      text: Retry Settings
      text-auto-resize: true

  Label
    id: labelMaxRetries
    anchors.top: fundoconfigsprey.top
    anchors.left: fundoconfigsprey.left
    margin-top: 24
    margin-left: 8
    text: Max Retrie
    font: verdana-11px-rounded
    text-auto-resize: true

  SpinBox
    id: maxRetriesPrey
    anchors.left: labelMaxRetries.right
    anchors.verticalCenter: labelMaxRetries.verticalCenter
    margin-left: 5
    size: 52 20
    font: verdana-11px-rounded
    text-align: center
    minimum: 0
    maximum: 300
    step: 1

  Label
    id: labelDelayRetries
    anchors.left: maxRetriesPrey.right
    anchors.verticalCenter: maxRetriesPrey.verticalCenter
    margin-left: 14
    text: Delay
    font: verdana-11px-rounded
    text-auto-resize: true

  HorizontalScrollBar
    id: delayRetries
    anchors.left: labelDelayRetries.right
    anchors.right: fundoconfigsprey.right
    anchors.verticalCenter: labelDelayRetries.verticalCenter
    margin-left: 8
    margin-right: 8
    height: 14
    minimum: 0
    maximum: 5000
    step: 100

  Label
    id: delayMsValue
    anchors.centerIn: delayRetries
    text-align: center
    text: 0ms
    font: verdana-11px-rounded
    color: white
    text-auto-resize: true

  Button
    id: closePanel
    anchors.top: fundoconfigsprey.bottom
    anchors.left: fundoconfigsprey.left
    anchors.right: fundoconfigsprey.right
    margin-top: 6
    text: Close
]=], g_ui.getRootWidget())

preyInterface:hide()

if modules._G.g_app.isMobile() then
  preyInterface:setSize("360 390")
end

preyButton.settings.onClick = function()
  preyInterface:show()
  preyInterface:raise()
  preyInterface:focus()
end

preyInterface.closePanel.onClick = function()
  preyInterface:hide()
end

local STKEY = "lnsPreyRerollPanel"

charStorage[STKEY] = charStorage[STKEY] or {
  lists = { [1] = {} },
  enabled = { [1] = false, [2] = false, [3] = false },
  delayMs = 400,
  maxRetries = 15
}

local st = charStorage[STKEY]
st.lists = st.lists or { [1] = {} }
st.lists[1] = st.lists[1] or {}
st.enabled = st.enabled or { [1] = false, [2] = false, [3] = false }
st.delayMs = tonumber(st.delayMs) or 400
st.maxRetries = tonumber(st.maxRetries) or 15

st.renewBelowPercent = 5

savePreyChar()

local PREY_ACTION_LISTREROLL = 0
local PREY_ACTION_MONSTERSELECTION = 2

local function nowMillis()
  if g_clock and type(g_clock.millis) == "function" then
    return g_clock.millis()
  end
  if g_clock and type(g_clock.seconds) == "function" then
    return math.floor(g_clock.seconds() * 1000)
  end
  return os.time() * 1000
end

local function trim(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function normalizeText(s)
  s = tostring(s or ""):lower()
  s = s:gsub("%s+", " ")
  return trim(s)
end

local function sameText(a, b)
  return normalizeText(a) == normalizeText(b)
end

local function capitalizeEachWord(str)
  return tostring(str or ""):gsub("(%a)([%w_']*)", function(first, rest)
    return first:upper() .. rest:lower()
  end)
end

local function clamp(n, a, b)
  n = tonumber(n) or a
  if n < a then return a end
  if n > b then return b end
  return n
end

local function desiredList()
  st.lists[1] = st.lists[1] or {}
  return st.lists[1]
end

local function listHasDesired(name)
  name = normalizeText(name)
  if name == "" then return false end

  for _, v in ipairs(desiredList()) do
    if normalizeText(v) == name then
      return true
    end
  end

  return false
end

local mobRowTemplate = [[
UIWidget
  id: root
  height: 18
  focusable: false
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #2F2F2F
    opacity: 0.75

  Label
    id: mobName
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
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
]]

local function sortMonsterList()
  table.sort(st.lists[1], function(a, b)
    return normalizeText(a) < normalizeText(b)
  end)
end

local function refreshMobList()
  local listW = preyInterface.panelPreyList1
  if not listW then return end

  if listW.destroyChildren then
    listW:destroyChildren()
  else
    local ch = listW:getChildren()
    for i = #ch, 1, -1 do
      ch[i]:destroy()
    end
  end

  sortMonsterList()

  for _, mobName in ipairs(st.lists[1]) do
    local row = g_ui.loadUIFromString(mobRowTemplate, listW)
    row.mobName:setText(mobName)

    row.remove.onClick = function()
      local newList = {}
      for _, v in ipairs(st.lists[1]) do
        if not sameText(v, mobName) then
          table.insert(newList, v)
        end
      end
      st.lists[1] = newList
      savePreyChar()
      refreshMobList()
    end
  end
end

local function addMobFromInput()
  local edit = preyInterface.inserirMobName1
  if not edit then return end

  local name = trim(edit:getText())
  if name == "" then return end

  local pretty = capitalizeEachWord(name)

  for _, v in ipairs(st.lists[1]) do
    if sameText(v, pretty) then
      edit:setText("")
      return
    end
  end

  table.insert(st.lists[1], pretty)
  edit:setText("")
  savePreyChar()
  refreshMobList()
end

preyInterface.buttonAdd.onClick = addMobFromInput

preyInterface.inserirMobName1.onKeyPress = function(widget, keyCode)
  if keyCode == KeyEnter or keyCode == KeyReturn then
    addMobFromInput()
    return true
  end
  return false
end

local function applyDelayLabel()
  preyInterface.delayMsValue:setText(tostring(math.floor(st.delayMs)) .. "ms")
end

preyInterface.delayRetries:setValue(clamp(st.delayMs, 0, 5000))
applyDelayLabel()

preyInterface.delayRetries.onValueChange = function(_, value)
  st.delayMs = clamp(value, 0, 5000)
  applyDelayLabel()
  savePreyChar()
end

preyInterface.maxRetriesPrey:setValue(clamp(st.maxRetries, 0, 300))
preyInterface.maxRetriesPrey.onValueChange = function(_, value)
  st.maxRetries = clamp(value, 0, 300)
  savePreyChar()
end

local function getSlotSwitchWidget(i)
  if i == 1 then return preyInterface.ativarPrey1, preyInterface.labelPrey1 end
  if i == 2 then return preyInterface.ativarPrey2, preyInterface.labelPrey2 end
  if i == 3 then return preyInterface.ativarPrey3, preyInterface.labelPrey3 end
  return nil, nil
end

local function applySwitchUI(i)
  local w, lbl = getSlotSwitchWidget(i)
  if not w or not lbl then return end

  if st.enabled[i] == true then
    w:setImageSource("/images/game/prey/prey_select")
  else
    w:setImageSource("/images/game/prey/prey_select_blocked")
  end

  lbl:setText("Prey " .. i)
end

local function bindSwitch(i)
  local w = getSlotSwitchWidget(i)
  if not w then return end

  w.onClick = function()
    st.enabled[i] = not (st.enabled[i] == true)
    savePreyChar()
    applySwitchUI(i)
  end
end

for i = 1, 3 do
  bindSwitch(i)
  applySwitchUI(i)
end

refreshMobList()

local currentRolls = { [0] = 0, [1] = 0, [2] = 0 }
local lastActionAt = { [0] = 0, [1] = 0, [2] = 0 }

local function mainEnabled()
  return charStorage[switchPrey] and charStorage[switchPrey].enabled == true
end

local function slotEnabled(slotIndex)
  return mainEnabled() and st.enabled[slotIndex + 1] == true
end

local function canAction(slotIndex)
  local t = nowMillis()
  local delay = tonumber(st.delayMs) or 400
  if delay < 100 then delay = 100 end

  if t - (lastActionAt[slotIndex] or 0) < delay then
    return false
  end

  lastActionAt[slotIndex] = t
  return true
end

local function getPreyTracker()
  return modules.game_prey and modules.game_prey.preyTracker
end

local function getPreyWindow()
  return modules.game_prey and modules.game_prey.preyWindow
end

local function getSlotObjects(slotIndex)
  local tracker = getPreyTracker()
  local window = getPreyWindow()

  if not tracker or not tracker.contentsPanel then return nil, nil end
  if not window then return nil, nil end

  local slotName = "slot" .. tostring(slotIndex + 1)
  return tracker.contentsPanel[slotName], window[slotName]
end

local function getSlotCreatureName(windowSlot)
  if not windowSlot or not windowSlot.title or not windowSlot.title.getText then
    return ""
  end

  local ok, text = pcall(function()
    return windowSlot.title:getText()
  end)

  if ok then
    return normalizeText(text)
  end

  return ""
end

local function getSlotPercent(trackerSlot)
  if not trackerSlot or not trackerSlot.time or not trackerSlot.time.getPercent then
    return nil
  end

  local ok, percent = pcall(function()
    return trackerSlot.time:getPercent()
  end)

  if ok then
    return tonumber(percent)
  end

  return nil
end

local function getCreatureNameFromTracker(trackerSlot)
  if not trackerSlot or not trackerSlot.creature or not trackerSlot.creature.getTooltip then
    return ""
  end

  local ok, tip = pcall(function()
    return trackerSlot.creature:getTooltip()
  end)

  if not ok or not tip then return "" end

  local name = tostring(tip):match("Creature:%s*([^\n]+)")
  return normalizeText(name or "")
end

local function rerollSlot(slotIndex)
  if not canAction(slotIndex) then return false end

  currentRolls[slotIndex] = (currentRolls[slotIndex] or 0) + 1
  if currentRolls[slotIndex] > (tonumber(st.maxRetries) or 15) then
    return false
  end

  g_game.preyAction(slotIndex, PREY_ACTION_LISTREROLL, 0)
  return true
end

local function selectMonster(slotIndex, optionIndex)
  if not canAction(slotIndex) then return false end

  currentRolls[slotIndex] = 0
  g_game.preyAction(slotIndex, PREY_ACTION_MONSTERSELECTION, optionIndex)
  return true
end

local function handleSelectMonster(slotIndex, windowSlot)
  if not windowSlot or not windowSlot.inactive or not windowSlot.inactive.list then
    return false
  end

  local children = windowSlot.inactive.list:getChildren() or {}

  for j, child in ipairs(children) do
    local name = ""
    if child.getTooltip then
      local ok, tip = pcall(function()
        return child:getTooltip()
      end)
      if ok then name = tip or "" end
    end

    if listHasDesired(name) then
      return selectMonster(slotIndex, j - 1)
    end
  end

  return rerollSlot(slotIndex)
end

local function handleActivePrey(slotIndex, trackerSlot, creatureName)
  local percent = getSlotPercent(trackerSlot)
  if not percent then return false end

  if not listHasDesired(creatureName) then
    return false
  end

  if percent <= 5 then
    currentRolls[slotIndex] = 0
    return rerollSlot(slotIndex)
  end

  currentRolls[slotIndex] = 0
  return false
end

local preyOpenedByScript = false

macro(400, function()
  if not mainEnabled() then
    preyOpenedByScript = false
    return
  end

  if #desiredList() == 0 then return end

  if not preyOpenedByScript and modules.game_prey and modules.game_prey.show then
    modules.game_prey.show()
    preyOpenedByScript = true

    schedule(500, function()
      if modules.game_prey and modules.game_prey.hide then
        modules.game_prey.hide()
      end
    end)
  end

  for slotIndex = 0, 2 do
    if slotEnabled(slotIndex) then
      local trackerSlot, windowSlot = getSlotObjects(slotIndex)
      if trackerSlot and windowSlot then
        local creatureName = getSlotCreatureName(windowSlot)

        if creatureName == "select monster" then
          if handleSelectMonster(slotIndex, windowSlot) then
            return
          end
        else
          local trackerCreatureName = getCreatureNameFromTracker(trackerSlot)
          if trackerCreatureName ~= "" then
            creatureName = trackerCreatureName
          end

          if handleActivePrey(slotIndex, trackerSlot, creatureName) then
            return
          end
        end
      end
    end
  end
end)

UI.Separator()
