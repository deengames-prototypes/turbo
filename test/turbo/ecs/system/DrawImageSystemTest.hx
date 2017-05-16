package nebula.ecs.system;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;

import IntComponent;
using massive.munit.Assert;

import nebula.ecs.component.PositionComponent;
import nebula.ecs.component.ImageComponent;
import nebula.ecs.Entity;
import nebula.ecs.system.DrawImageSystem;

@:access(nebula.ecs.system.DrawImageSystem)
class DrawImageSystemTest
{
    @Test
    public function entitiesNeedAPositionAndImage()
    {
        var system = new DrawImageSystem(new FlxState());
        var e = new Entity().add(new StringComponent("testing!")).add(new IntComponent(1));
        system.entityChanged(e);               
        Assert.areEqual(0, system.entities.length);
        
        var e2 = new Entity().add(new PositionComponent(0, 0)).add(new ImageComponent("not used.png"));
        system.entityChanged(e2);        
        Assert.areEqual(1, system.entities.length);
        Assert.areEqual(e2, system.entities[0]);
    }
    
    @Test
    public function entityChangedInitializesTheSpritesSprite()
    {
        var system = new DrawImageSystem(new FlxState());
        var e = new Entity()
            .add(new PositionComponent(0, 0))
            .add(new ImageComponent("assets/apple.png"));
        system.entityChanged(e);
        Assert.isNotNull(e.get(ImageComponent).sprite);
    }
    
    @Test
    public function updateSetsTheSpriteCoordinatesToTheComponentsCoordinates()
    {
        var system = new DrawImageSystem(new FlxState());
        var i = new ImageComponent("assets/ball.png");
        var p = new PositionComponent(135, 208);
        var e = new Entity().add(p).add(i);
        system.entityChanged(e);
        system.update(0);
        
        var sprite = i.sprite;
        Assert.areEqual(p.x, sprite.x);
        Assert.areEqual(p.y, sprite.y);
        
        // player moves the entity. Does the image's sprite move?
        p.x = 32;
        p.y = 65;
        
        system.update(0);
        
        Assert.areEqual(p.x, sprite.x);
        Assert.areEqual(p.y, sprite.y);
    }

    @Test
    public function updateInitializesRepeatingSpriteToFlxBackdrop()
    {
        var system = new DrawImageSystem(new FlxState());
        var i = new ImageComponent("assets/ball.png",true);
        var p = new PositionComponent(135, 208);
        var e = new Entity().add(p).add(i);
        
        system.entityChanged(e);
        system.update(0);
        
        var sprite = i.sprite;
        Assert.isType(sprite, FlxBackdrop);
    }
    
}