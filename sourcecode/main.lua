require('game')

BUTTON_HEIGHT = 64

local
function newButton(text, fn)
    return 
    {
      text = text,
      fn = fn,
      
      now = false,
      last = false
    }
end

buttons = {}
local fs = 2

font = nil
titleFont = nil
nameFont = nil
creditFont = nil

function love.load()
  currentscreen = 'menu'
  
    interval = 2 -- Sets the speed of the snake
  -- Load Game Soundtrack
    music = love.audio.newSource('soundtrack.mp3', 'static') -- Load sound track
    music:setLooping(true) -- Keep the music looped
    music:play() -- Play music
  
  if currentscreen == 'menu' then
    -- Load Menu
    menuLoad()
    -- Load Fonts
    font = love.graphics.newFont("Roboto-Light.ttf", 16 * fs)
    titleFont = love.graphics.newFont("Roboto-Light.ttf", 32 * fs)
    nameFont = love.graphics.newFont("Roboto-Light.ttf", 9 * fs)
    creditFont = love.graphics.newFont("Roboto-Light.ttf", 6 * fs)
  elseif currentscreen == 'game' then
    -- Do Nothing
  end
end

function game()
  add_food() -- Puts a piece of food on the screen
  add_second_food() -- Puts another piece of food on the screen
end

-- Draw the Game
function love.draw()
	game_draw()
  
  if currentscreen == 'menu' then
    menuDraw()
  elseif currentscreen == 'game' then
    gameDraw()
  end
end

-- Update the Game
function love.update(dt)
  if currentscreen == 'menu' then
    
  elseif currentscreen == 'game' then
    gameUpdate(dt)
  end
end

function menuLoad()
  -- menu
  table.insert(buttons, newButton('Press A To Start'))
end

function gameDraw()
  -- Draw GameOver Text
  if state == GameStates.game_over then
    love.graphics.setFont(font)
    love.graphics.print('Game Over!', 520,325)
    love.graphics.setFont(nameFont)
    love.graphics.print('Press B to restart', 540, 375)
    love.graphics.print('Press + to quit to menu', 515, 400)
  end
    
  -- Draw Pause Text
  if state == GameStates.pause then
    love.graphics.setFont(font)
    love.graphics.print('Game Paused', 520, 325)
    love.graphics.setFont(nameFont)
    love.graphics.print('Press A to continue', 540, 375)
  end
end

function menuDraw()
  -- Draw Main Menu
  local ww = love.graphics.getWidth()
  local wh = love.graphics.getHeight()
  
  local button_width = ww * (1/3)
  local margin = 25
  
  local total_height = (BUTTON_HEIGHT + margin) * #buttons
  local cursor_y = 0
  
  -- Draw Title
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setFont(titleFont)
  love.graphics.print('Snakey NX', 465, 100)
  love.graphics.setFont(nameFont)
  love.graphics.print('By Teddy312', 580, 200)
  
  love.graphics.setFont(creditFont)
  love.graphics.print('Credits: Music by Eric Matyas - www.soundimage.org', 1, 705)
  
  -- Draw Buttons and Text
  for i, button in ipairs (buttons) do
    button.last = button.now
    
    local bx = (ww * 0.5) - (button_width * 0.5)
    local by = (wh * 0.5) - (BUTTON_HEIGHT * 0.5) + cursor_y
    
    local color = {1, 1, 1, 1.0}
    
    
    -- Draw Buttons
    love.graphics.setColor(unpack(color))
    love.graphics.rectangle("fill", bx, by, button_width, BUTTON_HEIGHT)
    
    -- Draw Button Text
    local textW = font:getWidth(button.text)
    local textH = font:getHeight(button.text)
    love.graphics.setColor(0, 0, 0, 1.0)
    love.graphics.setFont(font)
    love.graphics.print( button.text, (ww * 0.5 ) - textW * 0.5, by + textH * 0.5)
    
    cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
  end
end

function gameUpdate(dt)
  if state == GameStates.running then
    interval = interval - 1
    if interval < 0 then
      game_update()
      interval = 2
    end
  end
end

-- Control functions for Nintendo Switch
function love.gamepadpressed(joystick, button)
  if button == 'dpleft' and state == GameStates.running then
    left = true; right = false; up = false; down = false;
  elseif button == 'dpright' and state == GameStates.running then
    left = false; right = true; up = false; down = false;
  elseif button == 'dpup' and state == GameStates.running then
    left = false; right = false; up = true; down = false;
  elseif button == 'dpdown' and state == GameStates.running then
    left = false; right = false; up = false; down = true;
  elseif button == 'b' and state == GameStates.game_over then
    game_restart()
  elseif button == 'a' then
    if state == GameStates.running then
      -- Pause Game
      state = GameStates.pause
    elseif state == GameStates.game_over then
      -- Do nothing
    elseif state == GameStates.pause then
      -- Unpause Game
      state = GameStates.running
    end
  elseif button == 'plus' and state == GameStates.game_over then
    game_end()
  end
  
  if button == 'a' and currentscreen == 'menu' then
    currentscreen = 'game'
    state = GameStates.running
    game()
  end
end

-- Control functions for PC for testing purposes
function love.keypressed(key)
  if key == 'left' and state == GameStates.running then
    left = true; right = false; up = false; down = false;
  elseif key == 'right' and state == GameStates.running then
    left = false; right = true; up = false; down = false;
  elseif key == 'up' and state == GameStates.running then
    left = false; right = false; up = true; down = false;
  elseif key == 'down' and state == GameStates.running then
    left = false; right = false; up = false; down = true;
  elseif key == 'r' and state == GameStates.game_over then
    game_restart()
  elseif key == 'p' then
    if state == GameStates.running then
      -- Pause Game
      state = GameStates.pause
    elseif state == GameStates.game_over then
      -- Do nothing
    elseif state == GameStates.pause then
      -- Unpause Game
      state = GameStates.running
    end
  elseif key == 'backspace' and state == GameStates.game_over then
    game_end()
  end
  
  if key == 'return' and currentscreen == 'menu' then
    currentscreen = 'game'
    state = GameStates.running
    game()
  elseif key == 'escape' and currentscreen == 'menu' then
    love.event.quit(0)
  end
end