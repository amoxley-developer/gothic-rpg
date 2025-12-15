class_name Battlefield
extends Node2D

@onready var player: Player = $Player
@onready var playerUI: PlayerUI = $PlayerUI
@onready var enemy: Enemy = $Enemy
@onready var attack_pre_timer: Timer = $AttackTimers/PreTimer
@onready var attack_initial_timer: Timer = $AttackTimers/InitialTimer
@onready var attack_optimal_timer: Timer = $AttackTimers/OptimalTimer


var current_attack: String

enum BattlefieldState {UI_SELECTION, PLAYER_ATTACK, ENEMY_ATTACK}

var current_state: BattlefieldState

func _ready() -> void:
	playerUI.execute_attack.connect(_on_player_attack)
	set_state(BattlefieldState.UI_SELECTION)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("accept"):
		if current_state == BattlefieldState.PLAYER_ATTACK:
			execute_attack()


func _on_player_attack(attack_name: String) -> void:
	print('attacking')
	set_state(BattlefieldState.PLAYER_ATTACK)
	if attack_name == 'Sword':
		enemy.take_damage(3)
	elif attack_name == 'Crossbow':
		start_crossbow_attack()
	current_attack = attack_name
	playerUI.pause_ui()

func set_state(new_state: BattlefieldState) -> void:
	if new_state == BattlefieldState.UI_SELECTION:
		playerUI.unpause_ui()
	else:
		playerUI.pause_ui()
	current_state = new_state

func start_crossbow_attack() -> void:
	attack_pre_timer.wait_time = .5
	attack_initial_timer.wait_time = 1
	attack_optimal_timer.wait_time = 1
	attack_pre_timer.start()

func execute_attack() -> void:
	if not attack_pre_timer.is_stopped():
		return
	var attack_multiplier := 1.0
	if not attack_initial_timer.is_stopped():
		attack_multiplier = 0.5
	elif not attack_optimal_timer.is_stopped():
		attack_multiplier = 2.0
	var base_damage := 0
	if current_attack == 'Crossbow':
		base_damage = 2
	else:
		base_damage = 3

	attack_pre_timer.stop()
	attack_initial_timer.stop()
	attack_optimal_timer.stop()

	enemy.take_damage(ceil(base_damage * attack_multiplier))
	playerUI.unpause_ui()
	playerUI.reset_menu()
	set_state(BattlefieldState.UI_SELECTION)

func _on_pre_timer_timeout() -> void:
	print('completed pre timer')
	attack_initial_timer.start()

func _on_initial_timer_timeout() -> void:
	print('completed initial timer')
	attack_optimal_timer.start()

func _on_optimal_timer_timeout() -> void:
	print('completed optimal timer')
	execute_attack()
