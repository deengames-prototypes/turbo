package turbo.ecs.systems;

import turbo.ecs.components.AbstractComponent;
import turbo.ecs.components.PositionComponent;
import turbo.ecs.components.SpriteComponent;
import turbo.ecs.components.TextComponent;
import turbo.ecs.Entity;

import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;

// Moves stuff to entity.move(x, y). Does NOT apply velocity.
// Velocity works differently (see: KeyboardInputMovementSystem).
// Also, doesn't deal with collisions; see: CollisionSystem
class MoveSystem extends AbstractSystem
{
    public function new()
    {
        // With a sprite component or a text component
        super([PositionComponent]);
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        for (entity in this.entities)
        {
            var position:PositionComponent = entity.get(PositionComponent);

            // e.move(...) is one-time, not continuously applied. Play nice with keyboard input + collisions.
            if (position.moveToX != null && position.moveToY != null)
            {
                position.x = position.moveToX;
                position.y = position.moveToY;
                position.moveToX = null;
                position.moveToY = null;

                if (entity.has(SpriteComponent))
                {
                    var sprite:SpriteComponent = entity.get(SpriteComponent);
                    sprite.sprite.x = position.x;
                    sprite.sprite.y = position.y;
                }
                else if (entity.has(TextComponent))
                {
                    var text:TextComponent = entity.get(TextComponent);
                    text.textField.x = position.x;
                    text.textField.y = position.y;
                }
                else
                {
                    throw "Can't move entity without a sprite or text component.";
                }
            }
        }
    }
}