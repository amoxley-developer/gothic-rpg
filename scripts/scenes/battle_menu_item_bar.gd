class_name BattleMenuItemBar
extends Node2D

@export var menu_resource: BattleMenuItem
@export var menu_name_node: RichTextLabel
var menu_name: String
var sub_menu_items: Array[SubMenuItem]
var is_active := false

func _ready() -> void:
  menu_name = menu_resource.menu_name
  sub_menu_items = menu_resource.sub_menu_items
  set_menu_label()

func set_menu_label() -> void:
  menu_name_node.text = menu_name

func set_menu_active() -> void:
  # change color to white
  is_active = true
  return

func set_menu_inactive() -> void:
  # change color to grey
  is_active = false
  return
