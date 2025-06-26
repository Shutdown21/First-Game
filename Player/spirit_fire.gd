extends Area2D

const LAUNCH_SPEED := 1800.0
var launched := false

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
var _target_position: Vector2
var _current_velocity := Vector2.ZERO

var player: CharacterBody2D

var hover_offset := Vector2.ZERO

func _ready():
	_current_velocity = Vector2.ZERO
	$Life.start()
	
func _physics_process(delta: float) -> void:
	if not launched and player != null:
		global_position = player.global_position + hover_offset
	if launched:
		var direction = global_position.direction_to(_target_position)
		var desired_velocity = direction * max_speed
		var change = (desired_velocity - _current_velocity) * drag_factor
		_current_velocity += change
		position += _current_velocity * delta
		look_at(global_position + _current_velocity)
	if global_position.distance_to(_target_position) < 10.0:
		queue_free()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies") and is_instance_valid(body):
		_target = body
		_target_position = body.global_position
		$Life.paused = true
		launched = true
		
	if _target != null:
		return
		

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox":
		queue_free()

func _on_life_timeout() -> void:
	if _target == null:
		queue_free()


#FIX SPAWNING BUG
