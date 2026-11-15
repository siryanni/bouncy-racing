extends CharacterBody2D
class_name main
@onready var carTextures = [
	preload("res://auto_gelb.png"),
	preload("res://assets/Car.png"),
	preload("res://auto_lila.png"),
	preload("res://assets/bmw.png"),
	preload("res://auto_braun.png"),
	preload("res://car-sprite.png"),
	preload("res://assets/mazdamx1995na.png")
]

@onready var timerLabel = $"../CanvasLayer/Timer"
@onready var Car = $CarSprite
@onready var ASound = $accelerationSound
@onready var speedometerLabel = $"../CanvasLayer/speedometer"
@onready var speedometerNeedle = $"../CanvasLayer/speedometeNeedleSprite"
var resetTime=0;
var roundTimesRecord=""
const CollisionFricionConstant=0.5 # if 1 then no friction is added, the velocity says the same, if 0 all velocity is removed
const vPixSecToVKmHConstant = 1.0/3.0

func speedToNeedleRotation(speed: float)->float:
	return ((0.6)*speed)-90

func getTimeMs() -> float:
	return  Time.get_ticks_msec(); 
	
func getVelocityinKmH() -> float: 
	var vPixSec = velocity.x+velocity.y
	if(vPixSec<0):vPixSec=-vPixSec
	var vKmH = vPixSec*vPixSecToVKmHConstant
	return vKmH
	
func _physics_process(delta: float) -> void:
	
	UpdateCarTexture(Global.carTextureIndex)
	
	#log
	print("Processing tick:"+
	"\n global_position:"+str(global_position)+
	"\n velocity:"+str(velocity)+
	"\n rotation:"+str(rotation_degrees)+
	"\n Time in ticks ms:"+str(getTimeMs())+
	"\n Speed:"+str(getVelocityinKmH()))
	
	#rotate speedometer needle
	speedometerNeedle.rotation_degrees=speedToNeedleRotation(getVelocityinKmH())
	
	#labels
	timerLabel.text="Record Times:"+str(roundTimesRecord)+" Time: "+str((getTimeMs()-resetTime)/1000)+"s";
	speedometerLabel.text="Speed: "+str(getVelocityinKmH())+"km/h"
	
	# process friction 
	if(velocity.x>0):velocity.x-=1;
	if(velocity.y>0):velocity.y-=1;
	
	if(velocity.x<0):velocity.x+=1;
	if(velocity.y<0):velocity.y+=1;
	
	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	
	#process rotation changes
	if(direction[0]<0):rotation_degrees=rotation_degrees-1;
	if(direction[0]>0):rotation_degrees=rotation_degrees+1;
	
	#process velocity changes
	var totalAdditionalVelocity=1;
	if(direction[1]>0): totalAdditionalVelocity=10;#forward
	if(direction[1]<0):totalAdditionalVelocity=-10#backward

	velocity.x += cos(rotation) * totalAdditionalVelocity
	velocity.y += sin(rotation) * totalAdditionalVelocity
	
	if(not direction[1]==0):ASound.play()
	move_and_slide()

func _on_boundaries_area_entered(area: Area2D) -> void:#boundries
	print("collided")
	velocity.x=-velocity.x
	velocity.y=-velocity.y
	return;	


func _on_area_2d_area_entered(area: Area2D) -> void:#boundries2
	print("collided")
	velocity.x=-velocity.x
	velocity.y=-velocity.y
	velocity.x=velocity.x*CollisionFricionConstant
	velocity.y=velocity.y*CollisionFricionConstant
	return;	


func _on_goal_area_area_entered(area: Area2D) -> void:#goal
	roundTimesRecord+=str((getTimeMs()-resetTime)/1000)+"s\n"
	resetTime=getTimeMs();
	
	print("goal reached")

func UpdateCarTexture(index: int)-> void:
		Car.texture = carTextures[index]
