extends VBoxContainer

@onready var veigar = $"../Veigar"

var items = {
	"Infinity Edge": {
		"stat": "ad",
		"bonus": 10,
		"price": 100,
		"scaling": 1.5,
		"count": 0,
		"icon": preload("res://Shop/InfinityEdge.webp")
	},
	"Statikk Shiv": {
		"stat": "attack_speed",
		"bonus": 0.2,
		"price": 150,
		"scaling": 1.5,
		"count": 0,
		"icon": preload("res://Shop/StatikkShiv.webp")
	},
	"Luden's Echo": {
		"stat": "ap",
		"bonus": 10,
		"price": 200,
		"scaling": 1.5,
		"count": 0,
		"icon": preload("res://Shop/LudensEcho.jpg")
	},
	"Tear of Goddess": {
		"stat": "mana_max",
		"bonus": 50,
		"price": 100,
		"scaling": 1.4,
		"count": 0,
		"icon": preload("res://Shop/Tear.webp")
	}
}

func _ready():
	for item_name in items.keys():
		var item = items[item_name]

		var hbox = HBoxContainer.new()
		hbox.name = item_name
		hbox.custom_minimum_size = Vector2(250, 64)

		var icon = TextureRect.new()
		icon.texture = item["icon"]
		icon.expand = true
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.custom_minimum_size = Vector2(48, 48)

		var label = Label.new()
		label.text = "%s (💰%d)" % [item_name, item["price"]]
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		label.name = "Label"

		var button = Button.new()
		button.text = "Acheter"
		button.name = "Button"
		button.pressed.connect(_on_item_pressed.bind(item_name, label))

		hbox.add_child(icon)
		hbox.add_child(label)
		hbox.add_child(button)

		add_child(hbox)

func _on_item_pressed(item_name: String, label: Label):
	var item = items[item_name]
	var cost = item["price"]

	if veigar.essence_bleue >= cost:
		veigar.essence_bleue -= cost
		veigar[item["stat"]] += item["bonus"]
		item["count"] += 1
		item["price"] = int(item["price"] * item["scaling"])

		label.text = "%s (💰%d)" % [item_name, item["price"]]
	else:
		print("Pas assez d'essence bleue pour acheter %s" % item_name)
