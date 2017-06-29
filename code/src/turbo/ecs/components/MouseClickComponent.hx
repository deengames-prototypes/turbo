package turbo.ecs.components;

import flixel.FlxSprite;

class MouseClickComponent extends AbstractComponent
{
    public var isPixelPerfect(default, null):Bool;
    
    // internal
    public var sprite:FlxSprite;
    public var isInitialized:Bool = false;

    public function new(isPixelPerfect:Bool)
    {
        super();
        this.isPixelPerfect = isPixelPerfect;
    }
}