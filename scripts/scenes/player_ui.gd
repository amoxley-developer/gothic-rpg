class_name Player_UI
extends Node2D

enum States {UNSELECTED, SUBMENU_OPENED, SELECTED}

# Make the PlayerSelections a map with string keys and PlayerSelection value. The PlayerSelection will be a resource
enum PlayerSelections {BASIC_ATTACK, SPECIAL_ATTACK, ITEMS}


var state: States = States.UNSELECTED

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("accept"):
        if state != States.SELECTED:
            set_state(state+1)
        else:
            # print the player selection's option
            set_state(States.UNSELECTED)
    if Input.is_action_just_pressed("cancel"):
        if state != States.UNSELECTED:
            set_state(state-1)

func set_state(new_state: States) -> void:
    var previous_state := state
    state = new_state
    print('previous_state ', previous_state)
    print('current_state ', state)


