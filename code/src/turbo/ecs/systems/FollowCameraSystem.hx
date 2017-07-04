package turbo.ecs.systems;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;

import turbo.ecs.components.AbstractComponent;
import turbo.ecs.components.CameraComponent;
import turbo.ecs.components.SpriteComponent;
import turbo.ecs.Entity;

class FollowCameraSystem extends AbstractSystem
{
    public function new()
    {
        super([CameraComponent, SpriteComponent]);
    }
    
    override public function entityRemoved(entity:Entity):Void
    {
        super.entityRemoved(entity);
        if (this.entities.length == 0)
        {
            if (FlxG.camera.target != null)
            {
                FlxG.camera.follow(null);
            }
        }
    }

    override public function entityAdded(entity:Entity):Void
    {
        super.entityAdded(entity);
        
        if (this.entities.length == 1)
        {   
            var sprite:SpriteComponent = this.entities[0].get(SpriteComponent);

            if (sprite != null && sprite.sprite != null && FlxG.camera.target != sprite.sprite)
            {
                FlxG.camera.follow(sprite.sprite);
            }
        }
        else if (this.entities.length >= 2)
        {
            throw "Camera can't follow more than one entity";
        }
    }
}