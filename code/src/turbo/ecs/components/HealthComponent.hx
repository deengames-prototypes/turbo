package turbo.ecs.components;

import turbo.ecs.components.AbstractComponent;
import noor.Exception;

/**
Anything with health. Has current/maximum health.
*/
class HealthComponent extends AbstractComponent
{
    public var currentHealth:Int = 0;
    public var maximumHealth(default, null):Int = 0;
    
    public function new(maximumHealth:Int):Void
    {
        super();
        this.currentHealth = maximumHealth;
        this.maximumHealth = maximumHealth;        
    }
}