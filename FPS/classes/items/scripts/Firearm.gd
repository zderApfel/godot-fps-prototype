class_name Firearm extends Item

## The caliber that the gun fires. Non-technical
@export_enum("N/A", "7.62 SOVIET", "7.62 RIMMED", "5.45 RU", "5.56 NATO", "7.62 NATO", ".300 Blackout", ".22 LR", "9mm LE", ".45acp", "Five Seven", ".44 Magnum", ".50 AE", "12 Gauge", "12g Pepperball", ".68 PB", "Arrow", "Shock Cartridge", ".80 LEAD", "Scrap Metal") var caliber: int

## If the gun can switch from semi to fully automatic
@export var is_automatic: bool = false

## The UID for the ammo used by this gun. Used for technical reference
@export var ammo: String

## How much recoil this gun has when firing
@export var recoil: float

## Maxmimum ammo in a magazine
@export var max_ammo: int

## Current ammo in the gun
@export var current_ammo: int

## Speed of the bullet after coming out of the gun
@export var muzzle_velocity: float = 0.0

@export var aim_down_sights_position: Vector3

@onready var bullet: Bullet
## Where the bullet comes out of the gun when the raycast doesn't hit
@onready var muzzle = $main_body/RayCast3D/muzzle
@onready var hitscan = $main_body/RayCast3D


func _physics_process(delta):
	current_ammo = clamp(current_ammo,0,max_ammo)
	if is_held: 
		self.primary_action(delta)
		self.secondary_action(delta)
		self.melee_action()
		self.reload()

func secondary_action(triangle) -> void:
	if Input.is_action_pressed("secondary_action"):
		position = position.lerp(aim_down_sights_position, 12 * triangle)
		var animation_position: float = 0.0
				
			
	else:
		position = position.lerp(first_person_position, 12 * triangle)

func reload() -> void:
	if Input.is_action_just_pressed("reload") and current_ammo != max_ammo and !Input.is_action_pressed("secondary_action"):
		print("Reloading weapon...")
		if current_ammo == 0:
			$AnimationPlayer.play("reload_empty")
			await $AnimationPlayer.animation_finished
			to_idle()
		else:
			$AnimationPlayer.play("reload")
			await $AnimationPlayer.animation_finished
			to_idle()
			
func shoot() -> void:
	$AnimationPlayer.stop()
	current_ammo -= 1
	bullet = load(ammo).instantiate()
	bullet = bullet.duplicate()
	
	Helpers.get_world(self).add_child(bullet)
	if hitscan.is_colliding(): bullet.impact(hitscan.get_collider())
	
	else:
		bullet.transform = muzzle.global_transform
		bullet.is_flying = true
		bullet.is_lootable = false
		bullet.muzzle_velocity = muzzle_velocity
		bullet.velocity = -bullet.transform.basis.z * muzzle_velocity

	$AnimationPlayer.play("RESET")
	$AnimationPlayer.speed_scale = 1.0
	$AnimationPlayer.play("shoot")


