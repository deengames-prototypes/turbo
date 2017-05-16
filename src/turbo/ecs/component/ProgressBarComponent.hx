package nebula.ecs.component;

import nebula.ecs.component.SpriteComponent;

/**
"Progress bar" is a poor name, since it doesn't necessarily denote progress.
It can be anything -- health, experience, time, etc.
*/

class ProgressBarComponent extends SpriteComponent
{
    public var width:Int = 0;
    public var height:Int = 0;
    public var currentProgress:Int = 0;
    public var maximumProgress:Int = 0;    
    
    public function new(maximumProgress:Int, width:Int = 32, height:Int = 16):Void
    {
        super();
        this.maximumProgress = maximumProgress;
        this.width = width;
        this.height = height;
    }
}