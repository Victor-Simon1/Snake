-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end


-- VARIABLES

ligne1 = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1} -- 18 
ligne2 = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1} 
ligne3 = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1} 
ligne4 = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}  
ligne5 = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1} 
ligne6 = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1} 
ligne7 = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}  
ligne8 = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}  
ligne9 = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1} 
ligne10 = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1} 
ligne11 = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1} 
ligne12 = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}  
ligne13 = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}  
ligne14 = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1} 
ligne15 = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1} 
ligne16 = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1}  
ligne17 = {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1} 
ligne18 = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1} 

niveau = {ligne1,ligne2,ligne3,ligne4,ligne5,ligne7,ligne8,ligne9,ligne10,ligne11,ligne12,ligne13,ligne14,ligne15,ligne16,ligne17,ligne18}

tile = {}
--tile[0] =  love.graphics.newImage("images/tile_1.png")
tile[1] =  love.graphics.newImage("images/tile1.png")
print(tile[0])
affichage = "game"

sprites = {}
font = love.graphics.newFont("images/blocked.ttf", 45)
love.graphics.setFont(font)
gameover = love.audio.newSource("images/gameover.wav","static")

--METHODES


function createSprite(img,x,y,vx,vy)
  
  local sprite = {}
  
  sprite.x = x
  sprite.y = y
  sprite.vx = vx
  sprite.vy = vy
  sprite.img = love.graphics.newImage("images/"..img..".png")
  sprite.l = sprite.img:getWidth()
  sprite.h = sprite.img:getHeight()
  sprite.supprime = false
  table.insert(sprites, sprite)
  
  return sprite
  
end
  
 snakes = {} 
  
function cree_snake(pimg, px, py, pvx, pvy)
  
  local s = createSprite(pimg, px, py, pvx, pvy)
  
  s.deplacement = false
  
  table.insert(snakes,s)
  return s
 
end 
apple = {}
function createApple(pimg)
  
  local px = love.math.random(1, #ligne1-2)
  local py = love.math.random(1, #niveau-2)
  local s = createSprite(pimg, widthCase*px, heightCase*py)
  
  table.insert(apple,s)
  return s
 
end 
function love.load()

  love.window.setMode(1024,768)
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  
  chrono = 0
  score = 0
  lastTouch = "right"
  
  widthCase = (largeur / #ligne1)
  heightCase = (hauteur / #niveau)
  
  snake = cree_snake("snake",widthCase*3,heightCase*3)
  cree_snake("snake",widthCase*3,heightCase*2)
  createApple("apple")

end
function love.update(dt)
  
  local ligne = math.floor(((snake.y+(snake.h/2))/heightCase)+1)
  local colonne = math.floor(((snake.x+(snake.l/2))/widthCase)+1)
  
  if niveau[ligne][colonne] == 0 then
    --print("It's good")
  else
    --print("It's not good")
    affichage = "game over"
  end

  
  local appleLigne =  math.floor((apple[1].y/heightCase)+1)
  local appleCol =  math.floor((apple[1].x/widthCase)+1)

  if appleLigne == ligne and appleCol == colonne then
    score = score +1
    local s = snakes[#snakes]
    cree_snake("snake", s.x, s.y)
    createApple("apple")
    
    apple[1].supprime = true
    table.remove(apple,1)
  end
  for i = #sprites ,1,-1 do
      if sprites[i].supprime == true then
        table.remove(sprites,i)
      end
  end
  if affichage == "game" then
    chrono = chrono + 1 * dt
      if chrono > 0.5 then
        for i=#snakes, 3, -1 do
          snakes[i].x = snakes[i-1].x 
          snakes[i].y = snakes[i-1].y 
        end

        if lastTouch == "right" then
          snake.x = snake.x + widthCase 
        elseif lastTouch == "left" then
          snake.x = snake.x - widthCase 
        elseif lastTouch == "up" then
          snake.y = snake.y - heightCase 
        elseif lastTouch == "down" then
          snake.y = snake.y + heightCase 
        end
        for i=#snakes , 2, -1 do
          local ligne = math.floor(((snake.y+(snake.h/2))/heightCase)+1)
          local colonne = math.floor(((snake.x+(snake.l/2))/widthCase)+1)
          local colSnakeI = math.floor(((snakes[i].x + (snakes[i].l / 2) ) / widthCase) +1)
          local ligneSnakeI = math.floor(((snakes[i].y + (snakes[i].h  / 2)) / heightCase) +1)
          if ligne == ligneSnakeI and colonne == colSnakeI then
            affichage = "game over"
          end
        end
        chrono = 0
        snakes[2].x = (colonne-1) * widthCase
        snakes[2].y = (ligne-1 )* heightCase
      end
    end 
    
end

function love.draw()
  
  for ligne = 1,#niveau do
    for colonne = 1,#ligne1 do
      xRect = widthCase * (colonne - 1)
      yRect = heightCase * (ligne - 1)
      id = niveau[ligne][colonne]
      if id == 0 then
        love.graphics.setColor(255, 0, 0) -- rgb
        love.graphics.rectangle("line",xRect,yRect,largeur / #ligne1,hauteur / #niveau, 0,50 ,50) -- plein ou pas,x,y,lar,haut
        love.graphics.setColor(255, 255, 255)
      else
        love.graphics.draw(tile[id],xRect,yRect,0,widthCase / tile[id]:getWidth(),heightCase / tile[id]:getHeight())
      end
    end  
  end
  
  for i= #sprites,1,-1 do
    local s = sprites[i]
    love.graphics.draw(s.img, s.x, s.y,0,widthCase / s.img:getWidth(),heightCase / s.img:getHeight())
  end
  love.graphics.print({{255,0,0}, "SCORE "..score}, largeur / 4,0, 0)
  love.graphics.print({{255,0,0}, "FPS "..love.timer.getFPS()}, 0,0, 0)
  if affichage == "game over" then
    love.graphics.print({{255,0,0}, "PERDU"}, largeur / 4, hauteur / 3, 0, 2, 2)
  end
  
end

function love.keypressed(key)
  if affichage == "game" then
    
    if key == "escape" then
      love.event.quit()  
    end

    if key == "left" then
     lastTouch = "left"
    end
  
    if key == "right"  then
      lastTouch = "right"
    end
  
    if key == "up" then
      lastTouch = "up"
    end
  
    if key == "down" then
      lastTouch = "down"
    end
  end
  
end
