extends Control

@export var max_hp: float = 30.0
@export var ap_reward: float = 2.0
@export var gold_reward: float = 5.0

var hp: int = 0

signal died(ap_gain, gold_gain)

@onready var hp_label = $HPLabel
@onready var hp_bar = $HPBar
@onready var sprite = self

func _ready():
	update_hp_display()

func setup_stats(multiplier: float):
	max_hp *= multiplier
	hp = int(max_hp)  # Cast propre
	update_hp_display()

func take_damage(amount: int):
	hp -= amount
	if hp <= 0:
		hp = 0
		emit_signal("died", ap_reward, gold_reward)
		queue_free()
	update_hp_display()
	flash_hit()

func update_hp_display():
	hp_label.text = "HP: %d" % hp
	hp_bar.max_value = max_hp
	hp_bar.value = hp

func flash_hit():
	sprite.modulate = Color(1, 0.2, 0.2)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1)
