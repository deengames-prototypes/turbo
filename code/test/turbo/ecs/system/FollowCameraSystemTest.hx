package turbo.ecs.system;

import flixel.FlxState;
import flixel.FlxG;
import IntComponent;
import StringComponent;
using massive.munit.Assert;
import turbo.ecs.components.ColourComponent;
import turbo.ecs.components.CameraComponent;
import turbo.ecs.components.ImageComponent;
import turbo.ecs.components.PositionComponent;
import turbo.ecs.Entity;
using turbo.ecs.EntityFluentApi;
import turbo.ecs.systems.FollowCameraSystem;


@:access(turbo.ecs.systems.FollowCameraSystem)
class FollowCameraSystemTest
{
    @Test
    public function cameraSystemFollowsEntitiesWithImageAndCameraComponents()
    {
        var system = new FollowCameraSystem();
        
        var entity:Entity = new Entity().add(new StringComponent("testing!")).add(new IntComponent(1));
        system.entityChanged(entity);
        Assert.areEqual(0, system.entities.length);
        
        system = new FollowCameraSystem();
        entity = new Entity().image("fakeImage");
        system.entityChanged(entity);
        Assert.areEqual(0, system.entities.length);

        entity = new Entity().image("assets/apple.png").trackWithCamera();
        system.entityChanged(entity);

        Assert.areEqual(1, system.entities.length);
        Assert.areEqual(entity, system.entities[0]);
    }
    
    @Test
    public function cameraSystemFollowsEntitiesWithColourAndCameraComponents()
    {
        var system = new FollowCameraSystem();
        
        var entity = new Entity().colour(128, 128, 0).trackWithCamera();
        system.entityChanged(entity);

        Assert.areEqual(1, system.entities.length);
        Assert.areEqual(entity, system.entities[0]);
    }
    
    @Test
    public function updateInitializesCameraFollow()
    {
        var system = new FollowCameraSystem();

        var entity:Entity = new Entity().image("assets/apple.png").trackWithCamera();
        system.entityChanged(entity);
        
        Assert.isNull(FlxG.camera.target);
        system.update(0);
        Assert.areEqual(entity.get(ImageComponent).sprite, FlxG.camera.target);
    }

    @Test
    public function addingMoreThanOneEntityThrowsException()
    {
        var system = new FollowCameraSystem();

        var entity:Entity = new Entity().image("assets/apple.png").trackWithCamera();        
        system.entityChanged(entity);
        
        entity = new Entity().image("assets/apple.png").trackWithCamera();

        var message:String = Assert2.throws(String, function()
        {
            system.entityChanged(entity);
            system.update(0);
        });

        Assert.areEqual("Camera can't follow more than one entity", message);
    }

    @Test
    public function removingCameraComponentResetCameraTarget()
    {
        var system = new FollowCameraSystem();

        var entity:Entity = new Entity().image("assets/apple.png").trackWithCamera();
        system.entityChanged(entity);
        
        Assert.isNull(FlxG.camera.target);

        system.update(0);
        Assert.areEqual(entity.get(ImageComponent).sprite, FlxG.camera.target);

        entity.remove(CameraComponent);
        system.update(0);
        Assert.isNull(FlxG.camera.target);
    }
}