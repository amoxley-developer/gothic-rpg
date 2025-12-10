class_name Battlefield
extends Node2D

@onready var player: Player = $Player
@onready var playerUI: PlayerUI = $PlayerUI
@onready var enemy: Enemy = $Enemy

func _ready() -> void:
  playerUI.execute_attack.connect(_on_player_attack)

func _on_player_attack(attack_name: String) -> void:
  print(attack_name)

