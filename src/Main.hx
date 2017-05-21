
import luxe.GameConfig;
import luxe.Input;
import luxe.Color;
import game.*;

class Main extends luxe.Game {
    
    var world:World;
    var player:Object;

    override function config(config:GameConfig) {

        config.window.title = 'luxe game';
        config.window.width = 960;
        config.window.height = 640;
        config.window.fullscreen = false;

        return config;

    } //config

    override function ready() {
        world = new World();
        player = world.createPlayer();
        for(i in 0...5)
            world.createAi();
        for(i in 0...20)
            world.createFood();
    } //ready

    override function onkeyup(event:KeyEvent) {

        if(event.keycode == Key.escape) {
            Luxe.shutdown();
        }

    } //onkeyup

    override function update(delta:Float) {
        if(touched) {
            var cursor = Luxe.screen.cursor.pos;
            player.dir = Math.atan2(cursor.y - Luxe.screen.mid.y, cursor.x - Luxe.screen.mid.x);
            player.speed = 3;
        } else {
            player.speed = 0;
        }
        draw(world.update());
        Luxe.camera.pos.set_xy(player.x - Luxe.screen.mid.x, player.y - Luxe.screen.mid.y);
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
            });
        }
    }

} //Main
