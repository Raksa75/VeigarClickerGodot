extends Control

@onready var veigar = $Veigar
@onready var enemy_container = $EnemyContainer

var enemy_scenes = [
	preload("res://EnemyScenes/Melee.tscn"),
	preload("res://EnemyScenes/Caster.tscn"),
	preload("res://EnemyScenes/Cannon.tscn"),
	preload("res://EnemyScenes/Raptor.tscn"),
	preload("res://EnemyScenes/Wolf.tscn"),
	preload("res://EnemyScenes/Krugs.tscn"),
	preload("res://EnemyScenes/Gromp.tscn"),
	preload("res://EnemyScenes/BlueBuff.tscn"),
	preload("res://EnemyScenes/RedBuff.tscn"),
	preload("res://EnemyScenes/Void.tscn"),
	preload("res://EnemyScenes/Herald.tscn"),
	preload("res://EnemyScenes/Drake.tscn"),
	preload("res://EnemyScenes/Nashor.tscn"),
	preload("res://EnemyScenes/Elder.tscn"),
	preload("res://EnemyScenes/Atakan.tscn")
]

var current_enemy_index := 0
var wave_count := 1

func _ready():
	spawn_next_enemy()

func spawn_next_enemy():
	if current_enemy_index >= enemy_scenes.size():
		current_enemy_index = 0
		wave_count += 1
		print("🌊 Nouvelle vague : %d (HP x%.2f | AP x%.2f)" % [wave_count, get_wave_multiplier(), get_ap_scaling()])

	var enemy_scene = enemy_scenes[current_enemy_index]
	var enemy_instance = enemy_scene.instantiate()
	enemy_container.add_child(enemy_instance)

	# Position dans le container
	if enemy_instance is Control:
		enemy_instance.position = Vector2.ZERO
	elif enemy_instance is Node2D:
		enemy_instance.global_position = enemy_container.global_position

	# Appliquer le scaling de la vague (HP)
	enemy_instance.setup_stats(get_wave_multiplier())

	# Appliquer scaling AP (plus lent que HP)
	enemy_instance.ap_reward *= get_ap_scaling()

	# Connexion & assignation
	enemy_instance.died.connect(on_enemy_killed)
	veigar.enemy = enemy_instance

func on_enemy_killed(ap_gain: int, gold_gain: int):
	veigar.on_enemy_killed(ap_gain, gold_gain)
	current_enemy_index += 1

	await get_tree().create_timer(1.0).timeout
	for child in enemy_container.get_children():
		child.queue_free()

	spawn_next_enemy()

# ⬇️ Scaling HP : exponentiel
func get_wave_multiplier() -> float:
	return pow(5.0, wave_count - 1)

# ⬇️ Scaling AP : progressif lent
func get_ap_scaling() -> float:
	return 1.0 + (wave_count - 1) * 0.25
