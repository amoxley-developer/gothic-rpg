class_name Player
extends CharacterBody2D

@export var stats_resource: StatsResource
@onready var healthLabel: RichTextLabel = $HealthLabel
@onready var playerSprite: Sprite2D = $PlayerSprite

func _ready() -> void:
  update_health_label()

func update_health_label() -> void:
  healthLabel.text = 'Health: ' + str(stats_resource.health)

func display_default_sprite() -> void:
  playerSprite.texture = load("res://assets/sprites/player/player_sprite.png")

func display_attack_sprite() -> void:
  playerSprite.texture = load("res://assets/sprites/player/attack_player_sprite.png")

func display_optimal_attack_sprite() -> void:
  playerSprite.texture = load("res://assets/sprites/player/optimal_attack_player_sprite.png")