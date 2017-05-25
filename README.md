# HKOSCon2017 Haxe Game Workshop

Workshop info: [Build a cross-platform game in Haxe](http://hkoscon.org/2017/topics/build-a-cross-platform-game-in-haxe/)

This is an [agar.io](https://agar.io/) clone to demonstrate the capability of Haxe in building cross platform games,
where codes are shared among multiple game platforms (web, mac, windows, android & ios),
as well as between game client and game server for multiplayer games.

## How to Build and Run

### Install Haxe

Get Haxe from http://haxe.org/download/.

### Install Dependencies

 * [Luxe](https://luxeengine.com). According to the instruction at https://luxeengine.com/get/:

   ```bash
   haxelib install snowfall
   haxelib run snowfall update luxe
   ```
 
 * [hxnodejs](https://github.com/HaxeFoundation/hxnodejs)

   ```bash
   haxelib install hxnodejs
   ```

### Server

```bash
haxe server.hxml
cd bin/server
yarn add ws
node server.js
```

### Client

```bash
haxelib run flow run web
haxelib run flow run mac
haxelib run flow run windows
```

## Shared Code

The `World` class contains the core game logic.
When the game is set to single-player mode, the `World` is run in the client.
In other words, the same piece of Haxe code for the `World` class is compiled into different platforms
(web, mac, windows, android, & ios).
When the game is in multi-player mode, the `World` is run on the server. Again, the same piece of 
Haxe code for the `World` class is compiled into the server language (nodejs for our choice here).

The `Command` and `Message` enums represents the protocol between the client and server in multiplayer
mode. The same piece of code is used in both client and server.

## Feedback / Questions

Feel free to [open issues](https://github.com/kevinresol/hkoscon2017-haxe-game/issues) or contact us directly.

## License

...
