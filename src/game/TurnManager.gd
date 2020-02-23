class_name TurnManager
extends Node

signal turn_started(actor)
signal action_started(actor)
signal action_ended(actor)
signal turn_ended(actor)

var running := false

var _current_index := 0


func start(map: Map, gui: BattleGUI) -> void:
	var actors := map.get_actors()

	running = true
	_current_index = 0

	while running:
		var actor := actors[_current_index] as Actor
		var controller := actor.controller as Controller
		var battle_stats := actor.battle_stats as BattleStats

		if controller:
			battle_stats.start_turn()
			controller.connect_to_gui(gui)

			emit_signal("turn_started", actor)

			while not battle_stats.finished:
				controller.determine_action()
				var action: Action = yield(controller, "determined_action")
				if action:
					action.start()
					emit_signal("action_started", actor)
					yield(action, "finished")
					emit_signal("action_ended", actor)

			emit_signal("turn_ended", actor)
			controller.disconnect_from_gui(gui)

		_current_index = (_current_index + 1) % actors.size()
