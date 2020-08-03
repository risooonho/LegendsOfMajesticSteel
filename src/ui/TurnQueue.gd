class_name TurnQueue
extends ReferenceRect

const _ICON_PLAYER := preload("res://assets/graphics/ui/icons/player_turn.png")
const _ICON_ENEMY := preload("res://assets/graphics/ui/icons/enemy_turn.png")

const _ANIM_TIME := 0.4

onready var _panel := $Panel as Control
onready var _scroll := $Panel/Scroll as ScrollContainer

onready var _container := $Panel/Scroll/Container as Control
onready var _margin := $Panel/Scroll/Container/Margin as Control

onready var _icons := $Panel/Scroll/Container/Margin/Icons as Control

onready var _tween := $Tween as Tween


func set_queue(factions: Array) -> void:
	_clear()
	_add_icons(factions)
	_resize_container()

	var old_panel_size := _panel.rect_size

	_resize_panel()

	_queue_animate_panel_size_change(old_panel_size)
	_queue_animate_new_icons()
	# warning-ignore:return_value_discarded
	_tween.start()


func next_turn() -> void:
	if _icons.get_child_count() > 0:
		var margins_width_start := _margin.rect_size.x

		var icon := _icons.get_child(0) as Control
		var icon_position := icon.rect_position
		_icons.remove_child(icon)

		if _panel.rect_size.x == rect_size.x:
			_resize_container()

		_queue_animate_icons_shift(margins_width_start)
		_queue_animate_icon_drop(icon, icon_position)

		# warning-ignore:return_value_discarded
		_tween.start()


func remove_icon(index: int) -> void:
	var icon := _icons.get_child(index) as Control
	var icon_position := icon.rect_position
	_icons.remove_child(icon)

	_queue_animate_icon_drop(icon, icon_position)
	# warning-ignore:return_value_discarded
	_tween.start()


func _clear() -> void:
	for c in _icons.get_children():
		var child := c as Node
		child.queue_free()


func _add_icons(factions: Array) -> void:
	for f in factions:
		var faction := f as int
		match faction:
			Actor.Faction.PLAYER:
				_add_single_icon(_ICON_PLAYER)
			Actor.Faction.ENEMY:
				_add_single_icon(_ICON_ENEMY)
			_:
				assert(false)


func _add_single_icon(texture: Texture) -> void:
	var icon := TextureRect.new()
	icon.texture = texture
	_icons.add_child(icon)


func _resize_container() -> void:
	_margin.rect_size = Vector2.ZERO # Force margin to recalculate size

	_container.rect_min_size = _margin.rect_size
	_container.rect_size = _margin.rect_size


func _resize_panel() -> void:
	_scroll.rect_min_size = _margin.rect_size
	_scroll.rect_size = Vector2.ZERO

	_panel.rect_size = Vector2.ZERO
	_scroll.rect_min_size.x = 0

	if _panel.rect_size.x > rect_size.x:
		_panel.rect_size.x = rect_size.x


func _queue_animate_panel_size_change(old_panel_size: Vector2) -> void:
	var new_panel_size := _panel.rect_size

	_panel.rect_size = old_panel_size
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(_panel, "rect_size",
			old_panel_size, new_panel_size, _ANIM_TIME,
			Tween.TRANS_QUAD, Tween.EASE_OUT)


func _queue_animate_new_icons() -> void:
	var height := _margin.rect_size.y

	var old_pos := Vector2(0, -height)
	var new_pos := Vector2.ZERO

	_margin.rect_position = old_pos
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(_margin, "rect_position",
			old_pos, new_pos, _ANIM_TIME,
			Tween.TRANS_QUAD, Tween.EASE_OUT)


func _queue_animate_icons_shift(margins_width_start: float) -> void:
	_margin.rect_size = Vector2.ZERO
	var margins_width_end := _margin.rect_size.x

	var diff_x := margins_width_start - margins_width_end
	assert(diff_x > 0)
	var old_position := Vector2(diff_x, 0)

	_margin.rect_position = old_position
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(_margin, "rect_position",
			old_position, Vector2.ZERO, _ANIM_TIME,
			Tween.TRANS_QUAD, Tween.EASE_OUT)


func _queue_animate_icon_drop(icon: Control, icon_position: Vector2) -> void:
	_container.add_child_below_node(_margin, icon)

	var start_pos := icon_position + _icons.rect_position
	var end_pos := Vector2(icon_position.x, _panel.rect_size.y)

	icon.rect_position = start_pos
	# warning-ignore:return_value_discarded
	_tween.interpolate_property(icon, "rect_position",
			start_pos, end_pos, _ANIM_TIME,
			Tween.TRANS_QUAD, Tween.EASE_OUT)
	# warning-ignore:return_value_discarded
	_tween.interpolate_callback(icon, _ANIM_TIME, "queue_free")
