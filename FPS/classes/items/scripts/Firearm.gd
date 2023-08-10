class_name Firearm extends Item

## The caliber that the gun fires. Non-technical
@export_enum("N/A", "7.62 SOVIET", "7.62 RIMMED", "5.45 RU", "5.56 NATO", "7.62 NATO", ".300 Blackout", ".22 LR", "9mm LE", ".45acp", "Five Seven", ".44 Magnum", ".50 AE", "12 Gauge") var caliber: int

## The UID for the ammo used by this gun. Used for technical reference
@export var ammo: String

## How much recoil this gun has when firing
@export var recoil: float

## Speed of the bullet after coming out of the gun
@export var muzzle_velocity: float = 0.0

@onready var bullet: Bullet
@onready var muzzle = $muzzle


func ready():
	print(muzzle)

func _physics_process(delta):
	if is_held: self.primary_action(delta)
	if is_held: self.secondary_action(delta)

func primary_action(triangle):
	if Input.is_action_just_pressed("primary_action"):
		shoot()

func secondary_action(triangle):
	if Input.is_action_just_pressed("secondary_action"):
		print("Secondary Action")

func shoot():
	bullet = load(ammo).instantiate()
	bullet = bullet.duplicate()
	
	get_parent().add_child(bullet)
	bullet.global_position = muzzle.global_position
	
	$AnimationPlayer.stop()
	$AnimationPlayer.play("shoot")
