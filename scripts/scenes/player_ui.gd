class_name PlayerUI
extends Node2D

enum States {UNSELECTED, SUBMENU_OPENED, SELECTED}

const MENU_HEIGHT := 16
const MENU_WIDTH := 64

@onready var placeholderLabel: RichTextLabel = $RichTextLabel

const battleMenuItemBarScn := preload("res://scenes/battle_menu_item_bar.tscn")
@export var menu_items_resources: Array[BattleMenuItem]
var menu_items: Array[BattleMenuItemBar]
var sub_menu_items: Array[BattleMenuItemBar]
var current_sub_menu_item_idx := 0
var current_sub_menu_item: BattleMenuItemBar
var current_menu_item: BattleMenuItemBar
var current_menu_item_idx := 0

var state: States = States.UNSELECTED

func _ready() -> void:
	placeholderLabel.visible = false
	create_menu_items()
	set_menu_status(null, current_menu_item)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("accept") or Input.is_action_just_pressed("cancel"):
		handle_menu_selection()
	if Input.is_action_just_pressed('ui_up') or Input.is_action_just_pressed('ui_down'):
		handle_menu_navigation()

func handle_menu_selection() -> void:
	if Input.is_action_just_pressed("accept") and state != States.SELECTED:
		match state:
			States.UNSELECTED:
				current_menu_item.set_menu_label(Enums.MenuItemState.ACTIVE)
				create_sub_menu_items()
				set_menu_status(null, current_sub_menu_item)
			States.SUBMENU_OPENED:
				current_sub_menu_item.set_menu_label(Enums.MenuItemState.ACTIVE)
		set_state(state+1)
	if Input.is_action_just_pressed("cancel") and state != States.UNSELECTED:
		match state:
			States.SUBMENU_OPENED:
				current_menu_item.set_menu_label(Enums.MenuItemState.HIGHLIGHTED)
				current_sub_menu_item_idx = 0
				delete_sub_menu_items()
			States.SELECTED:
				current_sub_menu_item.set_menu_label(Enums.MenuItemState.HIGHLIGHTED)
		set_state(state-1)
			
func handle_menu_navigation() -> void:
	match state:
		States.UNSELECTED:
			var prev_menu_item = current_menu_item
			var menu_items_size = menu_items.size()
			current_menu_item_idx = get_menu_idx(current_menu_item_idx, menu_items_size)
			current_menu_item = menu_items[current_menu_item_idx]
			set_menu_status(prev_menu_item, current_menu_item)
		States.SUBMENU_OPENED:
			var prev_sub_menu_item = current_sub_menu_item
			var sub_menu_items_size = sub_menu_items.size()
			current_sub_menu_item_idx = get_menu_idx(current_sub_menu_item_idx, sub_menu_items_size)
			current_sub_menu_item = sub_menu_items[current_sub_menu_item_idx]
			set_menu_status(prev_sub_menu_item, current_sub_menu_item)

func get_menu_idx(current_idx: int, menu_size: int) -> int:
	if Input.is_action_just_pressed('ui_up'):
		if current_idx == 0:
			current_idx = menu_size - 1
		else:
			current_idx -= 1
	elif Input.is_action_just_pressed('ui_down'):
		current_idx += 1
		if current_idx == menu_size:
			current_idx = 0
	return current_idx

func set_menu_status(prev_menu_item: BattleMenuItemBar, curr_menu_item: BattleMenuItemBar) -> void:
	if prev_menu_item:
		prev_menu_item.set_menu_label(Enums.MenuItemState.INACTIVE)
	curr_menu_item.set_menu_label(Enums.MenuItemState.HIGHLIGHTED)

func set_state(new_state: States) -> void:
	var previous_state := state
	state = new_state
	print('previous_state: ', States.keys()[previous_state])
	print('current_state: ', States.keys()[state])

func create_menu_items() -> void:
	var y_pos := 0
	for menu_resource in menu_items_resources:
		var battle_menu_item_bar: BattleMenuItemBar = battleMenuItemBarScn.instantiate()
		battle_menu_item_bar.menu_resource = menu_resource
		battle_menu_item_bar.position = Vector2(0, y_pos)
		menu_items.append(battle_menu_item_bar)
		add_child(battle_menu_item_bar)
		y_pos += MENU_HEIGHT + 8
	current_menu_item = menu_items[current_menu_item_idx]

func create_sub_menu_items() -> void:
	var y_pos := 0
	for submenu_resource in current_menu_item.sub_menu_items:
		var sub_battle_menu_item_bar: BattleMenuItemBar = battleMenuItemBarScn.instantiate()
		sub_battle_menu_item_bar.sub_menu_resource = submenu_resource
		sub_battle_menu_item_bar.position = Vector2(MENU_WIDTH + 16, y_pos)
		sub_menu_items.append(sub_battle_menu_item_bar)
		add_child(sub_battle_menu_item_bar)
		y_pos += MENU_HEIGHT + 8
	current_sub_menu_item = sub_menu_items[current_sub_menu_item_idx]

func delete_sub_menu_items() -> void:
	for sub_menu_item in sub_menu_items:
		sub_menu_item.queue_free()
	sub_menu_items = []
	current_sub_menu_item = null
