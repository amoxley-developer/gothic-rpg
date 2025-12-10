class_name StatsResource
extends Resource

enum CHANGE_DIRECTION {UP, DOWN}

@export var health: int
@export var base_health: int
@export var mana: int
@export var attack: int
@export var base_attack: int
@export var defense: int
@export var speed: int
@export var luck: int

func change_health(amount: int, direction: CHANGE_DIRECTION) -> int:
  if (direction == CHANGE_DIRECTION.UP):
    health += amount
    if health > base_health:
      health = base_health
  else:
    health -= amount
    if health < 0:
      health = 0
  return health

func increase_health(amount: int) -> int:
  return change_health(amount, CHANGE_DIRECTION.UP)

func decrease_health(amount: int) -> int:
  return change_health(amount, CHANGE_DIRECTION.DOWN)