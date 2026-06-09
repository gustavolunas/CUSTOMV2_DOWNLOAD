----- ATTACKBOT
if not loadCharStorage or not saveCharStorage or not loadNamedSharedStorage or not saveNamedSharedStorage then
  return warn("[AttackBot] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()
sharedStorage_attackbot = sharedStorage_attackbot or loadNamedSharedStorage("settings_attackbot")

sharedStorage_attackbot.attackBotShared = sharedStorage_attackbot.attackBotShared or {}
sharedStorage_attackbot.attackBotShared.safeIdsAndares =
  normalizeSharedMap(sharedStorage_attackbot.attackBotShared.safeIdsAndares)

local function saveAttackBotChar()
  saveCharStorage(charStorage)
end

local function saveAttackBotShared()
  local diskData = loadNamedSharedStorage("settings_attackbot")
  diskData.attackBotShared = diskData.attackBotShared or {}

  diskData.attackBotShared.safeIdsAndares =
    mergeSharedMaps(
      diskData.attackBotShared.safeIdsAndares,
      sharedStorage_attackbot.attackBotShared.safeIdsAndares
    )

  sharedStorage_attackbot.attackBotShared.safeIdsAndares =
    diskData.attackBotShared.safeIdsAndares

  saveNamedSharedStorage("settings_attackbot", diskData)
end

switchCombo = "comboButton"
charStorage[switchCombo] = charStorage[switchCombo] or { enabled = false }

comboButton = setupUI([[
Panel
  height: 40
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: AttackBot
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

  Button
    id: 1
    anchors.top: prev.bottom
    anchors.left: parent.left
    text: 1
    margin-right: 2
    margin-top: 4
    size: 17 17

  Button
    id: 2
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    text: 2
    margin-left: 4
    size: 17 17
    
  Button
    id: 3
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    text: 3
    margin-left: 4
    size: 17 17

  Button
    id: 4
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    text: 4
    margin-left: 4
    size: 17 17 
    
  Button
    id: 5
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    text: 5
    margin-left: 4
    size: 17 17
    
  Label
    id: name
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: parent.right
    text-align: center
    margin-left: 4
    height: 17
    text: Prof.: #1
    background: #292A2A
]])
comboButton:setId(switchCombo)
comboButton.title:setOn(charStorage[switchCombo].enabled)
comboButton.title.onClick = function(widget)
  local state = not widget:isOn()
  widget:setOn(state)
  charStorage[switchCombo].enabled = state
  saveAttackBotChar()
end

comboInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 530 338
  text: Panel AttackBot
  margin-top: -50

  Panel
    id: infolist1
    anchors.top: parent.top
    anchors.left: parent.left
    size: 270 255
    image-source: /images/ui/miniwindow
    image-border: 20
    margin-left: -4
    margin-right: -4
    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Configuration Spells & Runes
      margin-top: 2

  TextList
    id: spellList
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.bottom: prev.bottom
    margin-bottom: 5
    margin-top: 20
    margin-left: 4
    margin-right: 16
    padding: 1
    vertical-scrollbar: spellListScrollBar
    opacity: 0.95

  VerticalScrollBar
    id: spellListScrollBar
    anchors.top: spellList.top
    anchors.bottom: spellList.bottom
    anchors.left: spellList.right
    step: 10
    pixels-scroll: true
    visible: true
    border: 1 #1f1f1f
    image-color: #363636
    opacity: 0.90
    margin-left: 0

  Button
    id: adicionarSpell
    anchors.left: infolist1.left
    anchors.top: infolist1.bottom
    margin-top: 3
    size: 134 20
    text: Add Spell

  Button
    id: adicionarRuna
    anchors.left: adicionarSpell.right
    anchors.verticalCenter: adicionarSpell.verticalCenter
    margin-left: 3
    size: 134 20
    text: Add Rune

  Panel
    id: infolist2
    anchors.top: infolist1.top
    anchors.left: infolist1.right
    anchors.right: parent.right
    size: 190 300
    image-source: /images/ui/miniwindow
    image-border: 20
    margin-left: 10
    margin-right: -4
    Label
      id: title2
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Anti-Red & Tools Configs
      margin-top: 2

  BotSwitch
    id: virarTarget
    anchors.left: infolist2.left
    anchors.right: infolist2.right
    anchors.top: infolist2.top
    margin-top: 25
    margin-left: 8
    margin-right: 8
    size: 35 20
    text: Turn Target Direction

  BotSwitch
    id: manterDist
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    margin-top: 5
    margin-right: 45
    size: 35 20
    text: Pause Spells Unsafe

  Button
    id: cfgPauseSpells
    anchors.left: prev.right
    anchors.top: prev.top
    anchors.right: virarTarget.right
    size: 35 20
    margin-left: 2
    text: Config

  HorizontalSeparator
    id: Hsep
    anchors.top: manterDist.bottom
    anchors.left: manterDist.left
    anchors.right: virarTarget.right
    margin-top: 8

  Label
    id: labelDistSegura
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    text: Dist Check Players: 0
    margin-top: 5

  HorizontalScrollBar
    id: distSegura
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    margin-top: 5
    minimum: 1
    maximum: 12
    step: 1

  BotSwitch
    id: checkPlayers
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    margin-top: 5
    size: 35 20
    text: Check Players

  BotSwitch
    id: checkFloors
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    margin-top: 5
    size: 35 20
    text: Check other Floors

  Label
    id: labelDistStairs
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    text: Dist Check Stairs: 0
    margin-top: 7

  HorizontalScrollBar
    id: distStairs
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    margin-top: 5
    minimum: 1
    maximum: 12
    step: 1

  Panel
    id: idsSafeAndares
    anchors.top: prev.bottom
    margin-top: 5
    anchors.left: prev.left
    anchors.right: prev.right
    height: 74

  BotSwitch
    id: checkStairs
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    margin-top: -1
    size: 35 20
    text: Check Stairs

  Button
    id: closePanel
    anchors.left: adicionarSpell.left
    anchors.right: adicionarRuna.right
    anchors.top: adicionarSpell.bottom
    size: 35 20
    margin-top: 3
    text: Close
]=], g_ui.getRootWidget())
comboInterface:hide()

if modules._G.g_app.isMobile() then
  comboInterface:setSize("530 360")
end

comboButton.settings.onClick = function()
  if not comboInterface:isVisible() then
    comboInterface:show()
    comboInterface:raise()
    comboInterface:focus()
  end
end
comboInterface.closePanel.onClick = function() comboInterface:hide() end

spellAddPanel = setupUI([=[
MainWindow
  id: spellAddPanel
  size: 260 310
  anchors.centerIn: parent
  margin-top: -50
  text: Insert Spell AttackBot

  ComboBox
    id: selectType
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    margin-top: 0
    margin-left: -6
    margin-right: -6
    height: 22
    @onSetup: |
        self:addOption("Editable")
        self:addOption("Knight")
        self:addOption("Paladin")
        self:addOption("Monk")
        self:addOption("Mage")

  FlatPanel
    id: panelMain
    anchors.top: prev.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    height: 215
    margin: -6
    margin-top: 5

    Label
      id: magiaLabel
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      text: Spell Name:
      margin-left: 5
      margin-right: 5
      margin-top: 4
      font: verdana-11px-rounded

    TextEdit
      id: magia
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      placeholder: Insert spell here
      visible: true

    ComboBox
      id: magiaSelect
      anchors.left: prev.left
      anchors.right: prev.right
      anchors.top: prev.top
      anchors.bottom: prev.bottom
      visible: false
      @onSetup: |
          self:addOption(" ")

    Label
      id: distanceLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Distance:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: distance
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 1
      maximum: 12
      step: 1

    Label
      id: manaLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Mana:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: mana
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 0
      maximum: 1000
      step: 10

    Label
      id: mobsLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Mobs:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: mobs
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 1
      maximum: 10
      step: 1

    Label
      id: cdLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Cooldown:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: cooldown
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      margin-right: 15
      minimum: 0
      maximum: 60000
      step: 1

    Button
      id: calculeCooldown
      anchors.top: prev.top
      anchors.left: prev.right
      anchors.right: cdLabel.right
      text: T
      width: 10
      height: 13
      margin-left: 2
      font: verdana-11px-rounded

    CheckBox
      id: safe
      anchors.top: prev.bottom
      anchors.left: cdLabel.left
      margin-top: 10
      text: Spell Safe?
      font: verdana-11px-rounded
      text-auto-resize: true

  Button
    id: cancelarBt
    anchors.left: panelMain.left
    anchors.top: panelMain.bottom
    width: 120
    margin-top: 5
    text: Cancel
    font: verdana-11px-rounded

  Button
    id: adicionarBt
    anchors.right: panelMain.right
    anchors.top: panelMain.bottom
    width: 120
    margin-top: 5
    text: Insert
    font: verdana-11px-rounded
]=], g_ui.getRootWidget())
spellAddPanel:hide()

runeAddPanel = setupUI([=[
MainWindow
  id: runeAddPanel
  size: 220 210
  anchors.centerIn: parent
  margin-top: -50
  text: Insert Rune AttackBot

  FlatPanel
    id: panelMain
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.left: parent.left
    height: 150
    margin: -6
    margin-top: 0

    Label
      id: runaLabel
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      text: Rune ID:
      margin-left: 5
      margin-right: 5
      margin-top: 15
      font: verdana-11px-rounded

    BotItem
      id: runa
      anchors.top: prev.top
      anchors.right: parent.right
      margin-right: 8
      margin-top: -10

    Label
      id: distanceLabel
      anchors.top: prev.bottom
      anchors.left: runaLabel.left
      anchors.right: parent.right
      margin-top: 4
      margin-right: 5
      text: Distance:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: distance
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 1
      maximum: 12
      step: 1

    Label
      id: mobsLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 8
      text: Mobs:
      font: verdana-11px-rounded

    HorizontalScrollBar
      id: mobs
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 1
      maximum: 10
      step: 1

    CheckBox
      id: safe
      anchors.top: mobs.bottom
      anchors.left: distanceLabel.left
      margin-top: 14
      text: Rune Safe?
      font: verdana-11px-rounded
      text-auto-resize: true

  Button
    id: cancelarBt
    anchors.left: panelMain.left
    anchors.top: panelMain.bottom
    width: 100
    margin-top: 5
    text: Cancel
    font: verdana-11px-rounded

  Button
    id: adicionarBt
    anchors.right: panelMain.right
    anchors.top: panelMain.bottom
    width: 100
    margin-top: 5
    text: Insert
    font: verdana-11px-rounded
]=], g_ui.getRootWidget())
runeAddPanel:hide()

panelSpellsUnsafe = setupUI([=[
MainWindow
  id: unsafePanel
  size: 260 320
  margin-top: -50
  text: Settings Unsafe

  FlatPanel
    id: flatp
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    margin: -5
    margin-bottom: 20
    margin-top: 1

    Label
      id: info
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 5
      margin-right: 0
      text-wrap: true
      text-auto-resize: true
      text: "[BR]: Defina o que deve ser feito caso seu personagem abra PK ou pegue frags.\n\n[EN]: Define what should be done if your character engages in PK or gets frags."

    HorizontalSeparator
      id: hsep
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 4
      margin-right: 4

    Label
      id: info2
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      text-align: center
      text: Reactive in:
      
    HorizontalScrollBar
      id: minutosVoltarUnsafe
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5

    BotSwitch
      id: pausarUnsafe
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      text: Pause Unsafe Spells

    HorizontalSeparator
      id: hsep2
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 5
      margin-left: 4
      margin-right: 4
    
    Label
      id: info3
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      text-align: center
      text: Amount Frags:
      
    HorizontalScrollBar
      id: qtdeFrags
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5

    BotSwitch
      id: deslogarFrags
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      text: Logout on Frags

  Button
    id: closePanel
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    size: 35 20
    margin-top: 6
    text: Close
]=], g_ui.getRootWidget())
panelSpellsUnsafe:hide()

profileNamePanel = setupUI([=[
MainWindow
  id: attackProfileNamePanel
  size: 260 120
  anchors.centerIn: parent
  margin-top: -50
  text: Rename AttackBot Profile

  FlatPanel
    id: panelMain
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 58
    margin: -6
    margin-top: 0

    Label
      id: info
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      margin-left: 5
      margin-right: 5
      margin-top: 5
      text: Nome do profile:
      font: verdana-11px-rounded

    TextEdit
      id: profileName
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 5
      placeholder: #N/D

  Button
    id: cancelarBt
    anchors.left: panelMain.left
    anchors.top: panelMain.bottom
    width: 120
    margin-top: 5
    text: Cancel
    font: verdana-11px-rounded

  Button
    id: salvarBt
    anchors.right: panelMain.right
    anchors.top: panelMain.bottom
    width: 120
    margin-top: 5
    text: Save
    font: verdana-11px-rounded
]=], g_ui.getRootWidget())
profileNamePanel:hide()

if comboInterface and comboInterface.cfgPauseSpells then
  comboInterface.cfgPauseSpells.onClick = function()
    panelSpellsUnsafe:show()
    panelSpellsUnsafe:raise()
    panelSpellsUnsafe:focus()
  end
end

local sharedCfg = sharedStorage_attackbot.attackBotShared

local function cleanAttackProfileName(text)
  text = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
  if #text > 18 then
    text = text:sub(1, 18)
  end
  return text
end

local function defaultAttackBotProfile()
  return {
    name = "",
    main = {
      virarTarget = false,
      manterDist = false,
      checkPlayers = false,
      checkStairs = false,
      checkFloors = false,
      distSegura = 10,
      distStairs = 6,

      minutosVoltarUnsafe = 5,
      pausarUnsafe = false,
      qtdeFrags = 1,
      deslogarFrags = false
    },
    attacks = {}
  }
end

charStorage.attackBotProfiles = charStorage.attackBotProfiles or {
  activeProfile = 1,
  profiles = {}
}

for i = 1, 5 do
  charStorage.attackBotProfiles.profiles[i] =
    charStorage.attackBotProfiles.profiles[i] or defaultAttackBotProfile()
end

charStorage.attackBotProfiles.activeProfile =
  math.max(1, math.min(5, tonumber(charStorage.attackBotProfiles.activeProfile) or 1))

charStorage.attackBotMonkHarmony = charStorage.attackBotMonkHarmony or { points = 0 }

local function getActiveAttackProfileIndex()
  return math.max(1, math.min(5, tonumber(charStorage.attackBotProfiles.activeProfile) or 1))
end

local function getActiveAttackProfile()
  local idx = getActiveAttackProfileIndex()
  charStorage.attackBotProfiles.profiles[idx] =
    charStorage.attackBotProfiles.profiles[idx] or defaultAttackBotProfile()

  local p = charStorage.attackBotProfiles.profiles[idx]
  p.main = p.main or defaultAttackBotProfile().main
  p.attacks = p.attacks or {}

  p.main.minutosVoltarUnsafe = tonumber(p.main.minutosVoltarUnsafe) or 5
  p.main.pausarUnsafe = p.main.pausarUnsafe == true
  p.main.qtdeFrags = tonumber(p.main.qtdeFrags) or 1
  p.main.deslogarFrags = p.main.deslogarFrags == true

  p.main.disabledByFrag = type(p.main.disabledByFrag) == "table" and p.main.disabledByFrag or {}
  p.main.reenableUnsafeAt = tonumber(p.main.reenableUnsafeAt) or 0

  return p
end

local function getAttackProfile(idx)
  idx = math.max(1, math.min(5, tonumber(idx) or 1))
  charStorage.attackBotProfiles.profiles[idx] =
    charStorage.attackBotProfiles.profiles[idx] or defaultAttackBotProfile()

  local p = charStorage.attackBotProfiles.profiles[idx]
  p.name = cleanAttackProfileName(p.name)
  p.main = p.main or defaultAttackBotProfile().main
  p.attacks = p.attacks or {}
  return p
end

local function getAttackProfileDisplayName(idx)
  idx = math.max(1, math.min(5, tonumber(idx) or 1))
  local p = getAttackProfile(idx)
  local name = cleanAttackProfileName(p.name)

  if name ~= "" then
    return name
  end

  return "#" .. idx
end

local cfg = getActiveAttackProfile()

local function refreshAttackProfileButtons()
  local active = getActiveAttackProfileIndex()

  for i = 1, 5 do
    local btn = comboButton and comboButton[tostring(i)]
    if btn then
      local isActive = (i == active)

      if btn.setOn then
        btn:setOn(isActive)
      end

      if btn.setColor then
        btn:setColor(isActive and "white" or "white")
      end

      if btn.setBackgroundColor then
        btn:setBackgroundColor(isActive and "alpha" or "alpha")
      end

      if btn.setImageColor then
        btn:setImageColor(isActive and "green" or "gray")
      end

      if btn.setOpacity then
        btn:setOpacity(isActive and 1.0 or 0.85)
      end

      if btn.setTooltip then
        btn:setTooltip("Profile " .. i .. ": " .. getAttackProfileDisplayName(i))
      end
    end
  end
end

local function refreshAttackProfileLabel()
  if comboButton and comboButton.name then
    comboButton.name:setText(getAttackProfileDisplayName(getActiveAttackProfileIndex()))
  end
  refreshAttackProfileButtons()
end

local function setActiveAttackProfile(idx)
  idx = math.max(1, math.min(5, tonumber(idx) or 1))
  charStorage.attackBotProfiles.activeProfile = idx
  cfg = getActiveAttackProfile()

  if comboInterface and comboInterface.distSegura then
    comboInterface.distSegura:setValue(cfg.main.distSegura or 10)
  end
  if comboInterface and comboInterface.labelDistSegura then
    comboInterface.labelDistSegura:setText("Dist Check Players: " .. (cfg.main.distSegura or 10))
  end

  if comboInterface and comboInterface.distStairs then
    comboInterface.distStairs:setValue(cfg.main.distStairs or 6)
  end
  if comboInterface and comboInterface.labelDistStairs then
    comboInterface.labelDistStairs:setText("Dist Check Stairs: " .. (cfg.main.distStairs or 6))
  end

  if comboInterface and comboInterface.virarTarget then
    comboInterface.virarTarget:setOn(cfg.main.virarTarget == true)
  end
  if comboInterface and comboInterface.manterDist then
    comboInterface.manterDist:setOn(cfg.main.manterDist == true)
  end
  if comboInterface and comboInterface.checkPlayers then
    comboInterface.checkPlayers:setOn(cfg.main.checkPlayers == true)
  end
  if comboInterface and comboInterface.checkStairs then
    comboInterface.checkStairs:setOn(cfg.main.checkStairs == true)
  end
  if comboInterface and comboInterface.checkFloors then
    comboInterface.checkFloors:setOn(cfg.main.checkFloors == true)
  end

 cfg.main.disabledByFrag = type(cfg.main.disabledByFrag) == "table" and cfg.main.disabledByFrag or {}
  cfg.main.reenableUnsafeAt = tonumber(cfg.main.reenableUnsafeAt) or 0

  refreshAttackProfileLabel()
  rebuildAttackList()
  saveAttackBotChar()
end

local openAttackProfileNameEditor = nil

for i = 1, 5 do
  local btn = comboButton[tostring(i)]
  if btn then
    btn.onClick = function()
      setActiveAttackProfile(i)
    end

    btn.onDoubleClick = function()
      setActiveAttackProfile(i)
      if openAttackProfileNameEditor then
        openAttackProfileNameEditor(i)
      end
    end
  end
end

refreshAttackProfileLabel()


local function W(parent, id)
  if not parent then return nil end
  return (parent.getChildById and parent:getChildById(id)) or (parent.recursiveGetChildById and parent:recursiveGetChildById(id))
end

local function trimText(s) return (s or ""):gsub("^%s+", ""):gsub("%s+$", "") end
local function trim(s) return trimText(s) end
local function clearChildren(w) if not w then return end for i = #w:getChildren(), 1, -1 do w:getChildren()[i]:destroy() end end
local function clamp(v, a, b)
  v = tonumber(v) or a
  if v < a then return a end
  if v > b then return b end
  return v
end

local profileNameInput = W(profileNamePanel, "profileName")
local profileNameSave = W(profileNamePanel, "salvarBt")
local profileNameCancel = W(profileNamePanel, "cancelarBt")
local renamingAttackProfileIndex = getActiveAttackProfileIndex()

openAttackProfileNameEditor = function(idx)
  idx = math.max(1, math.min(5, tonumber(idx) or getActiveAttackProfileIndex()))
  renamingAttackProfileIndex = idx

  local p = getAttackProfile(idx)

  if profileNameInput then
    profileNameInput:setText(cleanAttackProfileName(p.name))
  end

  if profileNamePanel then
    profileNamePanel:setText("Rename Profile #" .. idx)
    profileNamePanel:show()
    profileNamePanel:raise()
    profileNamePanel:focus()
  end

  if profileNameInput and profileNameInput.focus then
    profileNameInput:focus()
  end
end

if comboButton and comboButton.name then
  comboButton.name.onDoubleClick = function()
    openAttackProfileNameEditor(getActiveAttackProfileIndex())
  end
end

if profileNameSave then
  profileNameSave.onClick = function()
    local p = getAttackProfile(renamingAttackProfileIndex)
    p.name = cleanAttackProfileName(profileNameInput and profileNameInput:getText() or "")
    saveAttackBotChar()
    refreshAttackProfileLabel()

    if profileNamePanel then
      profileNamePanel:hide()
    end
  end
end

if profileNameCancel then
  profileNameCancel.onClick = function()
    if profileNamePanel then
      profileNamePanel:hide()
    end
  end
end
local function nowMs()
  if type(now) == "number" then return now end
  if g_clock and g_clock.millis then return g_clock.millis() end
  return (os.time() * 1000) + math.floor((os.clock() * 1000) % 1000)
end
local function setSafeLabel(w, v) if not w then return end w:setColor(v and "#00FF00" or "#FF4040") w:setText(v and "[S]" or "[N]") end
local function spellInfo(d,m) d=tonumber(d) or 1 m=tonumber(m) or 1 return "["..d.." Sqm | +"..m.." Mob(s)"..(m>1 and "s" or "").."]" end
local function runeInfo(d,m) d=tonumber(d) or 1 m=tonumber(m) or 1 return "["..d.." Sqm | +"..m.." Mob(s)"..(m>1 and "s" or "").."]" end

local function getBotItemId(widget)
  if not widget then return 0 end
  if widget.getItemId then
    local ok,id = pcall(function() return widget:getItemId() end)
    if ok and id and id > 0 then return id end
  end
  if widget.getItem then
    local ok,item = pcall(function() return widget:getItem() end)
    if ok and item and item.getId then
      local ok2,id = pcall(function() return item:getId() end)
      if ok2 and id and id > 0 then return id end
    end
  end
  return 0
end

local function setItemIcon(widget, itemId)
  itemId = tonumber(itemId)
  if not widget then return end
  if not itemId or itemId <= 0 then return widget:setVisible(false) end
  widget:setVisible(true)
  if widget.setItemId then return widget:setItemId(itemId) end
  if widget.setItem and Item and Item.create then widget:setItem(Item.create(itemId, 1)) end
end

local function bindSwitch(widget, key)
  widget:setOn(cfg.main[key])
  widget.onClick = function(w)
    local state = not w:isOn()
    w:setOn(state)
    cfg.main[key] = state
    saveAttackBotChar()
  end
end

comboButton.title:setOn(charStorage[switchCombo].enabled)
bindSwitch(comboInterface.virarTarget, "virarTarget")
bindSwitch(comboInterface.manterDist, "manterDist")
bindSwitch(comboInterface.checkPlayers, "checkPlayers")
bindSwitch(comboInterface.checkStairs, "checkStairs")
bindSwitch(comboInterface.checkFloors, "checkFloors")

comboInterface.distSegura:setValue(cfg.main.distSegura or 0)
comboInterface.labelDistSegura:setText("Dist Check Players: " .. (cfg.main.distSegura or 0))
comboInterface.distSegura.onValueChange = function(_, value)
  cfg.main.distSegura = value
  comboInterface.labelDistSegura:setText("Dist Check Players: " .. value)
  saveAttackBotChar()
end

comboInterface.distStairs:setValue(cfg.main.distStairs or 0)
comboInterface.labelDistStairs:setText("Dist Check Stairs: " .. (cfg.main.distStairs or 0))
comboInterface.distStairs.onValueChange = function(_, value)
  cfg.main.distStairs = value
  comboInterface.labelDistStairs:setText("Dist Check Stairs: " .. value)
  saveAttackBotChar()
end

local idsSafeContainer = UI.ContainerEx(function(_, items)
  local currentMap = normalizeSharedMap(sharedCfg.safeIdsAndares)
  local newList = normalizeIdList(normalizeContainerItems(items))
  local newSet = {}
  local ts = nowStorageTs()

  for _, id in ipairs(newList) do
    newSet[id] = true
    currentMap[tostring(id)] = { state = true, ts = ts }
  end

  for k, v in pairs(currentMap) do
    local id = tonumber(k)
    if id and not newSet[id] and v.state == true then
      currentMap[k] = { state = false, ts = ts }
    end
  end

  sharedCfg.safeIdsAndares = currentMap
  saveAttackBotShared()
end, true, comboInterface.idsSafeAndares)

idsSafeContainer:setParent(comboInterface.idsSafeAndares)
idsSafeContainer:fill("parent")
idsSafeContainer:setOpacity(1.00)
idsSafeContainer:setItems(sharedMapToList(sharedCfg.safeIdsAndares))

local spellRowTemplate = [[
UIWidget
  id: root
  height: 38
  focusable: true
  draggable: true
  background-color: alpha
  border: 1 alpha
  opacity: 1.00
  margin-top: 2
  $hover:
    background-color: #2a2a2a
    border: 1 #3a3a3a
  $focus:
    background-color: #2a2a2a
    border: 1 #3a3a3a

  BotSwitch
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    margin-top: 0
    width: 20
    height: 20
    text-align: center
    color: white
    image-source: /images/ui/button_rounded

  Label
    id: spellName
    anchors.left: enabled.right
    anchors.top: parent.top
    margin-left: 6
    margin-top: 4
    color: orange
    text: ""
    font: verdana-11px-rounded
    text-auto-resize: true

  Label
    id: distText
    anchors.left: spellName.left
    anchors.top: spellName.bottom
    margin-top: 2
    color: #c8c8c8
    text: ""
    font: verdana-11px-rounded
    text-auto-resize: true

  Label
    id: safeText
    anchors.left: distText.right
    anchors.verticalCenter: distText.verticalCenter
    margin-left: 4
    color: #ff5a5a
    text: ""
    font: verdana-11px-rounded
    text-auto-resize: true

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
    image-source: /images/ui/button_rounded
    image-color: red
    opacity: 1.00
    $hover:
      image-color: red
      color: #ffd0d0
      opacity: 0.95
]]

local runeRowTemplate = [[
UIWidget
  id: root
  height: 38
  focusable: true
  draggable: true
  background-color: alpha
  border: 1 alpha
  opacity: 1.00
  margin-top: 2
  $hover:
    background-color: #2a2a2a
    border: 1 #3a3a3a
  $focus:
    background-color: #2a2a2a
    border: 1 #3a3a3a

  BotSwitch
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    margin-top: 0
    width: 20
    height: 20
    text-align: center
    color: white
    image-source: /images/ui/button_rounded

  UIItem
    id: icon
    anchors.left: enabled.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 2
    size: 30 30
    visible: false

  Label
    id: distText
    anchors.left: icon.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 1
    color: #c8c8c8
    text: ""
    font: verdana-11px-rounded
    text-auto-resize: true

  Label
    id: safeText
    anchors.left: distText.right
    anchors.verticalCenter: distText.verticalCenter
    margin-left: 4
    color: #ff5a5a
    text: ""
    font: verdana-11px-rounded
    text-auto-resize: true

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
    image-source: /images/ui/button_rounded
    image-color: red
    opacity: 1.00
    $hover:
      image-color: red
      color: #ffd0d0
      opacity: 0.95
]]

local editingSpellIndex = nil
local editingRuneIndex = nil

local selectType = W(spellAddPanel, "selectType")
local magiaSelect = W(spellAddPanel, "magiaSelect")
local spellMagia = W(spellAddPanel,"magia")
local spellDistance = W(spellAddPanel,"distance")
local spellMana = W(spellAddPanel,"mana")
local spellMobs = W(spellAddPanel,"mobs")
local spellCooldown = W(spellAddPanel,"cooldown")
local spellSafe = W(spellAddPanel,"safe")
local spellCancelarBt = W(spellAddPanel,"cancelarBt")
local spellAdicionarBt = W(spellAddPanel,"adicionarBt")
local spellDistanceLabel = W(spellAddPanel,"distanceLabel")
local spellManaLabel = W(spellAddPanel,"manaLabel")
local spellMobsLabel = W(spellAddPanel,"mobsLabel")
local spellCooldownLabel = W(spellAddPanel,"cdLabel")
local spellCalcCooldownBtn = W(spellAddPanel, "calculeCooldown")

local runeItem = W(runeAddPanel,"runa")
local runeDistance = W(runeAddPanel,"distance")
local runeMobs = W(runeAddPanel,"mobs")
local runeSafe = W(runeAddPanel,"safe")
local runeCancelarBt = W(runeAddPanel,"cancelarBt")
local runeAdicionarBt = W(runeAddPanel,"adicionarBt")
local runeDistanceLabel = W(runeAddPanel,"distanceLabel")
local runeMobsLabel = W(runeAddPanel,"mobsLabel")
local unsafeMinutos = W(panelSpellsUnsafe, "minutosVoltarUnsafe")
local unsafePausar = W(panelSpellsUnsafe, "pausarUnsafe")
local unsafeFrags = W(panelSpellsUnsafe, "qtdeFrags")
local unsafeDeslogar = W(panelSpellsUnsafe, "deslogarFrags")
local unsafeClose = W(panelSpellsUnsafe, "closePanel")
local unsafeLabelMin = W(panelSpellsUnsafe, "info2")
local unsafeLabelFrags = W(panelSpellsUnsafe, "info3")

if unsafeMinutos then
  if unsafeMinutos.setMinimum then unsafeMinutos:setMinimum(1) end
  if unsafeMinutos.setMaximum then unsafeMinutos:setMaximum(120) end
  if unsafeMinutos.setStep then unsafeMinutos:setStep(1) end
end

if unsafeFrags then
  if unsafeFrags.setMinimum then unsafeFrags:setMinimum(1) end
  if unsafeFrags.setMaximum then unsafeFrags:setMaximum(8) end
  if unsafeFrags.setStep then unsafeFrags:setStep(1) end
end

local function refreshUnsafePanel()
  local min = tonumber(cfg.main.minutosVoltarUnsafe) or 5
  local frags = tonumber(cfg.main.qtdeFrags) or 1

  if unsafeMinutos then
    unsafeMinutos:setValue(min)
  end

  if unsafePausar then
    unsafePausar:setOn(cfg.main.pausarUnsafe == true)
  end

  if unsafeFrags then
    unsafeFrags:setValue(frags)
  end

  if unsafeDeslogar then
    unsafeDeslogar:setOn(cfg.main.deslogarFrags == true)
  end

  -- 🔥 UPDATE LABELS
  if unsafeLabelMin then
    unsafeLabelMin:setText("Reactive in: " .. min .. " min")
  end

  if unsafeLabelFrags then
    unsafeLabelFrags:setText("Amount Frags: " .. frags)
  end
end

-- Tabela com as magias pré-configuradas {Nome, Distância, Mana, Mobs, CD, Safe}
local predefinedSpells = {
  ["Paladin"] = {
    {"Exevo mas san", 4, 160, 1, 4106, false},
    {"Exori san", 9, 20, 1, 2100, true},
    {"Exori con", 9, 25, 1, 2100, true},
    {"Exori gran con", 9, 55, 1, 6080, true}
  },
  ["Knight"] = {
    {"Exori gran", 1, 340, 1, 4106, false},
    {"Exori", 1, 115, 1, 2016, false},
    {"Exori min", 1, 200, 1, 4030, false},
    {"Exori mas", 2, 160, 1, 6100, false},
    {"Exori hur", 5, 40, 1, 4060, true},
    {"Exori ico", 1, 30, 1, 2070, true},
    {"Exori gran ico", 1, 300, 1, 15020, true}
  },
  ["Mage"] = {
    {"Exori frigo", 8, 20, 1, 2027, true},
    {"Exevo gran mas frigo", 7, 1000, 1, 15055, true},
    {"Exori vis", 8, 20, 1, 2027, true},
    {"Exevo gran mas vis", 7, 600, 1, 15055, true},
    {"Exori flam", 8, 20, 1, 2027, true},
    {"Exevo gran mas flam", 7, 1000, 1, 15055, true},
    {"Exori tera", 8, 20, 1, 2027, true},
    {"Exevo gran mas tera", 7, 600, 1, 15055, true}
  },
  -- SPELL, DISTANCIA, MANA, MOBS, COOLDOWN, SAFE
  ["Monk"] = {
    {"Exori Pug", 1, 35, 1, 4096, true},
    {"Exori Amp Pug", 1, 50, 1, 20090, false},
    {"Exori Med Pug", 1, 180, 1, 4074, false},
    {"Exori Mas Pug", 2, 125, 1, 4035, false},
    {"Exori Gran Pug", 1, 325, 1, 15103, false},
    {"Exori Gran Mas Pug", 1, 315, 1, 16015, false},
    {"Exori Nia", 1, 50, 1, 8074, true},
    {"Exori Mas Nia", 1, 195, 1, 8050, false},
    {"Exori Gran Nia", 1, 210, 1, 24103, true}
  }
}

local MONK_HARMONY_FINISHERS = {
  ["exori mas nia"] = true,
  ["exori gran nia"] = true
}

local function updateSpellPanelLabels()
  if spellDistanceLabel and spellDistance then spellDistanceLabel:setText("Distance: " .. (spellDistance:getValue() or 0)) end
  if spellManaLabel and spellMana then spellManaLabel:setText("Mana: " .. (spellMana:getValue() or 0)) end
  if spellMobsLabel and spellMobs then spellMobsLabel:setText("Mobs: " .. (spellMobs:getValue() or 0)) end
  if spellCooldownLabel and spellCooldown then spellCooldownLabel:setText("Cooldown: " .. (spellCooldown:getValue() or 0)) end
end

local function updateRunePanelLabels()
  if runeDistanceLabel and runeDistance then runeDistanceLabel:setText("Distance: " .. (runeDistance:getValue() or 0)) end
  if runeMobsLabel and runeMobs then runeMobsLabel:setText("Mobs: " .. (runeMobs:getValue() or 0)) end
end

if spellDistance then spellDistance.onValueChange = function() updateSpellPanelLabels() end end
if spellMana then spellMana.onValueChange = function() updateSpellPanelLabels() end end
if spellMobs then spellMobs.onValueChange = function() updateSpellPanelLabels() end end
if spellCooldown then spellCooldown.onValueChange = function() updateSpellPanelLabels() end end
if runeDistance then runeDistance.onValueChange = function() updateRunePanelLabels() end end
if runeMobs then runeMobs.onValueChange = function() updateRunePanelLabels() end end

unsafeMinutos.onValueChange = function(_, value)
  local v = tonumber(value) or 5
  cfg.main.minutosVoltarUnsafe = v

  if unsafeLabelMin then
    unsafeLabelMin:setText("Reactive in: " .. v .. " min")
  end

  saveAttackBotChar()
end

if unsafePausar then
  unsafePausar.onClick = function(widget)
    local state = not widget:isOn()
    widget:setOn(state)
    cfg.main.pausarUnsafe = state
    saveAttackBotChar()
  end
end

unsafeFrags.onValueChange = function(_, value)
  local v = tonumber(value) or 1
  cfg.main.qtdeFrags = v

  if unsafeLabelFrags then
    unsafeLabelFrags:setText("Amount Frags: " .. v)
  end

  saveAttackBotChar()
end

if unsafeDeslogar then
  unsafeDeslogar.onClick = function(widget)
    local state = not widget:isOn()
    widget:setOn(state)
    cfg.main.deslogarFrags = state
    saveAttackBotChar()
  end
end

if unsafeClose then
  unsafeClose.onClick = function()
    panelSpellsUnsafe:hide()
  end
end

if selectType and magiaSelect and spellMagia then
  selectType.onOptionChange = function(comboBox, option)
    if option == "Editable" then
      spellMagia:setVisible(true)
      magiaSelect:setVisible(false)
      spellDistance:setValue(0)
      spellMana:setValue(0)
      spellMobs:setValue(1)
      spellCooldown:setValue(0)
      spellSafe:setChecked(false)
    else
      spellMagia:setVisible(false)
      magiaSelect:setVisible(true)

      magiaSelect:clearOptions()
      local vocSpells = predefinedSpells[option] or {}
      if #vocSpells == 0 then
        magiaSelect:addOption("Nenhuma magia cadastrada")
      else
        for _, s in ipairs(vocSpells) do
          magiaSelect:addOption(s[1])
        end
        local first = vocSpells[1]
        spellDistance:setValue(first[2])
        spellMana:setValue(first[3])
        spellMobs:setValue(first[4] or 1)
        spellCooldown:setValue(first[5])
        spellSafe:setChecked(first[6])
        updateSpellPanelLabels()
      end
    end
  end

  magiaSelect.onOptionChange = function(comboBox, option)
    local currentType = selectType:getCurrentOption().text
    local vocSpells = predefinedSpells[currentType] or {}
    for _, s in ipairs(vocSpells) do
      if s[1] == option then
        spellDistance:setValue(s[2])
        spellMana:setValue(s[3])
        spellMobs:setValue(s[4] or 1)
        spellCooldown:setValue(s[5])
        spellSafe:setChecked(s[6])
        updateSpellPanelLabels()
        break
      end
    end
  end
end

local function resetSpellAddPanel()
  if selectType then selectType:setOption("Editable") end
  if spellMagia then 
    spellMagia:setText("") 
    spellMagia:setVisible(true)
  end
  if magiaSelect then magiaSelect:setVisible(false) end
  if spellDistance then spellDistance:setValue(1) end
  if spellMana then spellMana:setValue(0) end
  if spellMobs then spellMobs:setValue(1) end
  if spellCooldown then spellCooldown:setValue(0) end
  if spellSafe then spellSafe:setChecked(false) end
  updateSpellPanelLabels()
end

local function resetRuneAddPanel()
  if runeItem then
    if runeItem.setItemId then
      runeItem:setItemId(0)
    elseif runeItem.setItem then
      pcall(function() runeItem:setItem(nil) end)
    end
  end
  if runeDistance then runeDistance:setValue(1) end
  if runeMobs then runeMobs:setValue(1) end
  if runeSafe then runeSafe:setChecked(false) end
  updateRunePanelLabels()
end

local function setupDragAndDrop(row)
  row.onDragEnter = function(self, mousePos)
    self:setOpacity(0.4)
    return true
  end
  row.onDragLeave = function(self, droppedWidget, mousePos)
    self:setOpacity(1.0)
  end
  row.onDrop = function(self, droppedWidget, mousePos)
    self:setOpacity(1.0)
    droppedWidget:setOpacity(1.0)
    local parent = self:getParent()
    local children = parent:getChildren()
    local fromIndex, toIndex = 0, 0
    for i, child in ipairs(children) do
      if child == droppedWidget then fromIndex = i end
      if child == self then toIndex = i end
    end
    if fromIndex > 0 and toIndex > 0 and fromIndex ~= toIndex then
      local movedItem = table.remove(cfg.attacks, fromIndex)
      table.insert(cfg.attacks, toIndex, movedItem)
      saveAttackBotChar()
      rebuildAttackList()
    end
    return true
  end
end

local function createSpellRow(data, index)
  local row = setupUI(spellRowTemplate, comboInterface.spellList)
  setupDragAndDrop(row) -- Aplica o Drag & Drop na Spell

  row.enabled:setOn(data.enabled == true)
  row.enabled.onClick = function(w)
    local state = not w:isOn()
    w:setOn(state)
    if cfg.attacks[index] then cfg.attacks[index].enabled = state end
    saveAttackBotChar()
  end
  row.spellName:setText(tostring(data.spell or ""))
  row.distText:setText(spellInfo(data.distance, data.mobs))
  setSafeLabel(row.safeText, data.safe)
  row.remove.onClick = function()
    table.remove(cfg.attacks, index)
    saveAttackBotChar()
    rebuildAttackList()
  end
  row.onDoubleClick = function()
    local data = cfg.attacks[index]
    if not data then return end
    editingIndex = index
    spellMagia:setText(data.spell or "")
    spellDistance:setValue(data.distance or 1)
    spellMana:setValue(data.mana or 0)
    spellMobs:setValue(data.mobs or 1)
    spellCooldown:setValue(data.cooldown or 0)
    spellSafe:setChecked(data.safe or false)
    updateSpellPanelLabels()
    comboInterface:hide()
    spellAddPanel:show()
    spellAddPanel:raise()
    spellAddPanel:focus()
  end
end

local function createRuneRow(data, index)
  local row = setupUI(runeRowTemplate, comboInterface.spellList)
  setupDragAndDrop(row) -- Aplica o Drag & Drop na Runa

  row.enabled:setOn(data.enabled == true)
  row.enabled.onClick = function(w)
    local state = not w:isOn()
    w:setOn(state)
    if cfg.attacks[index] then cfg.attacks[index].enabled = state end
    saveAttackBotChar()
  end
  setItemIcon(row.icon, tonumber(data.id) or 0)
  row.distText:setText(runeInfo(data.distance, data.mobs))
  setSafeLabel(row.safeText, data.safe)
  row.remove.onClick = function()
    table.remove(cfg.attacks, index)
    saveAttackBotChar()
    rebuildAttackList()
  end
  row.onDoubleClick = function()
    local data = cfg.attacks[index]
    if not data then return end
    editingIndex = index
    setItemIcon(runeItem, tonumber(data.id) or 0)
    if runeItem and runeItem.setItemId then runeItem:setItemId(tonumber(data.id) or 0) end
    runeDistance:setValue(data.distance or 1)
    runeMobs:setValue(data.mobs or 1)
    runeSafe:setChecked(data.safe or false)
    updateRunePanelLabels()
    comboInterface:hide()
    runeAddPanel:show()
    runeAddPanel:raise()
    runeAddPanel:focus()
  end
end

function rebuildAttackList()
  if not comboInterface or not comboInterface.spellList then return end
  clearChildren(comboInterface.spellList)
  for i, data in ipairs(cfg.attacks or {}) do 
    if data.type == "spell" then
      createSpellRow(data, i)
    elseif data.type == "rune" then
      createRuneRow(data, i)
    end
  end
end

comboInterface.adicionarSpell.onClick = function()
  editingIndex = nil
  resetSpellAddPanel()
  comboInterface:hide()
  spellAddPanel:show()
  spellAddPanel:focus()
  spellAddPanel:raise()
end

comboInterface.adicionarRuna.onClick = function()
  editingIndex = nil
  resetRuneAddPanel()
  comboInterface:hide()
  runeAddPanel:show()
  runeAddPanel:raise()
  runeAddPanel:focus()
end

spellAdicionarBt.onClick = function()
  local spellName = ""

  -- Verifica de onde pegar o nome da magia
  if selectType and selectType:getCurrentOption().text == "Editable" then
    spellName = trimText(spellMagia:getText())
  else
    spellName = trimText(magiaSelect:getCurrentOption().text)
    if spellName == "Nenhuma magia cadastrada" or spellName == "" then
       return warn("Nenhuma magia válida selecionada para esta vocação.")
    end
  end

  if spellName == "" then return warn("Insira ou selecione uma spell.") end

  local data = {
    type = "spell",
    enabled = true,
    spell = spellName,
    distance = spellDistance:getValue(),
    mana = spellMana:getValue(),
    mobs = spellMobs:getValue(),
    cooldown = spellCooldown:getValue(),
    safe = spellSafe:isChecked(),
    nextCast = 0
  }

  if editingIndex then
    data.enabled = cfg.attacks[editingIndex] and cfg.attacks[editingIndex].enabled ~= false or true
    data.nextCast = cfg.attacks[editingIndex] and cfg.attacks[editingIndex].nextCast or 0
    cfg.attacks[editingIndex] = data
    editingIndex = nil
  else
    table.insert(cfg.attacks, data)
  end

  saveAttackBotChar()
  rebuildAttackList()
  spellAddPanel:hide()
  comboInterface:show()
end

runeAdicionarBt.onClick = function()
  local runeId = getBotItemId(runeItem)
  if not runeId or runeId <= 0 then return warn("Selecione uma rune.") end

  local data = {
    type = "rune",
    enabled = true,
    id = runeId,
    distance = runeDistance:getValue(),
    mobs = runeMobs:getValue(),
    safe = runeSafe:isChecked(),
    nextCast = 0
  }

  if editingIndex then
    data.enabled = cfg.attacks[editingIndex] and cfg.attacks[editingIndex].enabled ~= false or true
    data.nextCast = cfg.attacks[editingIndex] and cfg.attacks[editingIndex].nextCast or 0
    cfg.attacks[editingIndex] = data
    editingIndex = nil
  else
    table.insert(cfg.attacks, data)
  end

  saveAttackBotChar()
  rebuildAttackList()
  runeAddPanel:hide()
  comboInterface:show()
end

spellCancelarBt.onClick = function()
  editingIndex = nil
  spellAddPanel:hide()
  comboInterface:show()
end

runeCancelarBt.onClick = function()
  editingIndex = nil
  comboInterface:show()
  runeAddPanel:hide()
end

setActiveAttackProfile(getActiveAttackProfileIndex())
refreshUnsafePanel()
updateSpellPanelLabels()
updateRunePanelLabels()

local SkullWhite = 3
local SkullRed = 4
local SkullBlack = 5

local PKSkulls = {
  [SkullWhite] = true,
  [SkullRed] = true,
  [SkullBlack] = true
}

local function getSafePlayerCheckDist()
  return math.max(1, tonumber(cfg.main.distSegura) or 1)
end

local function getSafeOtherFloorCheckDist()
  return math.max(1, tonumber(cfg.main.qtdePlayers) or 1)
end

local function getSafeStairsCheckDist()
  return math.max(1, tonumber(cfg.main.distStairs) or 1)
end

local function isPkSkulled(creature)
  if not creature or not creature.getSkull then return false end
  local skull = creature:getSkull()
  return PKSkulls[skull] == true
end

local function hasPartyShield(creature)
  if not creature then
    return false
  end

  if creature.isPartyMember and creature:isPartyMember() then
    return true
  end

  return false
end

local function isAttackBotFriend(creature)
  if not creature or not creature:isPlayer() or creature:isLocalPlayer() then
    return false
  end

  local cname = creature:getName()
  if not cname then return false end

  -- party real, somente pelo estado atual
  if creature.isPartyMember and creature:isPartyMember() then
    return true
  end

  charStorage.playerList = charStorage.playerList or {}
  charStorage.playerList.friendList = charStorage.playerList.friendList or {}

  for _, friendName in ipairs(charStorage.playerList.friendList) do
    if trimText(friendName):lower() == trimText(cname):lower() then
      return true
    end
  end

  if type(isFriend) == "function" and isFriend(cname) then
    return true
  end

  return false
end

local function isSpellProtectedPlayer(creature)
  if not creature or not creature:isPlayer() or creature:isLocalPlayer() then
    return false
  end

  if isAttackBotFriend(creature) then
    return false
  end

  return not isPkSkulled(creature)
end

local function getPlayerFloorScan()
  local result = {
    sameFloor = false,
    otherFloor = false
  }

  local myPos = pos()
  if not myPos then return result end

  local maxDist = getSafePlayerCheckDist()

  for _, spec in pairs(getSpectators(true)) do
    if isSpellProtectedPlayer(spec) then
      local sPos = spec:getPosition()

      if sPos then
        local dist = math.max(math.abs(myPos.x - sPos.x), math.abs(myPos.y - sPos.y))

        if sPos.z == myPos.z then
          if cfg.main.checkPlayers and dist <= maxDist then
            result.sameFloor = true
          end
        else
          if cfg.main.checkFloors and math.abs(sPos.z - myPos.z) == 1 and dist <= maxDist then
            result.otherFloor = true
          end
        end
      end
    end
  end

  return result
end

local function hasPlayerOnScreenSameFloor()
  return getPlayerFloorScan().sameFloor == true
end

local function hasPlayerOnOtherFloors()
  return getPlayerFloorScan().otherFloor == true
end

local MINIMAP_STAIRS_COLORS = {
  [210] = true,
  [211] = true,
  [212] = true,
  [213] = true,

}

local function isMinimapStairs(pos)
  if not pos or not g_map or not g_map.getMinimapColor then return false end

  local color = g_map.getMinimapColor(pos)
  color = tonumber(color)

  if not color then return false end

  return MINIMAP_STAIRS_COLORS[color] == true
end


local function hasConfiguredUnsafeId(tile)
  if not tile then return false end

  local ids = sharedMapToList(sharedCfg.safeIdsAndares)

  for _, item in pairs(tile:getItems() or {}) do
    if item and item.getId and table.find(ids, item:getId()) then
      return true
    end
  end

  return false
end

local function hasYellowMinimapStair(tile)
  if not tile then return false end
  return isMinimapStairs(tile:getPosition()) == true
end

local function isNearConfiguredStairs()
  if not cfg.main.checkStairs then return false end

  local myPos = pos()
  if not myPos then return false end

  local stairDist = getSafeStairsCheckDist()

  -- 1) ID configurado = UNSAFE direto, MAS SÓ NO ANDAR ATUAL
  for _, tile in pairs(g_map.getTiles(myPos.z) or {}) do
    local tPos = tile:getPosition()

    if tPos then
      local dist = math.max(math.abs(myPos.x - tPos.x), math.abs(myPos.y - tPos.y))

      if dist <= stairDist and hasConfiguredUnsafeId(tile) then
        return "id"
      end
    end
  end

  -- 2) Minimap amarelo = só sinalizador de escada/andar, também no andar atual
  for _, tile in pairs(g_map.getTiles(myPos.z) or {}) do
    local tPos = tile:getPosition()

    if tPos then
      local dist = math.max(math.abs(myPos.x - tPos.x), math.abs(myPos.y - tPos.y))

      if dist <= stairDist and hasYellowMinimapStair(tile) then
        return "yellow"
      end
    end
  end

  return false
end

local function hasPlayerOnOtherFloorsNearStairs()
  if not cfg.main.checkStairs then return false end

  local myPos = pos()
  if not myPos then return false end

  local maxPlayerDist = getSafePlayerCheckDist()

  for _, spec in pairs(getSpectators(true) or {}) do
    if spec and spec:isPlayer() and not spec:isLocalPlayer() and isSpellProtectedPlayer(spec) then
      local sPos = spec:getPosition()

      if sPos and sPos.z ~= myPos.z and math.abs(sPos.z - myPos.z) == 1 then
        local dist = math.max(math.abs(myPos.x - sPos.x), math.abs(myPos.y - sPos.y))

        if dist <= maxPlayerDist then
          return true
        end
      end
    end
  end

  return false
end

local function hasProtectedPlayerForUnsafe()
  local scan = getPlayerFloorScan()

  if scan.sameFloor then return true end
  if hasPlayerOnOtherFloorsNearStairs() then return true end
  if scan.otherFloor then return true end

  return false
end

function LNS_HAS_UNSAFE_CONDITION()
  local scan = getPlayerFloorScan()

  if scan.sameFloor then return true end

  local stairMode = isNearConfiguredStairs()

  if stairMode == "id" then
    return true
  end

  if stairMode == "yellow" then
    return hasPlayerOnOtherFloorsNearStairs() == true
  end

  if scan.otherFloor then return true end

  return false
end

macro(100, function()
  LNS_HAS_UNSAFE_CONDITION()
  local p = player
  if not p then return end

  local unsafe = false

  if type(LNS_HAS_UNSAFE_CONDITION) == "function" then
    unsafe = LNS_HAS_UNSAFE_CONDITION() == true
  end

  if unsafe then
    if p:getText() ~= "UNSAFE" then
      p:setText("UNSAFE")
    end
  else
    if p:getText() == "UNSAFE" then
      p:setText("")
    end
  end
end)

local worldName = g_game.getWorldName() or ""
local WORLD_COMBAT_LOCK = 1000
if worldName == "Telaria" or worldName == "Eternia" or worldName == "Aurera-Global" then
  WORLD_COMBAT_LOCK = 2000
end

local combatGlobalUntil = 0
local lastRuneGlobal = 0

local runeCooldownIcon = {
  [3155] = 21,
  [3175] = 116,
  [3202] = 117,
  [3191] = 16,
  [3161] = 115
}

local function isRuneClientCooldownActive(runeId)
  runeId = tonumber(runeId) or 0

  local iconId = runeCooldownIcon[runeId]
  if not iconId then return false end

  return modules.game_cooldown
     and modules.game_cooldown.isCooldownIconActive
     and modules.game_cooldown.isCooldownIconActive(iconId) == true
end




local MONK_HARMONY_MAX = 5
local MONK_HARMONY_BUILDERS = {
  ["exori gran pug"] = true,
  ["exori amp pug"] = true,
  ["exori gran mas pug"] = true,
  ["exori mas pug"] = true,
  ["exori med pug"] = true
}
local MONK_HARMONY_FINISHERS = {
  ["exori mas nia"] = true,
  ["exori gran nia"] = true
}

local function monkSpellKey(text)
  return trimText(text):lower()
end

local function isMonkHarmonyVocation()
  local p = g_game.getLocalPlayer()
  if not p then return false end
  local voc = tonumber(p:getVocation()) or 0
  return voc == 5 or voc == 10
end

local function monkHarmonyGet()
  return math.max(0, math.min(MONK_HARMONY_MAX, tonumber(charStorage.attackBotMonkHarmony.points) or 0))
end

local function monkHarmonySet(v)
  charStorage.attackBotMonkHarmony.points = math.max(0, math.min(MONK_HARMONY_MAX, tonumber(v) or 0))
  saveAttackBotChar()
end

local function monkHarmonyAdd(v)
  monkHarmonySet(monkHarmonyGet() + (tonumber(v) or 1))
end

local function monkHarmonyReset()
  monkHarmonySet(0)
end

local function isHarmonyBuilderSpell(spell)
  return MONK_HARMONY_BUILDERS[monkSpellKey(spell)] == true
end

local function isHarmonyFinisherSpell(spell)
  return MONK_HARMONY_FINISHERS[monkSpellKey(spell)] == true
end

local function hasConfiguredHarmonyFinisher()
  for _, attack in ipairs(cfg.attacks or {}) do
    if attack.enabled and attack.type == "spell" and isHarmonyFinisherSpell(attack.spell or "") then
      return true
    end
  end
  return false
end

local function monkHarmonyFlowActive()
  return isMonkHarmonyVocation() and hasConfiguredHarmonyFinisher()
end

local function resetComboCooldowns()
  for _, attack in ipairs(cfg.attacks or {}) do
    attack.nextCast = 0
  end
  combatGlobalUntil = 0
  lastRuneGlobal = 0
  monkHarmonyReset()
end

local function iAmFrag()
  local p = g_game.getLocalPlayer()
  if not p then return false end
  local skull = p.getSkull and p:getSkull() or 0
  return PKSkulls[skull] == true
end



local function iAmDead()
  local p = g_game.getLocalPlayer()
  if not p then return false end
  if p.getHealthPercent then
    return (p:getHealthPercent() or 100) <= 0
  end
  return false
end

local function disableUnsafeAttacksByFrag()
  local did = false
  local marked = {}

  cfg.main.disabledByFrag = type(cfg.main.disabledByFrag) == "table" and cfg.main.disabledByFrag or {}

  for _, idx in ipairs(cfg.main.disabledByFrag) do
    marked[idx] = true
  end

  for i, attack in ipairs(cfg.attacks or {}) do
    if attack and attack.enabled ~= false and attack.safe ~= true then
      attack.enabled = false

      if not marked[i] then
        table.insert(cfg.main.disabledByFrag, i)
        marked[i] = true
      end

      did = true
    end
  end

  if did then
    rebuildAttackList()
    saveAttackBotChar()
    warn("[AttackBot] PK/Frag detectado - unsafe desligadas.")
  end
end

local function restoreUnsafeAttacksByFrag()
  if type(cfg.main.disabledByFrag) ~= "table" or #cfg.main.disabledByFrag == 0 then
    cfg.main.reenableUnsafeAt = 0
    return
  end

  for _, idx in ipairs(cfg.main.disabledByFrag) do
    local attack = cfg.attacks and cfg.attacks[idx]
    if attack then
      attack.enabled = true
    end
  end

  cfg.main.disabledByFrag = {}
  cfg.main.reenableUnsafeAt = 0

  rebuildAttackList()
  saveAttackBotChar()
  warn("[AttackBot] Unsafe religadas.")
end

local function countAttackMonstersAround(centerPos, maxDist)
  if not centerPos then return 0 end

  local count = 0
  local specs = {}

  if g_map and g_map.getSpectators then
    local ok, res = pcall(function() return g_map.getSpectators(centerPos, false) end)
    if ok and type(res) == "table" then specs = res end
  elseif type(getSpectators) == "function" then
    local ok, res = pcall(function() return getSpectators(false) end)
    if ok and type(res) == "table" then specs = res end
  end

  for _, s in ipairs(specs) do
    if s and s.isMonster and s:isMonster() then
      local sPos = s:getPosition()
      if sPos and sPos.z == centerPos.z then
        local dist = math.max(math.abs(centerPos.x - sPos.x), math.abs(centerPos.y - sPos.y))
        if dist <= (maxDist or 7) then
          count = count + 1
        end
      end
    end
  end

  return count
end

local function isSafeAllowedForCurrentTarget(isSafe, targetIsPlayer)
  if targetIsPlayer then return true end
  if not hasProtectedPlayerForUnsafe() then return true end
  return isSafe == true
end

local function attackReady(attack)
  return now >= (tonumber(attack.nextCast) or 0)
end

local function canCastSpellAttack(attack, dist, targetIsPlayer, pPos)
  local maxDist = tonumber(attack.distance) or 8
  local manaOk = mana() >= (tonumber(attack.mana) or 0)
  local mobsOk = true
  local needMobs = tonumber(attack.mobs) or 0

  if (not targetIsPlayer) and needMobs > 0 then
    mobsOk = countAttackMonstersAround(pPos, 7) >= needMobs
  end

  return dist <= maxDist and manaOk and mobsOk and isSafeAllowedForCurrentTarget(attack.safe, targetIsPlayer)
end

local function canUseRuneAttack(attack, dist, targetIsPlayer, pPos)
  local runeId = tonumber(attack.id) or 0

  if isRuneClientCooldownActive(runeId) then
    return false
  end

  local maxDist = tonumber(attack.distance) or 8
  local mobsOk = true
  local needMobs = tonumber(attack.mobs) or 0

  if (not targetIsPlayer) and needMobs > 0 then
    mobsOk = countAttackMonstersAround(pPos, 7) >= needMobs
  end

  return dist <= maxDist and mobsOk and isSafeAllowedForCurrentTarget(attack.safe, targetIsPlayer)
end

local function isUnsafeNowForAttack(targetIsPlayer)
  if targetIsPlayer then return false end

  if type(LNS_HAS_UNSAFE_CONDITION) == "function" then
    return LNS_HAS_UNSAFE_CONDITION() == true
  end

  return hasProtectedPlayerForUnsafe() == true
end

local function tryUseAttack(attack, dist, target, targetIsPlayer, pPos, unsafeNow)
  if not attack or not attack.enabled or not attackReady(attack) then return false end

  -- se estiver unsafe, ignora imediatamente spell/rune unsafe
  if unsafeNow and attack.safe ~= true then
    return false
  end

  local maxDist = tonumber(attack.distance) or 8
  if dist > maxDist then return false end

  if attack.type == "spell" then
    local manaOk = mana() >= (tonumber(attack.mana) or 0)
    if not manaOk then return false end

    local needMobs = tonumber(attack.mobs) or 0
    if not targetIsPlayer and needMobs > 0 then
      if countAttackMonstersAround(pPos, 7) < needMobs then
        return false
      end
    end

    local words = trimText(attack.spell)
    if words == "" then return false end

    say(words)
    combatGlobalUntil = now + WORLD_COMBAT_LOCK
    return true
  end

  if attack.type == "rune" then
    local runeId = tonumber(attack.id) or 0

    if pauseForMw and pauseForMw > now then return false end
    if runeId <= 0 then return false end
    if isRuneClientCooldownActive(runeId) then return false end

    local needMobs = tonumber(attack.mobs) or 0
    if not targetIsPlayer and needMobs > 0 then
      if countAttackMonstersAround(pPos, 7) < needMobs then
        return false
      end
    end

    local ok = pcall(function()
      useWith(runeId, target)
    end)

    if ok then
      combatGlobalUntil = now + 50
      return true
    end
  end

  return false
end

local function tryUseMonkBuilder(dist, target, targetIsPlayer, pPos)
  for _, attack in ipairs(cfg.attacks or {}) do
    if attack.enabled and attack.type == "spell" and isHarmonyBuilderSpell(attack.spell or "") then
      if tryUseAttack(attack, dist, target, targetIsPlayer, pPos) then
        return true
      end
    end
  end
  return false
end

local function tryUseMonkFinisher(dist, target, targetIsPlayer, pPos)
  for _, attack in ipairs(cfg.attacks or {}) do
    if attack.enabled and attack.type == "spell" and isHarmonyFinisherSpell(attack.spell or "") then
      if tryUseAttack(attack, dist, target, targetIsPlayer, pPos) then
        return true
      end
    end
  end
  return false
end

local monkHarmonyIcon = addIcon("lnsAttackBotMonkHarmony", {
  text = "Harmony",
  switchable = false,
  moveable = true
}, function() end)
monkHarmonyIcon:setSize({height = 52, width = 74})
monkHarmonyIcon.text:setFont("verdana-11px-rounded")
macro(100, function()
  if not isMonkHarmonyVocation() then
    monkHarmonyIcon:hide()
    return
  end

  monkHarmonyIcon:show()
  local points = monkHarmonyGet()

  if points >= MONK_HARMONY_MAX then
    monkHarmonyIcon.text:setColoredText({tostring(points) .. "/5", "green"})
  else
    monkHarmonyIcon.text:setColoredText({tostring(points) .. "/5", "orange"})
  end
end)

resetComboCooldowns()

if g_game and connect then
  connect(g_game, {
    onGameStart = function()
      resetComboCooldowns()
    end
  })
end

local cdSpell = { active = false, spell = "", lastTime = 0 }
local function stopSpellCalc()
  cdSpell.active = false
  cdSpell.spell = ""
  cdSpell.lastTime = 0
end

macro(100, function()
  if not cdSpell.active then return end
  if cdSpell.spell == "" then stopSpellCalc(); return end
  say(cdSpell.spell)
end)

onTalk(function(name, level, mode, text, channelId, pos)
  local player = g_game.getLocalPlayer()
  if not player then return end

  if cdSpell.active and name == player:getName() then
    local msg = trimText(text):lower()
    local expected = trimText(cdSpell.spell):lower()
    if expected ~= "" and msg == expected then
      local t = nowMs()
      if cdSpell.lastTime > 0 then
        local cd = math.floor(t - cdSpell.lastTime)
        local v = clamp(cd, 0, 60000)
        if spellCooldown and spellCooldown.setValue then
          spellCooldown:setValue(v)
          if spellCooldown.onValueChange then
            pcall(function() spellCooldown.onValueChange(spellCooldown, v) end)
          end
        end
        updateSpellPanelLabels()
        warn(string.format("[CD-SPELL] %d ms (%.1fs)", v, v / 1000))
        stopSpellCalc()
      else
        cdSpell.lastTime = t
      end
    end
  end

  if name ~= player:getName() then return end

  local spoken = trimText(text):lower()

  if isMonkHarmonyVocation() then
    if MONK_HARMONY_BUILDERS[spoken] then
      monkHarmonyAdd(1)
    elseif MONK_HARMONY_FINISHERS[spoken] then
      monkHarmonyReset()
    end
  end

  for _, attack in ipairs(cfg.attacks or {}) do
    if attack.type == "spell" and attack.enabled then
      local spellWords = trimText(attack.spell):lower()
      if spellWords ~= "" and spellWords == spoken then
        attack.nextCast = now + (tonumber(attack.cooldown) or WORLD_COMBAT_LOCK)
        combatGlobalUntil = now + WORLD_COMBAT_LOCK
        return
      end
    end
  end
end)

local function getSelectedSpellNameForCooldown()
  local spell = ""

  if selectType and selectType:getCurrentOption() then
    local currentType = selectType:getCurrentOption().text or ""

    if currentType == "Editable" then
      spell = trimText(spellMagia and spellMagia:getText() or "")
    else
      if magiaSelect and magiaSelect:getCurrentOption() then
        spell = trimText(magiaSelect:getCurrentOption().text or "")
      end
    end
  else
    spell = trimText(spellMagia and spellMagia:getText() or "")
  end

  if spell == "Nenhuma magia cadastrada" then
    spell = ""
  end

  return spell
end

if spellCalcCooldownBtn then
  spellCalcCooldownBtn.onClick = function()
    local spell = getSelectedSpellNameForCooldown()

    if spell == "" then
      warn("Digite ou selecione uma spell.")
      return
    end

    cdSpell.active = true
    cdSpell.spell = spell
    cdSpell.lastTime = 0

    warn("[CD-SPELL] Iniciado para: " .. spell .. ". Fale/caste a spell 2x para calcular.")
  end
end

if not iAmFrag() then
  restoreUnsafeAttacksByFrag()
end
macro(200, function()
  if not charStorage[switchCombo] or charStorage[switchCombo].enabled ~= true then return end

  -- só funciona se os 2 estiverem ligados, como você pediu
  if cfg.main.pausarUnsafe ~= true then
    if #cfg.main.disabledByFrag > 0 then
      restoreUnsafeAttacksByFrag()
    end
    return
  end

  if cfg.main.manterDist ~= true then
    if #cfg.main.disabledByFrag > 0 then
      restoreUnsafeAttacksByFrag()
    end
    return
  end

  local frag = iAmFrag()

  -- pegou PK agora -> desliga unsafe
  if frag and (#cfg.main.disabledByFrag == 0) then
    disableUnsafeAttacksByFrag()
    cfg.main.reenableUnsafeAt = 0
    saveAttackBotChar()
    return
  end

  -- se já tem coisas desligadas, administra reativação
  if #cfg.main.disabledByFrag > 0 then
    if iAmDead() then
      restoreUnsafeAttacksByFrag()
      return
    end

    -- enquanto estiver de skull, não começa contagem
    if frag then
      cfg.main.reenableUnsafeAt = 0
      return
    end

    -- perdeu skull
    local mins = tonumber(cfg.main.minutosVoltarUnsafe) or 0

    if mins <= 0 then
      return
    end

    if cfg.main.reenableUnsafeAt <= 0 then
      cfg.main.reenableUnsafeAt = nowMs() + (mins * 60 * 1000)
      saveAttackBotChar()
      return
    end

    if nowMs() >= cfg.main.reenableUnsafeAt then
      restoreUnsafeAttacksByFrag()
      return
    end
  end
end)

-- =========================
-- LOGOUT ON FRAGS
-- =========================
cfg.main.fragsAtual = tonumber(cfg.main.fragsAtual) or 0

onTextMessage(function(mode, text)
  if not cfg or not cfg.main then return end
  if cfg.main.deslogarFrags ~= true then return end
  if type(text) ~= "string" then return end
  if not text:find("Warning! The murder of") then return end

  cfg.main.fragsAtual = tonumber(cfg.main.fragsAtual) or 0
  cfg.main.qtdeFrags = tonumber(cfg.main.qtdeFrags) or 1

  cfg.main.fragsAtual = cfg.main.fragsAtual + 1
  saveAttackBotChar()

  if cfg.main.fragsAtual >= cfg.main.qtdeFrags then
    cfg.main.fragsAtual = 0
    saveAttackBotChar()

    modules.game_interface.forceExit()
  end
end)

macro(50, function()
  if not charStorage[switchCombo] or charStorage[switchCombo].enabled ~= true then return end
  if pausandoCombo and pausandoCombo > now then return end

  local player = g_game.getLocalPlayer()
  local target = g_game.getAttackingCreature()

  if not player or not target then return end
  if player:isNpc() then return end

  local pPos = player:getPosition()
  local tPos = target:getPosition()

  if not pPos or not tPos or pPos.z ~= tPos.z then
    return
  end

  local dist = math.max(
    math.abs(pPos.x - tPos.x),
    math.abs(pPos.y - tPos.y)
  )

  local targetIsPlayer = (target.isPlayer and target:isPlayer()) or false

  local unsafeNow = false

  if not targetIsPlayer then
    if type(LNS_HAS_UNSAFE_CONDITION) == "function" then
      unsafeNow = LNS_HAS_UNSAFE_CONDITION() == true
    else
      unsafeNow = hasProtectedPlayerForUnsafe() == true
    end
  end

  -- respeita exhaust/global
  if combatGlobalUntil > now then
    return
  end

  -- monk system
  if monkHarmonyFlowActive() and not unsafeNow then
    if monkHarmonyGet() >= MONK_HARMONY_MAX then
      if tryUseMonkFinisher(dist, target, targetIsPlayer, pPos) then
        return
      end
    else
      if tryUseMonkBuilder(dist, target, targetIsPlayer, pPos) then
        return
      end
    end
  end

  --==================================================
  -- UNSAFE = somente magias SAFE
  --==================================================
  if unsafeNow then
    for _, attack in ipairs(cfg.attacks or {}) do
      if attack
      and attack.enabled
      and attack.safe == true then

        if tryUseAttack(
          attack,
          dist,
          target,
          targetIsPlayer,
          pPos,
          true
        ) then
          return
        end
      end
    end

    return
  end

  --==================================================
  -- SAFE = fluxo normal
  --==================================================
  for _, attack in ipairs(cfg.attacks or {}) do
    if tryUseAttack(
      attack,
      dist,
      target,
      targetIsPlayer,
      pPos,
      false
    ) then
      return
    end
  end
end)

macro(200, function()
  if not charStorage[switchCombo] or charStorage[switchCombo].enabled ~= true then return end
  if not cfg.main.virarTarget then return end

  local target = g_game.getAttackingCreature()
  if not target then return end

  local tPos = target:getPosition()
  local pPos = pos()
  if not tPos or not pPos or tPos.z ~= pPos.z then return end

  local xDiff = tPos.x > pPos.x
  local yDiff = tPos.y > pPos.y
  local isXBigger = math.abs(tPos.x - pPos.x) > math.abs(tPos.y - pPos.y)

  local player = g_game.getLocalPlayer()
  if not player then return end
  local dir = player:getDirection()

  if xDiff and isXBigger then
    if dir ~= 1 then turn(1) end
    return
  elseif not xDiff and isXBigger then
    if dir ~= 3 then turn(3) end
    return
  elseif yDiff and not isXBigger then
    if dir ~= 2 then turn(2) end
    return
  elseif not yDiff and not isXBigger then
    if dir ~= 0 then turn(0) end
    return
  end
end)

---------------------------------- HEALING
if not loadCharStorage or not saveCharStorage then
  return print("[Healing] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function saveHealingChar()
  saveCharStorage(charStorage)
end

local switchHealing = "healingButton"

charStorage[switchHealing] = charStorage[switchHealing] or { enabled = false }

healingButton = setupUI([[
Panel
  height: 19
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Healing
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
]])

healingButton:setId(switchHealing)
healingButton.title:setOn(charStorage[switchHealing].enabled == true)

healingButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  charStorage[switchHealing].enabled = newState
  saveHealingChar()
end

local PROFILE = "Default"
local MAX_ROWS = 3

charStorage.healingPanel = charStorage.healingPanel or {}
charStorage.healingPanel[PROFILE] = charStorage.healingPanel[PROFILE] or {
  spells = {},
  hp = {},
  mp = {},
  counts = {
    spells = 0,
    hp = 0,
    mp = 0
  }
}

local db = charStorage.healingPanel[PROFILE]
db.spells = db.spells or {}
db.hp = db.hp or {}
db.mp = db.mp or {}
db.counts = db.counts or {}

if db.counts.spells == nil then db.counts.spells = math.min(#db.spells, MAX_ROWS) end
if db.counts.hp == nil then db.counts.hp = math.min(#db.hp, MAX_ROWS) end
if db.counts.mp == nil then db.counts.mp = math.min(#db.mp, MAX_ROWS) end

local function clampCount(n)
  n = tonumber(n) or 0
  if n < 0 then return 0 end
  if n > MAX_ROWS then return MAX_ROWS end
  return n
end

local function realCount(kind)
  db.counts = db.counts or {}
  db.counts[kind] = clampCount(db.counts[kind])
  return db.counts[kind]
end

local function forceSaveKind(kind, list)
  list = list or {}

  local clean = {}
  for i = 1, math.min(#list, MAX_ROWS) do
    clean[#clean + 1] = list[i]
  end

  db[kind] = clean
  db.counts[kind] = #clean

  charStorage.healingPanel[PROFILE][kind] = clean
  charStorage.healingPanel[PROFILE].counts = db.counts

  saveHealingChar()
end

local panelHealing = setupUI([[
MainWindow
  size: 550 337
  text: Panel Healing
  margin-top: -50

  FlatPanel
    id: flatP
    anchors.fill: parent
    margin: -8
    margin-top: -5
    margin-bottom: 20

    Panel
      id: col1
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      width: 171
      margin: 6

      Label
        text: Spells
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font: verdana-11px-rounded
        text-auto-resize: true

      HorizontalSeparator
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        margin-top: 4

      TextList
        id: list1
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: controls1.top
        margin-top: 4
        margin-bottom: 4

      Panel
        id: controls1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 20

        Button
          id: add1
          text: +
          width: 40
          height: 20
          anchors.left: parent.left
          anchors.verticalCenter: parent.verticalCenter

        Label
          id: count1
          text: 0/3
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          font: verdana-11px-rounded
          text-auto-resize: true

        Button
          id: rem1
          text: -
          width: 40
          height: 20
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter

    Panel
      id: col2
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: col1.right
      width: 171
      margin-top: 6
      margin-bottom: 6
      margin-left: 6

      Label
        text: HP
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font: verdana-11px-rounded
        text-auto-resize: true

      HorizontalSeparator
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        margin-top: 4

      TextList
        id: list2
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: controls2.top
        margin-top: 4
        margin-bottom: 4

      Panel
        id: controls2
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 20

        Button
          id: add2
          text: +
          width: 40
          height: 20
          anchors.left: parent.left
          anchors.verticalCenter: parent.verticalCenter

        Label
          id: count2
          text: 0/3
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          font: verdana-11px-rounded
          text-auto-resize: true

        Button
          id: rem2
          text: -
          width: 40
          height: 20
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter

    Panel
      id: col3
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.left: col2.right
      width: 172
      margin: 6

      Label
        text: MP
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font: verdana-11px-rounded
        text-auto-resize: true

      HorizontalSeparator
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        margin-top: 4

      TextList
        id: list3
        anchors.top: prev.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: controls3.top
        margin-top: 4
        margin-bottom: 4

      Panel
        id: controls3
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 20

        Button
          id: add3
          text: +
          width: 40
          height: 20
          anchors.left: parent.left
          anchors.verticalCenter: parent.verticalCenter

        Label
          id: count3
          text: 0/3
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.verticalCenter: parent.verticalCenter
          font: verdana-11px-rounded
          text-auto-resize: true

        Button
          id: rem3
          text: -
          width: 40
          height: 20
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter

  Button
    id: closePanel
    anchors.left: flatP.left
    anchors.right: flatP.right
    anchors.top: flatP.bottom
    margin-left: -1
    margin-top: 5
    text: Close
]], g_ui.getRootWidget())

panelHealing:hide()

if modules._G.g_app.isMobile() then
  panelHealing:setSize("550 357")
end

panelHealing.closePanel.onClick = function()
  panelHealing:hide()
end

healingButton.settings.onClick = function()
  panelHealing:show()
  panelHealing:raise()
  panelHealing:focus()
end

g_ui.loadUIFromString([[
SpellRow < Panel
  id: root
  height: 70
  focusable: true
  background-color: #4a4a4a
  border: 1 #2a2a2a
  opacity: 1.00
  margin-top: 2

  $hover:
    background-color: #555555
    border: 1 #6a6a6a

  $focus:
    background-color: #5d5d5d
    border: 1 #808080

  BotTextEdit
    id: spellText
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    font: verdana-11px-rounded
    margin-left: 4
    margin-right: 4
    margin-top: 3
    tooltip: Insert Spell Here

  HorizontalScrollBar
    id: hpScroll
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    margin-top: 3
    minimum: 0
    maximum: 100
    step: 1
    value: 80

  BotSwitch
    id: activeSwitch
    anchors.right: parent.right
    anchors.top: hpScroll.bottom
    margin-right: 5
    margin-top: 4
    size: 35 25
    text: OFF
    font: verdana-9px

  Label
    id: hpText
    anchors.left: hpScroll.left
    anchors.top: hpScroll.bottom
    margin-top: 2
    color: white
    text: HP <= 80%
    text-auto-resize: true

  Label
    id: manaText
    anchors.left: hpScroll.left
    anchors.top: hpText.bottom
    margin-top: 2
    color: white
    text: Mana: 0
    text-auto-resize: true
]])

g_ui.loadUIFromString([[
PotionRow < Panel
  id: root
  height: 70
  focusable: true
  background-color: #4a4a4a
  border: 1 #2a2a2a
  opacity: 1.00
  margin-top: 2

  $hover:
    background-color: #5d5d5d
    border: 1 #808080

  BotItem
    id: image
    anchors.left: parent.left
    anchors.top: parent.top
    margin-left: 4
    margin-top: 25
    size: 37 37

  HorizontalScrollBar
    id: Scroll
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    margin-left: 4
    margin-right: 4
    margin-top: 3
    minimum: 0
    maximum: 100
    step: 1
    value: 80

  BotSwitch
    id: activeBox
    anchors.right: parent.right
    anchors.verticalCenter: image.verticalCenter
    margin-right: 5
    margin-top: 4
    size: 35 25
    text: OFF
    font: verdana-9px

  Label
    id: hpText
    anchors.left: image.right
    anchors.verticalCenter: image.verticalCenter
    margin-left: 10
    margin-top: -1
    color: white
    font: verdana-11px-rounded
    text: HP <= 80%
]])

local selectedRows = {
  spells = nil,
  hp = nil,
  mp = nil
}

local SPELL_MANA_COST = {
  ["exura"] = 20,
  ["exura ico"] = 40,
  ["exura gran"] = 70,
  ["exura vita"] = 160,
  ["exura gran ico"] = 200,
  ["exura med ico"] = 90,
  ["exura infir ico"] = 160,
  ["exura san"] = 160,
  ["exura gran san"] = 210,
  ["utura"] = 60,
  ["utura gran"] = 100,
  ["utura mas sio"] = 140,
  ["exura sio"] = 140,
  ["exura gran sio"] = 200,
  ["exura mas res"] = 160,
  ["exura gran mas res"] = 250
}

local function trimText(text)
  return tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function resolveSpellMana(spellName)
  spellName = trimText(spellName):lower()
  if spellName == "" then return 0 end
  return SPELL_MANA_COST[spellName] or 0
end

local function getList(kind)
  if kind == "spells" then return panelHealing.flatP.col1.list1 end
  if kind == "hp" then return panelHealing.flatP.col2.list2 end
  return panelHealing.flatP.col3.list3
end

local function getCounter(kind)
  if kind == "spells" then return panelHealing.flatP.col1.controls1.count1 end
  if kind == "hp" then return panelHealing.flatP.col2.controls2.count2 end
  return panelHealing.flatP.col3.controls3.count3
end

local function refreshCounter(kind)
  getCounter(kind):setText(tostring(realCount(kind)) .. "/" .. MAX_ROWS)
end

local function refreshAllCounters()
  refreshCounter("spells")
  refreshCounter("hp")
  refreshCounter("mp")
end

local function setRowSelected(kind, row)
  selectedRows[kind] = row

  local list = getList(kind)
  for _, child in ipairs(list:getChildren()) do
    if child.setFocused then
      child:setFocused(child == row)
    end
  end
end

local function clearRowSelected(kind)
  selectedRows[kind] = nil
end

local function makeSpellEntry(data)
  data = data or {}

  local spell = tostring(data.spell or "")
  local hpValue = tonumber(data.hp) or 80
  local manaValue = tonumber(data.mana)

  if manaValue == nil then
    manaValue = resolveSpellMana(spell)
  end

  return {
    spell = spell,
    hp = hpValue,
    mana = manaValue or 0,
    enabled = data.enabled == true
  }
end

local function makePotionEntry(data, defaultItem)
  data = data or {}

  return {
    itemId = tonumber(data.itemId) or defaultItem,
    hp = tonumber(data.hp) or 80,
    enabled = data.enabled == true
  }
end

local function formatSpellName(text)
  text = trimText(text)
  text = text:gsub("%s+", " ")

  if text == "" then return "" end

  local words = {}
  for word in text:gmatch("%S+") do
    local first = word:sub(1, 1):upper()
    local rest = word:sub(2):lower()
    table.insert(words, first .. rest)
  end

  return table.concat(words, " ")
end

local function bindSpellRow(row, entry, kind)
  row._entry = entry

  row.spellText:setText(entry.spell or "")
  row.hpScroll:setValue(entry.hp or 80)
  row.hpText:setText("HP <= " .. tostring(entry.hp or 80) .. "%")
  row.manaText:setText("Mana: " .. tostring(entry.mana or 0))
  row.activeSwitch:setOn(entry.enabled == true)
  row.activeSwitch:setText(entry.enabled and "ON" or "OFF")

  row.onClick = function(widget)
    setRowSelected(kind, widget)
  end

  row.spellText.onTextChange = function(widget, text)
    local formatted = formatSpellName(text)

    if text ~= formatted then
      widget:setText(formatted)
      return
    end

    entry.spell = formatted
    entry.mana = resolveSpellMana(formatted)
    row.manaText:setText("Mana: " .. tostring(entry.mana))
    saveHealingChar()
  end

  row.hpScroll.onValueChange = function(widget, value)
    entry.hp = tonumber(value) or 80
    row.hpText:setText("HP <= " .. tostring(entry.hp) .. "%")
    saveHealingChar()
  end

  row.activeSwitch.onClick = function(widget)
    local state = not widget:isOn()
    widget:setOn(state)
    widget:setText(state and "ON" or "OFF")
    entry.enabled = state
    saveHealingChar()
  end
end

local function bindPotionRow(row, entry, kind)
  row._entry = entry

  row.Scroll:setValue(entry.hp or 80)

  if kind == "mp" then
    row.hpText:setText("MP <= " .. tostring(entry.hp or 80) .. "%")
  else
    row.hpText:setText("HP <= " .. tostring(entry.hp or 80) .. "%")
  end

  row.activeBox:setOn(entry.enabled == true)
  row.activeBox:setText(entry.enabled and "ON" or "OFF")

  if row.image and row.image.setItemId then
    row.image:setItemId(entry.itemId or 0)
  end

  row.onClick = function(widget)
    setRowSelected(kind, widget)
  end

  row.Scroll.onValueChange = function(widget, value)
    entry.hp = tonumber(value) or 80

    if kind == "mp" then
      row.hpText:setText("MP <= " .. tostring(entry.hp) .. "%")
    else
      row.hpText:setText("HP <= " .. tostring(entry.hp) .. "%")
    end

    saveHealingChar()
  end

  row.activeBox.onClick = function(widget)
    local state = not widget:isOn()
    widget:setOn(state)
    widget:setText(state and "ON" or "OFF")
    entry.enabled = state
    saveHealingChar()
  end

  if row.image then
    row.image.onItemChange = function(widget)
      local id = 0

      if widget.getItemId then
        id = tonumber(widget:getItemId()) or 0
      elseif widget.getItem and widget:getItem() and widget:getItem().getId then
        id = tonumber(widget:getItem():getId()) or 0
      end

      if id > 0 then
        entry.itemId = id
        saveHealingChar()
      end
    end

    row.image.onItemIdChange = function(widget, itemId)
      itemId = tonumber(itemId) or 0

      if itemId > 0 then
        entry.itemId = itemId
        saveHealingChar()
      end
    end
  end
end

local function createSpellRow(kind, entry)
  local row = g_ui.createWidget("SpellRow", getList(kind))
  bindSpellRow(row, entry, kind)
  return row
end

local function createPotionRow(kind, entry)
  local row = g_ui.createWidget("PotionRow", getList(kind))
  bindPotionRow(row, entry, kind)
  return row
end

local function clearList(kind)
  local list = getList(kind)

  for _, child in ipairs(list:getChildren()) do
    child:destroy()
  end

  clearRowSelected(kind)
end

local function normalizeInitialStorage()
  local kinds = {"spells", "hp", "mp"}

  for _, kind in ipairs(kinds) do
    local count = realCount(kind)
    local clean = {}

    for i = 1, count do
      local row = db[kind] and db[kind][i]

      if row then
        if kind == "spells" then
          clean[#clean + 1] = makeSpellEntry(row)
        elseif kind == "hp" then
          clean[#clean + 1] = makePotionEntry(row, 266)
        else
          clean[#clean + 1] = makePotionEntry(row, 268)
        end
      end
    end

    forceSaveKind(kind, clean)
  end
end

local function loadRows()
  clearList("spells")
  clearList("hp")
  clearList("mp")

  for i = 1, realCount("spells") do
    local entry = db.spells[i]
    if entry then
      db.spells[i] = makeSpellEntry(entry)
      createSpellRow("spells", db.spells[i])
    end
  end

  for i = 1, realCount("hp") do
    local entry = db.hp[i]
    if entry then
      db.hp[i] = makePotionEntry(entry, 266)
      createPotionRow("hp", db.hp[i])
    end
  end

  for i = 1, realCount("mp") do
    local entry = db.mp[i]
    if entry then
      db.mp[i] = makePotionEntry(entry, 268)
      createPotionRow("mp", db.mp[i])
    end
  end

  refreshAllCounters()
end

local function addRow(kind)
  local count = realCount(kind)
  if count >= MAX_ROWS then return end

  local clean = {}

  for i = 1, count do
    if db[kind][i] then
      clean[#clean + 1] = db[kind][i]
    end
  end

  local entry

  if kind == "spells" then
    entry = makeSpellEntry()
  elseif kind == "hp" then
    entry = makePotionEntry(nil, 266)
  else
    entry = makePotionEntry(nil, 268)
  end

  clean[#clean + 1] = entry

  forceSaveKind(kind, clean)
  loadRows()
end

local function removeRow(kind)
  local count = realCount(kind)
  if count <= 0 then return end

  local list = getList(kind)
  local children = list:getChildren()
  if #children == 0 then return end

  local row = selectedRows[kind] or children[#children]
  local removeIndex = nil

  for i, child in ipairs(children) do
    if child == row then
      removeIndex = i
      break
    end
  end

  if not removeIndex then return end

  local clean = {}

  for i = 1, count do
    if i ~= removeIndex and db[kind][i] then
      clean[#clean + 1] = db[kind][i]
    end
  end

  forceSaveKind(kind, clean)
  loadRows()
end

panelHealing.flatP.col1.controls1.add1.onClick = function()
  addRow("spells")
end

panelHealing.flatP.col1.controls1.rem1.onClick = function()
  removeRow("spells")
end

panelHealing.flatP.col2.controls2.add2.onClick = function()
  addRow("hp")
end

panelHealing.flatP.col2.controls2.rem2.onClick = function()
  removeRow("hp")
end

panelHealing.flatP.col3.controls3.add3.onClick = function()
  removeRow("mp")
end

panelHealing.flatP.col3.controls3.add3.onClick = function()
  addRow("mp")
end

panelHealing.flatP.col3.controls3.rem3.onClick = function()
  removeRow("mp")
end

normalizeInitialStorage()
loadRows()

local healProfile = PROFILE
local healSpellCooldown = 900
local healPotionCooldown = 250
local lastHealSpellCast = 0
local lastHealPotionUse = 0
local lastHealMpPotionUse = 0
local spellLock = false

local function nowMs()
  if g_clock and g_clock.millis then
    return g_clock.millis()
  end
  return now or 0
end

local function getHealDB()
  charStorage.healingPanel = charStorage.healingPanel or {}
  charStorage.healingPanel[healProfile] = charStorage.healingPanel[healProfile] or {
    spells = {},
    hp = {},
    mp = {},
    counts = {
      spells = 0,
      hp = 0,
      mp = 0
    }
  }

  charStorage.healingPanel[healProfile].spells = charStorage.healingPanel[healProfile].spells or {}
  charStorage.healingPanel[healProfile].hp = charStorage.healingPanel[healProfile].hp or {}
  charStorage.healingPanel[healProfile].mp = charStorage.healingPanel[healProfile].mp or {}
  charStorage.healingPanel[healProfile].counts = charStorage.healingPanel[healProfile].counts or {}

  return charStorage.healingPanel[healProfile]
end

local function getHealCount(hdb, kind)
  hdb.counts = hdb.counts or {}
  local n = tonumber(hdb.counts[kind]) or 0

  if n < 0 then return 0 end
  if n > MAX_ROWS then return MAX_ROWS end

  return n
end

local function normalizeSpellRow(row)
  if not row then return nil end
  if row.enabled ~= true then return nil end

  local spell = tostring(row.spell or row.words or "")
  local hpValue = tonumber(row.hp) or 0
  local manaValue = tonumber(row.mana) or 0

  if spell == "" then return nil end

  return {
    spell = spell,
    hp = hpValue,
    mana = manaValue
  }
end

local function normalizePotionRow(row, mode)
  if not row then return nil end
  if row.enabled ~= true then return nil end

  local itemId = tonumber(row.itemId) or 0
  local threshold = tonumber(row.hp) or tonumber(row.mp) or 0

  if itemId <= 0 then return nil end

  return {
    itemId = itemId,
    threshold = threshold,
    mode = mode
  }
end

local function getBestHealSpell()
  local hdb = getHealDB()
  local currentHp = hppercent()
  local currentMana = mana()
  local candidates = {}
  local count = getHealCount(hdb, "spells")

  for i = 1, count do
    local row = normalizeSpellRow(hdb.spells[i])
    if row and currentHp <= row.hp then
      candidates[#candidates + 1] = row
    end
  end

  if #candidates == 0 then return nil end

  table.sort(candidates, function(a, b)
    if a.hp ~= b.hp then
      return a.hp < b.hp
    end
    return a.mana > b.mana
  end)

  for _, row in ipairs(candidates) do
    if currentMana >= row.mana then
      return row
    end
  end

  return nil
end

local function getBestHpPotion()
  local hdb = getHealDB()
  local currentHp = hppercent()
  local best = nil
  local count = getHealCount(hdb, "hp")

  for i = 1, count do
    local row = normalizePotionRow(hdb.hp[i], "hp")
    if row and currentHp <= row.threshold then
      if not best or row.threshold < best.threshold then
        best = row
      end
    end
  end

  return best
end

local function getBestMpPotion()
  local hdb = getHealDB()
  local currentMp = manapercent()
  local best = nil
  local count = getHealCount(hdb, "mp")

  for i = 1, count do
    local row = normalizePotionRow(hdb.mp[i], "mp")
    if row and currentMp <= row.threshold then
      if not best or row.threshold < best.threshold then
        best = row
      end
    end
  end

  return best
end

onTalk(function(name, level, mode, text, channelId, pos)
  local localPlayer = g_game.getLocalPlayer()
  if not localPlayer or name ~= localPlayer:getName() then return end

  local hdb = getHealDB()
  local msg = tostring(text or ""):lower()
  local count = getHealCount(hdb, "spells")

  for i = 1, count do
    local row = normalizeSpellRow(hdb.spells[i])
    if row then
      local words = row.spell:lower()

      if words ~= "" and msg:find(words, 1, true) then
        spellLock = true
        lastHealSpellCast = nowMs()

        schedule(healSpellCooldown, function()
          spellLock = false
        end)

        return
      end
    end
  end
end)

macro(100, function()
  if not charStorage.healingButton or charStorage.healingButton.enabled ~= true then return end
  if spellLock then return end

  local t = nowMs()
  if t - lastHealSpellCast < healSpellCooldown then return end

  local best = getBestHealSpell()
  if not best then return end

  spellLock = true
  lastHealSpellCast = t
  pauseFriendHeal = now + 500
  say(best.spell)

  schedule(healSpellCooldown, function()
    spellLock = false
  end)
end)

macro(100, function()
  if not charStorage.healingButton or charStorage.healingButton.enabled ~= true then return end
  if pauseForMw and pauseForMw > now then return end

  local t = nowMs()
  if t - lastHealPotionUse < healPotionCooldown then return end

  local best = getBestHpPotion()
  if not best then return end

  local localPlayer = g_game.getLocalPlayer()
  if not localPlayer then return end

  lastHealPotionUse = t
  useWith(best.itemId, localPlayer)
end)

macro(100, function()
  if not charStorage.healingButton or charStorage.healingButton.enabled ~= true then return end
  if pauseForMw and pauseForMw > now then return end

  local t = nowMs()
  if t - lastHealMpPotionUse < healPotionCooldown then return end

  local best = getBestMpPotion()
  if not best then return end

  local localPlayer = g_game.getLocalPlayer()
  if not localPlayer then return end

  lastHealMpPotionUse = t
  useWith(best.itemId, localPlayer)
end)

saveHealingChar()

-- Prioridade absoluta para Healing próprio
macro(50, function()
  if not charStorage.healingButton or charStorage.healingButton.enabled ~= true then return end

  local critical = false

  local hdb = getHealDB()

  for i = 1, getHealCount(hdb, "spells") do
    local row = normalizeSpellRow(hdb.spells[i])
    if row and hppercent() <= row.hp then
      critical = true
      break
    end
  end

  for i = 1, getHealCount(hdb, "hp") do
    local row = normalizePotionRow(hdb.hp[i], "hp")
    if row and hppercent() <= row.threshold then
      critical = true
      break
    end
  end

  if critical then
    pauseFriendHeal = now + 700
  end
end)

-------------------------------- CONDITIONS
if not loadCharStorage or not saveCharStorage then
  return print("[Conditions] LNS Storage Core nao carregado.")
end

charStorage = charStorage or loadCharStorage()

local function saveConditionsChar()
  saveCharStorage(charStorage)
end

local switchConditions = "conditionsButton"
local panelName = "conditionsInterface"

storage = storage or {}
charStorage[switchConditions] = charStorage[switchConditions] or { enabled = false }
charStorage[panelName] = charStorage[panelName] or {
  switches = {},
  combos = {},
  texts = {}
}

if charStorage[panelName].switches == nil and type(charStorage[panelName].checks) == "table" then
  charStorage[panelName].switches = charStorage[panelName].checks
  charStorage[panelName].checks = nil
end

charStorage[panelName].switches = charStorage[panelName].switches or {}
charStorage[panelName].combos   = charStorage[panelName].combos or {}
charStorage[panelName].texts    = charStorage[panelName].texts or {}

if storage[panelName] and not charStorage[panelName .. "_migrated"] then
  local old = storage[panelName]
  if type(old.switches) == "table" then
    for k, v in pairs(old.switches) do
      if charStorage[panelName].switches[k] == nil then
        charStorage[panelName].switches[k] = v
      end
    end
  end
  if type(old.combos) == "table" then
    for k, v in pairs(old.combos) do
      if charStorage[panelName].combos[k] == nil then
        charStorage[panelName].combos[k] = v
      end
    end
  end
  if type(old.texts) == "table" then
    for k, v in pairs(old.texts) do
      if charStorage[panelName].texts[k] == nil then
        charStorage[panelName].texts[k] = v
      end
    end
  end
  charStorage[panelName .. "_migrated"] = true
  saveConditionsChar()
end

if storage[switchConditions] and charStorage[switchConditions] and charStorage[switchConditions].enabled == nil then
  charStorage[switchConditions].enabled = storage[switchConditions].enabled == true
  saveConditionsChar()
end


conditionsButton = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Conditions
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
]])

conditionsButton:setId(switchConditions)
conditionsButton.title:setOn(charStorage[switchConditions].enabled == true)

conditionsButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  charStorage[switchConditions].enabled = newState
  saveConditionsChar()
end

conditionsInterface = setupUI([=[
MainWindow
  id: mainPanel
  size: 350 270
  text: Perfect Conditions
  margin-top: -50

  FlatPanel
    id: infolist1
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 115
    margin-left: -4
    margin-right: -4

    BotSwitch
      id: spellHaste
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: 8
      margin-left: 8
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblHaste
      anchors.left: spellHaste.right
      anchors.verticalCenter: spellHaste.verticalCenter
      margin-left: 5
      text: Haste
      font: verdana-11px-rounded
      text-auto-resize: true

    ComboBox
      id: comboHaste
      anchors.right: parent.right
      anchors.verticalCenter: spellHaste.verticalCenter
      margin-right: 8
      width: 150
      @onSetup: |
        self:addOption("")
        self:addOption("Utani Hur")
        self:addOption("Utani Gran Hur")
        self:addOption("Utani Tempo Hur")
        self:addOption("Utamo Tempo San")

    BotSwitch
      id: spellBuff
      anchors.top: spellHaste.bottom
      anchors.left: spellHaste.left
      margin-top: 6
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblBuff
      anchors.left: spellBuff.right
      anchors.verticalCenter: spellBuff.verticalCenter
      margin-left: 5
      text: Buff
      font: verdana-11px-rounded
      text-auto-resize: true

    ComboBox
      id: comboBuff
      anchors.right: comboHaste.right
      anchors.verticalCenter: spellBuff.verticalCenter
      width: 150
      @onSetup: |
        self:addOption("")
        self:addOption("Utito Tempo")
        self:addOption("Utamo Tempo")
        self:addOption("Utito Tempo San")
        self:addOption("Utito Virtu")
        self:addOption("Utori Virtu")

    BotSwitch
      id: spellAntilyze
      anchors.top: spellBuff.bottom
      anchors.left: spellBuff.left
      margin-top: 6
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblAntiLyze
      anchors.left: spellAntilyze.right
      anchors.verticalCenter: spellAntilyze.verticalCenter
      margin-left: 5
      text: Anti-Lyze
      font: verdana-11px-rounded
      text-auto-resize: true

    TextEdit
      id: comboAntilyze
      anchors.right: comboBuff.right
      anchors.verticalCenter: spellAntilyze.verticalCenter
      width: 150
      height: 20
      placeholder: Insert anti-lyze spell

    BotSwitch
      id: spellUtura
      anchors.top: spellAntilyze.bottom
      anchors.left: spellAntilyze.left
      margin-top: 6
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblUtura
      anchors.left: spellUtura.right
      anchors.verticalCenter: spellUtura.verticalCenter
      margin-left: 5
      text: Utura Gran
      font: verdana-11px-rounded
      text-auto-resize: true

    TextEdit
      id: textUturaGran
      anchors.right: comboAntilyze.right
      anchors.verticalCenter: spellUtura.verticalCenter
      width: 150
      height: 20
      placeholder: Insert utura spell

  FlatPanel
    id: infolist2
    anchors.top: infolist1.bottom
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    height: 178
    margin-top: 8
    margin-bottom: 20
    margin-left: -4
    margin-right: -4

    BotSwitch
      id: spellUtamo
      anchors.top: parent.top
      anchors.left: parent.left
      margin-top: 8
      margin-left: 8
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblUtamo
      anchors.left: spellUtamo.right
      anchors.verticalCenter: spellUtamo.verticalCenter
      margin-left: 5
      text: Auto Magic Shield
      font: verdana-11px-rounded
      text-auto-resize: true

    BotSwitch
      id: spellUtana
      anchors.top: spellUtamo.bottom
      anchors.left: spellUtamo.left
      margin-top: 6
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblUtana
      anchors.left: spellUtana.right
      anchors.verticalCenter: spellUtana.verticalCenter
      margin-left: 5
      text: Auto Invisible
      font: verdana-11px-rounded
      text-auto-resize: true

    BotSwitch
      id: cureStatus
      anchors.top: spellUtana.bottom
      anchors.left: spellUtana.left
      margin-top: 6
      image-source: /images/ui/button_rounded
      size: 35 20
      font: verdana-11px-rounded
      $on:
        text: On
      $!on:
        image-color: gray
        text: Off

    Label
      id: lblCureStatus
      anchors.left: cureStatus.right
      anchors.verticalCenter: cureStatus.verticalCenter
      margin-left: 5
      text: Cure Status
      font: verdana-11px-rounded
      text-auto-resize: true

  Button
    id: closePanel
    anchors.left: infolist2.left
    anchors.right: infolist2.right
    anchors.top: infolist2.bottom
    margin-top: 5
    text: Close

]=], g_ui.getRootWidget())

conditionsInterface:hide()

local function getConditionWidget(id)
  if not conditionsInterface then return nil end
  return conditionsInterface:recursiveGetChildById(id)
end

if modules._G.g_app.isMobile() then
  conditionsInterface:setSize("350 290")
end

local closeBtn = getConditionWidget("closePanel")
if closeBtn then
  closeBtn.onClick = function()
    conditionsInterface:hide()
  end
end

conditionsButton.settings.onClick = function()
  if not conditionsInterface:isVisible() then
    conditionsInterface:show()
    conditionsInterface:raise()
    conditionsInterface:focus()
  end
end

local function bindSwitch(id)
  local w = getConditionWidget(id)
  if not w then
    warn("bindSwitch nao encontrou widget: " .. tostring(id))
    return
  end

  local saved = charStorage[panelName].switches[id]
  if saved ~= nil then
    w:setOn(saved == true)
  else
    charStorage[panelName].switches[id] = w:isOn() == true
    saveConditionsChar()
  end

  w.onClick = function(widget)
    local newState = not widget:isOn()
    widget:setOn(newState)
    charStorage[panelName].switches[id] = newState
    saveConditionsChar()
  end
end

local function bindCombo(id)
  local combo = getConditionWidget(id)
  if not combo then
    warn("bindCombo nao encontrou widget: " .. tostring(id))
    return
  end

  if charStorage[panelName].combos[id] ~= nil then
    combo:setCurrentOption(charStorage[panelName].combos[id])
  else
    charStorage[panelName].combos[id] = combo:getCurrentOption()
    saveConditionsChar()
  end

  combo.onOptionChange = function(widget, option)
    charStorage[panelName].combos[id] = option
    saveConditionsChar()
  end
end

local function bindText(id)
  local w = getConditionWidget(id)
  if not w then
    warn("bindText nao encontrou widget: " .. tostring(id))
    return
  end

  if charStorage[panelName].texts[id] ~= nil then
    w:setText(tostring(charStorage[panelName].texts[id]))
  else
    charStorage[panelName].texts[id] = w:getText() or ""
    saveConditionsChar()
  end

  w.onTextChange = function(widget, text)
    charStorage[panelName].texts[id] = tostring(text or "")
    saveConditionsChar()
  end
end

bindSwitch("spellHaste")
bindCombo("comboHaste")

bindSwitch("spellBuff")
bindCombo("comboBuff")

bindSwitch("spellAntilyze")
bindText("comboAntilyze")

bindSwitch("spellUtura")
bindText("textUturaGran")

bindSwitch("spellUtamo")
bindSwitch("spellUtana")
bindSwitch("cureStatus")

local userUturaTimer = 0
local userBuffTimer = 0
local utanaCast = 0

local function _trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function conditionsEnabled()
  return charStorage[switchConditions] and charStorage[switchConditions].enabled == true
end

local function getCondCfg()
  local cfg = charStorage[panelName]
  if not cfg then return nil end
  cfg.switches = cfg.switches or {}
  cfg.combos = cfg.combos or {}
  cfg.texts = cfg.texts or {}
  return cfg
end

onTalk(function(name, level, mode, text, channelId, pos)
  local player = g_game.getLocalPlayer()
  if not player then return end
  if name ~= player:getName() then return end

  text = tostring(text or ""):lower()

  local cfg = getCondCfg()
  if not cfg then return end

  local buffSpell = _trim(cfg.combos["comboBuff"]):lower()
  if buffSpell ~= "" and text == buffSpell then
    userBuffTimer = now + 10000
  end

  local uturaSpell = _trim(cfg.texts["textUturaGran"]):lower()
  if uturaSpell ~= "" and text == uturaSpell then
    userUturaTimer = now + 60500
  end
end)

local _lastMovePos = nil
local _lastMoveMs = 0

local function isMovingRecently(ms)
  ms = ms or 250
  local p = pos()
  if not p then return false end

  if not _lastMovePos then
    _lastMovePos = {x = p.x, y = p.y, z = p.z}
    return false
  end

  if p.x ~= _lastMovePos.x or p.y ~= _lastMovePos.y or p.z ~= _lastMovePos.z then
    _lastMovePos = {x = p.x, y = p.y, z = p.z}
    _lastMoveMs = now
    return true
  end

  return _lastMoveMs > 0 and now - _lastMoveMs <= ms
end

-- ANTI-LYZE
macro(100, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellAntilyze"] then return end
  if not isParalyzed() then return end

  local spell = _trim(cfg.texts["comboAntilyze"])
  if spell == "" then return end

  say(spell)
end)

-- HASTE
macro(200, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellHaste"] then return end
  if hasHaste() then return end
  if isParalyzed() then return end
  if isInPz() then return end
  if not isMovingRecently(250) then return end

  local spell = _trim(cfg.combos["comboHaste"])
  if spell == "" then return end

  say(spell)
end)

-- BUFF / UTITO / UTAMO TEMPO / ETC
macro(200, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellBuff"] then return end
  if userBuffTimer and userBuffTimer >= now then return end
  if not g_game.isAttacking() then return end

  local spell = _trim(cfg.combos["comboBuff"])
  if spell == "" then return end

  say(spell)
  userBuffTimer = now + 10000
end)

-- UTURA GRAN / REGEN
macro(500, function()
  if not conditionsEnabled() then return end

  local player = g_game.getLocalPlayer()
  if not player then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellUtura"] then return end
  if userUturaTimer and userUturaTimer >= now then return end
  if player:getMana() < 200 then return end

  local spell = _trim(cfg.texts["textUturaGran"])
  if spell == "" then spell = "utura gran" end

  say(spell)
  userUturaTimer = now + 60500
end)

-- CURE STATUS
macro(200, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["cureStatus"] then return end
  if g_game.isAttacking() then return end

  if isPoisioned() then
    say("exana pox")
    return
  end

  if isBurning() then
    say("exana flam")
    return
  end

  if isEnergized() then
    say("exana vis")
    return
  end

  if isCursed() then
    say("exana mort")
    return
  end

  if isBleeding() then
    say("exana kor")
    return
  end
end)

-- AUTO MAGIC SHIELD
macro(200, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellUtamo"] then return end
  if hasManaShield() then return end

  say("utamo vita")
end)

-- AUTO INVISIBLE
macro(200, function()
  if not conditionsEnabled() then return end

  local cfg = getCondCfg()
  if not cfg or not cfg.switches["spellUtana"] then return end
  if mana() < 441 then return end
  if utanaCast > 0 and now - utanaCast < 120000 then return end

  say("utana vid")
  utanaCast = now
end)
