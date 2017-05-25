package game;

@:keep
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
	depth:Float,
	x:Float,
	y:Float,
}