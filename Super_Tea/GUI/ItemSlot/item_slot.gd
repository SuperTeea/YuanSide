extends Button

@export var itemdata : ItemData
@onready var react = $TextureRect

func  _ready() -> void:
	react.texture = itemdata.texture
	pass
