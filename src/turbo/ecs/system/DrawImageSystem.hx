package nebula.ecs.system;

import nebula.ecs.component.AbstractComponent;
import nebula.ecs.component.PositionComponent;
import nebula.ecs.component.ImageComponent;
import nebula.ecs.Entity;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;

// Looks for and initializes ImageComponent instances
class DrawImageSystem extends AbstractSystem
{
    private var state:FlxState;
    
    public function new(state:FlxState)
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

            image.sprite.setPosition(position.x,position.y);
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
                    image.sprite = new FlxBackdrop(image.image) ;
                }
                else
                {
                    image.sprite = new FlxSprite(0, 0, image.image);
                }
                this.state.add(image.sprite);
            }
            
            var position:PositionComponent = entity.get(PositionComponent);
            image.sprite.x = position.x;
            image.sprite.y = position.y;
        }
    }
}