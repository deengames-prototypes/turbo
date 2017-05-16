package nebula.ecs.system;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.FlxInput.FlxInputState;
import flixel.input.keyboard.FlxKey;

import nebula.ecs.Entity;
import nebula.ecs.component.AbstractComponent;
import nebula.ecs.component.KeyboardInputComponent;
import nebula.ecs.component.PositionComponent;

// Looks for KeyboardInputComponents and moves their SpriteComponents to arrow keys or WASD
class KeyboardInputMovementSystem extends AbstractSystem
{
    public function new()
    {
        super([KeyboardInputComponent, PositionComponent]);
    }
        
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        for (entity in this.entities)
        {
            var component:KeyboardInputComponent = entity.get(KeyboardInputComponent);
            var position:PositionComponent = entity.get(PositionComponent);
                
            var dx:Float = 0;
            var dy:Float = 0;
            var movement:Float = component.moveSpeed * elapsed;
            
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
    
    // Overridable function to facilitate testing
    // Key is an int value because Flixel defines it as such. Sigh.
    // Well, anyway, we have to then match/know the key values in our test code.
    private function isPressed(keyCode:Int)
    {
        return FlxG.keys.checkStatus(keyCode, FlxInputState.PRESSED);
    }
}