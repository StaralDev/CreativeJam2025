using Godot;
using System;

namespace RunnerGame.Level;

public partial class Segment : Node2D
{
	public float Speed = 1.0f;
	public PlayerCharacter playerCharacter;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		Position += new Vector2( -Speed, 0);
	
		foreach (Node node in GetChildren())
		{
			if (node is not Obstical) { continue; }

			var obstical = (Obstical)node;
			var onScreenPosition = obstical.GlobalPosition;
			var areaWidth = obstical.Width/2;

			if (
				playerCharacter is not null
				&& onScreenPosition.X > playerCharacter.Position.X
				&& !obstical.PassedPlayer
				)
			{
				obstical.PassedPlayer = true;
				obstical.OnPassedPlayer();
			}

			if (
				onScreenPosition.X+areaWidth < 1920
				&& !obstical.EnteredScreen
				)
			{
				obstical.EnteredScreen = true;
				obstical.OnScreenEntered();
			}

			if (
				onScreenPosition.X-areaWidth < 0
				&& !obstical.ExitedScreen
			)
			{
				obstical.ExitedScreen = true;
				obstical.OnScreenExited();
			}
			
		}
	}
}
