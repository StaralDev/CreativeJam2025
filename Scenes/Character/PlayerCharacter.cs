using Godot;
using System;

public partial class PlayerCharacter : CharacterBody2D
{
	public const float Speed = 300.0f;
	public const float JumpVelocity = -400.0f;
	public bool DoubleJumpAvalible = true;
	public CollisionShape2D hitbox;

	public override void _Ready()
	{
		hitbox = GetNode<Area2D>("Area2D").GetNode<CollisionShape2D>("HitBox");
	}

	public override void _PhysicsProcess(double delta)
	{
		Vector2 velocity = Velocity;

		// Add the gravity.
		if (!IsOnFloor())
		{
			velocity += GetGravity() * (float)delta;
		}

		// Handle Jump.
		if (Input.IsActionJustPressed("Jump"))
		{
			if (IsOnFloor())
			{
				velocity.Y = JumpVelocity;
				DoubleJumpAvalible = true;
			}
			else if (DoubleJumpAvalible)
			{
				velocity.Y = JumpVelocity;
				DoubleJumpAvalible = false;
			}
		}

		if (Input.IsActionJustPressed("Duck"))
		{
			//hitbox.Translation = new Vector2(0.0, 30.0);
		}

		Velocity = velocity;
		MoveAndSlide();
	}

	public void Death()
	{}
}
