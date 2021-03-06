package turbo.ecs;

using massive.munit.Assert;
import turbo.ecs.Container;
import turbo.ecs.Entity;
import turbo.ecs.systems.AbstractSystem;

class ContainerTest
{
    @Test
    public function constructorCreatesEmptyCollections()
    {
        var container = new Container();
        Assert.areEqual(0, container.entities.length);
        Assert.areEqual(0, container.systems.length);
    }
    
    @Test
    public function constructorSetsInstance()
    {
        var c1 = new Container();
        Assert.areEqual(c1, Container.instance);
        var c2 = new Container();
        Assert.areEqual(c2, Container.instance);
    }
    
    @Test
    public function addSystemAddsSystem()
    {
        var container = new Container();
        var expected = new DummySystem();
        container.addSystem(expected);
        Assert.areEqual(1,container.systems.length);
        var actual = container.systems[0];
        Assert.areEqual(expected, actual);
    }
    
    @Test
    public function addEntityAddsEntity()
    {
        var container = new Container();
        var expected = new Entity();
        container.addEntity(expected);
        Assert.areEqual(1, container.entities.length);
        var actual = container.entities[0];
        Assert.areEqual(expected, actual);
    }
    
    @Test
    public function updateUpdatesAllSystems()
    {
        var container = new Container();
        var s1 = new DummySystem();
        var s2 = new DummySystem();
        container.addSystem(s1);
        container.addSystem(s2);
        
        var expected = 1.0721;
        container.update(0.13);
        container.update(expected);
        Assert.areEqual(expected, s1.lastUpdate);
        Assert.areEqual(expected, s2.lastUpdate);
    }
    
    @Test
    public function entityChangedCallsEntityChangedOnAllSystems()
    {
        var container = new Container();
        var s1 = new DummySystem();
        var s2 = new DummySystem();
        container.addSystem(s1);
        container.addSystem(s2);
        
        var expected = new Entity();
        container.entityChanged(new Entity());
        container.entityChanged(expected);
        Assert.areEqual(expected, s1.lastChanged);
        Assert.areEqual(expected, s2.lastChanged);
    }

    @Test
    public function removeEntityCallsRemoveEntityOnAllSystems()
    {
        var container = new Container();
        var s1 = new DummySystem();
        var s2 = new DummySystem();
        container.addSystem(s1);
        container.addSystem(s2);
        
        var e = new Entity();
        container.entityChanged(e);
        container.removeEntity(e);
        Assert.areEqual(e, s1.lastRemoved);
        Assert.areEqual(e, s2.lastRemoved);
    }
}

class DummySystem extends turbo.ecs.systems.AbstractSystem
{
    public var lastUpdate(default, null):Float;
    public var lastRemoved(default, null):Entity;
    public var lastChanged(default, null):Entity;
    
    public function new()
    {
        super([turbo.ecs.components.AbstractComponent]);
    }
    
    override public function update(elapsed:Float):Void
    {
        this.lastUpdate = elapsed;
    }
    
    override public function entityChanged(e:Entity):Void
    {
        this.lastChanged = e;
    }

    override public function removeEntity(e:Entity):Void
    {
        this.lastRemoved = e;
    }
}