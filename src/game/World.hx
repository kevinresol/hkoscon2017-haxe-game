package game;


class World {
	public var objects:Array<Object> = [];
	var size:{width:Int, height:Int};
	var count:Int = 0;
	
	public function new() {
		size = {
			width: 1000,
			height: 1000,
		}
	}
	
	public function insert(object:Object) {
		objects.push(object);
	}
	
	public function remove(object:Object) {
		objects.remove(object);
	}
	
	public function createAi() {
		insert({
			id: count++,
			type: Ai,
			color: Std.random(1 << 24),
			size: 10,
			dir: Math.random() * Math.PI * 2,
			speed: 1,
			x: Std.random(size.width),
			y: Std.random(size.height),
		});
	}
	
	public function update():GameState {
		for(object in objects) if(object.speed != 0) {
			if(object.type == Ai && Math.random() < 0.1) object.dir += Math.random() - 0.5;
			object.x += Math.cos(object.dir) * object.speed;
			object.y += Math.sin(object.dir) * object.speed;
		}
		return objects;
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
