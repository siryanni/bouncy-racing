extends CharacterBody2D
@onready var timerLabel = $"../CanvasLayer/Timer"
@onready var resetTime=0;
const CollisionFricionConstant=0.5 # if 1 then no friction is added, the velocity says the same, if 0 all velocity is removed

func getTimeSec() -> float:
	return  Time.get_ticks_msec()/1000; 
	
func _physics_process(delta: float) -> void:
	print("Processing tick:\n global_position:"+str(global_position)+"\n velocity:"+str(velocity)+"\n rotation:"+str(rotation_degrees)+"\n Time in ticks ms:"+str(getTimeSec()))
	timerLabel.text="Time:"+str(getTimeSec()-resetTime);
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
	resetTime=getTimeSec();
	print("goal reached")
