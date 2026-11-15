extends CharacterBody2D
@onready var timerLabel = $"../CanvasLayer/Timer"
@onready var speedometerLabel = $"../CanvasLayer/speedometer"
@onready var resetTime=0;
const CollisionFricionConstant=0.5 # if 1 then no friction is added, the velocity says the same, if 0 all velocity is removed
const vPixSecToVKmHConstant = 1.0/3.0

func getTimeMs() -> float:
	return  Time.get_ticks_msec(); 
	
func getVelocityinKmH() -> float: 
	var vPixSec = velocity.x+velocity.y
	if(vPixSec<0):vPixSec=-vPixSec
	var vKmH = vPixSec*vPixSecToVKmHConstant
	return vKmH
	
func _physics_process(delta: float) -> void:
	
	#log
	print("Processing tick:\n global_position:"+str(global_position)+"\n velocity:"+str(velocity)+"\n rotation:"+str(rotation_degrees)+"\n Time in ticks ms:"+str(getTimeMs()))
	
	#labels
	timerLabel.text="Time: "+str((getTimeMs()-resetTime)/1000)+"s";
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
	resetTime=getTimeMs();
	print("goal reached")
