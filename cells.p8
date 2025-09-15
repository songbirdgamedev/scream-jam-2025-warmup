pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--cells

function _init()
	init_player()
	init_enemies()
	win_amount = 500
end

function _update()
	update_player()
	update_enemies()
end

function _draw()
	cls()

	draw_player()
	draw_enemies()

	--score
	print("●=" .. player.eat, 0, 5, 7)

	--win
	if player.eat >= win_amount then
		rectfill(0, 55, 127, 75, 0)
		print("congratulations!!!", 28, 56, 7)
		print("you became", 43, 63, 7)
		print("a multicelled organism", 20, 70, 7)
	end
end

-->8
--player

function init_player()
	player = {
		x = 60,
		y = 60,
		dx = 0,
		dy = 0,
		c = 11,
		r = 2,
		speed = 0.08,
		eat = 0
	}
end

function update_player()
	--controls
	if btn(⬅️) then
		player.dx -= player.speed
	end
	if btn(➡️) then
		player.dx += player.speed
	end
	if btn(⬆️) then
		player.dy -= player.speed
	end
	if btn(⬇️) then
		player.dy += player.speed
	end

	--movement
	player.x += player.dx
	player.y += player.dy

	--flip sides
	if player.x > 127 then
		player.x = 1
	end
	if player.x < 0 then
		player.x = 126
	end
	if player.y > 127 then
		player.y = 1
	end
	if player.y < 0 then
		player.y = 126
	end
end

function draw_player()
	circfill(
		player.x,
		player.y,
		player.r,
		player.c
	)
end

-->8
--enemies

function init_enemies()
	enemies = {}
	max_enemies = 15
	max_enemy_size = 10
	enemy_speed = 0.6
end

function update_enemies()
	if #enemies < max_enemies then
		create_enemies()
	end

	for enemy in all(enemies) do
		--movement
		enemy.x += enemy.dx
		enemy.y += enemy.dy

		--outside screen
		if enemy.x > 137
				or enemy.x < -10
				or enemy.y < -10
				or enemy.y > 137 then
			del(enemies, enemy)
		end

		check_collision(enemy)
	end
end

function create_enemies()
	--local variables
	local x, y, dx, dy, c = 0, 0, 0, 0, 0
	local r = flr(rnd((max_enemy_size + player.r) / 2)) + 1

	--random start position
	place = flr(rnd(4))

	if place < 2 then
		y = flr(rnd(128))
		dy = rnd(enemy_speed * 2) - enemy_speed

		if place == 0 then
			--left
			x = flr(rnd(8) - 16)
			dx = rnd(enemy_speed)
		else
			--right
			x = flr(rnd(8) + 128)
			dx = -rnd(enemy_speed)
		end
	else
		x = flr(rnd(128))
		dx = rnd(enemy_speed * 2) - enemy_speed

		if place == 2 then
			--top
			y = flr(rnd(8) - 16)
			dy = rnd(enemy_speed)
		else
			--bottom
			y = flr(rnd(8) + 128)
			dy = -rnd(enemy_speed)
		end
	end

	--size determines color
	if r == 1 then
		c = 10
	elseif r == 2 then
		c = 6
	elseif r == 3 then
		c = 9
	elseif r == 4 then
		c = 14
	elseif r == 5 then
		c = 2
	elseif r == 6 then
		c = 8
	elseif r == 7 then
		c = 7
	elseif r == 8 then
		c = 12
	elseif r == 9 then
		c = 1
	elseif r == 10 then
		c = 3
	else
		c = 8
	end

	--make enemy table
	local enemy = {
		x = x,
		y = y,
		dx = dx,
		dy = dy,
		r = r,
		c = c
	}

	--add it to enemies table
	add(enemies, enemy)
end

function draw_enemies()
	for enemy in all(enemies) do
		circfill(
			enemy.x,
			enemy.y,
			enemy.r,
			enemy.c
		)
	end
end

-->8
--logic

function check_collision(enemy)
	diff_x = player.x - enemy.x
	diff_y = player.y - enemy.y
	dist_sq = diff_x ^ 2 + diff_y ^ 2
	rsum_sq = (player.r + enemy.r) ^ 2

	if dist_sq < rsum_sq then
		compare_size(enemy)
	end
end

function compare_size(enemy)
	if flr(player.r) > enemy.r then
		player.eat += 1
		player.r += .2
		del(enemies, enemy)
	else
		_init()
	end
end
