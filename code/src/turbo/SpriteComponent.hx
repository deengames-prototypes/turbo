package turbo.ecs.component;

import flixel.FlxSprite;

/**
An internal component; anything with a sprite (colour, image).
*/
class SpriteComponent extends AbstractComponent
{
    // internal
    public var sprite:FlxSprite;

    public function new()
    {
        super();
    }
}