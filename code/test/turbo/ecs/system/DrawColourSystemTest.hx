package turbo.ecs.system;

import flixel.FlxState;
import IntComponent;
using massive.munit.Assert;
import turbo.ecs.component.PositionComponent;
import turbo.ecs.component.ColourComponent;
import turbo.ecs.Entity;
import turbo.ecs.system.DrawColourSystem;
import StringComponent;

@:access(turbo.ecs.system.DrawColourSystem)
class DrawColourSystemTest
{
    @Test
    public function entitiesNeedAPositionAndColour()
    {
        var system = new DrawColourSystem(new FlxState());
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
        var system = new DrawColourSystem(new FlxState());
        var e = new Entity().add(new PositionComponent(0, 0)).add(new ColourComponent(0, 0, 0, 1, 1));
        system.entityChanged(e);
        Assert.isNotNull(e.get(ColourComponent).sprite);
    }
        
    @Test
    public function updateRemakesTheSpriteIfTheComponentColourChanges()
    {
        var system = new DrawColourSystem(new FlxState());
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
    
    @Test
    public function updateSetsTheSpriteCoordinatesToTheComponentsCoordinates()
    {
        var system = new DrawColourSystem(new FlxState());
        var c = new ColourComponent(0, 0, 0, 32, 32);
        var p = new PositionComponent(17, 29);
        var e = new Entity().add(p).add(c);
        system.entityChanged(e);
        system.update(0);
        
        var sprite = c.sprite;
        Assert.areEqual(p.x, sprite.x);
        Assert.areEqual(p.y, sprite.y);
        
        // player moves the entity. Does the colour's sprite move?
        p.x = 32;
        p.y = 48;
        
        system.update(0);
        
        Assert.areEqual(p.x, sprite.x);
        Assert.areEqual(p.y, sprite.y);
    }
    
}