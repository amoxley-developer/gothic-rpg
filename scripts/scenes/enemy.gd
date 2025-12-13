class_name Enemy
extends CharacterBody2D

@export var stats_resource: StatsResource
@onready var healthLabel: RichTextLabel = $HealthLabel

func _ready() -> void:
  update_health_label()

func update_health_label() -> void:
  healthLabel.text = 'Health: ' + str(stats_resource.health)

func take_damage(amount: int) -> void:
  stats_resource.decrease_health(amount)
  update_health_label()