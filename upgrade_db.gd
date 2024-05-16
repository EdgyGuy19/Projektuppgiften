extends Node

const ICON_PATH = "res://Assets/Rogue Like Items/"

const UPGRADES = {
	"magic1": {
		"icon": ICON_PATH + "item_5.png",
		"displayname": "Magic Tome",
		"details": "Shoot some magic at a random enemy.",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"magic2": {
		"icon": ICON_PATH + "item_10.png",
		"displayname": "Magic Tome",
		"details": "Shoot more magic!",
		"level": "Level: 2",
		"prerequisite": ["magic1"],
		"type": "weapon"
	},

	"boots1": {
		"icon": ICON_PATH + "item_13.png",
		"displayname": "Spiked boot",
		"details": "Somehow boosts your speed",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"boots2": {
		"icon": ICON_PATH + "item_13.png",
		"displayname": "Spiked boot",
		"details": "Second boot for more speed",
		"level": "Level: 2",
		"prerequisite": ["boots1"],
		"type": "weapon"
	},
	"jesus": {
		"icon": ICON_PATH + "item_12.png",
		"displayname": "Religion",
		"details": "Heals you with the help of God",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
}
