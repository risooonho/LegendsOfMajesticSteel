class_name ActorStatusPanel
extends PanelContainer

signal portrait_pressed

onready var _portrait := $HBoxContainer/PortraitButton as Button
onready var _name := $HBoxContainer/VBoxContainer/Name as Label
onready var _stamina := $HBoxContainer/VBoxContainer/HBoxContainer/ \
		Stamina as Range
onready var _stamina_number := $HBoxContainer/VBoxContainer/HBoxContainer/ \
		StaminaNumber as Label


func set_actor(actor: Actor) -> void:
	clear()
	_portrait.icon = actor.portrait
	_portrait.disabled = false
	_name.text = actor.character_name
	_stamina.value = actor.battle_stats.stamina
	_stamina_number.text = str(actor.battle_stats.stamina)


func clear() -> void:
	_portrait.icon = null
	_portrait.disabled = true
	_name.text = ""
	_stamina.value = 0
	_stamina_number.text = ""


func _on_PortraitButton_pressed() -> void:
	emit_signal("portrait_pressed")
