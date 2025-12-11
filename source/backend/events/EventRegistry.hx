package backend.events;

class EventRegistry {
    public static var handlers:Map<String, UnifiedEventHandler> = new Map();

    public static function register(name:String, handler:UnifiedEventHandler) {
        handlers.set(name.toLowerCase(), handler);
    }

    public static function get(name:String):UnifiedEventHandler {
        return handlers.get(name.toLowerCase());
    }

    public static function exists(name:String):Bool {
        return handlers.exists(name.toLowerCase());
    }
}
