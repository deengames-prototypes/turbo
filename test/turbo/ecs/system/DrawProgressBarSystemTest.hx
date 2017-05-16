package nebula.ecs.system;

import flixel.FlxState;
import IntComponent;
using massive.munit.Assert;
import nebula.ecs.component.PositionComponent;
import nebula.ecs.component.ProgressBarComponent;
import nebula.ecs.Entity;
import nebula.ecs.system.DrawProgressBar;
import StringComponent;

@:access(nebula.ecs.system.DrawProgressBar)
class DrawProgressBarSystemTest
{
    @Test
    public function entitiesNeedAPositionAndProgressBar()
    {
        var system = new DrawColourSystem(new FlxState());
        var e = new Entity().add(new StringComponent("testing!")).add(new IntComponent(1));
        system.entityChanged(e);               
        Assert.areEqual(0, system.entities.length);
        
        var e2 = new Entity().add(new PositionComponent(0, 0)).add(new ProgressBarComponent(10);
        system.entityChanged(e2);        
        Assert.areEqual(1, system.entities.length);
        Assert.areEqual(e2, system.entities[0]);
    }
    
    @Test
    public function entityChangedInitializesTheProgressBarSprite()
    {
        var system = new DrawColourSystem(new FlxState());
        var e = new Entity().add(new PositionComponent(0, 0)).add(new ProgressBarComponent(50));
        system.entityChanged(e);
        Assert.isNotNull(e.get(ProgressBarComponent).sprite);
    }
    
    @Test
    public function updateRemakesTheSpriteIfTheProgressChanges()
    {
        var system = new DrawColourSystem(new FlxState());
        var c = new ProgressBarComponent(32);
        var e = new Entity().add(new PositionComponent(0, 0)).add(c);
        system.entityChanged(e);
        system.update(0);
        
        var s1 = c.sprite;
        Assert.isNotNull(s1);
        
        c.currentProgress = 10;
        system.update(0);
        var s2 = c.sprite;
        Assert.areNotEqual(s1, s2);
    }
    
    @Test
    public function updateSetsTheSpriteCoordinatesToTheComponentsCoordinates()
    {
        var system = new DrawColourSystem(new FlxState());
        var c = new ProgressBarComponent(100);
        var p = new PositionComponent(17, 29);
        var e = new Entity().add(p).add(c);
        system.entityChanged(e);
        system.update(0);
        
        var sprite = c.sprite;
        Assert.areEqual(p.x, sprite.x);
        Assert.areEqual(p.y, sprite.y);
        
        // player moves the entity. Does the bar's sprite move?
        p.x = 32;
        p.y = 48;
        
        system.update(0);
        
        Assert.areEqual(p.x, sprite.x);
        Assert.areEqual(p.y, sprite.y);
    }
    
}