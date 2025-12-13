class_name Battlefield
extends Node2D

@onready var player: Player = $Player
@onready var playerUI: PlayerUI = $PlayerUI
@onready var enemy: Enemy = $Enemy

func _ready() -> void:
  playerUI.execute_attack.connect(_on_player_attack)

func _on_player_attack(attack_name: String) -> void:
  if attack_name == 'Sword':
    enemy.take_damage(3)
  elif attack_name == 'Crossbow':
    enemy.take_damage(2)
  playerUI.reset_menu()
