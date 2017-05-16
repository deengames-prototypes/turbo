
package nebula.ecs.component;

import flixel.FlxSprite;

class MouseClickComponent extends AbstractComponent
{
    public var callbacks:Array<Float->Float->Void>;
    
    // internal
    public var sprite:FlxSprite;

    public function new()
    {
        super();
        callbacks = new Array<Float->Float->Void>();
    }

    public function registerCallBack(callback:Float->Float->Void)
    {
    	callbacks.push(callback);
    }

    public function removeCallBack(callback:Float->Float->Void)
    {
    	callbacks.remove(callback);
    }
}