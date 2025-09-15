pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--cells

function _init()
	player = {
		x = 60,
		y = 60,
		c = 11, --inside color
		c2 = 3, --outside color
		r = 2,
		dx = 0,
		dy = 0,
		speed = 0.08,
		eat = 0
	}

	--game settings
	enemies = {}
	max_enemies = 15
	max_enemy_size = 10
	enemy_speed = 0.6
	win_amount = 500
end

function _update()
	--player controls
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

	--player movement
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

	--enemy update
	create_enemies()

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

		--collide with player
	end
end

function _draw()
	cls()

	--player
	circfill(player.x, player.y, player.r, player.c)
	circ(player.x, player.y, player.r + 1, player.c2)

	--enemies
	for enemy in all(enemies) do
		circfill(enemy.x, enemy.y, enemy.r, enemy.c)
		circ(enemy.x, enemy.y, enemy.r + 1, enemy.c2)
	end
end

-->8
--enemies

function create_enemies()
	if #enemies < max_enemies then
		--local variables
		local x, y = 0, 0
		local dx, dy = 0, 0
		local r = flr(rnd((max_enemy_size + player.r) / 2)) + 1
		local c, c2 = 0, 0

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
			c, c2 = 10, 9
		elseif r == 2 then
			c, c2 = 6, 7
		elseif r == 3 then
			c, c2 = 9, 4
		elseif r == 4 then
			c, c2 = 14, 4
		elseif r == 5 then
			c, c2 = 2, 1
		elseif r == 6 then
			c, c2 = 8, 2
		elseif r == 7 then
			c, c2 = 7, 6
		elseif r == 8 then
			c, c2 = 12, 1
		elseif r == 9 then
			c, c2 = 1, 12
		elseif r == 10 then
			c, c2 = 3, 11
		else
			c, c2 = 8, 12
		end

		--make enemy table
		local enemy = {
			x = x,
			y = y,
			dx = dx,
			dy = dy,
			r = r,
			c = c,
			c2 = c2
		}

		--add it to enemies table
		add(enemies, enemy)
	end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
