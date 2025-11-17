class_name PlayerUI
extends Node2D

enum States {UNSELECTED, SUBMENU_OPENED, SELECTED}

@export var menu_items: Array[BattleMenuItem]

var current_menu_item: BattleMenuItem
var current_menu_item_idx := 0


var state: States = States.UNSELECTED

func _ready() -> void:
	current_menu_item = menu_items[current_menu_item_idx]
	print(current_menu_item.name)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("accept"):
		if state != States.SELECTED:
			set_state(state+1)
	if Input.is_action_just_pressed("cancel"):
		if state != States.UNSELECTED:
			set_state(state-1)
	# Unselected state
	if state == States.UNSELECTED:
		if Input.is_action_just_pressed('ui_up') or Input.is_action_just_pressed('ui_down'):
			handle_unselected_menu_navigation()

			
func handle_unselected_menu_navigation() -> void:
	var menu_items_size = menu_items.size()
	if Input.is_action_just_pressed('ui_up'):
			if current_menu_item_idx == 0:
				current_menu_item_idx = menu_items_size - 1
			else:
				current_menu_item_idx -= 1
	elif Input.is_action_just_pressed('ui_down'):
		current_menu_item_idx += 1
		if current_menu_item_idx == menu_items_size:
			current_menu_item_idx = 0
	current_menu_item = menu_items[current_menu_item_idx]
	print('current menu item: ', current_menu_item.name)

func set_state(new_state: States) -> void:
	var previous_state := state
	state = new_state
	print('previous_state: ', States.keys()[previous_state])
	print('current_state: ', States.keys()[state])
