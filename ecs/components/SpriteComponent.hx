package turbo.ecs.components;

import flixel.FlxSprite;
import turbo.ecs.Entity;
import turbo.ecs.components.AbstractComponent;

/**
An internal component; anything with a sprite (colour, image, progress bar).
This makes them followable by the camera.
*/
class SpriteComponent extends AbstractComponent
{
    // internal
    public var sprite:FlxSprite;

    public function new(parent:Entity)
    {
        super(parent);
    }

    public function move(x:Float, y:Float):Void
    {
        if (this.sprite != null)
        {
            this.sprite.x = x;
            this.sprite.y = y;
        }
    }
}