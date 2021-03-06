/// @description

position_bar_y = lerp(position_bar_y, position_bar_y_end, 0.2);

if (abs(position_bar_y - position_bar_y_end) <= 5) {
	canDisplayText = true;
}

if (canDisplayText) {
	if (!is_waiting_for_keypress) {
		if (delta_time mod (room_speed * 0.01) == 0) {
			if (dialog_get_picture() == spr_Chaos_Icons) {
				audio_play_sound(snd_ChaosDialog, 2, false);
				audio_sound_pitch(snd_ChaosDialog, choose(0.8, 1.0, 1.2));
			}
			if (dialog_get_picture() == spr_Verdali_Icons) {
				audio_play_sound(snd_VerdaliDialog, 2, false);
				audio_sound_pitch(snd_VerdaliDialog, choose(0.6, 0.8, 1.0));
			}
			character_index++;
		}
		
		if (keyboard_check_released(vk_enter)) {
			character_index = string_length(dialog_get_message());
		}
		
		if (character_index >= string_length(dialog_get_message())) {
			is_waiting_for_keypress = true;
		}
	} else {
		if (keyboard_check_released(vk_enter)) {
			audio_play_sound(snd_Pickup1, 1, false);
			is_waiting_for_keypress = false;
			character_index = 0;
			
			dialog_next();
			
			if (dialog_end()) {
				dialog_cleanup();
				instance_destroy();
			}
		}
	}
	
}
