-- Game States
GameStates = {pause = 'pause', running = 'running', game_over = 'game over'}
state = GameStates.running

-- Start Position Snake
local snakeX = 15
local snakeY = 15
local dirX = 0
local dirY = 0

local SIZE = 20

local foodX = 0
local foodY = 0
local food2X = 0
local food2Y = 0

local tail = {}

tail_length = 0
up = false
down = false
left = false
right = false

-- Add food at random points within screen size
function add_food()
  math.randomseed(os.time() + 1.5)
  foodX = math.random(SIZE + 42)
  foodY = math.random(SIZE + 14)
end

-- Add second food at random points within screen size
function add_second_food()
  math.randomseed(os.time() + 2)
  food2X = math.random(SIZE + 42)
  food2Y = math.random(SIZE + 14)
end

-- Draw Stuff In-game
function game_draw()
  if currentscreen == 'game' then
  -- Draw Background
    love.graphics.setColor(0.2, 0.2, 0.2, 1.0)
    love.graphics.rectangle("fill", 0, 0, 1280, 720)
    
    -- Draw Borders
    love.graphics.setColor(0, 0, 0, 1.0)
    love.graphics.rectangle("fill", 20, 20, 1240, 680)
    
    -- Draw Snake Head
    love.graphics.setColor(1, 1, 1, 1.0)
    love.graphics.rectangle("fill", snakeX * SIZE, snakeY * SIZE, SIZE, SIZE)
    
    -- Draw Snake Tail
    love.graphics.setColor(1, 1, 1, 0.7)
    for _, v in ipairs(tail) do
      love.graphics.rectangle("fill", v[1] * SIZE, v[2] * SIZE, SIZE, SIZE)
    end
  
    -- Draw food
    love.graphics.setColor(0.7, 0.35, 0.4, 1.0)
    love.graphics.rectangle("fill", foodX * SIZE, foodY * SIZE, SIZE, SIZE)
    
    -- Draw food2
    love.graphics.setColor(0.5, 0.7, 0.2, 1.0)
    love.graphics.rectangle("fill", food2X * SIZE, food2Y * SIZE, SIZE, SIZE)
    
    -- Draw Score Text
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(nameFont)
    love.graphics.print('Score: '.. tail_length, 25, 23)
  end
end

-- Update Stuff In-Game
function game_update()
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
  end
  
  if snakeX == food2X and snakeY == food2Y then
    add_second_food()
    tail_length = tail_length + 1;
    table.insert(tail, {0, 0})
  end
  
  -- Check Left side Screen for Collision
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
  
  -- Add tail behind snake head
  if tail_length > 0 then
    for _, v in ipairs(tail) do
      local x, y = v[1], v[2]
      v[1], v[2] = oldX, oldY
      oldX, oldY = x, y
    end
  end
  
  -- Checks if snake collids with itself
  for _, v in ipairs(tail) do 
    if snakeX == v[1] and snakeY == v[2] then
      state = GameStates.game_over
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
end

-- Restart Game
function game_end()
  -- Remove Menu Buttons
  table.remove(buttons)
  
  -- Restart Game
  snakeX, snakeY = 15, 15
  dirX, dirY = 0, 0
  up = false; down = false; left = false; right = false;
  tail_length = 0
  state = GameStates.running
  
  -- Stop Soundtrack
  music:stop()
  
  -- Call love.load in main.lua
  love.load()
end