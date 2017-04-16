package turbo.ecs.components;

import turbo.ecs.components.AbstractComponent;

/**
Anything with health. Has current/maximum health.
*/
class HealthComponent extends AbstractComponent
{
    public var currentHealth(default, null):Int = 0;
    public var totalHealth(default, null):Int = 0;
    
    public function new(totalHealth:Int, parent:Entity):Void
    {
        super(parent);
        // TODO: throw if <= 0
        this.currentHealth = totalHealth;
        this.totalHealth = totalHealth;        
    }

    public function damage(damage:Int):Void
    {
        var wasDead = this.currentHealth <= 0;
        this.currentHealth -= damage;
        if (!wasDead && this.currentHealth <= 0)
        {
            this.trigger("Death");
        }
    }
}