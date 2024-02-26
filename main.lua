function love.load()
    wf= require 'libraries/windfield'
    world = wf.newWorld(0, 0)

    camera = require 'libraries/camera'
    cam = camera()

    anim8 = require 'libraries/anim8'
    love.graphics.setDefaultFilter("nearest", "nearest") -- esto es para que enfoque la imagen del personaje de manera clara 

    sti = require 'libraries/sti'
    gameMap =sti ('maps/testMap.lua') --esto es para el mapa

    --aqui estan las cosas del jugador
    player= {}
    player.collider = world:newBSGRectangleCollider(150, 150, 40, 60, 10)
    player.collider:setFixedRotation(true)
    player.x= 150
    player.y= 110
    player.velocidad = 250
    player.movimiento = love.graphics.newImage('sprites/player.png')
    player.grid = anim8.newGrid(12, 18, player.movimiento:getWidth(), player.movimiento:getHeight())
    
    -- con esto definimos como se veran los moviementos del jugar
    player.animacion = {}
    player.animacion.down = anim8.newAnimation(player.grid('1-4', 1), 0.2)
    player.animacion.left = anim8.newAnimation(player.grid('1-4', 2), 0.2)
    player.animacion.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
    player.animacion.up = anim8.newAnimation(player.grid('1-4', 4), 0.2)

    player.anim = player.animacion.down  --con esto definimos hacia donde vera el personaje al comenzar el juego

    fondo= love.graphics.newImage('sprites/background.png')

    walls = {}
    if gameMap.layers["walls"] then
        for i, obj in pairs(gameMap.layers["walls"].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(walls, wall)
        end
    end
    music = {}
    music.blip = love.audio.newSource("music/blip.wav", "static")
    music.music = love.audio.newSource("music/music.mp3", "stream")

    music.music:play()
end

function love.update(dt)
     local isMoving = false --con esto determinamos que los mobvimeintos del jugador solo se vean cunado precionamios una tacha
   
    local vx = 0
    local vy = 0

     --aqui determinamos que los controles sean las flechas del teclado
    if love.keyboard.isDown("right") then
        vx = player.velocidad
        player.anim = player.animacion.right
        isMoving = true
    end
    if love.keyboard.isDown("left") then
        vx = player.velocidad * -1
        player.anim = player.animacion.left
        isMoving = true
    end
    if love.keyboard.isDown("down") then
        vy = player.velocidad
        player.anim = player.animacion.down
        isMoving = true
    end
    if love.keyboard.isDown("up") then
        vy = player.velocidad * -1
        player.anim = player.animacion.up
        isMoving = true
    end

    player.collider:setLinearVelocity(vx, vy)

    if isMoving == false then
        player.anim:gotoFrame(2)
    end

    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()

    player.anim:update(dt)

    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    if cam.x < w/2 then
        cam.x = w/2
    end

    if cam.y < h/2 then
        cam.y = h/2
    end

    --con esta defino que la camara no se vea mas alla de los bordes del mapa
    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    if cam.x > (mapW - w/2)  then
        cam.x = (mapW - w/2)
    end

    if cam.y > (mapH - h/2) then
        cam.y = (mapH - h/2)
    end
    local objetivoX = 3000--
    local objetivoY = 3000


end

function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["tierra"])
        gameMap:drawLayer(gameMap.layers["obj"])
        player.anim:draw(player.movimiento, player.x, player.y, nil, 4, nil, 4, 8)
      --  world:draw()
    cam:detach()
    love.graphics.print("hola",10,10)
end