package game;

enum ObjectType {
	Player;
	Ai;
	Food;
}

typedef Object = {
	id:Int,
	type:ObjectType,
	color:Int,
	size:Float,
	dir:Float,
	speed:Float,
	x:Float,
	y:Float,
}