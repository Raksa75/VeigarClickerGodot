extends Node

var mana := 0.0
var mana_max := 100.0
var mana_regen := 0.0

var ad := 10 # Dégâts des clics / gain de mana
var ap := 1  # Dégâts du sort
var attack_speed := 1.0 # Clics automatiques par seconde

var essence_bleue := 0

signal stats_updated

var enemy: Node = null # on lui assigne dynamiquement dans Main.gd

var auto_attack_timer := 0.0

func _process(delta):
	auto_attack_timer += delta
	var interval = 1.0 / attack_speed
	if auto_attack_timer >= interval:
		auto_attack_timer = 0.0
		perform_click()

	emit_signal("stats_updated")

func _on_veigar_button_pressed():
	perform_click()

func perform_click():
	if mana >= mana_max:
		cast_spell()
	else:
		gain_mana(ad)

func gain_mana(amount: float):
	mana += amount
	if mana > mana_max:
		mana = mana_max

func cast_spell():
	if not is_instance_valid(enemy):
		return

	enemy.take_damage(ap)
	mana = 0

func on_enemy_killed(ap_gain: int, gold_gain: int):
	ap += ap_gain
	essence_bleue += gold_gain
