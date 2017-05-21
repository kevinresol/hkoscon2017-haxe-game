
import luxe.GameConfig;
import luxe.Input;
import luxe.Color;
import luxe.tween.Actuate;
import haxe.*;
import mp.Command;
import mp.Message;
import game.*;

using Lambda;

class Main extends luxe.Game {
    
    var world:World;
    var state:GameState;
    var player:Object;
    var id:Int;
    var mp:Bool = false;
    var ws:js.html.WebSocket; // TODO: cross platform

    override function config(config:GameConfig) {

        config.window.title = 'luxe game';
        config.window.width = 960;
        config.window.height = 640;
        config.window.fullscreen = false;

        return config;

    } //config

    override function ready() {
        if(mp) {
            ws = new js.html.WebSocket('ws://localhost:8888');
            ws.onmessage = function(msg) {
                var msg:Message = Unserializer.run(msg.data);
                switch msg {
                    case Joined(id):
                    case State(s): state = s;
                }
            }
        } else {
            world = new World();
            player = world.createPlayer();
        }
            
    } //ready

    override function onkeyup(event:KeyEvent) {

        if(event.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

    override function update(delta:Float) {
        var mid = Luxe.screen.mid;
        if(touched) {
            var cursor = Luxe.screen.cursor.pos;
            player.dir = Math.atan2(cursor.y - mid.y, cursor.x - mid.x);
            if(mp) try ws.send(Serializer.run(StartMove)) catch(e:Dynamic) {} else player.speed = 3;
        } else {
            if(mp) try ws.send(Serializer.run(StopMove)) catch(e:Dynamic) {} else player.speed = 0;
        }
        
        if(mp) {
            if(state != null) {
                player = state.objects.find(function(o) return o.id == id);
                if(player == null) id = null;
                draw(state.objects);
            }
        } else {
            state = world.update();
            draw(state.objects);
        }
        
        // Update camera
        if(player != null) {
            var scale = player.size / 40;
            Actuate.tween(Luxe.camera.scale, 0.2, {x: scale, y: scale});
            Luxe.camera.pos.set_xy(player.x - mid.x, player.y - mid.y);
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
    
    function draw(objects:Array<Object>) {
        for(object in objects) {
            Luxe.draw.circle({
                x: object.x,
                y: object.y,
                r: object.size, 
                color: new Color().rgb(object.color),
                immediate: true, // should use a sprite/visual
                depth: object.depth,
            });
        }
    }

} //Main
