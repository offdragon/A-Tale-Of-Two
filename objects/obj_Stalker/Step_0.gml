/// @description Movement

event_inherited();

// animations
#region animations

switch (state) {
	#region Attack
	case "Attack":
		changeSprite(1, spr_Stalker_Attack);
		// hitboxes
		if (animationHitFrame(5)) {
			makeHitBox(spr_Stalker_Attack_Mask, self, 2, 4, damage, image_xscale);
		}
		break;
	#endregion
	#region Hurt
	case "Hurt":
		changeSprite(0.5, spr_Stalker_Hurt);
		break;
	#endregion
	#region Regular Movement
	default:
		if (!onGround) {
			// air animations
			changeSprite(0, spr_Stalker_Air);
				
			// falling down
			if (sign(vsp) > 0) {
				image_index = 1;
			}
			// jumping up
			else {
				image_index = 0;
					
			}
		} else {
			if (hsp == 0) {
				changeSprite(1, spr_Stalker_Idle);
			} else {
				changeSprite(1, spr_Stalker_Run);
			}
		}
		break;
	#endregion
}

if (hsp != 0) {
	image_xscale = sign(hsp);
}

#endregion

