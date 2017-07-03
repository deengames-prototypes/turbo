package turbo.ecs.systems;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.FlxInput.FlxInputState;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;

import turbo.ecs.Entity;
import turbo.ecs.components.KeyboardInputComponent;
import turbo.ecs.components.PositionComponent;
import turbo.ecs.components.SpriteComponent;
import turbo.ecs.components.VelocityComponent;

// Looks for KeyboardInputComponents and moves their SpriteComponents to arrow keys or WASD
// Use velocity, since that plays well with collisions
class KeyboardInputSystem extends AbstractSystem
{
    public function new()
    {
        super([KeyboardInputComponent, PositionComponent, VelocityComponent, SpriteComponent]);
    }
        
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        for (entity in this.entities)
        {
            var component:KeyboardInputComponent = entity.get(KeyboardInputComponent);
            var sprite:SpriteComponent = entity.get(SpriteComponent);
            var velocityComponent = entity.get(VelocityComponent);

            var vx:Float = 0;
            var vy:Float = 0;
            var isMoving:Bool = false;
            
            if (isPressed(FlxKey.LEFT) || isPressed(FlxKey.A))
            {
                vx = -component.moveSpeed;
                isMoving = true;
            }
            else if (isPressed(FlxKey.RIGHT) || isPressed(FlxKey.D))
            {
                vx = component.moveSpeed;
                isMoving = true;
            }
                
            if (isPressed(FlxKey.UP) || isPressed(FlxKey.W))            
            {
                vy = -component.moveSpeed;
                isMoving = true;
            }
            else if (isPressed(FlxKey.DOWN) || isPressed(FlxKey.S))
            {
                vy = component.moveSpeed;
                isMoving = true;
            }

            if (isMoving)
            {
                velocityComponent.set("Movement", vx, vy);
            }
            else
            {
                velocityComponent.set("Movement", 0, 0);
            }

            var finalVelocity = velocityComponent.getVelocity();
            sprite.sprite.velocity.x = finalVelocity.x;
            sprite.sprite.velocity.y = finalVelocity.y;

            // We know this sprite has velocity, and that velocity determines position.
            // In this case, synch back from the sprite to the position component.
            var position = entity.get(PositionComponent);
            position.x = sprite.sprite.x;
            position.y = sprite.sprite.y;
        }
    }
    
    // Overridable function to facilitate testing
    // Key is an int value because Flixel defines it as such. Sigh.
    // Well, anyway, we have to then match/know the key values in our test code.
    // Alternatively, we can return FlxG.keys.getIsDown(), and check that.
    private function isPressed(keyCode:Int)
    {
        return FlxG.keys.checkStatus(keyCode, FlxInputState.PRESSED);
    }
}