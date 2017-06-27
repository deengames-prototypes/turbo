package turbo.ecs.components;

import flixel.FlxSprite;

class MouseClickComponent extends AbstractComponent
{
    /////// TODO: make this a bind event
    public var mouseDownCallback(default, null):FlxSprite->Void;
    public var isPixelPerfect(default, null):Bool;
    
    // internal
    public var sprite:FlxSprite;
    public var isInitialized:Bool = false;

    public function new(mouseDownCallback:FlxSprite->Void, isPixelPerfect:Bool)
    {
        super();
        this.mouseDownCallback = mouseDownCallback;
        this.isPixelPerfect = isPixelPerfect;
    }
}