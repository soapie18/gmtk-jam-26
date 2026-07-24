extends CanvasLayer

signal fishing_finished(success: bool)
 
@export var fish: Fish
@export var rod: Rod

@onready var root_ui: Control            = %Control
@onready var catch_area: Control         = %CatchBox
@onready var bar_track: Control          = %FishBar
@onready var catch_bar: ColorRect        = %TheGreen
@onready var fish_icon: TextureRect      = %FihhIcon
@onready var progress: ProgressBar       = %ProgressBar
@onready var label_name: Label           = %FishCaughtLabel
@onready var burst: GPUParticles2D       = %ConfettiBurst

const BASE_BAR_HEIGHT := 20.0
const BASE_HOOK_WINDOW := 0.6
const BASE_ESCAPE_DRAIN := 22.0
const PROGRESS_GAIN := 28.0
const DURATION := 2.0

enum STATE { CASTING, BITE, HOOK, PLAY, END }

var _state: STATE = STATE.CASTING
var _elapsed: float = 0.0
var _duration: float = 0.0
var _bite_timer: float = 2.0
var _hook_window: float
var _bar_h: float
var _bar_pos: float = 0.0
var _bar_vel: float = 0.0
var _fish_pos: float = 0.5
var _fish_vel: float = 0.0
var _progress_val: float = 0.0
var _fish_seed: float

func _ready():
	if not fish or not rod:
		push_warning("Fish and or rod not found.")
		return
	
	_set_defaults()

func _unhandled_input(event):
	if _state == STATE.HOOK:
		if event.is_action_pressed("fish"):
			_on_hook()

func _update_input_bar(delta: float):
	var up := Input.is_action_pressed("fish")
	var dir := 1.0 if up else -1.0
 
	_bar_vel += dir * rod.bar_accel * delta
	_bar_vel -= _bar_vel * rod.bar_drag
	_bar_vel -= rod.bar_gravity * delta 
 
	_bar_pos += _bar_vel * delta / _track_height()
	_bar_pos = clamp(_bar_pos, 0.0, 1.0)
 
	if _bar_pos == 0.0 and _bar_vel < 0.0:
		_bar_vel *= -0.35
	if _bar_pos == 1.0 and _bar_vel > 0.0:
		_bar_vel *= -0.35
 
	_set_catch_bar_visual()

func  _update_fish_motion(delta: float):
	var d := fish.difficulty
	match fish.pattern:
		fish.MovePattern.SMOOTH:
			var t = _elapsed + _fish_seed
			var target = 0.5 + 0.35 * sin( t * 1.2) + 0.15 * sin( t * 2.7 + 1.3)
			_fish_vel += (target - _fish_pos) * (2.2 + 2.0 * d )
			_fish_vel *= 0.84 - 0.2 * d
		fish.MovePattern.DARTY:
			if randi() % 10 == 0:
				_fish_vel = randf_range(- 2.8 - 2.5 * d, 2.8 + 2.5 * d )
			_fish_vel *= 0.86 - 0.25 * d
		fish.MovePattern.SINK_RISE:
			var t2 = _elapsed * (0.6 + d)
			var target2 = 0.5 + 0.45 * sin(t2)
			_fish_vel += (target2 - _fish_pos) * (1.3 + 1.2 * d)
			_fish_vel += 0.7 * sin(t2 * 2.5) * d
			_fish_vel *= 0.88 
		fish.MovePattern.CHAOTIC:
			var t3 = _elapsed * 2.0
			_fish_vel += randf_range(-0.8,0.8) * (1.2 + 2.2 * d)
			_fish_vel += 0.8 * sin(t3 * 3.3)
			_fish_vel *= 0.80 - 0.1 * d
	
	_fish_pos += _fish_vel * delta * 0.45
	_fish_pos = clamp(_fish_pos, 0.1, 1.0)
	_set_fish_visual()

func _physics_process(delta: float):
	_elapsed += delta
	_duration += delta
	
	match _state :
		STATE.CASTING:
			#
			_state = STATE.BITE
		STATE.BITE:
			_bite_timer -= delta * rod.bite_rate_mult
			if _bite_timer <= 0.0:
				_prompt_hook()
		STATE.HOOK:
			_hook_window -= delta * rod.hook_window_mult
			if _hook_window <= 0.0:
				_fail("Too slow")
		STATE.PLAY:
			_update_input_bar(delta)
			_update_fish_motion(delta)
			_handle_collisions(delta)
			_update_progress_ui()
			
			if _progress_val >= 100.0:
				_success()
			elif _progress_val <= 0.0 and _duration > DURATION:
				_fail("Escaped")
			
		STATE.END:
			pass

func _prompt_hook():
	_state = STATE.HOOK
	_hook_window = BASE_HOOK_WINDOW * rod.hook_window_mult 
	
	flash_node(catch_area, 0.12)
	_punch_ui(root_ui, 1.05, 0.08)

func _fail(_why: String):
	_state = STATE.END
	print("fail : " + _why)
	
	_shake(5.0, 0.20)
	
	await get_tree().create_timer(0.2).timeout
	fishing_finished.emit(false)

func _success():
	_state = STATE.END
	#CATCH SOUND EFFECT ON THIS LINE
	burst.emitting = true
	label_name.show()
	
	_shake(10.0, 0.25)
	_punch_ui(root_ui, 1.12, 0.18)
	
	await get_tree().create_timer(0.25).timeout
	fishing_finished.emit(true)

func _on_hook():
	_state = STATE.PLAY
	_progress_val = 20.0 # gives the player a headstart
	
	_time_freeze(0.06 * rod.hit_freeze_mult)
	_shake(6.0, 0.18)
	
func _rng_bite_time() -> float:
	return max(0.25, fish.bite_time_avg + randf_range(-fish.bite_time_variance,fish.bite_time_variance))
	

func _track_height() -> float:
	return bar_track.size.y - _bar_h

func _bar_px_top() -> float:
	var track_top := bar_track.global_position.y
	var y := track_top + (1.0 - _bar_pos) * _track_height()
	return y
	
func _set_catch_bar_visual():
	catch_bar.size = Vector2(bar_track.size.x * 0.9, _bar_h)
 
	var y_top := _bar_px_top()
	catch_bar.global_position = Vector2(bar_track.global_position.x + bar_track.size.x*0.05, y_top)
	
func _set_defaults():
	label_name.text = fish.fish_name
	bar_track.modulate = fish.tint.lerp(Color.DARK_BLUE, 0.5)
	_bar_h = BASE_BAR_HEIGHT + rod.bar_size_bonus
	_hook_window = BASE_HOOK_WINDOW * rod.hook_window_mult
	_bite_timer = _rng_bite_time()
	_fish_seed = randf() * 1000.0
	
	_set_catch_bar_visual()
	_set_fish_visual()
	
func _set_fish_visual():
	var y: float = lerp(
		bar_track.global_position.y + bar_track.size. y - 12.0,
		bar_track.global_position.y + 12.0,
		_fish_pos
					)

	fish_icon.global_position.y = y
	fish_icon.modulate = fish.tint

func _handle_collisions(delta: float):
	var on_fish := _is_bar_over_fish()
	if on_fish:
		_progress_val += PROGRESS_GAIN * delta
	else:
		_progress_val -= BASE_ESCAPE_DRAIN * rod.escape_drain_mult * delta
 
	_progress_val = max(0, _progress_val)
	if _progress_val > 0:
		_duration = 0

func _update_progress_ui():
	progress.value = clamp(_progress_val, 0.0, 100.0)

func _is_bar_over_fish() -> bool:
	var fish_rect := Rect2(fish_icon.global_position, fish_icon.size)
 
	var bar_rect := Rect2(catch_bar.global_position, catch_bar.size)
	return bar_rect.intersects(fish_rect)

func _punch_ui(node: Node, scale_to: float, time: float):
	var t := create_tween()
	t.tween_property(node, "scale", Vector2.ONE * scale_to, time * 0.5 )
	t.tween_property(node, "scale", Vector2.ONE, time * 0.5 )

func flash_node(node: CanvasItem, duration: float):
	var t := create_tween()
	t.tween_property(node, "modulate", Color(1,1,1,0.4), duration * 0.5)
	t.tween_property(node, "modulate", Color(1,1,1,1), duration * 0.5 )

func _shake(intensity: float, duration: float):
	var tween := create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	for i in range(8):
		var off := Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		tween.tween_property(root_ui, "position", off, duration/8.0)
	tween.tween_property(root_ui, "position", Vector2.ZERO, 0.06)
	
func _time_freeze(seconds: float):
	Engine.time_scale = 0.0
	await get_tree().create_timer(seconds, true, true, true).timeout
	Engine.time_scale = 1.0
