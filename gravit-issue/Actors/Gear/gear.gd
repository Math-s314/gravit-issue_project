extends Collectible
class_name Gear

func collected(player : Player):
	player.gears_collected += 1
	super(player)
