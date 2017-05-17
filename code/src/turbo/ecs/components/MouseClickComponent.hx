package turbo.ecs.components;

import flixel.FlxSprite;

class MouseClickComponent extends AbstractComponent
{
    public var mouseDownCallback(default, null):Void->Void;
    public var isPixelPerfect(default, null):Bool;
    
    // internal
    public var sprite:FlxSprite;
    public var isInitialized:Bool = false;

    public function new(isPixelPerfect:Bool, mouseDownCallback:Void->Void)
    {
        super();
        this.mouseDownCallback = callback;
        this.isPixelPerfect = isPixelPerfect;
    }
}