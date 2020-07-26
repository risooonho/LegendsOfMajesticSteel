class_name Player
extends ActorController

signal _input_processed(action)

enum State {
	MOVEMENT,
	ABILITY_TARGETING,
	ABILITY_CONFIRMATION
}

var _map: Map = null
var _range_data: RangeData = null
var _control: BattleControl = null

var _state: int

var _ability_targetting: Ability.TargettingData
var _ability_target: Vector2

func determine_action(map: Map, range_data: RangeData, control: BattleControl) \
		-> void:
	_map = map
	_range_data = range_data
	_control = control
	_connect_to_gui()

	_state = State.MOVEMENT

	var action: Action = yield(self, '_input_processed')

	_disconnect_from_gui()
	_control = null
	_range_data = null
	_map = null

	_ability_targetting = null

	emit_signal("determined_action", action)


func _connect_to_gui() -> void:
	_control.gui.buttons_visible = true
	_control.mouse.dragging_enabled = true

	# warning-ignore:return_value_discarded
	_control.mouse.connect("click", self, "_mouse_click")

	# warning-ignore:return_value_discarded
	_control.gui.connect("ability_selected", self, "_ability_selected")
	# warning-ignore:return_value_discarded
	_control.gui.connect("ability_cleared", self, "_ability_cleared")
	# warning-ignore:return_value_discarded
	_control.gui.connect("wait_started", self, "_wait_clicked")


func _disconnect_from_gui() -> void:
	_control.mouse.disconnect("click", self, "_mouse_click")

	_control.gui.disconnect("ability_selected", self, "_ability_selected")
	_control.gui.disconnect("ability_cleared", self, "_ability_cleared")
	_control.gui.disconnect("wait_started", self, "_wait_clicked")


func _mouse_click(_position) -> void:
	var target_cell := _map.get_mouse_cell()

	match _state:
		State.MOVEMENT:
			_move(target_cell)
		State.ABILITY_TARGETING:
			_set_target(target_cell)
		State.ABILITY_CONFIRMATION:
			_confirm_ability_target(target_cell)


func _move(target_cell: Vector2) -> void:
	var path := _range_data.get_walk_path(get_actor().cell, target_cell)
	if path.size() > 0:
		var action := Move.new(get_actor(), _map, path)
		#action.allow_cancel(_gui)
		emit_signal("_input_processed", action)


func _set_target(target_cell: Vector2) -> void:
	if target_cell in _ability_targetting.valid_targets:
		_ability_target = target_cell
		_control.set_target(target_cell)

		_state = State.ABILITY_CONFIRMATION


func _confirm_ability_target(target_cell: Vector2) -> void:
	if _ability_target == target_cell:
		var ability := AbilityAction.new(get_actor(), _map,
				_control.gui.current_ability, target_cell)

		_control.gui.current_ability = null
		emit_signal("_input_processed", ability)
	else:
		_set_target(target_cell)


func _ability_selected(ability: Ability) -> void:
	_ability_targetting = ability.get_targetting_data(get_actor(), _map)
	_state = State.ABILITY_TARGETING


func _ability_cleared() -> void:
	_ability_targetting = null
	_state = State.MOVEMENT


func _wait_clicked() -> void:
	emit_signal("_input_processed", null)