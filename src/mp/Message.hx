package mp;

import game.*;

// sent from server to client
enum Message {
	Joined(id:Int);
	State(state:GameState);
}