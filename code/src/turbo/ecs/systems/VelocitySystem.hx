package turbo.ecs.systems;

import turbo.ecs.components.PositionComponent;
import turbo.ecs.components.SpriteComponent;
import turbo.ecs.components.VelocityComponent;
import turbo.ecs.Entity;

import flixel.FlxSprite;

class VelocitySystem extends AbstractSystem
{
    public function new()
    {
        
        super([VelocityComponent, SpriteComponent, PositionComponent]);
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        for (entity in this.entities)
        {
            var velocityComponent = entity.get(VelocityComponent);
            var sprite = entity.get(SpriteComponent);

            var aggregateVelocity = velocityComponent.velocity;
            sprite.sprite.velocity.copyFrom(aggregateVelocity);

            // We know this sprite has velocity, and that velocity determines position.
            // In this case, synch back from the sprite to the position component.
            var position = entity.get(PositionComponent);
            position.x = sprite.sprite.x;
            position.y = sprite.sprite.y;
            trace('V: sprite is at ${sprite.sprite.x}, ${sprite.sprite.y}');
        }
    }
}