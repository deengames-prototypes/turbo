package nebula.ecs.component;

import flixel.FlxSprite;

/**
An internal component; anything with a sprite (colour, image, progress bar).
This makes them followable by the camera.
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