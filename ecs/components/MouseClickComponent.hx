package turbo.ecs.components;

import flixel.input.mouse.FlxMouseEventManager;
import flixel.FlxObject;
import flixel.FlxG;
import turbo.ecs.components.AbstractComponent;

class MouseClickComponent extends AbstractComponent
{
    private var mouseDownCallback:Float->Float->Void;
    private var mouseUpCallback:Float->Float->Void;
    
    public function new(onMouseDown:Float->Float->Void, onMouseUp:Float->Float->Void = null, parent:Entity)
    {
        super(parent);
        this.mouseDownCallback = onMouseDown;
        this.mouseUpCallback = onMouseUp;

        if (parent.has(ImageComponent))
        {
            var image = parent.get(ImageComponent);
            if (image.sprite != null)
            {
                FlxMouseEventManager.add(image.sprite, this.mouseDown, this.mouseUp);
            } 
            else
            {
                throw "Can't add mouse-click to an image with a null sprite!";
            }
        }
        else if (parent.has(ColourComponent))
        {
            var colour = parent.get(ColourComponent);
            if (colour.sprite != null)
            {
                FlxMouseEventManager.add(colour.sprite, this.mouseDown, this.mouseUp);                
            } 
            else
            {
                throw "Can't add mouse-click to a colour with a null sprite!";
            }
        }
        else
        {
            throw "Can't add mouse-click component without an image or colour!";
        }
    }

    private function mouseDown(obj:FlxObject):Void
    {
        if (this.mouseDownCallback != null)
        {
            this.mouseDownCallback(FlxG.mouse.x,FlxG.mouse.y);
        }
    }

    private function mouseUp(obj:FlxObject):Void
    {
        if (this.mouseUpCallback != null)
        {
            this.mouseUpCallback(FlxG.mouse.x,FlxG.mouse.y);
        }
    }
}