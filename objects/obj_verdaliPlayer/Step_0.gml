/// @description Movement, Attacking, and Animation
// Can only move Verdali when chaos is not spawned
if (!instance_exists(obj_chaosPlayer) && !chaosSpawned) {
	
	if (state == "Move") {
		#region setup calculations
		// check key input
		key_changeForm = keyboard_check_pressed(ord("X")); // changing form
		key_spawnChaos = keyboard_check_pressed(ord("C")); // spawning Chaos

		// get direction movement
		move_dir = input.key_right - input.key_left;

		// check if on wall or ground
		onGround = place_meeting(x, y + 1, obj_testWall);
		onWall = place_meeting(x - 5, y, obj_testWall) - place_meeting(x + 5, y, obj_testWall);

		mvtLocked = max(mvtLocked - 1, 0);
		dashDuration = max(dashDuration - 1, 0);
		#endregion
		
		#region vertical movement
		if (dashDuration > 0) {
			vsp = 0;
		}
		else if (onWall != 0) {
			vsp = min(vsp + 1, 5);
		}
		else {
			vsp++;
		}
		
		// roll dodging
		if (input.key_dash && onGround) {
			image_index = 0;
			state = "Roll";	
		}

		// coyote time
		if (!onGround) {
			if (coyote_counter > 0) {
				coyote_counter--;
		
				if (!jumped) {
					if (input.key_jump) {
						vsp = -jumpSpeed;
						jumped = true;
					}
				}
			}
		} else {
			jumped = false;
			coyote_counter = coyote_max;
		}

		// Handle jump input buffering
		if (input.key_jump) {
			jumpBuffer = jumpBufMax;
		}

		// handle jump calculations and jump buffering
		if (jumpBuffer > 0) {
			if (input.key_jump) {
				if (onGround) {
					vsp = -jumpSpeed;
					jumpBuffer = 0;
					jumped = true;
				}
		
			}
		}
		#endregion

		#region horizontal movement
		// Handles horizontal left and right movement

		accelAndDecel();
		
		#endregion
		
		#region collision
		collisions(obj_testWall);
		#endregion
	
		#region change form
		// spawn chaos
		if (key_spawnChaos && onGround && hsp == 0 && vsp == 0 && !chaosSpawned){
			show_debug_message("Chaos has appeared!");
			screenShake(2, 20);
			instance_create_layer(x, y, "Player", obj_chaosPlayer);
			chaosSpawned = true;
		}
		chaosSpawned = false;

		// changing form
		if (key_changeForm) {
			screenShake(6, 15);
			state = "Transform";
			
		}
		#endregion
		
		#region attacking and magic
		
		// magic projectile attack TODO limit attack based on mp
		if (input.key_magic && global.verdali_mp > 0) {
			spawnProjectile(4, 30, obj_Magic_Blast, self);
			
		}
		
		// change to attacking state
		if (input.key_attack) {
			state = "Attack";
			
			// combo
			if (input.key_attack && image_index >= 2){
				image_index = 0;
				state = "Attack Two";
			}
		}
		#endregion
		
	}
	
}


#region animation
// Jumping
if (!onGround) {
				
	// mid-air attacking
	if (state == "Attack") {
		vsp = 0;
		changeSprite(0.7, spr_Verdali_Attack1);
					
		if (animationHitFrame(2)) {
			makeHitBox(spr_V_NewAttackMask, self, 2, 4, damageNum, image_xscale);
		}
					
		if (animationEnd()) {
			state = "Move";
			image_index = 0;
		}
					
	}
	// mid-air transform
	else if (state == "Transform") {
		vsp = 0;
		changeSprite(0.7, spr_Verdali_Transform);
		transform(obj_bondPlayer);
	}
	// normal jumping
	else {
		changeSprite(0, spr_Verdali_Air);
				
		// falling down
		if (sign(vsp) > 0) {
			image_index = 1;
		}
		// jumping up
		else {
			image_index = 0;
					
		}
	}
				
}
// attacking while on ground
else if (state == "Attack") {
	changeSprite(0.5, spr_Verdali_Attack1);
	// hitboxes
	if (animationHitFrame(2)) {
		makeHitBox(spr_V_NewAttackMask, self, 2, 4, damageNum, image_xscale);
	}
				
	if (animationEnd()) {
		state = "Move";
		image_index = 0;
	}
				
}
// Attack 2
else if (state == "Attack Two") {
	
	changeSprite(0.5, spr_Verdali_Attack2);
	
	if (animationHitFrame(2)) {
		makeHitBox(spr_Verdali_Attack2_Mask, self, 2, 4, damageNum, image_xscale);
	}
		
	if (animationEnd()) {
		state = "Move";
		image_index = 0;
	}
}
// Rolling animation
else if (state == "Roll") {
	if (!place_meeting(x + rollSpeed, y, obj_testWall) && !place_meeting(x - rollSpeed, y, obj_testWall)) {
		x += image_xscale * rollSpeed;
		changeSprite(0.6, spr_Verdali_Roll);
	}
	if (animationEnd()) {
		state = "Move";
	}
}
// transforming
else if (state == "Transform") {
	changeSprite(0.3, spr_Verdali_Transform);
	transform(obj_bondPlayer);
}
// on ground
else {
	// idle
	if (hsp == 0) {
		changeSprite(1, spr_Verdali);
	}
	// walking
	else if (abs(hsp) > 0 && abs(hsp) <= 3) {
		changeSprite(1, spr_Verdali_Walk);
	}
	// running
	else {
		changeSprite(1, spr_Verdali_Run);
	}

}
#endregion
