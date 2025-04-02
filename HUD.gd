extends Control

@onready var veigar = $"../Veigar"
@onready var mana_label = $ManaLabel
@onready var ap_label = $APLabel
@onready var ad_label = $ADLabel
@onready var as_label = $ASLabel
@onready var money_label = $MoneyLabel
@onready var mana_bar = $ManaBar

func _ready():
	veigar.stats_updated.connect(update_stats)
	update_stats()

func update_stats():
	# Affichage texte
	mana_label.text = "Mana: %d / %d" % [veigar.mana, veigar.mana_max]
	ap_label.text = "AP: %d" % veigar.ap
	as_label.text = "AS: %.2f" % veigar.attack_speed
	ad_label.text = "AD: %d" % veigar.ad
	money_label.text = "EB: %d" % veigar.essence_bleue

	# Affichage barre visuelle
	mana_bar.max_value = veigar.mana_max
	mana_bar.value = veigar.mana
