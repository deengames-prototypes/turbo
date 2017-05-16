package nebula.ecs.system;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxState;

import nebula.ecs.component.AbstractComponent;
import nebula.ecs.component.ProgressBarComponent;
import nebula.ecs.component.PositionComponent;
import nebula.ecs.Entity;

class DrawProgressBarSystem extends AbstractSystem
{
    private var state:FlxState;
    
    private var oldProgress:Map<ProgressBarComponent, Int>;
    
    public function new(state:FlxState)
    {
        super([ProgressBarComponent, PositionComponent]);
        this.state = state;
        this.oldProgress = new Map<ProgressBarComponent, Int>();
    }
    
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        
        for (entity in this.entities)
        {
            var bar:ProgressBarComponent = entity.get(ProgressBarComponent);            
            var position:PositionComponent = entity.get(PositionComponent);

            if (bar.sprite != null)
            {
                bar.sprite.setPosition(position.x,position.y);
            
                if (bar.currentProgress != oldProgress[bar])
                {
                    makeSprite(bar);
                    oldProgress[bar] = bar.currentProgress;
                }
            }
        }
    }
    
    override public function entityChanged(entity:Entity):Void
    {
        super.entityChanged(entity);
        for (entity in this.entities)
        {
            var bar:ProgressBarComponent = entity.get(ProgressBarComponent);            
            if (bar.sprite == null)
            {
                var s:FlxSprite = this.makeSprite(bar);
                this.state.add(s);
            }
            else
            {
                // Sprite size doesn't match component size
                if (bar.sprite.width != bar.width || bar.sprite.height != bar.height)
                {
                    this.state.remove(bar.sprite);
                    this.makeSprite(bar);
                    this.state.add(bar.sprite);
                }
            }
        }
    }
    
    private function makeSprite(bar:ProgressBarComponent):FlxSprite
    {
        var toReturn:FlxSprite = new FlxSprite();
        toReturn.makeGraphic(bar.width, bar.height, FlxColor.RED);
        bar.sprite =  toReturn;
        
        // Fill with blue as much as we've completed
        var progressX = Math.round(bar.currentProgress * bar.width / bar.maximumProgress);
        var pixels = bar.sprite.pixels;
        for (x in 0 ... progressX)
        {
            for (y in 0 ... bar.height)
            {
                pixels.setPixel(x, y, FlxColor.BLUE);
            } 
        }
        return toReturn;
    }
}