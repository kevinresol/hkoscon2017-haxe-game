package mp;

// sent from client to server
enum Command {
	Join;
	SetDirection(dir:Float);
	StartMove;
	StopMove;
}