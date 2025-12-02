class_name BattleMenuItemBar
extends Node2D

@export var menu_resource: BattleMenuItem
@export var menu_name_node: RichTextLabel

var sub_menu_resource: SubMenuItem
var menu_name: String
var sub_menu_items: Array[SubMenuItem] = []

func _ready() -> void:
	if menu_resource != null: 
		menu_name = menu_resource.menu_name
		sub_menu_items = menu_resource.sub_menu_items
	if sub_menu_resource != null:
		menu_name = sub_menu_resource.name
	set_menu_label(Enums.MenuItemState.INACTIVE)

func set_menu_label(menu_item_state: Enums.MenuItemState) -> void:
	menu_name_node.text = ''
	var color: Color
	match menu_item_state:
		Enums.MenuItemState.INACTIVE:
			color = Color.BLACK
		Enums.MenuItemState.HIGHLIGHTED:
			color = Color.GRAY
		Enums.MenuItemState.ACTIVE:
			color = Color.WHITE
	
	menu_name_node.push_color(color)
	menu_name_node.append_text(menu_name)
	menu_name_node.pop()
