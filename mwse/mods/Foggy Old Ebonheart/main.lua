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
        local prevRenderDistance = game.renderDistance
        decreaseViewRange()
        mwse.log("[FOE] player is Old Ebonheart, decreased render distance from %s to %s", prevRenderDistance, game.renderDistance)
    end
end

local function onCellChanged(e)
    local prevRenderDistance = game.renderDistance
    if(isOldEbonheart(e.cell) and (not isOldEbonheart(prevCell))) then -- Current cell is Old Ebonheart, previous cell is not
        decreaseViewRange()
        mwse.log("[FOE] Entering Old Ebonheart, decreased render distance from %s to %s", prevRenderDistance, game.renderDistance)
    elseif((not isOldEbonheart(e.cell)) and isOldEbonheart(prevCell)) then -- Current cell is not Old Ebonheart, previous cell is
        increaseViewRange()
        mwse.log("[FOE] Leaving Old Ebonheart, increased render distance from %s to %s", prevRenderDistance, game.renderDistance)
    end
    prevCell = e.cell
end

event.register(tes3.event.cellChanged, onCellChanged)
event.register(tes3.event.loaded, onGameLoaded)