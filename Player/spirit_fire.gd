extends Area2D

const LAUNCH_SPEED := 1800.0

@export var lifetime := 20.0

var max_speed := 500.0
var drag_factor: float:
	get:
		return _drag_factor
	set(value):
		set_drag_factor(value)

var _drag_factor: float = 0.15

func set_drag_factor(value: float) -> void:
	_drag_factor = clamp(value, 0.0, 1.0)

var _target

var _current_velocity := Vector2.ZERO

func _ready():
	_current_velocity = max_speed * 5 * Vector2.RIGHT.rotated(rotation)
	
func _physics_process(delta: float) -> void:
	var direction := Vector2.RIGHT.rotated(rotation).normalized()
	
	if _target:
		direction = global_position.direction_to(_target.global_position)

	var desired_velocity := direction * max_speed
	var change = (desired_velocity - _current_velocity) * drag_factor
	
	_current_velocity += change
	
	position += _current_velocity * delta
	look_at(global_position + _current_velocity)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		_target = body
		
	if _target != null:
		return
		
