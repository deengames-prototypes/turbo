package turbo.ecs.systems;

import flixel.util.FlxColor;
import flixel.FlxSprite;

import turbo.ecs.components.AbstractComponent;
import turbo.ecs.components.ColourComponent;
import turbo.ecs.components.PositionComponent;
import turbo.ecs.Entity;
import turbo.ecs.TurboState;

class DrawColourSystem extends AbstractSystem
{
    private var state:TurboState;
    
    public function new(state:TurboState)
    {
        super([ColourComponent, PositionComponent]);
        this.state = state;
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        for (entity in this.entities)
        {
            var colour:ColourComponent = entity.get(ColourComponent);            
            var position:PositionComponent = entity.get(PositionComponent);

            if (colour.sprite != null)
            {
                // Sprite width or height doesn't match component size
                if (colour.sprite.width != colour.width || colour.sprite.height != colour.height
                // Sprite colour doesn't match component colour
                    || colour.sprite.color.red != colour.red || colour.sprite.color.green != colour.green || colour.sprite.color.blue != colour.blue )
                {
                    this.state.remove(colour.sprite);
                    this.makeSprite(colour);
                    this.state.add(colour.sprite);
                }

                if (colour.show == true)
                {
                    colour.sprite.alpha = 1;
                    colour.show = null;
                }
                else if (colour.show == false)
                {
                    colour.sprite.alpha = 0;
                    colour.show = null;
                }
                // Else if null, do nothing
            }
        }
    }
    
    override public function entityChanged(entity:Entity):Void
    {
        super.entityChanged(entity);
        for (entity in this.entities)
        {
            var colour:ColourComponent = entity.get(ColourComponent);            
            if (colour.sprite == null)
            {
                var s:FlxSprite = this.makeSprite(colour);
                this.state.add(s);
            }
        }
    }
    
    private function makeSprite(colour:ColourComponent):FlxSprite
    {
        var flxColor:FlxColor = FlxColor.fromRGB(colour.red, colour.green, colour.blue);
        var toReturn:FlxSprite = new FlxSprite();
        toReturn.makeGraphic(colour.width, colour.height, flxColor);      
        // Not required (tints), but stores the colour so we can read it later
        toReturn.color = flxColor;
        colour.sprite =  toReturn;
        return toReturn;
    }
}