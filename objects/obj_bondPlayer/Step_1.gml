/// @description Death
if (global.bond_hp <= 0) {
	state = "Respawn";
	global.myLives--;
	global.bond_hp = global.bond_maxHp;
}