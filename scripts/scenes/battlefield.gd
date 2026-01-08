class_name Battlefield
extends Node2D

@onready var player: Player = $Player
@onready var playerUI: PlayerUI = $PlayerUI
@onready var enemy: Enemy = $Enemy
@onready var attack_pre_timer: Timer = $AttackTimers/PreTimer
@onready var attack_initial_timer: Timer = $AttackTimers/InitialTimer
@onready var attack_optimal_timer: Timer = $AttackTimers/OptimalTimer
@onready var attack_post_timer: Timer = $AttackTimers/PostTimer

var current_attack: String
var tween: Tween
var attacked: bool

enum BattlefieldState {UI_SELECTION, PLAYER_ATTACK, ENEMY_ATTACK}

var current_state: BattlefieldState

func _ready() -> void:
	playerUI.execute_attack.connect(_on_player_attack)
	set_state(BattlefieldState.UI_SELECTION)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("accept"):
		if current_state == BattlefieldState.PLAYER_ATTACK:
			if current_attack == 'Crossbow':
				execute_crossbow_attack()

func _on_player_attack(attack_name: String) -> void:
	set_state(BattlefieldState.PLAYER_ATTACK)
	if attack_name == 'Sword':
		start_sword_attack()
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

func start_sword_attack() -> void:
	const pre_timer_length := .5
	attack_pre_timer.wait_time = pre_timer_length
	attack_initial_timer.wait_time = 1.5
	attack_optimal_timer.wait_time = 1

	if tween:
		tween.kill()
	tween = create_tween()
	var new_x := enemy.position.x - 64
	tween.tween_property(player, "position", Vector2(new_x, player.position.y), pre_timer_length).set_trans(Tween.TRANS_SINE);
	attack_pre_timer.start()

func start_crossbow_attack() -> void:
	attack_pre_timer.wait_time = .5
	attack_initial_timer.wait_time = 1
	attack_optimal_timer.wait_time = 1
	attack_pre_timer.start()

func execute_crossbow_attack() -> void:
	if not attack_pre_timer.is_stopped() or attacked:
		return
	var attack_multiplier := 1.0
	if not attack_initial_timer.is_stopped():
		attack_multiplier = 0.5
	elif not attack_optimal_timer.is_stopped():
		attack_multiplier = 2.0

	attack_pre_timer.stop()
	attack_initial_timer.stop()
	attack_optimal_timer.stop()

	enemy.take_damage(ceil(2 * attack_multiplier))
	attacked = true
	attack_post_timer.start()

func _on_pre_timer_timeout() -> void:
	if current_attack == 'Crossbow':
		attack_initial_timer.start()
		player.display_attack_sprite()

func _on_initial_timer_timeout() -> void:
	attack_optimal_timer.start()
	player.display_optimal_attack_sprite()

func _on_optimal_timer_timeout() -> void:
	if (current_attack == 'Crossbow'):
		execute_crossbow_attack()

func _on_post_timer_timeout() -> void:
	playerUI.reset_menu()
	player.display_default_sprite()
	playerUI.unpause_ui()
	attacked = false
	set_state(BattlefieldState.UI_SELECTION)
