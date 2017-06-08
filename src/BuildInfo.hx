import haxe.macro.*;

using DateTools;

class BuildInfo {
    macro static public function getBuildDate():ExprOf<String> {
        var date = Date.now();
        var str = date.format("%Y-%m-%d %H:%M:%S");
        return macro $v{str};
    }
}