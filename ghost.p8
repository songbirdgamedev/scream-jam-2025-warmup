pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--ghost game

function _init()
	init_player()
	init_lights()
end

function _update()
	update_player()
	update_lights()
end

function _draw()
	cls()
	draw_lights()
	draw_player()
end

-->8
--player

function init_player()
	player = {
		x = 60,
		y = 60,
		r = 4,
		sprite = 1,
		size = 1,
		flip = false
	}
end

function update_player()
	--movement
	if btn(⬅️) then
		player.x -= 1
		player.flip = false
	end
	if btn(➡️) then
		player.x += 1
		player.flip = true
	end
	if btn(⬆️) then
		player.y -= 1
	end
	if btn(⬇️) then
		player.y += 1
	end

	--check boundary
	if player.x < 0 then
		player.x = 0
	elseif player.x > 120 then
		player.x = 120
	elseif player.y < 0 then
		player.y = 0
	elseif player.y > 120 then
		player.y = 120
	end
end

function draw_player()
	spr(
		player.sprite,
		player.x,
		player.y,
		player.size,
		player.size,
		player.flip
	)
end

-->8
--lights

function init_lights()
	lights = {}
	max_lights = 10
	max_size = 8
	color = 10
	speed = 0.6
end

function create_light()
	local x, y, dx, dy = 0, 0, 0, 0
	local spawn = flr(rnd(4))

	if spawn < 2 then
		y = flr(rnd(128))
		dy = rnd(speed * 2) - speed

		if spawn == 0 then
			--left
			x, dx = -8, rnd(speed)
		else
			--right
			x, dx = 135, -rnd(speed)
		end
	else
		x = flr(rnd(128))
		dx = rnd(speed * 2) - speed

		if spawn == 2 then
			--top
			y, dy = -8, rnd(speed)
		else
			--bottom
			y, dy = 135, -rnd(speed)
		end
	end

	local light = {
		x = x,
		y = y,
		dx = dx,
		dy = dy,
		r = ceil(rnd(max_size))
	}

	add(lights, light)
end

function update_lights()
	if #lights < max_lights then
		create_light()
	end

	for light in all(lights) do
		--movement
		light.x += light.dx
		light.y += light.dy

		--outside screen
		if light.x < -8
				or light.x > 135
				or light.y < -8
				or light.y > 135 then
			del(lights, light)
		end

		check_collision(light)
	end
end

function draw_lights()
	for light in all(lights) do
		circfill(
			light.x,
			light.y,
			light.r,
			color
		)
	end
end

-->8
--collision

function check_collision(light)
	local x = player.x + player.r
	local y = player.y + player.r
	diff_x = (x - light.x) ^ 2
	diff_y = (y - light.y) ^ 2
	dist_sq = diff_x + diff_y

	if dist_sq < light.r ^ 2 then
		_init()
	end
end

__gfx__
00000000007777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700078778700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000077777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700077777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
