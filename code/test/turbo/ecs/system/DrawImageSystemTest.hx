package turbo.ecs.system;

import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;

import IntComponent;
using massive.munit.Assert;

import turbo.ecs.components.PositionComponent;
import turbo.ecs.components.ImageComponent;
import turbo.ecs.Entity;
import turbo.ecs.TurboState;
import turbo.ecs.systems.DrawImageSystem;

@:access(turbo.ecs.systems.DrawImageSystem)
class DrawImageSystemTest
{
    @Test
    public function entitiesNeedAPositionAndImage()
    {
        var system = new DrawImageSystem(new TurboState());
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
        var system = new DrawImageSystem(new TurboState());
        var e = new Entity()
            .add(new PositionComponent(0, 0))
            .add(new ImageComponent("assets/apple.png"));
        system.entityChanged(e);
        Assert.isNotNull(e.get(ImageComponent).sprite);
    }

    @Test
    public function updateInitializesRepeatingSpriteToFlxBackdrop()
    {
        var system = new DrawImageSystem(new TurboState());
        var i = new ImageComponent("assets/ball.png",true);
        var p = new PositionComponent(135, 208);
        var e = new Entity().add(p).add(i);
        
        system.entityChanged(e);
        system.update(0);
        
        var sprite = i.sprite;
        Assert.isType(sprite, FlxBackdrop);
    }
    
}