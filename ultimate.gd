extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Game.ult_cooldown_time > 0:
		Game.ult_cooldown_time = max(0, Game.ult_cooldown_time - delta)
		text = "Ultimate Cooldown: " + str(int(Game.ult_cooldown_time + 1)) + "s"
	else:
		text = "Ultimate Cooldown: Ready"
