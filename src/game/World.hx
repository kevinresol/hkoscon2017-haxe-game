package game;


class World {
	// list of active game objects
	public var objects:Array<Object> = [];
	
	// objects spawns within this rectangle
	var size:{width:Int, height:Int};
	
	// counter for the object IDs
	var count:Int = 0;

	public function new() {
		size = {
			width: 2000,
			height: 2000,
		}

		for(i in 0...10) createAi();
		for(i in 0...50) createFood();
	}

	public function insert(object:Object) {
		objects.push(object);
		return object;
	}

	public inline function remove(object:Object) {
		objects.remove(object);
	}

	public function createPlayer() {
		return insert({
			id: count++,
			type: Player,
			color: 0xfffffff,
			size: 40,
			dir: Math.random() * Math.PI * 2,
			speed: 3,
			x: Std.random(size.width),
			y: Std.random(size.height),
			depth: 3,
		});
	}

	public function createAi() {
		return insert({
			id: count++,
			type: Ai,
			color: Std.random(1 << 24),
			size: 40,
			dir: Math.random() * Math.PI * 2,
			speed: 1,
			x: Std.random(size.width),
			y: Std.random(size.height),
			depth: 2,
		});
	}

	public function createFood() {
		return insert({
			id: count++,
			type: Food,
			color: Std.random(1 << 24),
			size: 10,
			dir: Math.random() * Math.PI * 2,
			speed: 0,
			x: Std.random(size.width),
			y: Std.random(size.height),
			depth: 1,
		});
	}

	public function update():GameState {
		
		for(object in objects) if(object.speed != 0) {
			
			// randomize AI direction
			if(object.type == Ai && Math.random() < 0.1) object.dir += Math.random() - 0.5;
			
			// update object positions by their speed and direction
			object.x += Math.cos(object.dir) * object.speed;
			object.y += Math.sin(object.dir) * object.speed;
		}
		
		// detect collisions and make larger objects consume smaller objects
		var removed = [];

		for(object in objects) {
			for(other in objects) {
				if(object.size > other.size) {
					var dx = object.x - other.x;
					var dy = object.y - other.y;
					
					// distance < radius
					if(dx * dx + dy * dy < object.size * object.size) {
						// we don't want to modify the array we are iterating
						removed.push(other);
						
						// size increases after consuming the target
						object.size += other.size * 0.1;
					}
				}
			}
		}
		
		for(object in removed) {
			
			// actually remove the objects
			remove(object);
			
			// replenish food
			if(object.type == Food) createFood();
			
		}

		return {
			objects: objects,
			removed: removed,
		}
	}
}
