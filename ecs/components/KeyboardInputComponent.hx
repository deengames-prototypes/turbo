package turbo.ecs.components;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.input.FlxInput.FlxInputState;
import turbo.ecs.components.AbstractComponent;

class KeyboardInputComponent extends AbstractComponent
{
    public var moveSpeed(default, null):Int = 0; // pixels per second
    
    public function new(moveSpeed:Int, parent:Entity)
    {
        super(parent);
        this.moveSpeed = moveSpeed;
    }

    override public function update(elapsedSeconds:Float):Void
    {
        super.update(elapsedSeconds);
        
        if (parent.has(PositionComponent))
        {
            var position:PositionComponent = parent.get(PositionComponent);        
                
            var dx:Float = 0;
            var dy:Float = 0;
            var movement:Float = this.moveSpeed * elapsedSeconds;
            
            if (isPressed(FlxKey.LEFT) || isPressed(FlxKey.A))
            {
                dx = -movement;
            }
            else if (isPressed(FlxKey.RIGHT) || isPressed(FlxKey.D))
            {
                dx = movement;
            }
                
            if (isPressed(FlxKey.UP) || isPressed(FlxKey.W))            
            {
                dy = -movement;
            }
            else if (isPressed(FlxKey.DOWN) || isPressed(FlxKey.S))
            {
                dy = movement;
            }
            
            position.x += dx;
            position.y += dy;
        }
    }

    private function isPressed(keyCode:Int)
    {
        return FlxG.keys.checkStatus(keyCode, FlxInputState.PRESSED);
    }
}