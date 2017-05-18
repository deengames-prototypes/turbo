import massive.munit.TestSuite;

import turbo.ecs.ContainerTest;
import turbo.ecs.EntityTest;
import turbo.ecs.system.AbstractSystemTest;
import turbo.ecs.system.DrawColourSystemTest;
import turbo.ecs.system.DrawImageSystemTest;
import turbo.ecs.system.FollowCameraSystemTest;
import turbo.ecs.system.KeyboardInputMovementSystemTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(turbo.ecs.ContainerTest);
		add(turbo.ecs.EntityTest);
		add(turbo.ecs.system.AbstractSystemTest);
		add(turbo.ecs.system.DrawColourSystemTest);
		add(turbo.ecs.system.DrawImageSystemTest);
		add(turbo.ecs.system.FollowCameraSystemTest);
		add(turbo.ecs.system.KeyboardInputMovementSystemTest);
	}
}
