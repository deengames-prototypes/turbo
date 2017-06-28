package turbo.ecs.system;

import IntComponent;
import StringComponent;

using massive.munit.Assert;

import turbo.ecs.Entity;
import turbo.ecs.TurboState;
import turbo.ecs.components.PositionComponent;
import turbo.ecs.components.ColourComponent;
import turbo.ecs.systems.DrawColourSystem;

@:access(turbo.ecs.systems.DrawColourSystem)
class DrawColourSystemTest
{
    @Test
    public function entitiesNeedAPositionAndColour()
    {
        var system = new DrawColourSystem(new TurboState());
        var e = new Entity().add(new StringComponent("testing!")).add(new IntComponent(1));
        system.entityChanged(e);               
        Assert.areEqual(0, system.entities.length);
        
        var e2 = new Entity().add(new PositionComponent(0, 0)).add(new ColourComponent(0, 0, 0, 1, 1));
        system.entityChanged(e2);        
        Assert.areEqual(1, system.entities.length);
        Assert.areEqual(e2, system.entities[0]);
    }
    
    @Test
    public function entityChangedInitializesTheColoursSprite()
    {
        var system = new DrawColourSystem(new TurboState());
        var e = new Entity().add(new PositionComponent(0, 0)).add(new ColourComponent(0, 0, 0, 1, 1));
        system.entityChanged(e);
        Assert.isNotNull(e.get(ColourComponent).sprite);
    }
        
    @Test
    public function updateRemakesTheSpriteIfTheComponentColourChanges()
    {
        var system = new DrawColourSystem(new TurboState());
        var c = new ColourComponent(0, 0, 0, 32, 32);
        var e = new Entity().add(new PositionComponent(0, 0)).add(c);
        system.entityChanged(e);
        system.update(0);
        
        var s1 = c.sprite;
        Assert.isNotNull(s1);
        
        c.red = 64;
        system.update(0);
        var s2 = c.sprite;
        Assert.areNotEqual(s1, s2);
        
        c.green = 16;
        system.update(0);
        var s3 = c.sprite;
        Assert.areNotEqual(s2, s3);
        
        c.blue = 137;
        system.update(0);
        var s4 = c.sprite;
        Assert.areNotEqual(s3, s4);
    }    
}