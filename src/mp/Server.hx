package mp;

import mp.Message;
import mp.Command;
import game.*;
import haxe.*;
import js.node.events.EventEmitter;

using Lambda;

class Server {
	static function main() {
		// websocket server
		var clients:Array<Client> = [];
		var world = new World();
		var ws = new WebSocketServer({port:8888});
		ws.on('connection', function(cnx:Connection) {
			var client = new Client(cnx);
			clients.push(client);
			
			cnx.on('message', function(msg) {
				var command:Command = Unserializer.run(msg);
				switch command {
					case Join:
						trace(command, client.player);
						if(client.player == null)
							client.player = world.createPlayer();
							
						var msg = Serializer.run(Joined(client.player.id));
						client.connection.send(msg);
					
					case SetDirection(dir):
						if(client.player != null) client.player.dir = dir;
						
					case StartMove:
						if(client.player != null) client.player.speed = 3;
						
					case StopMove:
						if(client.player != null) client.player.speed = 0;
				}
			});
			
			cnx.on('close', function(_) {
				if(client.player != null) 
					client.player.speed = 0; // simply stop moving
				clients.remove(client);
			});
		});
		
		// game loop
		var timer = new haxe.Timer(16);
		timer.run = function() {
			var state = world.update();
			
			// clean up the client-player association
			for(object in state.removed) {
				switch clients.find(function(c) return c.player != null && c.player.id == object.id) {
					case null: // hmm....
					case client: client.player = null;
				}
			}
			
			// boardcast the game state
			var msg = Serializer.run(State(state));
			for(client in clients)
				client.connection.send(msg);
		}
	}
}

class Client {
	public var connection(default, null):Connection;
	public var player:Object;
	
	public function new(connection)
		this.connection = connection;
}


extern class Connection extends EventEmitter<Connection> {
	function send(m:String):Void;
}

@:jsRequire('ws','Server')
extern class WebSocketServer extends EventEmitter<WebSocketServer> {
	function new(?config:Dynamic);
}
