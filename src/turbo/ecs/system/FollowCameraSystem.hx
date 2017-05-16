package nebula.ecs.system;

import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;

import nebula.ecs.component.AbstractComponent;
import nebula.ecs.component.CameraComponent;
import nebula.ecs.component.SpriteComponent;
import nebula.ecs.Entity;

class FollowCameraSystem extends AbstractSystem
{
    public function new()
    {
        super([CameraComponent, SpriteComponent]);
    }
    
    override public function entityChanged(entity:Entity):Void
    {
        super.entityChanged(entity);
        
        if (this.entities.length == 0)
        {
            if (FlxG.camera.target != null)
            {
                FlxG.camera.follow(null);
            }
        }
        else if (this.entities.length == 1)
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