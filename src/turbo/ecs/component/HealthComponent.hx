package nebula.ecs.component;

import nebula.ecs.component.AbstractComponent;
import noor.Exception;

/**
Anything with health. Has current/maximum health.
*/
class HealthComponent extends AbstractComponent
{
    public var currentHealth(default, null):Int = 0;
    public var maximumHealth(default, null):Int = 0;
    
    public function new(maximumHealth:Int):Void
    {
        super();
        // TODO: throw if <= 0
        this.currentHealth = maximumHealth;
        this.maximumHealth = maximumHealth;        
    }
}