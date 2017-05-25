package turbo.ecs;

// internal
class AfterEvent
{
    public var seconds(default, default):Float;
    public var callback(default, null):Void->Void;

    public function new(seconds:Float, callback:Void->Void)
    {
        this.seconds = seconds;
        this.callback = callback;
    }
}