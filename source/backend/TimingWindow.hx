package backend;

class TimingWindow {
    public static var sick:Float  = 45;   // ms
    public static var good:Float  = 90;
    public static var bad:Float   = 135;
    public static var miss:Float  = 180;

    public static function judge(diff:Float):String {
        var ad = Math.abs(diff);
        if (ad <= sick) return "sick";
        if (ad <= good) return "good";
        if (ad <= bad)  return "bad";
        return "miss";
    }
}
