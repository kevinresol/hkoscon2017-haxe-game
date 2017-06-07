package game;


class World {
	public var objects:Array<Object> = [];
	var size:{width:Int, height:Int};
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
			if(object.type == Ai && Math.random() < 0.1) object.dir += Math.random() - 0.5;
			object.x += Math.cos(object.dir) * object.speed;
			object.y += Math.sin(object.dir) * object.speed;
		}

		var removed = [];

		for(object in objects) {
			for(other in objects) {
				if(object.size > other.size) {
					var dx = object.x - other.x;
					var dy = object.y - other.y;
					if(dx * dx + dy * dy < object.size * object.size) {
						removed.push(other);
						object.size += other.size * 0.1;
					}
				}
			}
		}

		for(object in removed) {
			remove(object);
			if(object.type == Food) createFood();
		}

		return {
			objects: objects,
			removed: removed,
		}
	}
}




/**
 *
 *  var player = new Visual({
 *  	pos: new Vector(100, 100),
 *  	scale: new Vector(1, 1),
 *  	geom: Luxe.draw.circle(),
 *  	depth: 1,
 *
 *  });
 *
 *  player.pos.x =
 *  player.scale.x =
 *  player.destroy();
 *
 *  function ontouchdown() {
 *
 *  }
 *
 *  function update(dt) {
 *  	state = world.update();
 *  	draw(state);
 *  }
 */
