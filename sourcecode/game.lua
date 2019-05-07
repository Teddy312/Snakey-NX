-- Game States
GameStates = {pause = 'pause', running = 'running', game_over = 'game over'}
state = GameStates.running

-- Start Position Snake 1
local snakeX = 15
local snakeY = 15
local dirX = 0
local dirY = 0

local SIZE = 20

local foodX = 0
local foodY = 0
local food2X = 0
local food2Y = 0

-- tail Snake1
local tail = {}

-- Snake1 Variables
tail_length = 0
up = false
down = false
left = false
right = false

-- Snake2 Variables
tail2_length = 0
up2 = false
down2 = false
left2 = false
right2 = false

-- Tail Snake2
local tail2 = {}

-- Start Position Snake 2
local snake2X = 25
local snake2Y = 15
local dir2X = 0
local dir2Y = 0


-- Add food at random points within screen size
function add_food()
  math.randomseed(os.time() + 0.001)
  foodX = math.random(SIZE + 42)
  foodY = math.random(SIZE + 14)
end

-- Add second food at random points within screen size
function add_second_food()
  math.randomseed(os.time() + 10)
  food2X = math.random(SIZE + 42)
  food2Y = math.random(SIZE + 14)
end

-- Draw Stuff In-game
function game_draw()
  if currentscreen == 'game' then
    if border_enable == true then
    -- Draw Borders
      love.graphics.setColor(0.2, 0.2, 0.2, 1.0)
      love.graphics.rectangle("fill", 0, 0, 1280, 720)
    
      -- Draw Background
      love.graphics.setColor(0, 0, 0, 1.0)
      love.graphics.rectangle("fill", 20, 20, 1240, 680)
    elseif border_enable == false then
      -- Draw Borders
      love.graphics.setColor(0.0, 0.0, 0.0, 1.0)
      love.graphics.rectangle("fill", 0, 0, 1280, 720)
      
      -- Draw Background
      love.graphics.setColor(0, 0, 0, 1.0)
      love.graphics.rectangle("fill", 20, 20, 1240, 680)
    end
    
    -- Draw Snake1 Head
    love.graphics.setColor(1, 1, 1, 1.0)
    love.graphics.rectangle("fill", snakeX * SIZE, snakeY * SIZE, SIZE, SIZE)
    
    -- Draw Snake1 Tail
    love.graphics.setColor(1, 1, 1, 0.7)
    for _, v in ipairs(tail) do
      love.graphics.rectangle("fill", v[1] * SIZE, v[2] * SIZE, SIZE, SIZE)
    end
    
    if two_player then
      -- Draw Snake2 Head
      love.graphics.setColor(0, 1, 1, 1.0)
      love.graphics.rectangle("fill", snake2X * SIZE, snake2Y * SIZE, SIZE, SIZE)
    
      -- Draw Snake2 Tail
      love.graphics.setColor(0, 1, 1, 0.7)
      for _, v2 in ipairs(tail2) do
        love.graphics.rectangle("fill", v2[1] * SIZE, v2[2] * SIZE, SIZE, SIZE)
      end
    end
  
    -- Draw Food 1
    love.graphics.setColor(0.7, 0.2, 0.2, 1)
    love.graphics.rectangle("fill", foodX * SIZE, foodY * SIZE, SIZE, SIZE)
    
    -- Draw Food 2
    love.graphics.setColor(0.2, 0.7, 0.2, 1)
    love.graphics.rectangle("fill", food2X * SIZE, food2Y * SIZE, SIZE, SIZE)
    
    -- Draw Score Text
    love.graphics.setColor(1, 1, 1, 0.7)
    love.graphics.setFont(nameFont)
    love.graphics.print('Score: '.. tail_length, 25, 23)
    
    if two_player then
      love.graphics.setColor(0, 1, 1, 0.7)
      love.graphics.setFont(nameFont)
      love.graphics.print('Score: '.. tail2_length, 25, 50)
    end
  end
end

-- Update Stuff In-Game
function game_update()
  -- Snake1
  
	-- Update Movement
	if up and dirY == 0 then
		dirX, dirY = 0, -1
	elseif down and dirY == 0 then
		dirX, dirY = 0, 1
	elseif left and dirX == 0 then
		dirX, dirY = -1, 0
	elseif right and dirX == 0 then
		dirX, dirY = 1, 0	
	end
  
  local oldX = snakeX
  local oldY = snakeY
  
  snakeX = snakeX + dirX
	snakeY = snakeY + dirY
  
  -- Spawn new food when snake reaches it
  if snakeX == foodX and snakeY == foodY then
    add_food()
    tail_length = tail_length + 1;
    table.insert(tail, {0, 0})
  elseif snakeX == food2X and snakeY == food2Y then
    add_second_food()
    tail_length = tail_length + 1;
    table.insert(tail, {0, 0})
  end
  
  -- Check Left side Screen for Collision
  if border_enable then
    if snakeX < 1 then
      state = GameStates.game_over
    -- Check Right side Screen for Collision
    elseif snakeX > SIZE + 42 then
      state = GameStates.game_over
    -- Check Up side Screen for Collision
    elseif snakeY < 1 then
      state = GameStates.game_over
    -- Check Down side Screen for Collision
    elseif snakeY > SIZE + 14 then
      state = GameStates.game_over
    end
  else
    if snakeX < 0 then
      snakeX = SIZE + 43
    -- Check Right side Screen for Collision
    elseif snakeX > SIZE + 43 then
      snakeX = 0
    -- Check Up side Screen for Collision
    elseif snakeY < 0 then
      snakeY = SIZE + 15
    -- Check Down side Screen for Collision
    elseif snakeY > SIZE + 15 then
      snakeY = 0
    end
  end
  
  -- Add tail behind snake head
  if tail_length > 0 then
    for _, v in ipairs(tail) do
      local x, y = v[1], v[2]
      v[1], v[2] = oldX, oldY
      oldX, oldY = x, y
    end
  end
  
  -- Checks if snake collides with itself
  for _, v in ipairs(tail) do
    if snakeX == v[1] and snakeY == v[2] then
      state = GameStates.game_over
    end
  end
  for _, b in ipairs(tail2) do 
    if snakeX == b[1] and snakeY == b[2] then
      state = GameStates.game_over
    end
  end
  
  if two_player then
    if snakeX == snake2X and snakeY == snake2Y then
      state = GameStates.game_over
    end
  end
  
  -- Snake2
  if two_player then
    -- Update Movement
    if up2 and dir2Y == 0 then
      dir2X, dir2Y = 0, -1
    elseif down2 and dir2Y == 0 then
      dir2X, dir2Y = 0, 1
    elseif left2 and dir2X == 0 then 
      dir2X, dir2Y = -1, 0
    elseif right2 and dir2X == 0 then
      dir2X, dir2Y = 1, 0	
    end
    
    local old2X = snake2X
    local old2Y = snake2Y
    
    snake2X = snake2X + dir2X
    snake2Y = snake2Y + dir2Y
  
    -- Spawn new food when snake reaches it
    if snake2X == foodX and snake2Y == foodY then
      add_food()
      tail2_length = tail2_length + 1;
      table.insert(tail2, {0, 0})
    elseif snake2X == food2X and snake2Y == food2Y then
      add_second_food()
      tail2_length = tail2_length + 1;
      table.insert(tail2, {0, 0})
    end
  
    -- Check Left side Screen for Collision
    if border_enable then
      if snake2X < 1 then
        player2_dead()
      -- Check Right side Screen for Collision
      elseif snake2X > SIZE + 42 then
        player2_dead()
      -- Check Up side Screen for Collision
      elseif snake2Y < 1 then
        player2_dead()
      -- Check Down side Screen for Collision
      elseif snake2Y > SIZE + 14 then
        player2_dead()
      end
    else
      if snake2X < 0 then
        snake2X = SIZE + 43
      -- Check Right side Screen for Collision
      elseif snake2X > SIZE + 43 then
        snake2X = 0
      -- Check Up side Screen for Collision
      elseif snake2Y < 0 then
        snake2Y = SIZE + 15
      -- Check Down side Screen for Collision
      elseif snake2Y > SIZE + 15 then
        snake2Y = 0
      end
    end
  
    -- Add tail behind snake head
    if tail2_length > 0 then
      for _, b in ipairs(tail2) do
        local x2, y2 = b[1], b[2]
        b[1], b[2] = old2X, old2Y
        old2X, old2Y = x2, y2
      end
    end
  
    -- Checks if snake collids with itself
    for _, v in ipairs(tail) do
      if snake2X == v[1] and snake2Y == v[2] then
        player2_dead()
      end
    end
    for _, b in ipairs(tail2) do 
      if snake2X == b[1] and snake2Y == b[2] then
        player2_dead()
      end
    end
  end
end

-- Resets State of the Game when Restarting
function game_restart() 
  snakeX, snakeY = 15, 15
  dirX, dirY = 0, 0
  tail = {}
  up = false; down = false; left = false; right = false;
  tail_length = 0
  state = GameStates.running
  add_food()
  add_second_food()
  player2_dead()
end

-- Restart Game
function game_end()
  -- Remove Menu Buttons
  table.remove(buttons)
  
  -- Restart Game
  snakeX, snakeY = 15, 15
  dirX, dirY = 0, 0
  tail = {}
  up = false; down = false; left = false; right = false;
  tail_length = 0
  state = GameStates.running
  player2_dead()
  
  -- Stop Soundtrack
  music:stop()
  
  -- Call love.load in main.lua
  love.load()
end

-- When player 2 dies
function player2_dead()
  -- Disable player 2
  two_player = false
  -- Reset position player 2
  snake2X = 25
  snake2Y = 15
  -- Reset directions player 2
  up2 = false; down2 = false; left2 = false; right2 = false;
  dir2X, dir2Y = 0, 0
  -- Reset tail Player 2
  tail2 ={}
  tail2_length = 0
  
end