package;

import turbo.ecs.components.AbstractComponent;

class StringComponent extends AbstractComponent
{
    public var value:String;
    
    public function new(value:String)
    { 
        super();
        this.value = value;
    }
}