local prevCell = nil
local viewRangeIncrementSteps = 10
local game = tes3.getGame()

local defaultConfig = {
    viewRangeIncrementSteps = 10,
}

local configPath = "FoggyOldEbonheart"

local config = mwse.loadConfig(configPath, defaultConfig)

local function isOldEbonheart(cell)
    return cell.displayName == "Old Ebonheart" or cell.displayName == "Old Ebonheart, Docks"
end

local function increaseViewRange()
    for i=1, viewRangeIncrementSteps do
        mge.macros.increaseViewRange()
    end
end

local function decreaseViewRange()
    for i=1, viewRangeIncrementSteps do
        mge.macros.decreaseViewRange()
    end
end

local function onGameLoaded(e)
    prevCell = tes3.player.cell
    mwse.log("[FOE] viewRangeIncrementSteps: %s", config.viewRangeIncrementSteps)
    if isOldEbonheart(tes3.player.cell) then
        decreaseViewRange()
    end
end

local function onCellChanged(e)
    local prevRenderDistance = game.renderDistance
    if(isOldEbonheart(e.cell) and (not prevCell or not isOldEbonheart(prevCell))) then
        decreaseViewRange()
        mwse.log("[FOE] Entering Old Ebonheart, decreasing render distance from %s to %s", prevRenderDistance, game.renderDistance)
    elseif(prevCell and isOldEbonheart(prevCell)) then
        increaseViewRange()
        mwse.log("[FOE] Leaving Old Ebonheart, increasing render distance from %s to %s", prevRenderDistance, game.renderDistance)
    end
    prevCell = e.cell
end

event.register(tes3.event.cellChanged, onCellChanged)
event.register(tes3.event.loaded, onGameLoaded)