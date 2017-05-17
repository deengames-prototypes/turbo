package;

import turbo.ecs.components.AbstractComponent;

class IntComponent extends AbstractComponent
{
    public var value:Int;
    public function new(value:Int)
    { 
        super();
        this.value = value;
    }
}