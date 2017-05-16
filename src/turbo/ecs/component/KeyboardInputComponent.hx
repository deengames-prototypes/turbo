package nebula.ecs.component;

import flixel.FlxSprite;

class KeyboardInputComponent extends AbstractComponent
{
    public var moveSpeed(default, null):Int = 0; // pixels per second
    
    public function new(moveSpeed:Int)
    {
        super();
        this.moveSpeed = moveSpeed;
    }
}