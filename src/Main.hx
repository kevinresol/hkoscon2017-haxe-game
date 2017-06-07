
import luxe.GameConfig;
import luxe.Input;
import luxe.Color;
import luxe.tween.Actuate;
import game.*;
using Lambda;

#if MULTIPLAYER
import haxe.Serializer;
import haxe.Unserializer;
import mp.Command;
import mp.Message;
#end

class Main extends luxe.Game {

	var world:World;
	var state:GameState;
	var connected = false;
	var id:Null<Int> = null;
	#if MULTIPLAYER
	var ws:haxe.net.WebSocket;
	#end

	override function config(config:GameConfig) {

		// https://luxeengine.com/guide/#gettingstarted
		config.window.title = 'Haxe Agar';
		config.window.width = 960;
		config.window.height = 640;
		config.window.fullscreen = false;
		config.render.antialiasing = 8;

		return config;

	} //config

	override function ready() {
		#if MULTIPLAYER
			ws = haxe.net.WebSocket.create("ws://169.254.235.246:8888");
			ws.onopen = function() ws.sendString(Serializer.run(Join));
			ws.onmessageString = function(msg) {
				var msg:Message = Unserializer.run(msg);
				switch msg {
					case Joined(id): this.id = id;
					case State(state): this.state = state;
				}
			}
		#else
			world = new World();
			id = world.createPlayer().id;
		#end

	} //ready

	override function onkeyup(event:KeyEvent) {

		if(event.keycode == Key.escape) {
			Luxe.shutdown();
		}

	} //onkeyup

	override function update(delta:Float) {
		#if MULTIPLAYER
			ws.process();
			if(state == null) return; // not ready
		#else
			state = world.update();
		#end

		// handle move
		var player = state.objects.find(function(o) return o.id == id);
		if(player != null) {
			// move player
			var mid = Luxe.screen.mid;
			if(touched) {
				var cursor = Luxe.screen.cursor.pos;
				var dir = Math.atan2(cursor.y - mid.y, cursor.x - mid.x);
				#if MULTIPLAYER
					if(player.speed == 0) ws.sendString(Serializer.run(StartMove));
					ws.sendString(Serializer.run(SetDirection(dir)));
				#else
					player.speed = 3;
					player.dir = dir;
				#end
			} else {
				#if MULTIPLAYER
					if(player.speed != 0) ws.sendString(Serializer.run(StopMove));
				#else
					player.speed = 0;
				#end
			}

			// update camera
			var scale = player.size / 40;
			Actuate.tween(Luxe.camera.scale, 1.0, {x: scale, y: scale});
			Luxe.camera.pos.set_xy(player.x - mid.x, player.y - mid.y);
		}

		for(object in state.objects) {
			Luxe.draw.circle({
				x: object.x,
				y: object.y,
				r: object.size,
				color: new Color().rgb(object.color),
				immediate: true, // see luxe.Visual & luxe.Sprite for persistent display objects
				depth: object.depth,
			});
		}
	} //update

	var touched:Bool = false;
	override function onmousedown(e) {
		touched = true;
	}

	override function onmouseup(e) {
		touched = false;
	}
	
	override function ontouchdown(e) {
		touched = true;
	}

	override function ontouchup(e) {
		touched = false;
	}

} //Main
