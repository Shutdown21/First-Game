extends Area2D

const LAUNCH_SPEED := 1800.0

var max_speed := 300.0
var drag_factor: float:
	get:
		return _drag_factor
	set(value):
		set_drag_factor(value)

var _drag_factor: float = 0.15

func set_drag_factor(value: float) -> void:
	_drag_factor = clamp(value, 0.0, 1.0)

var _target = null
var _current_velocity := Vector2.ZERO

var player: CharacterBody2D

var hover_offset := Vector2.ZERO

func _ready():
	_current_velocity = Vector2.ZERO
	$Life.start()
	
func _physics_process(delta: float) -> void:
	if _target == null and player != null:
		global_position = player.global_position + hover_offset
	if _target:
		var direction = global_position.direction_to(_target.global_position)
		var desired_velocity = direction * max_speed
		var change = (desired_velocity - _current_velocity) * drag_factor
		_current_velocity += change
		position += _current_velocity * delta
		look_at(global_position + _current_velocity)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		_target = body
		$Life.stop()
		
	if _target != null:
		return
		
	if _target != null and not is_instance_valid(_target):
		_target = null
		

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox":
		queue_free()

func _on_life_timeout() -> void:
	if _target == null:
		queue_free()


#FIX SPAWNING BUG
