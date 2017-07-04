package turbo.ecs.systems;

import turbo.ecs.components.AbstractComponent;
import turbo.ecs.components.PositionComponent;
import turbo.ecs.components.ImageComponent;
import turbo.ecs.Entity;
import turbo.ecs.TurboState;

import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;

// Looks for and initializes ImageComponent instances
class DrawImageSystem extends AbstractSystem
{
    private var state:TurboState;

    // The old image name. So we know it changed.
    private var previousImages = new Map<Entity, String>();
    
    public function new(state:TurboState)
    {
        super([ImageComponent, PositionComponent]);
        this.state = state;
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        for (entity in this.entities)
        {
            var image:ImageComponent = entity.get(ImageComponent);
            var position:PositionComponent = entity.get(PositionComponent);

            var previous = previousImages.get(entity);
            if (previous != null && image.image != previous)
            {
                // Image changed. Force update.
                this.state.remove(image.sprite);
                image.sprite = null;
                this.entityChanged(entity);
                previousImages.set(entity, image.image);                
            }
            
            if (image.show == true)
            {
                image.sprite.alpha = 1;
                image.show = null;
            }
            else if (image.show == false)
            {                
                image.sprite.alpha = 0;
                image.show = null;
            }
            // Else if null, do nothing
        }
    }
    
    override public function entityChanged(entity:Entity):Void
    {
        super.entityChanged(entity);
        for (entity in this.entities)
        {
            var image:ImageComponent = entity.get(ImageComponent);            
            if (image.sprite == null)
            {
                if (image.isRepeating)
                {
                    image.sprite = new FlxBackdrop(image.image);
                    trace('Sprite for ${entity} is now ${image.sprite}');
                }
                else
                {
                    image.sprite = new FlxSprite(0, 0, image.image);
                    trace('Sprite for ${entity} (${image.sprite}) is now ${image.sprite}');
                }
                this.state.add(image.sprite);
            }
            
            var position:PositionComponent = entity.get(PositionComponent);
            image.sprite.x = position.x;
            image.sprite.y = position.y;
        }
    }
}