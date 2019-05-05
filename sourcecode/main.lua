require('game')

function love.load()
  interval = 2 -- Sets the speed of the snake
  add_food() -- Puts a piece of food on the screen
  
  -- Load Game Soundtrack
  music = love.audio.newSource('soundtrack.mp3', 'static') -- Load sound track
  music:setLooping(true) -- Keep the music looped
  music:play() -- Play music
end

-- Draw the Game
function love.draw()
	game_draw()
  
  -- Draw GameOver Text
  if state == GameStates.game_over then
    love.graphics.print("Game Over!", 500, 300, 0, 4, 4)
    love.graphics.print("Press A or B to restart", 430, 400, 0, 3, 3)
    
    love.graphics.print("Music by Eric Matyas - www.soundimage.org", 10, 700, 0, 1, 1)
  end
  
  -- Draw Pause Text
  if state == GameStates.pause then
    love.graphics.print("Pause", 550, 300, 0, 4, 4)
    love.graphics.print("Press A to continue", 450, 400, 0, 3, 3)
  end
end

-- Update the Game
function love.update()
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
  elseif button == 'a' and state then
    if state == GameStates.running then
      state = GameStates.pause
    elseif state == GameStates.game_over then
      game_restart()
    else
      state = GameStates.running
    end
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
      state = GameStates.pause
    elseif state == GameStates.game_over then
      game_restart()
    else
      state = GameStates.running
    end
  end
end