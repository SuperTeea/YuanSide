extends Control

@onready var label = $RichTextLabel
@onready var edit = $LineEdit

signal message_come(user, message)

func _ready() -> void:
	edit.visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			get_viewport().set_input_as_handled()
			print("T was pressed")
			print(edit.visible)
			if edit.visible:
				edit.visible = false
			else:
				edit.visible = true
				edit.grab_focus()

func _add_message(user : String, message):
	if user.contains('Yuan'):
		label.append_text('[rainbow]' + user + '[/rainbow] : ')
	else:
		label.append_text('[color=green]' + user + '[/color] : ')
	label.append_text(message + '\n')
func test():
	_add_message('YuanGod', '666')


func _on_line_edit_text_submitted(new_text: String) -> void:
	edit.text = ''
	edit.release_focus()
	edit.visible = false
	NetWork.send_message(R.UserName, new_text)
	print('sent ', R.UserName, new_text)
