extends Sprite2D

signal player_detected

@export_enum("LO: 6", "MED: 3", "HI: 0") var suspicion: int = 0
@export var suspicion_impact: float = 0.12
var perception: float = 0.00
var alerted: bool = false

func alert() -> void:
	if randf() < 1.0 - suspicion_impact * suspicion:
		alerted = true
		player_detected.emit()

func _process(_delta) -> void:
	if not alerted:
		modulate = Color(0.0, 1.0, 0.0, 1.0)
	else:
		modulate = Color(1.0, 0.0, 0.0, 1.0)
