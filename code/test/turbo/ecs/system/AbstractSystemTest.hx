package turbo.ecs.system;

using massive.munit.Assert;
import turbo.ecs.component.AbstractComponent;
import turbo.ecs.Entity;
import turbo.ecs.system.AbstractSystem;

// You may find this amusing. It's possible to test base/abstract class code
// in isolation. Then, subclasses only need to test subclassed code! Awesomeness ensues.
@:access(turbo.ecs.system.AbstractSystem)
class AbstractSystemTest
{
    @Test
    public function entityChangedDoesntDoAnythingIfEntityDoesntHaveAllMatchingComponents()
    {
        var system = new IntComponentSystem([IntComponent]);
        var e = new Entity().add(new StringComponent("testing!"));
        system.entityChanged(e);
        Assert.areEqual(0, system.entities.length);
    }
    
    @Test
    public function entityChangedTracksNewEntitiesWithAllMatchingComponents()
    {
        var system = new IntComponentSystem([IntComponent]);
        var e = new Entity().add(new StringComponent("testing!")).add(new IntComponent(1));
        system.entityChanged(e);        
        Assert.areEqual(1, system.entities.length);
        Assert.areEqual(system.entities[0], e);
    }
    
    @Test
    public function entityChangeRemovesEntitiesThatNoLongerMatchAllComponents()
    {
        var system = new IntComponentSystem([IntComponent]);
        var ic:IntComponent = new IntComponent(1);
        
        var e = new Entity().add(new StringComponent("testing!")).add(ic);
        system.entityChanged(e);        
        Assert.areEqual(1, system.entities.length);
        
        e.remove(IntComponent);
        system.entityChanged(e);        
        Assert.areEqual(0, system.entities.length);        
    }
}

class IntComponentSystem extends AbstractSystem
{
    public function new(types:Array<Class<AbstractComponent>>)
    {
        super(types);
    }
}