extends Collectible
class_name Gear

func collected(player : Player):
	player.gears_collected += 1
	player.HUD.set_gears(player.gears_collected)
	super(player)
