extends Node

var items: Dictionary = {
	"health_potion": preload("res://Items/health_potion.tres"),
	"mana_potion": preload("res://Items/mana_potion.tres"),
}

func get_item(id: String) -> BaseItem:
	return items.get(id, null)
