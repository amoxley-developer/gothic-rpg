class_name BattleMenuItem
extends Resource

@export var name: String
@export var sub_menu_items: Array[SubMenuItem]

func on_select() -> void:
    print(sub_menu_items)