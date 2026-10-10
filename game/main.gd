extends Node2D

const W = 1280.0
const H = 720.0
const SEA_TOP = 108.0
const SEA_BOTTOM = 583.0
const INK = Color("071b29")
const WHITE = Color("e6f5f2")
const MUTED = Color("577c80")
const MINT = Color("248c7d")
const GOLD = Color("d9a33f")
const CORAL = Color("ff837f")
const STAGES = [
	{"name":"珊瑚浅湾","boss":"红鳍鲨","note":"躲开冲刺，吃掉它身后的鱼群。","hp":60.0,"min_size":24.0,"pursuit":132.0,"size":48.0,"limit":31.0,"color":CORAL,"attacks":["charge"],"top":Color("d8f5ed"),"bottom":Color("a9d5d8")},
	{"name":"断礁水道","boss":"双尾猎手","note":"连续冲刺后会布置陷阱，留好移动空间。","hp":125.0,"min_size":29.0,"pursuit":149.0,"size":60.0,"limit":41.0,"color":Color("edac65"),"attacks":["double","fan","mines"],"top":Color("e3f4e8"),"bottom":Color("afd3ce")},
	{"name":"电流海沟","boss":"电鳗","note":"三轮电弹会扫过不同方向，及时换位。","hp":175.0,"min_size":34.0,"pursuit":160.0,"size":69.0,"limit":41.0,"color":Color("a897f2"),"attacks":["fan","charge","sweep","fan_burst"],"top":Color("e6f0fa"),"bottom":Color("b2cddd")},
	{"name":"针刺礁","boss":"刺球鱼","note":"两轮交错针刺之间留有空隙，别停在陷阱上。","hp":240.0,"min_size":40.0,"pursuit":160.0,"size":80.0,"limit":49.0,"color":Color("ce9ace"),"attacks":["radial","mines","radial_burst","charge"],"top":Color("f1ebf6"),"bottom":Color("c2cbdd")},
	{"name":"沉船暗流","boss":"灯笼鱼","note":"吸水后接扫射，留好冲刺和护泡。","hp":330.0,"min_size":46.0,"pursuit":168.0,"size":92.0,"limit":59.0,"color":Color("82c5cc"),"attacks":["suction","mines","double","sweep"],"top":Color("ddf2ed"),"bottom":Color("a4cecd")},
	{"name":"风暴海眼","boss":"风暴巨口","note":"旋转针刺、扫射和连冲交替出现。","hp":450.0,"min_size":53.0,"pursuit":180.0,"size":105.0,"limit":67.0,"color":Color("dd7f9c"),"attacks":["double","radial_burst","suction","sweep","mines","spiral"],"top":Color("e4eff8"),"bottom":Color("aecbdc")}
]
const EVOLUTIONS = [
	{"id":"shell","name":"珍珠护甲","category":"防御","desc":"每关开始的护盾增加一层。\n护盾最多保留三层。","color":Color("b4d9ee")},
	{"id":"food","name":"高效消化","category":"成长","desc":"吞噬获得的成长值增加 12%，最多增加 60%。\n可以重复选择。","color":MINT},
	{"id":"legacy","name":"深海血脉","category":"成长","desc":"以后每吃掉一条关底大鱼，\n本局移动速度增加 12%。","color":Color("c2adf1")},
	{"id":"dash","name":"潮汐冲刺","category":"冲刺","desc":"空格冲刺的冷却缩短 20%。\n最低冷却为 1.4 秒。","color":Color("80d8e5")},
	{"id":"combo","name":"猎食节奏","category":"连吃","desc":"连续吃 5 条鱼后加速 4 秒。\n继续吃鱼可以刷新加速。","color":GOLD},
	{"id":"swiftfood","name":"乘流进食","category":"连吃","desc":"冲刺或猎食加速期间，\n吞噬获得的成长值增加 25%。","color":Color("a9c5ff")},
	{"id":"heal","name":"海葵共生","category":"恢复","desc":"立即恢复 1 点生命。\n以后每吃 15 条鱼恢复 1 点。","color":CORAL},
	{"id":"speed","name":"流线鳍","category":"移动","desc":"移动速度增加 12%。\n可以重复选择。","color":Color("8fd6cd")},
	{"id":"carry","name":"丰饶储备","category":"成长","desc":"以后每关初始体型增加 2（最多增加 8）。\n每关仍然需要吃鱼成长。","color":Color("e4d69e")},
	{"id":"whirl","name":"宽口旋涡","category":"旋涡强化","desc":"旋涡范围增加 24（最多 185）。\n持续时间增加 0.25 秒（最多 2 秒）。","color":Color("79d8cf")},
	{"id":"whirl_cd","name":"回流","category":"旋涡强化","desc":"旋涡冷却缩短 25%。\n最低冷却为 5 秒。","color":Color("7cbde3")},
	{"id":"sonar","name":"强声波","category":"声波强化","desc":"声波伤害增加 5（最多 50），范围扩大。\n命中的敌人减速 1.8 秒。","color":Color("b0c9f0")},
	{"id":"sonar_cd","name":"短鸣","category":"声波强化","desc":"声波冷却缩短 25%。\n最低冷却为 5 秒。","color":Color("bfb3e8")},
	{"id":"bubble","name":"厚护泡","category":"护泡强化","desc":"护泡持续时间增加 0.4 秒（最多 2.8 秒）。\n冷却时间缩短 2 秒。","color":Color("9ddded")},
	{"id":"bubble_heal","name":"泡沫恢复","category":"护泡强化","desc":"每次开启护泡恢复 1 点生命。\n护泡需要冷却后才能再次开启。","color":Color("e8adad")},
	{"id":"time","name":"多留一会","category":"时间","desc":"以后每关的限时增加 8 秒（最多增加 24 秒）。\n可以重复选择。","color":Color("e1d498")},
	{"id":"glutton","name":"贪食","category":"风险","desc":"吞噬获得的成长值增加 22%，最多增加 60%。\n生命上限减少 1 点。","color":Color("f3a07e")},
	{"id":"echo","name":"余波","category":"连吃","desc":"每吃 10 条鱼，自动发出声波。\n清除附近电弹并推开敌人。","color":Color("9bbfee")},
	{"id":"growthshield","name":"鳞片再生","category":"防御","desc":"每吃 18 条鱼获得一层护盾。\n最多保留三层。","color":Color("b7d4b8")},
	{"id":"harvest","name":"收口","category":"声波强化","desc":"使用声波时，直接吞噬\n身边 95 范围内能吃的鱼。","color":Color("e6ca91")}
]

const SKILLS = [
	{"id":"whirl","name":"旋涡","desc":"吸入附近能吃的鱼。\n加快成长，但不能伤害 Boss。","color":Color("8cdbc4")},
	{"id":"sonar","name":"冲击声波","desc":"伤害 Boss，使它变小。\n击退敌人，清除飞弹和陷阱。","color":Color("aec6f1")},
	{"id":"bubble","name":"护泡","desc":"短时间免伤，抵抗吸力。\n适合穿过危险区域。","color":Color("aadbea")},
	{"id":"bite","name":"撕咬","desc":"向面前咬击，造成 34 点伤害。\n需要靠近 Boss，冷却 7 秒。","color":Color("e8b09b")},
	{"id":"ink","name":"墨幕","desc":"留下减速区域，挡住飞弹。\n持续 3.2 秒，冷却 12 秒。","color":Color("b5a8d7")}
]

var equipped_skills: Array[String] = []
var skill_offers: Array[String] = []
var pending_skill = ""
var paused_from = "playing"
var dash_hit_done = false
var dash_damage = 26.0
var sonar_damage = 28.0
var bite_cooldown = 0.0
var bite_flash = 0.0
var ink_cooldown = 0.0
var ink_remaining = 0.0
var ink_center = Vector2.ZERO
var ink_radius = 165.0
var hunt_phase = "warn"
var hunt_timer = 0.0
var hunt_elapsed = 0.0
var last_damage_source = ""
var stats: Dictionary = {"dash_casts":0,"skill_casts":0,"boss_damage":0.0,"damage_taken":0}

var rng = RandomNumberGenerator.new()
var sim_control_rng = RandomNumberGenerator.new()
var fx_rng = RandomNumberGenerator.new()
var font: SystemFont
var state = "title"
var clock_time = 0.0
var stage = 1
var round_time = 0.0
var total_time = 0.0
var time_bonus = 0.0
var round_bonus = 0.0
var failure_reason = ""
var position_player = Vector2(320,350)
var facing = Vector2.RIGHT
var last_move = Vector2.RIGHT
var pointer_outside = false
var mouse_control = true
var mouse_known = false
var radius_player = 21.0
var max_health = 4
var health = 4
var shield = 0
var invulnerable = 0.0
var dash_cooldown = 0.0
var dash_remaining = 0.0
var dash_direction = Vector2.RIGHT
var food_factor = 1.0
var speed_factor = 1.0
var legacy_levels = 0
var shell_levels = 0
var dash_factor = 1.0
var carry_size = 0.0
var has_combo = false
var has_swiftfood = false
var has_heal = false
var has_bubble_heal = false
var has_echo = false
var has_growthshield = false
var has_harvest = false
var has_glutton = false
var whirl_radius = 125.0
var whirl_duration = 1.8
var whirl_cd_max = 11.0
var whirl_cooldown = 0.0
var whirl_remaining = 0.0
var sonar_radius = 255.0
var sonar_push = 145.0
var sonar_slow = 1.3
var sonar_cd_max = 12.0
var sonar_cooldown = 0.0
var sonar_ring = 0.0
var bubble_duration = 1.6
var bubble_cd_max = 16.0
var bubble_cooldown = 0.0
var bubble_remaining = 0.0
var combo = 0
var combo_timer = 0.0
var boost_remaining = 0.0
var heal_count = 0
var echo_count = 0
var scale_count = 0
var eaten_count = 0
var total_eaten = 0
var score = 0
var muted = false
var entities: Array[Dictionary] = []
var boss: Dictionary = {}
var shots: Array[Dictionary] = []
var volleys: Array[Dictionary] = []
var skill_flashes: Dictionary = {}
var skill_block_flashes: Dictionary = {}
var last_cooldowns: Dictionary = {}
var mines: Array[Dictionary] = []
var particles: Array[Dictionary] = []
var trails: Array[Dictionary] = []
var buttons: Array[Dictionary] = []
var upgrades: Array[Dictionary] = []
var offers: Array[Dictionary] = []
var bubbles: Array[Dictionary] = []
var reefs: Array[Dictionary] = []
var supply_timer = 0.0
var message = ""
var message_remaining = 0.0
var message_color = MINT
var camera_shake = 0.0
var sound_players: Array[AudioStreamPlayer] = []
var sounds: Dictionary = {}
var sim_stage_records: Array[Dictionary] = []
var capture_mode = ""
var capture_frame = 0

func _ready() -> void:
	font = SystemFont.new()
	font.font_names = PackedStringArray(["Microsoft YaHei", "Noto Sans CJK SC", "Arial"])
	font.antialiasing = TextServer.FONT_ANTIALIASING_GRAY
	rng.seed = 872134
	for i in range(48):
		bubbles.append({"pos":Vector2(rng.randf_range(0,W),rng.randf_range(80,H)),"size":rng.randf_range(1,4),"speed":rng.randf_range(9,28),"phase":rng.randf()*TAU})
	for i in range(22):
		reefs.append({"x":rng.randf_range(0,W),"height":rng.randf_range(20,70),"phase":rng.randf()*TAU,"kind":i%3})
	get_window().mouse_exited.connect(func(): pointer_outside = true)
	get_window().mouse_entered.connect(func(): pointer_outside = false)
	_init_audio()
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--capture="): capture_mode = arg.substr(10)
	if "--self-test" in OS.get_cmdline_user_args(): _run_self_tests.call_deferred()
	if "--visual-test" in OS.get_cmdline_user_args(): _run_visual_tests.call_deferred()
	if "--balance-test" in OS.get_cmdline_user_args(): _run_balance_rules_tests.call_deferred()
	if "--input-test" in OS.get_cmdline_user_args(): _run_input_tests.call_deferred()
	if "--simulate" in OS.get_cmdline_user_args(): _run_balance_simulation.call_deferred()
	if not capture_mode.is_empty(): _prepare_capture()
	if "--preview-hunt" in OS.get_cmdline_user_args():
		muted = true
		mouse_control = false
		_new_run(321)
		round_time = STAGES[0].limit
		_start_hunt()
	queue_redraw()

func _process(delta: float) -> void:
	var dt = minf(delta,0.05)
	clock_time += dt
	for bubble in bubbles:
		bubble.pos.y -= bubble.speed*dt
		if bubble.pos.y < 80: bubble.pos.y = H+10
	for i in range(particles.size()-1,-1,-1):
		particles[i].life -= dt
		particles[i].pos += particles[i].vel*dt
		particles[i].vel *= pow(0.15,dt)
		if particles[i].life <= 0: particles.remove_at(i)
	for i in range(trails.size()-1,-1,-1):
		trails[i].life -= dt
		if trails[i].life <= 0: trails.remove_at(i)
	message_remaining = maxf(0,message_remaining-dt)
	camera_shake = maxf(0,camera_shake-dt*22)
	if state == "playing": _tick_game(dt,delta)
	elif state in ["last_hunt","hunt_hit"]: _tick_hunt(dt)
	_update_skill_feedback(delta)
	queue_redraw()
	if not capture_mode.is_empty():
		capture_frame += 1
		if capture_frame == 8: _save_capture.call_deferred()

func _input(event: InputEvent) -> void:
	if not capture_mode.is_empty(): return
	if event is InputEventMouseMotion: mouse_known = true
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var local_event = make_input_local(event)
		for button in buttons:
			if button.rect.has_point(local_event.position):
				_handle_action(button.action)
				return
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_ENTER:
				if state in ["title","dead","won"]: _new_run()
			KEY_ESCAPE: _toggle_pause()
			KEY_SPACE:
				if state == "playing": _dash()
			KEY_Q: _cast_slot(0)
			KEY_E: _cast_slot(1)
			KEY_R: _cast_slot(2)
			KEY_M: mouse_control = not mouse_control
			KEY_V: muted = not muted
			KEY_F11: get_window().mode = Window.MODE_WINDOWED if get_window().mode == Window.MODE_FULLSCREEN else Window.MODE_FULLSCREEN
			KEY_1,KEY_2,KEY_3:
				var index = event.keycode-KEY_1
				if state == "upgrade": _choose_upgrade(index)
				elif state == "skill_reward": _choose_skill(index)
				elif state == "skill_replace": _replace_skill(index)

func _handle_action(action: String) -> void:
	if action == "start": _new_run()
	elif action == "resume": state = paused_from
	elif action == "home": state = "title"
	elif action == "pause": _toggle_pause()
	elif action == "reward_back": state = "skill_reward"; pending_skill = ""
	elif action.begins_with("upgrade"): _choose_upgrade(int(action.substr(7)))
	elif action.begins_with("skillpick"): _choose_skill(int(action.substr(9)))
	elif action.begins_with("replace"): _replace_skill(int(action.substr(7)))
	elif action.begins_with("slot"): _cast_slot(int(action.substr(4)))
	else: _cast_skill(action)

func _new_run(run_seed: int = -1) -> void:
	if run_seed >= 0: rng.seed = run_seed
	else: rng.randomize()
	fx_rng.seed = run_seed+100000 if run_seed >= 0 else Time.get_ticks_usec()
	sim_stage_records.clear()
	stage = 1
	max_health = 4
	health = max_health
	shield = 0
	food_factor = 1.0
	speed_factor = 1.0
	legacy_levels = 0
	shell_levels = 0
	dash_factor = 1.0
	carry_size = 0
	time_bonus = 0
	has_combo = false
	has_swiftfood = false
	has_heal = false
	has_bubble_heal = false
	has_echo = false
	has_growthshield = false
	has_harvest = false
	has_glutton = false
	whirl_radius = 125
	whirl_duration = 1.3
	whirl_cd_max = 11
	sonar_radius = 225
	sonar_push = 70
	sonar_slow = 1.3
	sonar_cd_max = 9
	bubble_duration = 1.6
	bubble_cd_max = 16
	equipped_skills.clear()
	skill_offers.clear()
	pending_skill = ""
	dash_damage = 26
	sonar_damage = 28
	stats = {"dash_casts":0,"skill_casts":0,"boss_damage":0.0,"damage_taken":0}
	upgrades.clear()
	total_eaten = 0
	score = 0
	total_time = 0
	failure_reason = ""
	_start_stage()

func _start_stage() -> void:
	state = "playing"
	round_time = 0
	round_bonus = 0
	supply_timer = 4.5
	position_player = Vector2(270,355)
	mouse_known = true
	facing = Vector2.RIGHT
	last_move = Vector2.RIGHT
	radius_player = minf(21+carry_size,STAGES[stage-1].size*1.1-8)
	invulnerable = 2
	dash_cooldown = 0
	dash_remaining = 0
	dash_hit_done = false
	bite_cooldown = 0
	bite_flash = 0
	ink_cooldown = 0
	ink_remaining = 0
	paused_from = "playing"
	whirl_cooldown = 0
	whirl_remaining = 0
	sonar_cooldown = 0
	sonar_ring = 0
	bubble_cooldown = 0
	bubble_remaining = 0
	boost_remaining = 0
	combo = 0
	combo_timer = 0
	eaten_count = 0
	heal_count = 0
	echo_count = 0
	scale_count = 0
	shield = mini(3,shell_levels)
	entities.clear()
	shots.clear()
	volleys.clear()
	skill_flashes.clear()
	skill_block_flashes.clear()
	last_cooldowns.clear()
	mines.clear()
	particles.clear()
	trails.clear()
	boss = {"enraged":false,"pos":Vector2(850,350),"dir":Vector2.LEFT,"size":STAGES[stage-1].size,"phase":"patrol","timer":2.0,"target":Vector2.LEFT,"age":0.0,"tint":STAGES[stage-1].color,"attack":"charge","step":0,"lunges":0,"slow":0.0}
	boss.base_size = boss.size
	boss.min_size = STAGES[stage-1].min_size
	boss.max_hp = STAGES[stage-1].hp
	boss.hp = boss.max_hp
	boss.hurt_cooldown = 0.0
	boss.hit_flash = 0.0
	boss.invincible = false
	_spawn_school(Vector2(835,365),14)
	_spawn_school(Vector2(465,220),8)
	_spawn_school(Vector2(230,490),6)
	if stage >= 2:
		for i in range(mini(4,stage)):
			_spawn_hunter(Vector2(670+i*140,195+i%2*295))
	if stage >= 3:
		for i in range(mini(4,stage-1)):
			entities.append({"pos":Vector2(480+i*180,270+i%2*160),"dir":Vector2.RIGHT,"size":21.0,"speed":14.0,"phase":i*1.2,"kind":"jelly","tint":Color("cdade8"),"slow":0.0,"gold":false})
	_notice("冲刺撞中 Boss 能让它变小。" if stage == 1 else "第 %d 关：%s" % [stage,STAGES[stage-1].name],MINT,3)

func _spawn_hunter(p: Vector2) -> void:
	entities.append({"pos":p,"dir":Vector2.LEFT,"size":30.0,"speed":95.0,"phase":rng.randf()*TAU,"kind":"hunter","tint":Color("aa98e9"),"slow":0.0,"gold":false})

func _spawn_school(center: Vector2,count: int) -> void:
	var room = maxi(0,85-entities.size())
	for i in range(mini(count,room)):
		var p = center+Vector2(rng.randf_range(-170,170),rng.randf_range(-90,90))
		p.x = clampf(p.x,45,W-45)
		p.y = clampf(p.y,SEA_TOP+35,SEA_BOTTOM-35)
		var golden = rng.randf() < 0.085
		var size = rng.randf_range(9,14)
		if stage >= 3 and i%6 == 0: size = 19.0
		entities.append({"pos":p,"dir":Vector2.from_angle(rng.randf()*TAU),"size":size,"speed":rng.randf_range(25,45),"phase":rng.randf()*TAU,"kind":"food","tint":GOLD if golden else [Color("a7debd"),Color("85cfdc"),Color("dfbf88")][i%3],"slow":0.0,"gold":golden})

func _remaining_time() -> float:
	return maxf(0,STAGES[stage-1].limit+time_bonus+round_bonus-round_time)

func _mouse_direction(target: Vector2) -> Vector2:
	# Window exit events preserve steering even when Windows stops delivering motion.
	if pointer_outside or target.x < 0 or target.x > W or target.y < SEA_TOP or target.y > SEA_BOTTOM:
		return last_move.normalized() if last_move.length_squared() > 0.01 else facing
	var distance = position_player.distance_to(target)
	if distance <= 5: return Vector2.ZERO
	return (target-position_player).normalized()*minf(1,distance/45)

func _move_player(direction: Vector2,dt: float) -> void:
	var speed = 225*speed_factor*(1.32 if boost_remaining > 0 else 1.0)
	if direction.length_squared() > 0.01:
		last_move = direction.normalized()
		facing = facing.lerp(last_move,minf(1,dt*10)).normalized()
	if dash_remaining > 0:
		position_player += dash_direction*speed*2.7*dt
		if trails.size() < 20: trails.append({"pos":position_player,"dir":facing,"size":radius_player,"life":0.22})
	else: position_player += direction*speed*dt
	if stage >= 5:
		var offset = position_player-Vector2(690,345)
		if offset.length() < 205:
			position_player += Vector2(-offset.y,offset.x).normalized()*52*(1-offset.length()/240)*dt
	if boss.phase == "suction" and dash_remaining <= 0 and bubble_remaining <= 0:
		var offset: Vector2 = boss.pos-position_player
		if offset.length() < 360: position_player += offset.normalized()*145*(1-offset.length()/500)*dt
	_clamp_player()

func _clamp_player() -> void:
	position_player.x = clampf(position_player.x,radius_player+16,W-radius_player-16)
	position_player.y = clampf(position_player.y,SEA_TOP+radius_player+10,SEA_BOTTOM-radius_player-8)

func _tick_game(dt: float,elapsed: float = -1,steering: Vector2 = Vector2(INF,INF)) -> void:
	if state != "playing": return
	var timer_dt = dt if elapsed < 0 else elapsed
	round_time += timer_dt
	total_time += timer_dt
	if _remaining_time() <= 0:
		_start_hunt()
		return
	invulnerable = maxf(0,invulnerable-timer_dt)
	dash_cooldown = maxf(0,dash_cooldown-timer_dt)
	dash_remaining = maxf(0,dash_remaining-timer_dt)
	whirl_cooldown = maxf(0,whirl_cooldown-timer_dt)
	whirl_remaining = maxf(0,whirl_remaining-timer_dt)
	sonar_cooldown = maxf(0,sonar_cooldown-timer_dt)
	sonar_ring = maxf(0,sonar_ring-timer_dt)
	bubble_cooldown = maxf(0,bubble_cooldown-timer_dt)
	bubble_remaining = maxf(0,bubble_remaining-timer_dt)
	boost_remaining = maxf(0,boost_remaining-timer_dt)
	combo_timer = maxf(0,combo_timer-timer_dt)
	bite_cooldown = maxf(0,bite_cooldown-timer_dt)
	bite_flash = maxf(0,bite_flash-timer_dt)
	ink_cooldown = maxf(0,ink_cooldown-timer_dt)
	ink_remaining = maxf(0,ink_remaining-timer_dt)
	if combo_timer == 0: combo = 0
	var direction = Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_W) or Input.is_physical_key_pressed(KEY_UP): direction.y -= 1
	if Input.is_physical_key_pressed(KEY_S) or Input.is_physical_key_pressed(KEY_DOWN): direction.y += 1
	if Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT): direction.x -= 1
	if Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT): direction.x += 1
	if direction.length_squared() > 0: direction = direction.normalized()
	elif mouse_control and (mouse_known or pointer_outside): direction = _mouse_direction(get_global_mouse_position())
	if not is_inf(steering.x): direction = steering
	_move_player(direction,dt)
	for fish in entities:
		fish.phase += dt*2
		fish.slow = maxf(0,fish.slow-dt)
		if ink_remaining > 0 and fish.pos.distance_to(ink_center) < ink_radius: fish.slow = maxf(fish.slow,0.15)
		var away: Vector2 = fish.pos-position_player
		if fish.kind == "food":
			if away.length() < 90: fish.dir = fish.dir.lerp(away.normalized(),dt*2.2).normalized()
			else: fish.dir = fish.dir.rotated(sin(fish.phase)*dt*0.4)
		elif fish.kind == "hunter":
			if radius_player < fish.size*1.1 and away.length() < 300: fish.dir = fish.dir.lerp(-away.normalized(),dt*1.4).normalized()
			elif radius_player >= fish.size*1.1 and away.length() < 130: fish.dir = fish.dir.lerp(away.normalized(),dt*2).normalized()
		else: fish.dir = Vector2(sin(fish.phase*0.5),cos(fish.phase*0.3)).normalized()
		fish.pos += fish.dir*fish.speed*(0.35 if fish.slow > 0 else 1.0)*dt
		if whirl_remaining > 0 and fish.kind != "jelly" and radius_player >= fish.size*1.1 and away.length() < whirl_radius:
			fish.pos -= away.normalized()*170*(1-away.length()/(whirl_radius+40))*dt
		if fish.pos.x < 30 or fish.pos.x > W-30: fish.dir.x *= -1
		if fish.pos.y < SEA_TOP+25 or fish.pos.y > SEA_BOTTOM-25: fish.dir.y *= -1
		fish.pos.x = clampf(fish.pos.x,30,W-30)
		fish.pos.y = clampf(fish.pos.y,SEA_TOP+25,SEA_BOTTOM-25)
	_tick_boss(dt)
	_tick_hazards(dt)
	supply_timer -= dt
	if supply_timer <= 0:
		supply_timer = 4.8
		var food_count = 0
		for fish in entities:
			if fish.kind == "food": food_count += 1
		if food_count < 38: _spawn_school(boss.pos,10)
	_resolve_collisions()

func _tick_boss(dt: float) -> void:
	boss.age += dt
	boss.hurt_cooldown = maxf(0,boss.hurt_cooldown-dt)
	boss.hit_flash = maxf(0,boss.hit_flash-dt)
	if ink_remaining > 0 and boss.pos.distance_to(ink_center) < ink_radius: boss.slow = maxf(boss.slow,0.15)
	boss.timer -= dt
	boss.slow = maxf(0,boss.slow-dt)
	if _boss_enraged() and not boss.get("enraged",false):
		boss.enraged = true
		boss.step = 0
		_notice("风暴巨口进入狂暴。小心三次连冲。",CORAL,3)
		_burst(boss.pos,Color("cf7490"),28)
	for i in range(volleys.size()-1,-1,-1):
		volleys[i].delay -= dt
		if volleys[i].delay <= 0:
			for dir in volleys[i].directions: _spawn_shot(dir,volleys[i].speed,volleys[i].color,volleys[i].origin)
			volleys.remove_at(i)
	var slow_factor = 0.45 if boss.slow > 0 else 1.0
	var enraged = boss.get("enraged",false)
	var rage = 1.22 if enraged else (1.12 if _remaining_time() < 30 else 1.0)
	var toward: Vector2 = (position_player-boss.pos).normalized()
	if boss.phase == "wounded":
		boss.pos += (boss.pos-position_player).normalized()*20*dt
	elif boss.phase == "patrol":
		boss.dir = boss.dir.lerp(toward,dt*1.4).normalized()
		boss.pos += boss.dir*STAGES[stage-1].pursuit*slow_factor*rage*dt
		if boss.timer <= 0: _begin_boss_attack()
	elif boss.phase == "warn":
		if boss.timer <= 0: _execute_boss_attack()
	elif boss.phase == "charge":
		boss.pos += boss.target*_boss_charge_speed()*(1.08 if enraged else 1.0)*slow_factor*dt
		if boss.timer <= 0:
			if boss.lunges > 0:
				boss.lunges -= 1
				boss.target = toward
				boss.dir = toward
				boss.phase = "warn"
				boss.timer = 0.62 if enraged else 0.72
			else: _boss_recover()
	elif boss.phase == "suction":
		boss.dir = boss.dir.lerp(toward,dt).normalized()
		if boss.timer <= 0: _boss_recover()
	elif boss.phase == "recover":
		if boss.timer <= 0:
			boss.phase = "patrol"
			boss.timer = [1.4,1.25,1.0,0.9,0.8,0.75][stage-1]/rage
	boss.pos.x = clampf(boss.pos.x,90,W-90)
	boss.pos.y = clampf(boss.pos.y,SEA_TOP+80,SEA_BOTTOM-80)

func _begin_boss_attack() -> void:
	var patterns: Array = STAGES[stage-1].attacks
	if stage == 6 and boss.get("enraged",false): patterns = ["triple","spiral","suction","sweep","mines","triple"]
	boss.attack = patterns[boss.step%patterns.size()]
	boss.step += 1
	boss.target = (position_player-boss.pos).normalized()
	boss.dir = boss.target
	boss.phase = "warn"
	boss.timer = 0.7 if stage == 1 else (0.8 if not boss.get("enraged",false) else 0.75)
	boss.lunges = 2 if boss.attack == "triple" else (1 if boss.attack == "double" else 0)
	if boss.attack == "mines":
		var amount = 4 if stage == 6 else 3
		for i in range(amount):
			if mines.size() < 16:
				var p = position_player+Vector2.from_angle(i*TAU/amount+boss.age)*(40+i*24)
				p.x = clampf(p.x,60,W-60)
				p.y = clampf(p.y,SEA_TOP+35,SEA_BOTTOM-35)
				mines.append({"pos":p,"warning":1.15,"life":6.5,"size":29.0})

func _execute_boss_attack() -> void:
	match boss.attack:
		"charge","double","triple":
			boss.phase = "charge"
			boss.timer = 0.55
			_sound("dash",0.55)
		"fan","fan_burst":
			var count = 7 if boss.attack == "fan_burst" else (5 if stage >= 3 else 3)
			var directions: Array[Vector2] = []
			for i in range(count):
				var dir: Vector2 = boss.target.rotated((i-(count-1)/2.0)*0.23)
				directions.append(dir)
				_spawn_shot(dir,210,Color("8864c7"))
			if boss.attack == "fan_burst": volleys.append({"delay":0.48,"directions":directions,"speed":210.0,"color":Color("8864c7"),"origin":boss.pos})
			_boss_recover()
		"radial","radial_burst":
			var count = 12 if stage == 6 else 10
			var directions: Array[Vector2] = []
			for i in range(count):
				var dir = Vector2.from_angle(i*TAU/count+boss.age*0.23)
				_spawn_shot(dir,165,Color("c65b96"))
				directions.append(dir.rotated(PI/count))
			if boss.attack == "radial_burst": volleys.append({"delay":0.6,"directions":directions,"speed":165.0,"color":Color("c65b96"),"origin":boss.pos})
			_boss_recover()
		"suction":
			boss.phase = "suction"
			boss.timer = 3.0
		"sweep":
			for wave in range(3):
				var directions: Array[Vector2] = []
				for i in range(3): directions.append(boss.target.rotated((wave-1)*0.42+(i-1)*0.18))
				if wave == 0:
					for dir in directions: _spawn_shot(dir,220,Color("8864c7"))
				else: volleys.append({"delay":wave*0.35,"directions":directions,"speed":220.0,"color":Color("8864c7"),"origin":boss.pos})
			_boss_recover()
		"spiral":
			for wave in range(3):
				var directions: Array[Vector2] = []
				for i in range(10): directions.append(Vector2.from_angle(i*TAU/10+wave*0.14+boss.age*0.12))
				if wave == 0:
					for dir in directions: _spawn_shot(dir,180,Color("c65b96"))
				else: volleys.append({"delay":wave*0.42,"directions":directions,"speed":180.0,"color":Color("c65b96"),"origin":boss.pos})
			_boss_recover()
		"mines": _boss_recover()

func _boss_recover() -> void:
	boss.phase = "recover"
	boss.timer = [1.25,1.05,0.9,0.85,0.8,0.8][stage-1]
	if boss.get("enraged",false): boss.timer = 0.6

func _spawn_shot(direction: Vector2,speed: float,color: Color,origin: Vector2 = Vector2(INF,INF)) -> void:
	if shots.size() >= 48: return
	var source: Vector2 = boss.pos if is_inf(origin.x) else origin
	shots.append({"pos":source+direction*(boss.size+16),"vel":direction*speed,"life":7.0,"size":8.0,"color":color})

func _tick_hazards(dt: float) -> void:
	for i in range(shots.size()-1,-1,-1):
		shots[i].pos += shots[i].vel*dt
		shots[i].life -= dt
		var p: Vector2 = shots[i].pos
		if (ink_remaining > 0 and p.distance_to(ink_center) < ink_radius) or shots[i].life <= 0 or p.x < -30 or p.x > W+30 or p.y < SEA_TOP-10 or p.y > SEA_BOTTOM+10:
			shots.remove_at(i)
	for i in range(mines.size()-1,-1,-1):
		if mines[i].warning > 0: mines[i].warning -= dt
		else: mines[i].life -= dt
		if mines[i].life <= 0: mines.remove_at(i)

func _resolve_collisions() -> void:
	if state != "playing": return
	for i in range(entities.size()-1,-1,-1):
		var fish = entities[i]
		var distance = position_player.distance_to(fish.pos)
		if fish.kind == "jelly":
			if distance < radius_player*0.66+fish.size*0.7: _take_hit(fish.pos,"水母")
		elif radius_player >= fish.size*1.1:
			if distance < radius_player+fish.size*0.35:
				_eat(fish)
				entities.remove_at(i)
		elif distance < (radius_player+fish.size)*0.72: _take_hit(fish.pos,"尖牙鱼")
		if state != "playing": return
	for i in range(shots.size()-1,-1,-1):
		if position_player.distance_to(shots[i].pos) < radius_player*0.62+shots[i].size:
			_take_hit(shots[i].pos,"Boss 的飞弹")
			_burst(shots[i].pos,shots[i].color,4)
			shots.remove_at(i)
			if state != "playing": return
	for mine in mines:
		if mine.warning <= 0 and position_player.distance_to(mine.pos) < radius_player*0.65+mine.size:
			_take_hit(mine.pos,"针刺陷阱")
			if state != "playing": return
	var distance = position_player.distance_to(boss.pos)
	if distance < (radius_player+boss.size)*0.7:
		if dash_remaining > 0 and not dash_hit_done:
			dash_hit_done = true
			if _damage_boss(dash_damage,position_player,"冲刺"):
				invulnerable = maxf(invulnerable,0.4)
				position_player -= dash_direction*18
				_clamp_player()
		if radius_player >= boss.size*1.1 or boss.hp <= 0: _win_stage()
		elif boss.hp > 0: _take_hit(boss.pos,STAGES[stage-1].boss)

func _eat(fish: Dictionary) -> void:
	var multiplier = food_factor
	if has_swiftfood and (dash_remaining > 0 or boost_remaining > 0): multiplier *= 1.25
	var gain = (0.70 if stage == 1 else 0.50) if fish.kind == "food" else 2.0
	if fish.get("gold",false): gain = 1.5 if stage == 1 else 1.15
	elif fish.size >= 18 and fish.kind == "food": gain = 1.1 if stage == 1 else 0.85
	var was_ready = radius_player >= boss.size*1.1
	radius_player = minf(radius_player+gain*multiplier,boss.base_size*1.1+12)
	eaten_count += 1
	total_eaten += 1
	score += 25 if fish.get("gold",false) else (10 if fish.kind == "food" else 50)
	combo = combo+1 if combo_timer > 0 else 1
	combo_timer = 3
	if has_combo and combo >= 5: boost_remaining = 4
	if has_heal:
		heal_count += 1
		if heal_count >= 15:
			heal_count = 0
			health = mini(max_health,health+1)
	if has_growthshield:
		scale_count += 1
		if scale_count >= 18:
			scale_count = 0
			shield = mini(3,shield+1)
	if has_echo and _owns_skill("sonar"):
		echo_count += 1
		if echo_count >= 10:
			echo_count = 0
			_pulse(false)
	_burst(fish.pos,fish.tint,6)
	_sound("eat",0.42)
	if not was_ready and radius_player >= boss.size*1.1:
		_notice("已经长大了，去吃掉 %s。" % STAGES[stage-1].boss,GOLD,3)
		_sound("win",0.6)

func _take_hit(source: Vector2,who: String = "敌人") -> void:
	if invulnerable > 0 or dash_remaining > 0 or bubble_remaining > 0: return
	invulnerable = 1.4
	camera_shake = 8
	last_damage_source = who
	position_player += (position_player-source).normalized()*28
	_clamp_player()
	if shield > 0:
		shield -= 1
		_notice("护盾挡住了伤害。",Color("b4d9ee"),1.0)
	else:
		health -= 1
		stats.damage_taken += 1
		_notice("受到伤害，注意大鱼的蓄力方向。",CORAL,1.4)
	_burst(position_player,CORAL,15)
	_sound("hurt",0.7)
	if health <= 0: _fail("生命耗尽，最后一次伤害来自%s。" % who)

func _fail(reason: String) -> void:
	state = "dead"
	failure_reason = reason
	message_remaining = 0

func _dash() -> void:
	if state != "playing": return
	if _skill_blocked("dash",dash_cooldown): return
	skill_flashes["dash"] = 0.0
	stats.dash_casts += 1
	dash_hit_done = false
	dash_direction = facing
	dash_remaining = 0.24
	dash_cooldown = maxf(1.4,3.2*dash_factor)
	_sound("dash",0.5)

func _whirl() -> void:
	if state != "playing" or not _owns_skill("whirl"): return
	if _skill_blocked("whirl",whirl_cooldown): return
	stats.skill_casts += 1
	skill_flashes["whirl"] = 0.0
	whirl_remaining = whirl_duration
	whirl_cooldown = whirl_cd_max
	_sound("choice",0.45)

func _sonar() -> void:
	if state != "playing" or not _owns_skill("sonar"): return
	if _skill_blocked("sonar",sonar_cooldown): return
	stats.skill_casts += 1
	skill_flashes["sonar"] = 0.0
	sonar_cooldown = sonar_cd_max
	_pulse(true)
	_sound("choice",0.65)

func _pulse(manual: bool) -> void:
	sonar_ring = 0.55
	if position_player.distance_to(boss.pos) < sonar_radius:
		_damage_boss(sonar_damage if manual else 5.0,position_player,"冲击声波")
		boss.pos += (boss.pos-position_player).normalized()*sonar_push
		boss.pos.x = clampf(boss.pos.x,90,W-90)
		boss.pos.y = clampf(boss.pos.y,SEA_TOP+80,SEA_BOTTOM-80)
		boss.slow = sonar_slow
		# A pulse breaks suction but keeps other attack patterns readable.
		if boss.phase == "suction": _boss_recover()
	for fish in entities:
		if fish.kind != "food" and fish.pos.distance_to(position_player) < sonar_radius:
			fish.pos += (fish.pos-position_player).normalized()*sonar_push*0.8
			fish.pos.x = clampf(fish.pos.x,30,W-30)
			fish.pos.y = clampf(fish.pos.y,SEA_TOP+25,SEA_BOTTOM-25)
			fish.slow = sonar_slow
	for i in range(shots.size()-1,-1,-1):
		if shots[i].pos.distance_to(position_player) < sonar_radius:
			_burst(shots[i].pos,shots[i].color,3)
			shots.remove_at(i)
	for i in range(mines.size()-1,-1,-1):
		if mines[i].pos.distance_to(position_player) < sonar_radius: mines.remove_at(i)
	if manual and has_harvest:
		for i in range(entities.size()-1,-1,-1):
			var fish = entities[i]
			if fish.kind != "jelly" and radius_player >= fish.size*1.1 and fish.pos.distance_to(position_player) < 95:
				_eat(fish)
				entities.remove_at(i)

func _bubble() -> void:
	if state != "playing" or not _owns_skill("bubble"): return
	if _skill_blocked("bubble",bubble_cooldown): return
	stats.skill_casts += 1
	skill_flashes["bubble"] = 0.0
	bubble_remaining = bubble_duration
	bubble_cooldown = bubble_cd_max
	if has_bubble_heal: health = mini(max_health,health+1)
	_sound("choice",0.4)

func _win_stage() -> void:
	if state != "playing": return
	sim_stage_records.append({"stage":stage,"seconds":snappedf(round_time,0.01),"remaining":snappedf(_remaining_time(),0.01),"health":health,"food":eaten_count,"size":radius_player,"food_factor":food_factor,"time_bonus":time_bonus,"skills":equipped_skills.duplicate(),"perks":upgrades.map(func(u):return u.id)})
	_burst(boss.pos,GOLD,40)
	score += 200*stage+int(_remaining_time())*2
	if legacy_levels > 0: speed_factor += 0.12*legacy_levels
	health = mini(max_health,health+1)
	_sound("win",0.8)
	message_remaining = 0
	if stage == STAGES.size(): state = "won"
	else:
		state = "skill_reward"
		_generate_skill_offers()

func _generate_offers() -> void:
	offers.clear()
	var requirements = {"whirl":"whirl","whirl_cd":"whirl","sonar":"sonar","sonar_cd":"sonar","bubble":"bubble","bubble_heal":"bubble","harvest":"sonar","echo":"sonar"}
	var pool: Array[int] = []
	for i in range(EVOLUTIONS.size()):
		var id = EVOLUTIONS[i].id
		if id in requirements and not _owns_skill(requirements[id]): continue
		if id == "legacy" and stage >= STAGES.size()-1: continue
		if id == "shell" and shell_levels >= 3: continue
		if id in ["food","glutton"] and food_factor >= 1.6: continue
		if id == "carry" and carry_size >= 8: continue
		if id == "time" and time_bonus >= 24: continue
		if id == "whirl" and whirl_radius >= 185 and whirl_duration >= 2: continue
		if id == "sonar" and sonar_damage >= 50 and sonar_radius >= 300: continue
		if id == "bubble" and bubble_duration >= 2.8 and bubble_cd_max <= 10: continue
		if (id == "combo" and has_combo) or (id == "swiftfood" and has_swiftfood) or (id == "heal" and has_heal): continue
		if (id == "echo" and has_echo) or (id == "growthshield" and has_growthshield) or (id == "harvest" and has_harvest): continue
		if (id == "bubble_heal" and has_bubble_heal) or (id == "glutton" and has_glutton): continue
		if id == "dash" and 3.2*dash_factor <= 1.4: continue
		if id == "whirl_cd" and whirl_cd_max <= 5: continue
		if id == "sonar_cd" and sonar_cd_max <= 5: continue
		pool.append(i)
	for i in range(3):
		var n = rng.randi_range(0,pool.size()-1)
		offers.append(EVOLUTIONS[pool[n]])
		pool.remove_at(n)

func _choose_upgrade(index: int) -> void:
	if state != "upgrade" or index < 0 or index >= offers.size(): return
	var chosen = offers[index]
	_apply_upgrade(chosen)
	stage += 1
	_start_stage()
	_notice("获得 %s。" % chosen.name,chosen.color,2)

func _apply_upgrade(chosen: Dictionary) -> void:
	upgrades.append(chosen)
	match chosen.id:
		"shell": shell_levels += 1
		"food": food_factor = minf(1.6,food_factor+0.12)
		"legacy": legacy_levels += 1
		"dash": dash_factor *= 0.8
		"combo": has_combo = true
		"swiftfood": has_swiftfood = true
		"heal": has_heal = true; health = mini(max_health,health+1)
		"speed": speed_factor += 0.12
		"carry": carry_size = minf(8,carry_size+2)
		"whirl": whirl_radius = minf(185,whirl_radius+24); whirl_duration = minf(2.0,whirl_duration+0.25)
		"whirl_cd": whirl_cd_max = maxf(5,whirl_cd_max*0.75)
		"sonar": sonar_radius = minf(300,sonar_radius+25); sonar_push = minf(120,sonar_push+15); sonar_slow = 1.8; sonar_damage = minf(50,sonar_damage+5)
		"sonar_cd": sonar_cd_max = maxf(5,sonar_cd_max*0.75)
		"bubble": bubble_duration = minf(2.8,bubble_duration+0.4); bubble_cd_max = maxf(10,bubble_cd_max-1.5)
		"bubble_heal": has_bubble_heal = true
		"time": time_bonus = minf(24,time_bonus+8)
		"glutton": has_glutton = true; food_factor = minf(1.6,food_factor+0.22); max_health -= 1; health = mini(health,max_health)
		"echo": has_echo = true
		"growthshield": has_growthshield = true
		"harvest": has_harvest = true
	_sound("choice",0.6)

func _notice(value: String,color: Color,duration: float) -> void:
	message = value
	message_color = color
	message_remaining = duration

func _burst(p: Vector2,color: Color,count: int) -> void:
	for i in range(count):
		if particles.size() >= 190: break
		particles.append({"pos":p,"vel":Vector2.from_angle(fx_rng.randf()*TAU)*fx_rng.randf_range(30,150),"life":fx_rng.randf_range(0.3,0.7),"color":color,"size":fx_rng.randf_range(2,5)})

func _draw() -> void:
	buttons.clear()
	_draw_ocean()
	if state == "title":
		_draw_title()
		return
	_draw_world()
	_draw_hud()
	if state in ["skill_reward","skill_replace"]: _draw_skill_reward()
	elif state == "upgrade": _draw_upgrade()
	elif state in ["last_hunt","hunt_hit"]: _draw_hunt()
	elif state == "paused": _draw_pause()
	elif state in ["dead","won"]: _draw_result()

func _draw_ocean() -> void:
	for i in range(48):
		var color = STAGES[stage-1].top.lerp(STAGES[stage-1].bottom,float(i)/47)
		draw_rect(Rect2(0,i*H/48,W,H/48+1),color)
	for i in range(6):
		var x = 80+i*230+sin(clock_time*0.17+i)*30
		draw_colored_polygon(PackedVector2Array([Vector2(x,80),Vector2(x+35,80),Vector2(x+155,H),Vector2(x-20,H)]),Color(1,1,0.95,0.075))
	for row in range(7):
		var points = PackedVector2Array()
		for j in range(90):
			var x = j*W/89
			var y = SEA_TOP+38+row*68+sin(x*0.013+clock_time*0.4+row)*7+cos(x*0.006-clock_time*0.2)*5
			points.append(Vector2(x,y))
		draw_polyline(points,Color(1,1,0.95,0.15),2,true)
	for bubble in bubbles:
		var p = bubble.pos+Vector2(sin(clock_time*0.6+bubble.phase)*8,0)
		draw_arc(p,bubble.size,0,TAU,12,Color(0.15,0.46,0.48,0.18),1,true)
	for reef in reefs:
		var x: float = reef.x
		var h: float = reef.height
		var color = Color("75a7a0") if reef.kind == 0 else Color("9ab6a1")
		for j in range(3):
			var points = PackedVector2Array()
			for k in range(7):
				points.append(Vector2(x+j*8+sin(clock_time*0.5+reef.phase+k*0.45)*k*1.7,H-float(k)*h/6))
			draw_polyline(points,Color(color,0.4),3.5,true)
		draw_circle(Vector2(x,H-9),h*0.28,Color("c0cfc0"))
	draw_line(Vector2(0,SEA_BOTTOM+6),Vector2(W,SEA_BOTTOM+6),Color(0.3,0.55,0.55,0.2),1)

func _draw_fish(p: Vector2,r: float,direction: Vector2,color: Color,phase: float,predator: bool,is_boss: bool) -> void:
	var angle = direction.angle()
	draw_set_transform(p,angle,Vector2(1,-1 if direction.x < 0 else 1))
	var tail_wiggle = sin(phase)*r*0.14
	var outline = PackedVector2Array([Vector2(-r*0.7,0),Vector2(-r*1.45,-r*0.58+tail_wiggle),Vector2(-r*1.29,tail_wiggle),Vector2(-r*1.45,r*0.58+tail_wiggle)])
	draw_colored_polygon(outline,color.darkened(0.19))
	draw_colored_polygon(PackedVector2Array([Vector2(-r*0.25,-r*0.38),Vector2(-r*0.42,-r*0.92),Vector2(r*0.32,-r*0.4)]),color.darkened(0.23))
	var body = PackedVector2Array()
	for i in range(40):
		var a = i*TAU/40
		body.append(Vector2(cos(a)*r,sin(a)*r*0.61))
	draw_colored_polygon(body,color)
	var contour = body.duplicate()
	contour.append(body[0])
	draw_polyline(contour,Color(color.darkened(0.48),0.6),1.1,true)
	var belly = PackedVector2Array()
	for i in range(21):
		var a = float(i)*PI/20
		belly.append(Vector2(cos(a)*r*0.86,sin(a)*r*0.45+r*0.08))
	draw_colored_polygon(belly,color.lightened(0.24))
	draw_colored_polygon(PackedVector2Array([Vector2(-r*0.08,r*0.14),Vector2(-r*0.33,r*0.76),Vector2(r*0.32,r*0.34)]),color.darkened(0.1))
	if r > 18:
		for i in range(3):
			draw_arc(Vector2(-r*0.15-i*r*0.22,0),r*0.2,-0.8,0.8,8,Color(color.darkened(0.3),0.28),1.2,true)
	draw_circle(Vector2(r*0.46,-r*0.19),maxf(2.7,r*0.17),Color("fbf9e7"))
	draw_circle(Vector2(r*0.5,-r*0.18),maxf(1.5,r*0.087),INK)
	draw_circle(Vector2(r*0.53,-r*0.22),maxf(0.8,r*0.03),WHITE)
	if predator:
		draw_line(Vector2(r*0.72,r*0.15),Vector2(r*0.94,r*0.08),INK,maxf(1,r*0.045),true)
		draw_colored_polygon(PackedVector2Array([Vector2(r*0.73,r*0.12),Vector2(r*0.81,r*0.28),Vector2(r*0.86,r*0.1)]),WHITE)
		if is_boss:
			draw_line(Vector2(r*0.3,-r*0.36),Vector2(r*0.65,-r*0.25),color.darkened(0.4),maxf(2,r*0.06),true)
	else:
		draw_arc(Vector2(r*0.76,r*0.1),r*0.11,0,1.7,8,color.darkened(0.5),1.4,true)
	draw_set_transform(Vector2.ZERO)

func _draw_world() -> void:
	if stage >= 5:
		for i in range(7):
			var angle = clock_time*0.23+i*TAU/7
			var points = PackedVector2Array()
			for j in range(30):
				var t = float(j)/29
				points.append(Vector2(690,345)+Vector2.from_angle(angle+t*2.8)*(25+t*180))
			draw_polyline(points,Color(0.5,0.7,0.85,0.07),2,true)
	for mine in mines:
		if mine.warning > 0:
			draw_circle(mine.pos,mine.size,Color(1,0.64,0.32,0.12))
			draw_arc(mine.pos,mine.size,0,TAU,32,Color(GOLD,0.7),2,true)
			_center_text("!",mine.pos+Vector2(0,6),20,GOLD)
		else:
			draw_circle(mine.pos,mine.size,Color(0.75,0.4,0.55,0.11))
			for i in range(9):
				var a = i*TAU/9+clock_time*0.25
				draw_colored_polygon(PackedVector2Array([mine.pos+Vector2.from_angle(a)*18,mine.pos+Vector2.from_angle(a+0.12)*36,mine.pos+Vector2.from_angle(a+0.25)*18]),Color("de9cc5"))
			draw_circle(mine.pos,16,Color("a269a2"))
	if boss.phase == "suction":
		for i in range(5):
			var radius = fmod(clock_time*100+i*65,330.0)+20
			draw_arc(boss.pos,radius,0,TAU,70,Color(0.4,0.83,0.8,0.13),2,true)
		for i in range(10):
			var a = i*TAU/10
			var p: Vector2 = boss.pos+Vector2.from_angle(a)*180
			draw_line(p,p-Vector2.from_angle(a)*25,Color(MINT,0.35),2,true)
	if boss.phase == "warn":
		if boss.attack in ["charge","double","triple"]:
			var end: Vector2 = boss.pos+boss.target*360
			draw_line(boss.pos,end,Color(CORAL,0.2+sin(clock_time*18)*0.06),boss.size*0.62,true)
			draw_line(boss.pos,end,Color(CORAL,0.65),2,true)
		elif boss.attack in ["fan","fan_burst"]:
			for i in range(7 if boss.attack == "fan_burst" else (5 if stage >= 3 else 3)):
				var n = 7 if boss.attack == "fan_burst" else (5 if stage >= 3 else 3)
				var dir: Vector2 = boss.target.rotated((i-(n-1)/2.0)*0.23)
				draw_line(boss.pos+dir*boss.size,boss.pos+dir*280,Color(0.45,0.26,0.67,0.42),3,true)
		elif boss.attack in ["radial","radial_burst","spiral"]:
			draw_arc(boss.pos,boss.size+30+sin(clock_time*12)*5,0,TAU,60,Color(0.72,0.28,0.52,0.75),3,true)
		elif boss.attack == "sweep":
			for i in range(7):
				var dir: Vector2 = boss.target.rotated((i-3)*0.18)
				draw_line(boss.pos+dir*boss.size,boss.pos+dir*320,Color(0.45,0.26,0.67,0.35),2,true)
		elif boss.attack == "suction":
			draw_circle(boss.pos,330,Color(0.45,0.82,0.82,0.045))
			draw_arc(boss.pos,330,0,TAU,90,Color(MINT,0.25),1,true)
	for fish in entities:
		if fish.kind == "jelly": _draw_jelly(fish.pos,fish.size,fish.phase)
		else:
			if fish.get("gold",false): draw_circle(fish.pos,fish.size*1.55,Color(GOLD,0.07))
			_draw_fish(fish.pos,fish.size,fish.dir,fish.tint,fish.phase,fish.kind == "hunter",false)
	for shot in shots:
		draw_line(shot.pos-shot.vel.normalized()*18,shot.pos,Color(shot.color,0.6),4,true)
		draw_circle(shot.pos,shot.size+1.5,shot.color.darkened(0.3))
		draw_circle(shot.pos,shot.size,shot.color)
		draw_circle(shot.pos,shot.size*0.42,WHITE)
	var can_eat = (radius_player >= boss.size*1.1 or boss.hp <= 0) and not boss.invincible
	if can_eat: draw_arc(boss.pos,boss.size*1.22,0,TAU,70,Color(MINT,0.5),2,true)
	_draw_boss()
	if boss.phase in ["warn","charge"] and not boss.invincible:
		draw_arc(boss.pos,boss.size+6,boss.dir.angle()-1.32,boss.dir.angle()+1.32,32,GOLD.darkened(0.1),3,true)
	var hp_rect = Rect2(boss.pos+Vector2(-59,-boss.size-8),Vector2(118,5))
	draw_rect(hp_rect,Color("f0e7e0"))
	draw_rect(Rect2(hp_rect.position,Vector2(118*boss.hp/boss.max_hp,5)),CORAL.darkened(0.2))
	var boss_status = STAGES[stage-1].boss
	if boss.invincible: boss_status = "无敌追杀"
	elif can_eat: boss_status = "可以吞噬"
	elif boss.hp <= 0: boss_status = "已虚弱"
	elif boss.phase == "warn":
		boss_status = {"triple":"准备三连冲","fan_burst":"准备连发电弹","radial_burst":"准备两轮针刺","charge":"准备冲刺","double":"准备连冲","fan":"准备发射电弹","radial":"准备放出针刺","suction":"准备吸水","mines":"小心脚下","sweep":"准备三轮扫射","spiral":"准备旋转针刺"}[boss.attack]
	elif boss.phase == "suction": boss_status = "正在吸水"
	elif boss.phase == "recover": boss_status = "正在喘息"
	_center_text(boss_status,boss.pos+Vector2(0,-boss.size-14),14,MINT if can_eat else boss.tint.darkened(0.36))
	for trail in trails:
		_draw_fish(trail.pos,trail.size,trail.dir,Color(MINT,trail.life),clock_time*4,false,false)
	if whirl_remaining > 0:
		draw_circle(position_player,whirl_radius,Color(0.4,0.8,0.7,0.025))
		for i in range(6):
			var points = PackedVector2Array()
			for j in range(24):
				var t = float(j)/23
				points.append(position_player+Vector2.from_angle(clock_time*3+i*TAU/6+t*2.3)*(radius_player+15+t*(whirl_radius-radius_player-15)))
			draw_polyline(points,Color(0.55,0.94,0.8,0.24),2,true)
	if sonar_ring > 0:
		var r = (1-sonar_ring/0.55)*sonar_radius
		draw_arc(position_player,maxf(4,r),0,TAU,80,Color(0.72,0.83,1,sonar_ring),4,true)
	if shield > 0: draw_arc(position_player,radius_player+10,0,TAU,64,Color(0.7,0.9,1,0.4),2,true)
	if bubble_remaining > 0:
		draw_circle(position_player,radius_player+18,Color(0.7,0.92,1,0.1))
		draw_arc(position_player,radius_player+18,0,TAU,64,Color(0.7,0.92,1,0.85),3,true)
	if ink_remaining > 0:
		draw_circle(ink_center,ink_radius,Color(0.35,0.25,0.5,0.11))
		draw_arc(ink_center,ink_radius,0,TAU,70,Color(0.35,0.25,0.5,0.25),2,true)
	if bite_flash > 0:
		draw_arc(position_player,95+radius_player*0.3,facing.angle()-0.7,facing.angle()+0.7,25,Color(0.8,0.35,0.25,bite_flash*2),4,true)
	var fish_color = GOLD
	if invulnerable > 0: fish_color.a = 0.55+abs(sin(clock_time*14))*0.45
	_draw_fish(position_player,radius_player*maxf(0.05,1-hunt_timer/0.6) if state == "hunt_hit" else radius_player,facing,fish_color,clock_time*6,false,false)
	_center_text("你",position_player+Vector2(0,radius_player+18),12,INK)
	for p in particles:
		var color: Color = p.color
		color.a = minf(1,p.life*2)
		draw_circle(p.pos,p.size*minf(1,p.life*3),color)
	if message_remaining > 0 and state == "playing":
		var width = maxf(250,font.get_string_size(message,HORIZONTAL_ALIGNMENT_LEFT,-1,16).x+44)
		_panel(Rect2((W-width)/2,122,width,35),Color("f8fcf2"),Color(message_color,0.25),10)
		_center_text(message,Vector2(W/2,145),16,message_color.darkened(0.2))
	if combo >= 3 and state == "playing": _text("连吃 %d" % combo,Vector2(32,SEA_BOTTOM-16),15,GOLD)

func _draw_boss() -> void:
	var p: Vector2 = boss.pos
	var color: Color = GOLD if (radius_player >= boss.size*1.1 or boss.hp <= 0) and not boss.invincible else boss.tint
	if boss.hit_flash > 0: color = color.lightened(0.6)
	if stage == 6:
		_draw_leviathan(p,boss.size,boss.dir,boss.age,boss.get("enraged",false),(radius_player >= boss.size*1.1 or boss.hp <= 0) and not boss.invincible)
		return
	if stage == 3: draw_line(p-boss.dir*boss.size*0.6,p-boss.dir*boss.size*1.8,color.darkened(0.2),boss.size*0.55,true)
	_draw_fish(p,boss.size,boss.dir,color,boss.age*2,true,true)
	if stage == 2:
		var normal: Vector2 = Vector2(-boss.dir.y,boss.dir.x)
		draw_line(p-boss.dir*boss.size,p-boss.dir*boss.size*1.6+normal*18,color.darkened(0.12),9,true)
		draw_line(p-boss.dir*boss.size,p-boss.dir*boss.size*1.6-normal*18,color.darkened(0.12),9,true)
	elif stage == 3:
		for i in range(3): draw_circle(p+boss.dir*(-boss.size*0.5+i*boss.size*0.35),3.5,Color("ded8ff"))
	elif stage == 4:
		for i in range(12):
			var a = i*TAU/12
			var offset = Vector2(cos(a)*boss.size*0.88,sin(a)*boss.size*0.6)
			draw_line(p+offset,p+offset*1.25,color.darkened(0.25),3,true)
	elif stage == 5:
		var start = p+Vector2(0,-boss.size*0.35)
		var light = p+Vector2(30,-boss.size-20)
		draw_polyline(PackedVector2Array([start,start+Vector2(0,-50),light]),color.darkened(0.2),2,true)
		draw_circle(light,22,Color(GOLD,0.12))
		draw_circle(light,8,GOLD)

func _draw_jelly(p: Vector2,r: float,phase: float) -> void:
	var top = PackedVector2Array()
	for i in range(21):
		var angle = PI+i*PI/20
		top.append(p+Vector2(cos(angle)*r,sin(angle)*r*0.7))
	top.append(p+Vector2(r,5))
	top.append(p+Vector2(-r,5))
	draw_colored_polygon(top,Color(0.76,0.63,0.9,0.65))
	for i in range(4):
		var points = PackedVector2Array()
		for j in range(7): points.append(p+Vector2(-r*0.7+i*r*0.45+sin(phase+j*0.6)*3,j*4.0+3))
		draw_polyline(points,Color(0.8,0.69,0.92,0.6),2,true)
	draw_circle(p+Vector2(-5,-4),2,Color("4d4770"))
	draw_circle(p+Vector2(5,-4),2,Color("4d4770"))

func _draw_hud() -> void:
	draw_rect(Rect2(0,0,W,SEA_TOP),Color("f8fcf4"))
	_text("第 %d 关：%s" % [stage,STAGES[stage-1].name],Vector2(24,31),23,INK)
	_text(STAGES[stage-1].boss,Vector2(24,57),15,STAGES[stage-1].color.darkened(0.38))
	_text("生命 %.0f / %.0f" % [boss.hp,boss.max_hp],Vector2(24,84),14,CORAL.darkened(0.32))
	var note = "攻击会使 Boss 变小。长大到目标体型后吞噬它。"
	if stage == 1: note = "躲开冲刺，从侧面或趁喘息撞击大鱼。"
	_text(note,Vector2(310,30),14,MUTED)
	var goal: float = radius_player if boss.hp <= 0 and not boss.invincible else boss.size*1.1
	var initial = minf(21+carry_size,goal-1)
	var progress = clampf((radius_player-initial)/maxf(1,goal-initial),0,1)
	_panel(Rect2(310,48,480,10),Color("d2e4de"),Color.TRANSPARENT,5)
	if progress > 0: _panel(Rect2(310,48,maxf(10,480*progress),10),MINT,Color.TRANSPARENT,5)
	_text("体型 %.1f / %.1f" % [radius_player,goal],Vector2(310,84),15,MINT)
	if progress >= 1: _text("Boss 虚弱，靠近吞噬" if boss.hp <= 0 else "可以吞噬",Vector2(545,84),15,GOLD.darkened(0.3))
	else: _text("攻击可降低目标",Vector2(545,84),14,MUTED)
	for i in range(max_health): draw_circle(Vector2(894+i*22,25),7,CORAL if i < health else Color("d4ded8"))
	if shield > 0: _text("护盾 %d" % shield,Vector2(886,57),14,MUTED)
	_text("吞噬 %d 条鱼" % total_eaten,Vector2(886,83),13,MUTED)
	var seconds = int(ceil(_remaining_time()))
	var timer_color = CORAL.darkened(0.25) if seconds <= 20 else GOLD.darkened(0.3)
	var timed_out = state in ["last_hunt","hunt_hit"] or (state == "paused" and paused_from in ["last_hunt","hunt_hit"])
	_center_text("已满" if timed_out else "%02d:%02d" % [seconds/60,seconds%60],Vector2(1100,41),31,timer_color)
	_center_text("警戒倒计时",Vector2(1100,65),12,MUTED)
	_button(Rect2(1184,17,72,32),"暂停","pause",false)
	_text("%d / %d 关" % [stage,STAGES.size()],Vector2(1185,82),12,MUTED)
	var fraction = clampf(round_time/(STAGES[stage-1].limit+time_bonus+round_bonus),0,1)
	draw_rect(Rect2(0,SEA_TOP-3,W,3),Color(timer_color,0.08))
	draw_rect(Rect2(0,SEA_TOP-3,W*fraction,3),Color(timer_color,0.6))
	draw_rect(Rect2(0,SEA_BOTTOM+6,W,H-SEA_BOTTOM-6),Color("f3f8ef"))
	_text("本局进化",Vector2(24,609),12,MUTED)
	var upgrade_tip = ""
	for i in range(upgrades.size()):
		var up = upgrades[i]
		var rect = Rect2(127+i*204,592,192,25)
		_panel(rect,Color(up.color,0.07),Color(up.color,0.2),7)
		_center_text(up.name,rect.position+Vector2(96,18),13,up.color.darkened(0.4))
		if rect.has_point(get_global_mouse_position()): upgrade_tip = up.desc
	if upgrades.is_empty(): _text("击败 Boss 后获得技能和进化。",Vector2(127,609),13,MUTED)
	var hint = "冲刺撞中大鱼，会削减生命和体型。\n不要等警戒归零，大鱼会发动无敌追杀。"
	_skill_slot(Rect2(24,628,198,58),"空格","冲刺",dash_cooldown,maxf(1.4,3.2*dash_factor),MINT,"dash")
	for i in range(3):
		var rect = Rect2(236+i*212,628,198,58)
		if i >= equipped_skills.size():
			if _draw_locked_slot(rect,["Q","E","R"][i],i): hint = "每击败一个 Boss，可以选择一个技能。\n技能栏满了以后，可以替换或保留技能。"
		else:
			var id = equipped_skills[i]
			var data = _skill_data(id)
			if _skill_slot(rect,["Q","E","R"][i],data.name,_skill_cd(id),_skill_max_cd(id),data.color,id): hint = data.desc
	if not upgrade_tip.is_empty(): hint = upgrade_tip
	var hint_lines = hint.split("\n")
	for i in range(hint_lines.size()): _text(hint_lines[i],Vector2(885,649+i*22),12,MUTED)
	_text("鼠标移动" if mouse_control else "键盘移动",Vector2(24,708),11,MUTED)
	_text("M 切换控制",Vector2(148,708),11,MUTED)
	_text("ESC 暂停",Vector2(280,708),11,MUTED)
	_text("F11 全屏",Vector2(389,708),11,MUTED)
	_text("V 开关声音",Vector2(505,708),11,MUTED)

func _skill_slot(rect: Rect2,key: String,label: String,cooldown: float,maximum: float,color: Color,action: String) -> bool:
	var hover = rect.has_point(get_global_mouse_position())
	var accent = color.darkened(0.36)
	var flash: float = skill_flashes.get(action,0.0)
	var active = 0.0
	match action:
		"dash": active = dash_remaining
		"whirl": active = whirl_remaining
		"sonar": active = sonar_ring
		"bubble": active = bubble_remaining
		"bite": active = bite_flash
		"ink": active = ink_remaining
	var border = Color(accent,0.45 if cooldown <= 0 else 0.15)
	if skill_block_flashes.get(action,0.0) > 0: border = CORAL.darkened(0.15)
	_panel(rect,Color("e6f2ed") if hover else Color("f8fbf5"),border,12)
	var icon_rect = Rect2(rect.position+Vector2(10,6),Vector2(48,46))
	var center = icon_rect.get_center()
	_panel(icon_rect,Color(accent,0.08 if cooldown <= 0 else 0.045),Color(accent,0.24 if cooldown <= 0 else 0.1),9)
	# Keep the same symbol visible behind its cooldown, with desaturated translucent strokes.
	var icon_color = accent if cooldown <= 0 else accent.lerp(MUTED,0.65)
	_draw_skill_icon(action,center,18.0,icon_color,1.0 if cooldown <= 0 else 0.22)
	if cooldown > 0:
		var fraction = clampf(cooldown/maximum,0,1)
		var wipe = PackedVector2Array([center])
		var samples = maxi(2,int(72*fraction))
		for i in range(samples+1):
			var a = -PI/2+TAU*fraction*float(i)/samples
			var direction = Vector2.from_angle(a)
			var distance = minf(22/maxf(absf(direction.x),0.001),21/maxf(absf(direction.y),0.001))
			wipe.append(center+direction*distance)
		draw_colored_polygon(wipe,Color(0.42,0.52,0.51,0.105))
		var value = "%.1f" % cooldown if cooldown < 1 else "%d" % int(ceil(cooldown))
		var number_size = 17 if cooldown < 1 else 23
		_center_text(value,center+Vector2(1,8),number_size,Color(1,1,1,0.85))
		_center_text(value,center+Vector2(0,7),number_size,INK)
	if flash > 0:
		var pad = (0.85-flash)*6
		_panel(icon_rect.grow(pad),Color.TRANSPARENT,Color(MINT,flash*0.7),11)
	_panel(Rect2(rect.position+Vector2(70,8),Vector2(44,20)),Color(accent,0.09),Color.TRANSPARENT,5)
	_center_text(key,rect.position+Vector2(92,23),12,accent)
	_text(label,rect.position+Vector2(125,24),17 if label.length() > 3 else 19,INK)
	var status = "就绪" if cooldown <= 0 else "冷却中"
	if state in ["last_hunt","hunt_hit"]: status = "已被锁定"
	elif active > 0: status = "生效 %.1fs" % active
	_text(status,rect.position+Vector2(73,47),13,accent)
	if cooldown > 0 and active <= 0: _text("秒",rect.position+Vector2(171,46),11,MUTED)
	buttons.append({"rect":rect,"action":action})
	return hover

func _draw_title() -> void:
	_text("Tidebound 0.8",Vector2(80,93),17,MUTED)
	_text("潮汐进化",Vector2(73,203),73,INK)
	_text("撞击大鱼，使它变小，再把它吞掉。",Vector2(80,264),23,INK)
	_text("开局只有冲刺。击败 Boss 后选择技能和进化。",Vector2(80,311),18,MUTED)
	_text("警戒满了，大鱼会发动无敌追杀。",Vector2(80,344),18,MUTED)
	_button(Rect2(80,391,270,64),"开始游戏","start",true)
	_panel(Rect2(80,493,592,150),Color("eaf4e8"),Color(MINT,0.15),16)
	_text("鼠标控制移动，也可以用 WASD。",Vector2(100,527),16,INK)
	_text("空格冲刺",Vector2(100,565),16,MINT)
	_text("过关后逐步解锁技能",Vector2(360,565),16,MINT)
	_text("技能放入 Q、E、R 栏",Vector2(100,601),16,MINT)
	_text("技能栏满后可以替换",Vector2(360,601),16,MINT)
	_text("窗口外仍会继续游动，按 ESC 可以暂停。",Vector2(80,679),13,MUTED)
	var hero = Vector2(934+sin(clock_time*0.7)*15,320+sin(clock_time)*12)
	draw_circle(hero,160,Color(0.6,0.8,0.67,0.035))
	_draw_fish(Vector2(1070,510),89,Vector2(-1,-0.1).normalized(),CORAL,clock_time*1.5,true,true)
	_draw_fish(hero,62,Vector2(1,-0.1).normalized(),GOLD,clock_time*3,false,false)
	for i in range(6): _draw_fish(Vector2(827+i*45,171+sin(clock_time+i*0.7)*17),12+i%3*3,Vector2.LEFT,[MINT,Color("8dcced"),GOLD][i%3],clock_time*3+i,false,false)
	for i in range(4):
		var r = 100+i*15+sin(clock_time*2+i)*4
		draw_arc(hero,r,0.3+i*0.2,1.4+i*0.2,30,Color(MINT,0.1),2,true)
	_text("F11 可以切换全屏",Vector2(1023,679),13,MUTED)

func _draw_upgrade() -> void:
	draw_rect(Rect2(0,0,W,H),Color("eff6ed"))
	_center_text("选择进化",Vector2(W/2,90),35,INK)
	_center_text("第 %d 关完成。选择后进入 %s。" % [stage,STAGES[stage].name],Vector2(W/2,131),17,MUTED)
	for i in range(offers.size()):
		var up = offers[i]
		var rect = Rect2(106+i*366,174,336,350)
		var hover = rect.has_point(get_global_mouse_position())
		_panel(rect,Color("e1efea") if hover else Color("f9fcf5"),Color(up.color,0.8 if hover else 0.3),18)
		_text(up.category,rect.position+Vector2(25,36),14,up.color.darkened(0.4))
		_evolution_icon(up.id,rect.position+Vector2(168,101),up.color.darkened(0.4))
		_center_text(up.name,rect.position+Vector2(168,176),26,INK)
		var lines = up.desc.split("\n")
		for j in range(lines.size()): _center_text(lines[j],rect.position+Vector2(168,224+j*28),16,MUTED)
		_center_text("按 %d 选择" % (i+1),rect.position+Vector2(168,312),16,INK)
		buttons.append({"rect":rect,"action":"upgrade%d" % i})
	_center_text("过关最多恢复 1 点生命。当前生命 %d / %d。" % [health,max_health],Vector2(W/2,577),16,MUTED)
	_center_text("下一关限时 %d 秒。选择界面不会增加警戒。" % int(STAGES[stage].limit+time_bonus),Vector2(W/2,616),15,MUTED)
	_center_text("进化只保留在这次冒险中。",Vector2(W/2,664),13,MUTED)

func _draw_pause() -> void:
	draw_rect(Rect2(0,0,W,H),Color(0.94,0.98,0.94,0.96))
	_panel(Rect2(405,204,470,300),Color("f8fcf4"),Color(MINT,0.22),22)
	_center_text("已暂停",Vector2(W/2,263),32,INK)
	_center_text("倒计时和技能冷却都已停止。",Vector2(W/2,305),16,MUTED)
	_button(Rect2(450,342,380,54),"继续游戏","resume",true)
	_button(Rect2(450,422,380,48),"结束本局，返回标题","home",false)

func _draw_result() -> void:
	draw_rect(Rect2(0,0,W,H),Color("f3f8ef"))
	var victory = state == "won"
	_center_text("通关" if victory else "GAME OVER",Vector2(W/2,162),42,INK)
	_center_text("六关全部完成。" if victory else "第 %d 关：%s" % [stage,failure_reason],Vector2(W/2,207),18,MINT if victory else CORAL.darkened(0.2))
	_panel(Rect2(330,245,620,120),Color("f8fcf4"),Color(MINT,0.17),16)
	_center_text("吞噬的鱼",Vector2(445,279),14,MUTED)
	_center_text("%d" % total_eaten,Vector2(445,324),29,GOLD)
	_center_text("得分",Vector2(640,279),14,MUTED)
	_center_text("%d" % score,Vector2(640,324),29,GOLD)
	_center_text("本局用时",Vector2(835,279),14,MUTED)
	_center_text("%02d:%02d" % [int(total_time)/60,int(total_time)%60],Vector2(835,324),29,GOLD)
	_center_text("本局进化",Vector2(W/2,403),14,MUTED)
	if upgrades.is_empty(): _center_text("尚未获得",Vector2(W/2,435),15,MUTED)
	else:
		for i in range(upgrades.size()):
			var up = upgrades[i]
			var x = W/2-(upgrades.size()*180)/2.0+i*180
			_panel(Rect2(x,418,166,31),Color(up.color,0.08),Color(up.color,0.22),8)
			_center_text(up.name,Vector2(x+83,440),14,up.color.darkened(0.4))
	_button(Rect2(466,492,348,59),"再玩一局","start",true)
	_button(Rect2(466,571,348,43),"返回标题","home",false)
	var tip = "冲刺和冲击声波能削减 Boss 生命，让它变小。"
	_center_text(tip,Vector2(W/2,671),15,MUTED)

func _prepare_capture() -> void:
	mouse_control = false
	if capture_mode == "title": return
	_new_run(872134)
	if capture_mode == "skill_reward":
		_win_stage()
		skill_offers = ["whirl","sonar","bubble"]
	elif capture_mode == "skill_replace":
		stage = 4
		_start_stage()
		equipped_skills = ["sonar","whirl","bubble"]
		pending_skill = "bite"
		state = "skill_replace"
	elif capture_mode == "upgrade":
		equipped_skills = ["sonar"]
		_begin_evolution_reward()
		offers = [EVOLUTIONS[1],EVOLUTIONS[11],EVOLUTIONS[3]]
	elif capture_mode in ["hunt","hunt_charge","hunt_hit"]:
		round_time = STAGES[0].limit
		_start_hunt()
		hunt_timer = 0.3
		if capture_mode == "hunt_charge": hunt_phase = "charge"; boss.pos = position_player+Vector2(420,0); hunt_timer = 0
		elif capture_mode == "hunt_hit":
			state = "hunt_hit"
			hunt_timer = 0
			health = 0
			boss.pos = position_player+Vector2(15,0)
			_burst(position_player,CORAL,55)
	elif capture_mode == "timeout":
		_fail("领地警戒已满，大鱼的无敌冲刺击中了你。")
	elif capture_mode == "combat":
		stage = 2
		_start_stage()
		equipped_skills = ["sonar"]
		position_player = Vector2(620,345)
		boss.pos = Vector2(900,330)
		boss.hp = boss.max_hp*0.43
		boss.size = lerpf(boss.base_size,boss.min_size,0.57)
		radius_player = 31
		boss.attack = "double"
		boss.phase = "warn"
		boss.target = Vector2.LEFT
		boss.timer = 10
		round_time = 32
		sonar_cooldown = 5.7
		dash_cooldown = 1.8
		message_remaining = 0
	elif capture_mode == "won":
		stage = 6
		_start_stage()
		equipped_skills = ["sonar","bite","bubble"]
		state = "won"
		total_time = 338
		total_eaten = 280
		score = 6400

func _save_capture() -> void:
	await RenderingServer.frame_post_draw
	var path = "res://../work/preview_v8_%s.png" % capture_mode
	var result = get_viewport().get_texture().get_image().save_png(path)
	print("CAPTURE ",capture_mode," result=",result," path=",path)
	get_tree().quit(0 if result == OK else 1)

func _evolution_icon(id: String,p: Vector2,color: Color) -> void:
	draw_circle(p,43,Color(color,0.065))
	draw_arc(p,43,0,TAU,64,Color(color,0.24),1,true)
	if id in ["food","carry"]:
		_draw_fish(p,24,Vector2.RIGHT,color,clock_time*2,false,false)
		if id == "carry": draw_arc(p,32,0.2,2.5,25,color,2,true)
	elif id in ["shell","growthshield"]:
		var points = PackedVector2Array([p+Vector2(-23,-20),p+Vector2(23,-20),p+Vector2(20,12),p+Vector2(0,29),p+Vector2(-20,12),p+Vector2(-23,-20)])
		draw_polyline(points,color,3,true)
		if id == "shell": draw_circle(p,7,color)
		else:
			for i in range(3): draw_arc(p+Vector2(-12+i*12,0),7,0,PI,12,color,2,true)
	elif id in ["heal","bubble_heal"]:
		if id == "bubble_heal": draw_arc(p,28,0,TAU,45,Color(color,0.7),2,true)
		draw_line(p+Vector2(-17,0),p+Vector2(17,0),color,6,true)
		draw_line(p+Vector2(0,-17),p+Vector2(0,17),color,6,true)
	elif id in ["speed","dash","swiftfood"]:
		for i in range(3):
			var x = p.x-27+i*20
			draw_polyline(PackedVector2Array([Vector2(x,p.y-15),Vector2(x+13,p.y),Vector2(x,p.y+15)]),color,3,true)
	elif id in ["whirl","whirl_cd"]:
		var points = PackedVector2Array()
		for i in range(80):
			var t = float(i)/79
			points.append(p+Vector2.from_angle(t*TAU*1.5+clock_time*0.4)*(4+t*29))
		draw_polyline(points,color,3,true)
		if id == "whirl_cd": draw_circle(p+Vector2(20,-24),5,color)
	elif id in ["sonar","sonar_cd","echo"]:
		for i in range(3): draw_arc(p+Vector2(-15,0),12+i*11,-1.0,1.0,24,color,3,true)
		draw_circle(p+Vector2(-18,0),4,color)
		if id == "echo": draw_circle(p+Vector2(-29,0),3,Color(color,0.5))
	elif id == "bubble":
		draw_circle(p,28,Color(color,0.13))
		draw_arc(p,28,0,TAU,45,color,2,true)
		draw_arc(p+Vector2(-5,-6),15,PI,PI*1.6,18,WHITE,2,true)
	elif id == "time":
		draw_arc(p,27,0,TAU,45,color,2,true)
		draw_line(p,p+Vector2(0,-17),color,3,true)
		draw_line(p,p+Vector2(13,8),color,3,true)
		draw_circle(p,3,color)
	elif id in ["glutton","harvest"]:
		draw_arc(p,28,0.65,TAU-0.65,45,color,3,true)
		draw_line(p,p+Vector2.from_angle(0.65)*28,color,3,true)
		draw_line(p,p+Vector2.from_angle(-0.65)*28,color,3,true)
		for i in range(3): draw_circle(p+Vector2(15+i*8,0),2.5,color)
	else:
		for i in range(3):
			var x = p.x-22+i*22
			draw_line(Vector2(x,p.y+20),Vector2(x,p.y+4-i*13),color,7,true)


func _text(value: String,p: Vector2,size: int,color: Color) -> void:
	draw_string(font,p,value,HORIZONTAL_ALIGNMENT_LEFT,-1,size,color)

func _center_text(value: String,p: Vector2,size: int,color: Color) -> void:
	var width = font.get_string_size(value,HORIZONTAL_ALIGNMENT_LEFT,-1,size).x
	_text(value,p-Vector2(width/2,0),size,color)

func _panel(rect: Rect2,fill: Color,border: Color,corner: int) -> void:
	var box = StyleBoxFlat.new()
	box.bg_color = fill
	box.border_color = border
	box.set_border_width_all(1 if border.a > 0 else 0)
	box.set_corner_radius_all(corner)
	draw_style_box(box,rect)

func _button(rect: Rect2,label: String,action: String,primary: bool) -> void:
	var hover = rect.has_point(get_global_mouse_position())
	var fill = MINT.lightened(0.08) if primary and hover else (MINT if primary else Color("e4f0e6"))
	_panel(rect,fill,Color(MINT,0.6 if hover else 0.2),12)
	_center_text(label,rect.position+Vector2(rect.size.x/2,rect.size.y/2+7),19 if rect.size.y > 50 else 14,Color("fffef6") if primary else INK)
	buttons.append({"rect":rect,"action":action})

func _init_audio() -> void:
	for i in range(5):
		var player = AudioStreamPlayer.new()
		add_child(player)
		sound_players.append(player)
	var tones = {"ready":[880.0,1150.0,0.045],"eat":[650.0,1050.0,0.065],"dash":[380.0,150.0,0.17],"hurt":[170.0,75.0,0.22],"choice":[440.0,880.0,0.2],"win":[520.0,1040.0,0.33]}
	for key in tones:
		var tone = tones[key]
		var samples = int(22050*tone[2])
		var data = PackedByteArray()
		data.resize(samples*2)
		var phase = 0.0
		for i in range(samples):
			var t = float(i)/samples
			phase += lerpf(tone[0],tone[1],t)*TAU/22050
			var value = int(sin(phase)*sin(t*PI)*pow(1-t,2)*7000)
			data.encode_s16(i*2,value)
		var stream = AudioStreamWAV.new()
		stream.format = AudioStreamWAV.FORMAT_16_BITS
		stream.mix_rate = 22050
		stream.data = data
		sounds[key] = stream

func _sound(key: String,volume: float) -> void:
	if muted or not capture_mode.is_empty() or "--self-test" in OS.get_cmdline_user_args() or "--input-test" in OS.get_cmdline_user_args(): return
	for player in sound_players:
		if not player.playing:
			player.stream = sounds[key]
			player.volume_db = linear_to_db(volume*0.32)
			player.play()
			return



func _send_key(code: int,pressed: bool = true) -> void:
	var event = InputEventKey.new()
	event.keycode = code
	event.physical_keycode = code
	event.pressed = pressed
	Input.parse_input_event(event)
	Input.flush_buffered_events()

func _tap(code: int) -> void:
	_send_key(code)
	_send_key(code,false)

func _click_at(p: Vector2) -> void:
	var event = InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	event.position = get_viewport().get_final_transform()*get_global_transform_with_canvas()*p
	Input.parse_input_event(event)
	Input.flush_buffered_events()
	var release = event.duplicate()
	release.pressed = false
	Input.parse_input_event(release)
	Input.flush_buffered_events()

func _run_input_tests() -> void:
	muted = true
	await get_tree().process_frame
	await get_tree().process_frame
	_tap(KEY_ENTER)
	assert(state == "playing" and equipped_skills.is_empty())
	_tap(KEY_Q)
	assert(whirl_cooldown == 0 and sonar_cooldown == 0)
	mouse_control = false
	invulnerable = 100
	var initial_x = position_player.x
	_send_key(KEY_D)
	await get_tree().create_timer(0.18).timeout
	_send_key(KEY_D,false)
	assert(position_player.x > initial_x+15)
	_tap(KEY_SPACE)
	assert(dash_cooldown > 0)
	_tap(KEY_ESCAPE)
	var saved = round_time
	await get_tree().create_timer(0.12).timeout
	assert(state == "paused" and round_time == saved)
	_tap(KEY_ESCAPE)
	_win_stage()
	skill_offers = ["sonar","whirl","bubble"]
	_tap(KEY_1)
	assert(state == "upgrade" and equipped_skills == ["sonar"])
	_tap(KEY_1)
	assert(stage == 2 and state == "playing")
	_tap(KEY_Q)
	assert(sonar_cooldown > 0)
	_win_stage()
	skill_offers = ["sonar","whirl","bubble"]
	await get_tree().process_frame
	await get_tree().process_frame
	_click_at(Vector2(640,340))
	assert(state == "upgrade" and equipped_skills == ["sonar","whirl"])
	await get_tree().process_frame
	await get_tree().process_frame
	_click_at(Vector2(640,340))
	assert(stage == 3)
	_win_stage()
	skill_offers = ["bubble"]
	_tap(KEY_1)
	_tap(KEY_1)
	assert(stage == 4 and equipped_skills.size() == 3)
	_win_stage()
	skill_offers = ["bite","ink","keep"]
	_tap(KEY_1)
	assert(state == "skill_replace")
	_tap(KEY_2)
	assert(state == "upgrade" and equipped_skills[1] == "bite")
	_tap(KEY_2)
	assert(stage == 5)
	_win_stage()
	skill_offers = ["ink","keep"]
	_tap(KEY_2)
	_tap(KEY_3)
	assert(stage == 6)
	_win_stage()
	assert(state == "won")
	_tap(KEY_ENTER)
	assert(equipped_skills.is_empty())
	get_window().size = Vector2i(1000,700)
	_win_stage()
	skill_offers = ["sonar","whirl","bubble"]
	await get_tree().process_frame
	await get_tree().process_frame
	_click_at(Vector2(273,340))
	await get_tree().process_frame
	await get_tree().process_frame
	_click_at(Vector2(640,340))
	assert(state == "playing" and stage == 2 and equipped_skills == ["sonar"])
	_tap(KEY_F11)
	await get_tree().process_frame
	assert(get_window().mode == Window.MODE_FULLSCREEN)
	_tap(KEY_F11)
	await get_tree().process_frame
	assert(get_window().mode == Window.MODE_WINDOWED)
	print("PASS: locked buttons, WASD/dash, pause, skill-then-evolution, dynamic Q binding, mouse rewards, replacing a slot, keeping loadout, six stages, restart, letterboxed clicks, fullscreen")
	get_tree().quit(0)

func _run_self_tests() -> void:
	muted = true
	_new_run(100)
	assert(health == 4 and equipped_skills.is_empty() and STAGES.size() == 6)
	_cast_slot(0)
	_sonar()
	_whirl()
	_bubble()
	assert(sonar_cooldown == 0 and whirl_remaining == 0 and bubble_remaining == 0)
	entities.clear()
	position_player = boss.pos-Vector2(20,0)
	facing = Vector2.RIGHT
	var hp = boss.hp
	var size = boss.size
	_dash()
	_resolve_collisions()
	assert(boss.hp == hp-dash_damage and boss.size < size)
	var after_hit = boss.hp
	_resolve_collisions()
	assert(boss.hp == after_hit)
	_new_run(100)
	equipped_skills = ["sonar"]
	entities.clear()
	position_player = boss.pos-Vector2(150,0)
	shots.append({"pos":position_player+Vector2(50,0),"vel":Vector2.LEFT,"life":3.0,"size":8.0,"color":GOLD})
	mines.append({"pos":position_player+Vector2(50,0),"warning":0.0,"life":6.0,"size":29.0})
	hp = boss.hp
	size = boss.size
	_sonar()
	assert(boss.hp == hp-sonar_damage and boss.size < size and shots.is_empty() and mines.is_empty())
	_sonar()
	assert(boss.hp == hp-sonar_damage)
	# A shrinking boss must never make eating food shrink the player.
	radius_player = 40
	boss.size = 29
	_eat({"pos":position_player,"kind":"food","size":10.0,"gold":false,"tint":MINT})
	assert(radius_player > 40)
	_new_run(151)
	entities.clear()
	boss.hp = 0
	boss.size = boss.min_size
	position_player = boss.pos
	assert(radius_player < boss.size*1.1)
	_resolve_collisions()
	assert(state == "skill_reward")
	_new_run(200)
	var before = position_player
	pointer_outside = true
	last_move = Vector2.RIGHT
	_tick_game(0.1,0.1,_mouse_direction(position_player))
	assert(position_player.x > before.x+20)
	pointer_outside = false
	# Timeout locks combat before a possible swallow; the kill happens on contact.
	round_time = STAGES[0].limit-0.1
	radius_player = boss.size*1.1+1
	position_player = boss.pos
	_tick_game(0.05,0.2,Vector2.ZERO)
	assert(state == "last_hunt" and health == 4 and boss.invincible)
	hp = boss.hp
	assert(not _damage_boss(100,position_player,"test") and boss.hp == hp)
	_win_stage()
	assert(state == "last_hunt")
	_toggle_pause()
	var saved_hunt = hunt_timer
	_process(0.5)
	assert(state == "paused" and hunt_timer == saved_hunt)
	_toggle_pause()
	assert(state == "last_hunt")
	for i in range(80):
		if state == "dead": break
		_tick_hunt(0.1)
	assert(state == "dead" and health == 0 and "领地警戒" in failure_reason and hunt_elapsed >= 1.25)
	_new_run(321)
	var plan = ["sonar","whirl","bubble","bite","ink"]
	for s in range(1,6):
		assert(stage == s)
		_win_stage()
		assert(state == "skill_reward")
		skill_offers = [plan[s-1]]
		_choose_skill(0)
		if s > 3:
			assert(state == "skill_replace")
			_replace_skill(1 if s == 4 else 2)
		assert(state == "upgrade" and stage == s)
		for up in offers:
			if up.id in ["whirl","whirl_cd"]: assert(_owns_skill("whirl"))
			if up.id in ["sonar","sonar_cd","echo","harvest"]: assert(_owns_skill("sonar"))
			if up.id in ["bubble","bubble_heal"]: assert(_owns_skill("bubble"))
		_choose_upgrade(0)
	assert(stage == 6 and equipped_skills == ["sonar","bite","ink"] and upgrades.size() == 5)
	_win_stage()
	assert(state == "won")
	_new_run()
	assert(stage == 1 and equipped_skills.is_empty() and health == 4 and stats.boss_damage == 0)
	# Stress each habitat without changing attack logic or object lifetime limits.
	for s in range(1,7):
		stage = s
		_start_stage()
		for i in range(int(minf(60,STAGES[s-1].limit-2)*30)):
			invulnerable = 1000
			radius_player = 21
			_tick_game(1.0/30,1.0/30,Vector2.ZERO)
			particles.clear()
			assert(entities.size() <= 85 and shots.size() <= 48 and mines.size() <= 16 and volleys.size() <= 4)
		assert(state == "playing")
	print("PASS: starting locks, dash damage once, shock damage and shrink, projectile clear, no growth regression, cursor exit, warning/pursuit/contact death, pause hunt, skill unlock/replacement, prerequisite rewards, six stages, reset, bounded habitat stress")
	get_tree().quit(0)

func _boss_enraged() -> bool:
	return stage == 6 and boss.hp > 0 and (boss.hp <= boss.max_hp*0.55 or round_time >= 34.0)

func _update_skill_feedback(dt: float) -> void:
	var current = {"dash":dash_cooldown,"whirl":whirl_cooldown,"sonar":sonar_cooldown,"bubble":bubble_cooldown,"bite":bite_cooldown,"ink":ink_cooldown}
	for id in current:
		skill_flashes[id] = maxf(0,skill_flashes.get(id,0.0)-dt)
		skill_block_flashes[id] = maxf(0,skill_block_flashes.get(id,0.0)-dt)
		if state == "playing" and last_cooldowns.get(id,0.0) > 0 and current[id] <= 0:
			skill_flashes[id] = 0.85
			_sound("ready",0.22)
	last_cooldowns = current

func _skill_blocked(action: String,cooldown: float) -> bool:
	if cooldown <= 0: return false
	if skill_block_flashes.get(action,0.0) <= 0:
		var name = "冲刺" if action == "dash" else _skill_data(action).name
		_notice("%s还需冷却 %.1f 秒。" % [name,cooldown],CORAL,1.0)
	skill_block_flashes[action] = 0.25
	return true

func _draw_leviathan(p: Vector2,r: float,direction: Vector2,phase: float,enraged: bool,edible: bool) -> void:
	draw_set_transform(p,direction.angle(),Vector2(1,-1 if direction.x < 0 else 1))
	var armor = Color("28576b") if not enraged else Color("4a4266")
	if edible: armor = Color("687651")
	var ridge = Color("6599a4") if not enraged else Color("b67186")
	var eye = Color("64dfc7") if not enraged else Color("ff9b70")
	var sway = sin(phase*3.0)*r*0.13
	var tail = PackedVector2Array([Vector2(-r*0.6,-r*0.24),Vector2(-r*1.3,-r*0.18+sway),Vector2(-r*1.8,-r*0.48+sway),Vector2(-r*1.57,sway),Vector2(-r*1.84,r*0.5+sway),Vector2(-r*1.25,r*0.2+sway),Vector2(-r*0.6,r*0.23)])
	draw_colored_polygon(tail,armor.darkened(0.16))
	for sign_value in [-1,1]:
		var wing = PackedVector2Array([Vector2(-r*0.28,sign_value*r*0.1),Vector2(-r*0.85,sign_value*r*0.88+sway*0.25),Vector2(-r*0.35,sign_value*r*0.78),Vector2(r*0.24,sign_value*r*0.34)])
		draw_colored_polygon(wing,ridge.darkened(0.15))
		draw_line(wing[0],wing[1],armor.darkened(0.3),2,true)
	var body = PackedVector2Array([Vector2(-r*0.84,0),Vector2(-r*0.57,-r*0.52),Vector2(-r*0.12,-r*0.66),Vector2(r*0.4,-r*0.55),Vector2(r*0.88,-r*0.3),Vector2(r*1.02,0),Vector2(r*0.83,r*0.39),Vector2(r*0.33,r*0.55),Vector2(-r*0.24,r*0.52),Vector2(-r*0.65,r*0.3)])
	draw_colored_polygon(body,armor)
	var outline = body.duplicate()
	outline.append(body[0])
	draw_polyline(outline,armor.darkened(0.3),2,true)
	draw_colored_polygon(PackedVector2Array([Vector2(-r*0.47,r*0.27),Vector2(r*0.68,r*0.19),Vector2(r*0.55,r*0.42),Vector2(-r*0.23,r*0.4)]),ridge)
	for i in range(5):
		var x = (-0.65+i*0.23)*r
		var y = -r*(0.42+sin(float(i)/4*PI)*0.21)
		draw_colored_polygon(PackedVector2Array([Vector2(x,y),Vector2(x+r*0.06,y-r*(0.28+sin(i)*0.06)),Vector2(x+r*0.19,y+r*0.04)]),ridge.lightened(0.07))
		var scale = PackedVector2Array([Vector2(x+r*0.05,-r*0.29),Vector2(x+r*0.22,-r*0.14),Vector2(x+r*0.19,r*0.17),Vector2(x+r*0.02,r*0.03)])
		draw_colored_polygon(scale,armor.lightened(0.09))
		draw_polyline(PackedVector2Array([scale[0],scale[1],scale[2]]),Color(ridge,0.7),1.5,true)
	var mouth = PackedVector2Array([Vector2(r*0.47,r*0.08),Vector2(r*0.96,-r*0.03),Vector2(r*0.8,r*0.33),Vector2(r*0.42,r*0.3)])
	draw_colored_polygon(mouth,Color("102b3d"))
	for i in range(4):
		var x = r*(0.51+i*0.095)
		var y = r*(0.09-i*0.022)
		draw_colored_polygon(PackedVector2Array([Vector2(x,y),Vector2(x+r*0.035,y+r*0.135),Vector2(x+r*0.065,y-r*0.01)]),Color("faf5de"))
	for i in range(3):
		var x = r*(0.53+i*0.1)
		draw_colored_polygon(PackedVector2Array([Vector2(x,r*0.29),Vector2(x+r*0.03,r*0.18),Vector2(x+r*0.065,r*0.29)]),Color("e7eadc"))
	var eye_pos = Vector2(r*0.61,-r*0.24)
	draw_circle(eye_pos,r*0.15,Color(eye,0.15))
	draw_colored_polygon(PackedVector2Array([eye_pos+Vector2(-r*0.14,-r*0.04),eye_pos+Vector2(r*0.12,-r*0.06),eye_pos+Vector2(r*0.065,r*0.075),eye_pos+Vector2(-r*0.095,r*0.04)]),eye)
	draw_line(eye_pos+Vector2(0,-r*0.04),eye_pos+Vector2(-r*0.015,r*0.06),Color("16323a"),r*0.035,true)
	draw_line(eye_pos+Vector2(-r*0.16,-r*0.08),eye_pos+Vector2(r*0.14,-r*0.1),armor.darkened(0.4),3,true)
	for i in range(3): draw_circle(Vector2(-r*0.38+i*r*0.25,r*0.14),r*0.03,Color(eye,0.8))
	draw_set_transform(Vector2.ZERO)


func _run_visual_tests() -> void:
	muted = true
	_new_run()
	last_cooldowns = {"dash":0.1}
	dash_cooldown = 0
	_update_skill_feedback(0.1)
	assert(skill_flashes.dash > 0.8)
	stage = 6
	_start_stage()
	boss.hp = boss.max_hp*0.5
	_tick_boss(0.01)
	assert(boss.enraged)
	_begin_boss_attack()
	assert(boss.attack == "triple" and boss.lunges == 2)
	_execute_boss_attack()
	_tick_boss(0.56)
	assert(boss.phase == "warn" and boss.lunges == 1)
	_execute_boss_attack()
	_tick_boss(0.56)
	assert(boss.phase == "warn" and boss.lunges == 0)
	_execute_boss_attack()
	_tick_boss(0.56)
	assert(boss.phase == "recover")
	print("PASS: ready feedback, boss health phase, three telegraphed lunges")
	get_tree().quit(0)

func _draw_skill_icon(action: String,p: Vector2,size: float,color: Color,opacity: float) -> void:
	var paint = Color(color,opacity)
	var light = Color(color.lightened(0.15),opacity)
	if action == "dash":
		var arrow = PackedVector2Array([p+Vector2(-size*0.9,-size*0.27),p+Vector2(size*0.12,-size*0.27),p+Vector2(size*0.12,-size*0.65),p+Vector2(size*0.96,0),p+Vector2(size*0.12,size*0.65),p+Vector2(size*0.12,size*0.27),p+Vector2(-size*0.9,size*0.27),p+Vector2(-size*0.5,0)])
		draw_colored_polygon(arrow,paint)
		draw_line(p+Vector2(-size,-size*0.6),p+Vector2(-size*0.25,-size*0.6),light,2.2,true)
		draw_line(p+Vector2(-size,size*0.6),p+Vector2(-size*0.25,size*0.6),light,2.2,true)
	elif action == "whirl":
		var points = PackedVector2Array()
		for i in range(64):
			var t = float(i)/63
			points.append(p+Vector2.from_angle(t*TAU*1.65-PI/2)*(size*0.1+t*size*0.84))
		draw_polyline(points,paint,2.9,true)
		draw_circle(p,size*0.12,light)
	elif action == "sonar":
		var origin = p+Vector2(-size*0.59,0)
		draw_circle(origin,size*0.18,paint)
		for i in range(3): draw_arc(origin,size*(0.49+i*0.45),-1.03,1.03,24,paint,2.7,true)
	elif action == "bubble":
		draw_circle(p,size*0.89,Color(color,opacity*0.12))
		draw_arc(p,size*0.89,0,TAU,48,paint,2.8,true)
		draw_arc(p+Vector2(-size*0.12,-size*0.1),size*0.56,PI*1.08,PI*1.65,18,light,2.4,true)
		draw_circle(p+Vector2(size*0.41,size*0.34),size*0.1,light)




	elif action == "bite":
		draw_arc(p,size*0.85,0.3,PI-0.3,24,paint,3,true)
		draw_arc(p,size*0.85,PI+0.3,TAU-0.3,24,paint,3,true)
		for i in range(3):
			var x = p.x-size*0.5+i*size*0.5
			draw_colored_polygon(PackedVector2Array([Vector2(x-3,p.y-size*0.65),Vector2(x,p.y-size*0.15),Vector2(x+3,p.y-size*0.65)]),paint)
	elif action == "ink":
		draw_circle(p,size*0.7,paint)
		for i in range(6): draw_circle(p+Vector2.from_angle(i*TAU/6)*size*0.78,size*0.17,paint)

func _skill_data(id: String) -> Dictionary:
	for entry in SKILLS:
		if entry.id == id: return entry
	return {"id":"","name":"未解锁","desc":"击败 Boss 后选择技能。","color":MUTED}



func _skill_cd(id: String) -> float:
	return {"dash":dash_cooldown,"whirl":whirl_cooldown,"sonar":sonar_cooldown,"bubble":bubble_cooldown,"bite":bite_cooldown,"ink":ink_cooldown}.get(id,0.0)



func _skill_max_cd(id: String) -> float:
	return {"dash":maxf(1.4,3.2*dash_factor),"whirl":whirl_cd_max,"sonar":sonar_cd_max,"bubble":bubble_cd_max,"bite":7.0,"ink":12.0}.get(id,1.0)



func _owns_skill(id: String) -> bool:
	return id == "dash" or id in equipped_skills



func _cast_slot(index: int) -> void:
	if state != "playing": return
	if index >= equipped_skills.size():
		_notice("击败 Boss 后，可以解锁这个技能栏。",MUTED,1.5)
		return
	_cast_skill(equipped_skills[index])



func _cast_skill(id: String) -> void:
	if not _owns_skill(id): return
	match id:
		"dash": _dash()
		"whirl": _whirl()
		"sonar": _sonar()
		"bubble": _bubble()
		"bite": _bite()
		"ink": _ink()



func _bite() -> void:
	if state != "playing" or not _owns_skill("bite"): return
	if _skill_blocked("bite",bite_cooldown): return
	bite_cooldown = 7.0
	bite_flash = 0.28
	skill_flashes.bite = 0
	stats.skill_casts += 1
	var offset: Vector2 = boss.pos-position_player
	if offset.length() <= 150+radius_player*0.3 and facing.dot(offset.normalized()) > 0.35:
		_damage_boss(34,position_player,"撕咬")
	_sound("choice",0.55)

func _ink() -> void:
	if state != "playing" or not _owns_skill("ink"): return
	if _skill_blocked("ink",ink_cooldown): return
	ink_cooldown = 12.0
	ink_remaining = 3.2
	ink_center = position_player
	skill_flashes.ink = 0
	stats.skill_casts += 1
	_sound("choice",0.45)



func _damage_boss(amount: float,origin: Vector2,attack: String) -> bool:
	if state != "playing" or boss.get("invincible",false) or boss.hp <= 0 or boss.hurt_cooldown > 0: return false
	# The head is armored during a charge; flanking and recovery hits do full damage.
	if attack in ["冲刺","撕咬"] and boss.phase in ["warn","charge"] and (origin-boss.pos).normalized().dot(boss.dir) > 0.25:
		amount *= 0.6 if stage == 1 else 0.45
		stats.guard_hits = stats.get("guard_hits",0)+1
		if stats.guard_hits == 1: _notice("正面硬鳞减伤，趁喘息或从侧面攻击。",GOLD,2)
	var dealt = minf(amount,boss.hp)
	boss.hp -= dealt
	boss.hurt_cooldown = 0.1
	boss.hit_flash = 0.2
	boss.size = lerpf(boss.base_size,boss.min_size,1-boss.hp/boss.max_hp)
	stats.boss_damage += dealt
	_burst(boss.pos,GOLD,9)
	if boss.hp <= 0:
		boss.phase = "wounded"
		boss.lunges = 0
		volleys.clear()
		_notice("%s已虚弱，靠近即可吞噬它。" % STAGES[stage-1].boss,GOLD,2)
	return true

func _start_hunt() -> void:
	if state != "playing": return
	state = "last_hunt"
	hunt_timer = 0
	hunt_phase = "warn"
	hunt_elapsed = 0
	boss.invincible = true
	boss.hp = boss.max_hp
	boss.phase = "last_hunt"
	boss.size = maxf(boss.size,boss.base_size*1.12)
	boss.dir = (position_player-boss.pos).normalized()
	shots.clear()
	mines.clear()
	volleys.clear()
	message_remaining = 0
	_sound("hurt",0.6)



func _tick_hunt(dt: float) -> void:
	hunt_timer += dt
	hunt_elapsed += dt
	total_time += dt
	boss.age += dt
	if state == "hunt_hit":
		if hunt_timer >= 0.6: _fail("领地警戒已满，大鱼进入无敌，最后冲刺击中了你。")
		return
	boss.dir = (position_player-boss.pos).normalized()
	if hunt_phase == "warn":
		if hunt_timer >= 1.25:
			hunt_phase = "charge"
			hunt_timer = 0
			_sound("dash",0.8)
	else:
		boss.pos = boss.pos.move_toward(position_player,dt*(950+hunt_timer*550))
		if hunt_timer >= 0.12 and boss.pos.distance_to(position_player) < (boss.size+radius_player)*0.65:
			state = "hunt_hit"
			hunt_timer = 0
			health = 0
			_burst(position_player,CORAL,55)
			camera_shake = 13
			_sound("hurt",0.8)



func _toggle_pause() -> void:
	if state in ["playing","last_hunt","hunt_hit"]:
		paused_from = state
		state = "paused"
	elif state == "paused": state = paused_from



func _generate_skill_offers() -> void:
	skill_offers.clear()
	var pool: Array[String] = []
	for skill in SKILLS:
		if skill.id not in equipped_skills: pool.append(skill.id)
	# The first choice introduces three simple roles before the close-range skills.
	if equipped_skills.is_empty(): pool = ["whirl","sonar","bubble"]
	while not pool.is_empty() and skill_offers.size() < 3:
		var index = rng.randi_range(0,pool.size()-1)
		skill_offers.append(pool[index])
		pool.remove_at(index)
	if equipped_skills.size() >= 3: skill_offers.append("keep")



func _choose_skill(index: int) -> void:
	if state != "skill_reward" or index < 0 or index >= skill_offers.size(): return
	var id = skill_offers[index]
	if id == "keep":
		_begin_evolution_reward()
	elif equipped_skills.size() < 3:
		equipped_skills.append(id)
		_begin_evolution_reward()
	else:
		pending_skill = id
		state = "skill_replace"



func _replace_skill(index: int) -> void:
	if state != "skill_replace" or index < 0 or index >= equipped_skills.size(): return
	equipped_skills[index] = pending_skill
	pending_skill = ""
	_begin_evolution_reward()



func _begin_evolution_reward() -> void:
	state = "upgrade"
	_generate_offers()



func _draw_skill_reward() -> void:
	draw_rect(Rect2(0,0,W,H),Color("eff6ed"))
	var replacing = state == "skill_replace"
	_center_text("替换哪个技能？" if replacing else "获得一个技能",Vector2(W/2,82),35,INK)
	var subtitle = "新技能：%s。选择要替换的位置。" % _skill_data(pending_skill).name if replacing else "第 %d 关完成。先选技能，再选一项进化。" % stage
	_center_text(subtitle,Vector2(W/2,125),17,MUTED)
	var count = equipped_skills.size() if replacing else skill_offers.size()
	for i in range(count):
		var id = equipped_skills[i] if replacing else skill_offers[i]
		var skill = _skill_data(id)
		var rect = Rect2(106+i*366,172,336,355)
		var hover = rect.has_point(get_global_mouse_position())
		var color: Color = skill.color.darkened(0.32)
		_panel(rect,Color("e3f0e9") if hover else Color("f9fcf5"),Color(color,0.45),18)
		if id == "keep":
			_center_text("保持",rect.position+Vector2(168,115),29,MINT)
		else: _draw_skill_icon(id,rect.position+Vector2(168,111),35,color,1.0)
		var label = "保持现有技能" if id == "keep" else skill.name
		if replacing: label = "替换 %s：%s" % [["Q","E","R"][i],skill.name]
		_center_text(label,rect.position+Vector2(168,185),23,INK)
		var desc = "继续使用现在的三个技能。\n随后仍然可以选择进化。" if id == "keep" else skill.desc
		if replacing: desc = "新技能会放入这个位置。\n已有强化保留，可重新装备后生效。"
		var lines = desc.split("\n")
		for j in range(lines.size()): _center_text(lines[j],rect.position+Vector2(168,233+j*28),15,MUTED)
		if id != "keep" and not replacing: _center_text("冷却 %.1f 秒" % _skill_max_cd(id),rect.position+Vector2(168,287),13,color)
		_center_text("按 %d 选择" % (i+1),rect.position+Vector2(168,319),16,INK)
		buttons.append({"rect":rect,"action":("replace" if replacing else "skillpick")+str(i)})
	if replacing: _button(Rect2(480,554,320,43),"返回技能选择","reward_back",false)
	elif equipped_skills.size() < 3:
		_center_text("新技能将放入 %s 键。" % ["Q","E","R"][equipped_skills.size()],Vector2(W/2,575),16,MUTED)
	else: _center_text("三个技能栏已满。选择新技能后，可以指定替换位置。",Vector2(W/2,575),16,MUTED)
	_center_text("选择界面不会增加领地警戒。",Vector2(W/2,640),14,MUTED)



func _draw_locked_slot(rect: Rect2,key: String,index: int) -> bool:
	var hover = rect.has_point(get_global_mouse_position())
	_panel(rect,Color("edf2ed"),Color(MUTED,0.17),12)
	var p = rect.position+Vector2(34,29)
	draw_arc(p+Vector2(0,-4),7,PI,TAU,20,Color(MUTED,0.35),2,true)
	_panel(Rect2(p+Vector2(-9,-4),Vector2(18,15)),Color(MUTED,0.14),Color(MUTED,0.25),3)
	_text(key,rect.position+Vector2(72,22),14,MUTED)
	_text("未解锁",rect.position+Vector2(119,24),17,MUTED)
	_text("击败 Boss 后选择",rect.position+Vector2(73,47),12,MUTED)
	buttons.append({"rect":rect,"action":"slot%d" % index})
	return hover



func _draw_hunt() -> void:
	draw_rect(Rect2(0,SEA_TOP,W,SEA_BOTTOM-SEA_TOP),Color(CORAL,0.045+0.025*sin(clock_time*16)))
	var pulse = 1.3+sin(hunt_timer*12)*0.03
	draw_arc(boss.pos,boss.size*pulse,0,TAU,90,CORAL.darkened(0.2),3,true)
	draw_arc(boss.pos,boss.size*pulse+8,0,TAU,90,Color(CORAL,0.3),2,true)
	if state == "last_hunt":
		draw_line(boss.pos,position_player,Color(CORAL,0.4),3,true)
		draw_arc(position_player,radius_player+18,0,TAU,50,CORAL.darkened(0.25),2,true)
	_panel(Rect2(290,130,700,67),Color("fff5e9"),Color(CORAL,0.6),12)
	_center_text("领地警戒已满",Vector2(W/2,157),23,CORAL.darkened(0.3))
	_center_text("大鱼察觉到你的威胁，进入无敌并发动最后冲刺。",Vector2(W/2,183),15,INK)
	if state == "hunt_hit":
		draw_circle(position_player,(1-hunt_timer/0.6)*85,Color(CORAL,0.12))



func _sim_choose_rewards(build: String) -> void:
	var builds = {
		"combat_build":["sonar","bite","bubble","whirl","ink"],
		"expert_build":["sonar","bubble","whirl","ink","bite"],
		"resource_build":["whirl","sonar","bubble","bite","ink"],
		"whirl_build":["whirl","bubble","sonar","bite","ink"],
		"growth_build":["whirl","sonar","bite","bubble","ink"],
		"tempo_build":["sonar","bite","whirl","bubble","ink"],
		"bite_build":["bite","bubble","sonar","whirl","ink"],
		"defense_build":["bubble","sonar","whirl","ink","bite"]}
	var priorities: Array = builds.get(build,["whirl","sonar","bubble","ink","bite"])
	if state == "skill_reward":
		var best = -1
		var index = 0
		for i in range(skill_offers.size()):
			var id = skill_offers[i]
			var value = 5-priorities.find(id) if id in priorities else 0
			if equipped_skills.size() >= 3 and id != "keep":
				var worst = 6
				for old in equipped_skills: worst = mini(worst,5-priorities.find(old))
				if value <= worst: value = -2
			if value > best: best = value; index = i
		_choose_skill(index)
	elif state == "skill_replace":
		var worst = 0
		for i in range(equipped_skills.size()):
			if priorities.find(equipped_skills[i]) > priorities.find(equipped_skills[worst]): worst = i
		_replace_skill(worst)
	elif state == "upgrade":
		var perk_values = {"food":60,"sonar":55,"dash":55,"shell":50,"carry":48,"bubble_heal":48,"speed":45,"whirl":43,"sonar_cd":40,"heal":45,"time":25,"glutton":20,"echo":36,"growthshield":35,"combo":30,"swiftfood":30}
		var overrides = {
			"combat_build":{"sonar":100,"sonar_cd":90,"dash":85,"food":50},
			"whirl_build":{"whirl":100,"whirl_cd":90,"food":80,"carry":75,"swiftfood":70},
			"growth_build":{"food":100,"glutton":95,"swiftfood":85,"carry":80,"whirl":75},
			"tempo_build":{"dash":100,"sonar":90,"sonar_cd":85,"speed":80},
			"bite_build":{"dash":95,"shell":80,"speed":75,"carry":65},
			"defense_build":{"shell":100,"bubble":95,"bubble_heal":90,"heal":85}}
		perk_values.merge(overrides.get(build,{}),true)
		var best = -1
		var index = 0
		for i in range(offers.size()):
			var value = perk_values.get(offers[i].id,20)
			if offers[i].id in ["heal","bubble_heal","shell"] and health < 3: value += 55
			if offers[i].id == "glutton" and (max_health <= 3 or health <= 2): value = -5
			if value > best: best = value; index = i
		_choose_upgrade(index)



func _sim_decide(policy: String) -> Vector2:
	var to_boss: Vector2 = boss.pos-position_player
	var distance = to_boss.length()
	var edible = radius_player >= boss.size*1.1 or boss.hp <= 0
	var target: Vector2 = boss.pos
	if not edible:
		var best = INF
		var jellies: Array[Dictionary] = []
		for danger in entities:
			if danger.kind == "jelly" or (danger.kind == "hunter" and radius_player < danger.size*1.1): jellies.append(danger)
		for fish in entities:
			if fish.kind == "jelly" or fish.size*1.1 > radius_player: continue
			var cost = fish.pos.distance_to(position_player)
			if fish.get("gold",false): cost *= 0.68
			if boss.hp > 0 and fish.pos.distance_to(boss.pos) < boss.size+radius_player+45: cost += 220
			for danger in jellies:
				if fish.pos.distance_to(danger.pos) < radius_player+40: cost += 110
			if cost < best: best = cost; target = fish.pos
	var direction = (target-position_player).normalized()
	var offensive = policy != "gather"
	var danger = boss.hp > 0 and distance < boss.size+radius_player+90 and not edible
	if offensive:
		if policy == "expert_build" and boss.phase == "warn" and boss.timer < 0.3 and boss.attack in ["radial","radial_burst","fan","fan_burst","sweep","spiral"] and distance < 280:
			if _owns_skill("bubble") and bubble_cooldown <= 0: _bubble()
		var aligned = facing.dot(to_boss.normalized()) > 0.82
		if not edible and boss.hp > 0 and dash_cooldown <= 0 and distance < 340 and radius_player >= 23 and boss.phase in ["recover","patrol"]:
			direction = to_boss.normalized()
			if aligned and distance < radius_player+boss.size+90: _dash()
		# Don't push the boss away while spending an offensive dash.
		var shock_window = boss.phase == "recover" if policy == "expert_build" else true
		if _owns_skill("sonar") and sonar_cooldown <= 0 and distance < sonar_radius-15 and boss.hp > 0 and dash_remaining <= 0 and shock_window: _sonar()
		if _owns_skill("bite") and bite_cooldown <= 0 and distance < 148+radius_player*0.3 and aligned: _bite()
		if _owns_skill("whirl") and whirl_cooldown <= 0:
			var food = 0
			for fish in entities:
				if fish.kind != "jelly" and radius_player >= fish.size*1.1 and fish.pos.distance_to(position_player) < whirl_radius: food += 1
			if food >= 3: _whirl()
	if danger and _owns_skill("bubble") and bubble_cooldown <= 0 and invulnerable < 0.35:
		_bubble()
	if danger and dash_remaining <= 0:
		var attack_soon = offensive and dash_cooldown <= 0 and boss.hp > 0 and facing.dot(to_boss.normalized()) > 0.65 and boss.phase in ["recover","patrol"]
		if not attack_soon:
			direction = (direction+(position_player-boss.pos).normalized()*2.0).normalized()
			if boss.phase in ["warn","charge"] and boss.attack in ["charge","double","triple"]:
				var tangent: Vector2 = boss.target.orthogonal()
				var middle = Vector2(W/2,(SEA_TOP+SEA_BOTTOM)/2)
				if (position_player+tangent*90).distance_to(middle) > (position_player-tangent*90).distance_to(middle): tangent *= -1
				direction = tangent
				if policy != "gather" and boss.timer < 0.25 and facing.dot(tangent) > 0.7: _dash()
		if offensive and _owns_skill("bubble") and boss.phase in ["charge","suction"]: _bubble()
	for fish in entities:
		if fish.kind == "hunter" and radius_player < fish.size*1.1 and fish.pos.distance_to(position_player) < radius_player+fish.size+65:
			direction = (direction+(position_player-fish.pos).normalized()*2.6).normalized()
			if offensive:
				if _owns_skill("sonar") and sonar_cooldown <= 0 and dash_remaining <= 0: _sonar()
				elif _owns_skill("bubble") and bubble_cooldown <= 0: _bubble()
				elif _owns_skill("ink") and ink_cooldown <= 0: _ink()
		if fish.kind == "jelly" and fish.pos.distance_to(position_player) < radius_player+65:
			direction = (direction+(position_player-fish.pos).normalized()*2.4).normalized()
	for shot in shots:
		if shot.pos.distance_to(position_player) < radius_player+100:
			var tangent: Vector2 = shot.vel.orthogonal().normalized()
			var middle = Vector2(W/2,(SEA_TOP+SEA_BOTTOM)/2)
			if (position_player+tangent*70).distance_to(middle) > (position_player-tangent*70).distance_to(middle): tangent *= -1
			direction = (direction+tangent*2.1).normalized()
			if offensive:
				if _owns_skill("sonar") and sonar_cooldown <= 0: _sonar()
				if _owns_skill("bubble") and bubble_cooldown <= 0: _bubble()
				if _owns_skill("ink") and ink_cooldown <= 0: _ink()
	for mine in mines:
		if position_player.distance_to(mine.pos) < radius_player+65:
			direction = (direction+(position_player-mine.pos).normalized()*2.6).normalized()
			if offensive and _owns_skill("sonar") and sonar_cooldown <= 0: _sonar()
	if edible:
		direction = to_boss.normalized()
		if offensive and _owns_skill("bubble") and distance < 180: _bubble()
	if (policy == "expert" or policy.ends_with("_build")) and dash_remaining <= 0:
		direction = _sim_safe_direction(direction,edible)
	return direction

func _sim_collision_cost(point: Vector2,velocity: Vector2,enemy: Vector2,enemy_velocity: Vector2,clearance: float) -> float:
	var relative = enemy-point
	var movement = enemy_velocity-velocity
	var t = clampf(-relative.dot(movement)/maxf(0.001,movement.length_squared()),0,0.32)
	var distance = (relative+movement*t).length()
	return maxf(0,clearance+12-distance)*9



func _sim_safe_direction(desired: Vector2,edible: bool) -> Vector2:
	var best = -INF
	var result = desired
	var speed = 225*speed_factor*(1.32 if boost_remaining > 0 else 1.0)
	for i in range(17):
		var direction = desired if i == 16 else Vector2.from_angle(i*TAU/16)
		var velocity = direction*speed
		var endpoint = position_player+velocity*0.32
		var score_value = direction.dot(desired)*68
		if endpoint.x < radius_player+20 or endpoint.x > W-radius_player-20 or endpoint.y < SEA_TOP+radius_player+14 or endpoint.y > SEA_BOTTOM-radius_player-12: score_value -= 500
		if not edible and boss.hp > 0 and invulnerable < 0.3 and bubble_remaining < 0.3:
			var boss_velocity: Vector2 = boss.dir*STAGES[stage-1].pursuit
			if boss.phase == "charge" or (boss.phase == "warn" and boss.attack in ["charge","double","triple"] and boss.timer < 0.32): boss_velocity = boss.target*_boss_charge_speed()
			if boss.phase in ["recover","suction"]: boss_velocity = Vector2.ZERO
			score_value -= _sim_collision_cost(position_player,velocity,boss.pos,boss_velocity,(radius_player+boss.size)*0.7)
		for fish in entities:
			if fish.kind == "jelly" or (fish.kind == "hunter" and radius_player < fish.size*1.1):
				if fish.pos.distance_to(position_player) < 230:
					score_value -= _sim_collision_cost(position_player,velocity,fish.pos,fish.dir*fish.speed,radius_player*0.66+fish.size*0.72)
		for shot in shots:
			if shot.pos.distance_to(position_player) < 260 and bubble_remaining < 0.3:
				score_value -= _sim_collision_cost(position_player,velocity,shot.pos,shot.vel,radius_player*0.62+shot.size)
		for mine in mines:
			if mine.warning < 0.32: score_value -= _sim_collision_cost(position_player,velocity,mine.pos,Vector2.ZERO,radius_player*0.65+mine.size)
		if score_value > best: best = score_value; result = direction
	return result



func _simulate_case(seed_value: int,policy: String,first_only: bool) -> Dictionary:
	_new_run(seed_value)
	mouse_control = false
	mouse_known = false
	pointer_outside = false
	sim_control_rng.seed = seed_value+300000
	var decision_frames = 10 if policy in ["learner","learner_build"] else 5
	var frame = 0
	var steering = Vector2.RIGHT
	while frame < 40000 and state not in ["dead","won"]:
		if state in ["skill_reward","skill_replace","upgrade"]:
			if first_only: break
			_sim_choose_rewards(policy)
			continue
		if state == "playing":
			# One steering/ability decision every 1/6 second, on the real tick path.
			if frame%decision_frames == 0:
				if policy in ["learner","learner_build"]:
					var choice = "combat" if sim_control_rng.randf() > 0.28 else "gather"
					steering = _sim_decide(choice)
				else: steering = _sim_decide(policy)
			_tick_game(1.0/30,1.0/30,steering)
		elif state in ["last_hunt","hunt_hit"]: _tick_hunt(1.0/30)
		else: break
		particles.clear()
		trails.clear()
		frame += 1
	var outcome = "win" if state == "won" or (first_only and state == "skill_reward") else ("dead" if state == "dead" else "stopped")
	return {"seed":seed_value,"policy":policy,"first_only":first_only,"outcome":outcome,"stage":stage,"seconds":snappedf(total_time,0.1),"food":total_eaten,"health":health,"reason":failure_reason,"boss_hp":snappedf(boss.hp,0.1),"player_size":snappedf(radius_player,0.1),"stats":stats.duplicate(),"skills":equipped_skills.duplicate(),"stages":sim_stage_records.duplicate(true)}

func _sim_summary(cases: Array[Dictionary]) -> Dictionary:
	var wins = 0
	var timeout = 0
	var damage = 0.0
	var successful_times: Array[float] = []
	var reached = [0,0,0,0,0,0]
	for result in cases:
		if result.outcome == "win": wins += 1; successful_times.append(result.seconds)
		if "警戒" in result.reason: timeout += 1
		damage += result.stats.boss_damage
		for i in range(result.stage): reached[i] += 1
	successful_times.sort()
	return {"runs":cases.size(),"wins":wins,"win_percent":snappedf(100.0*wins/maxi(1,cases.size()),0.1),"timeout_deaths":timeout,"average_boss_damage":snappedf(damage/maxi(1,cases.size()),0.1),"median_clear_seconds":successful_times[successful_times.size()/2] if not successful_times.is_empty() else 0,"reached_stage":reached}



func _run_balance_simulation() -> void:
	muted = true
	var all_cases: Array[Dictionary] = []
	var summaries = {}
	var count = 20
	var seed_start = 7000
	var report_name = "balance-v8"
	var policies = ["combat_build","expert_build","resource_build","whirl_build","growth_build","tempo_build","bite_build","defense_build"]
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--samples="): count = int(arg.substr(10))
		if arg.begins_with("--seed-start="): seed_start = int(arg.substr(13))
		if arg.begins_with("--report="): report_name = arg.substr(9).get_file()
		if arg.begins_with("--policies="): policies = Array(arg.substr(11).split(","))
		if arg.begins_with("--tuning="):
			var tuning = JSON.parse_string(FileAccess.get_file_as_string(arg.substr(9)))
			for i in range(STAGES.size()):
				if tuning.has("limits"): STAGES[i].limit = tuning.limits[i]
				if tuning.has("hp"): STAGES[i].hp = tuning.hp[i]
	for policy in policies:
		var cases: Array[Dictionary] = []
		for i in range(count):
			var result = _simulate_case(seed_start+i,policy,"--first-only" in OS.get_cmdline_user_args())
			cases.append(result)
			all_cases.append(result)
		summaries[policy] = _sim_summary(cases)
		print("CAMPAIGN ",policy," ",JSON.stringify(summaries[policy]))
	var report = {"version":"0.8","dt":1.0/30,"decision_interval":1.0/6,"limits":STAGES.map(func(st):return st.limit),"boss_hp":STAGES.map(func(st):return st.hp),"summaries":summaries,"cases":all_cases}
	var report_dir = ProjectSettings.globalize_path("res://../work")
	DirAccess.make_dir_recursive_absolute(report_dir)
	var file = FileAccess.open(report_dir.path_join(report_name+".json"),FileAccess.WRITE)
	if file == null:
		push_error("Cannot save simulation report")
		get_tree().quit(1)
		return
	file.store_string(JSON.stringify(report,"  "))
	print("SIMULATION_SAVED ",report_name)
	get_tree().quit(0)

func _boss_charge_speed() -> float:
	return 475.0 if stage == 1 else 410+stage*22

func _run_balance_rules_tests() -> void:
	muted = true
	_new_run(123)
	equipped_skills = ["whirl","sonar","bubble"]
	for id in ["food","carry","whirl","sonar","bubble","time"]:
		var choice: Dictionary = {}
		for upgrade in EVOLUTIONS:
			if upgrade.id == id: choice = upgrade
		for i in range(20): _apply_upgrade(choice)
	assert(is_equal_approx(food_factor,1.6) and carry_size == 8)
	assert(whirl_radius == 185 and whirl_duration == 2)
	assert(sonar_damage == 50 and sonar_radius == 300)
	assert(bubble_duration <= 2.8 and time_bonus == 24)
	_generate_offers()
	for offer in offers: assert(offer.id not in ["food","carry","whirl","sonar","bubble","time"])
	for attack in ["sweep","spiral","fan_burst","radial_burst"]:
		_new_run(124)
		stage = 6
		_start_stage()
		boss.attack = attack
		boss.target = Vector2.LEFT
		_execute_boss_attack()
		var initial_shots = shots.size()
		assert(initial_shots > 0 and volleys.size() > 0)
		_tick_boss(0.5)
		_tick_boss(0.5)
		assert(volleys.is_empty() and shots.size() > initial_shots and shots.size() <= 48)
	# A late-stage food buff must not change first-stage learning values.
	_new_run(125)
	var food = {"kind":"food","gold":false,"size":10,"pos":position_player,"tint":MINT}
	_eat(food)
	assert(is_equal_approx(radius_player,21.7))
	stage = 2
	_start_stage()
	_eat(food)
	assert(is_equal_approx(radius_player,21.5))
	print("PASS: cumulative upgrade caps, exhausted offers removed, delayed boss volleys resolve, shot population bounded, tutorial growth unchanged")
	get_tree().quit(0)
