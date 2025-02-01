using Godot;
using System;

namespace RunnerGame.Level;

public partial class Obstical : Area2D
{
	// Describes whether the Obstical has passed the player yet.
	public bool PassedPlayer { get; set; } = false;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		AreaEntered += (area) => {
			OnEntered(area);

			Node areaParent = area.GetParent();

			if (areaParent is not null && areaParent is CharacterBody2D)
			{
				OnPlayerEntered((CharacterBody2D)areaParent);
			}
		};

		AreaExited += (area) => {
			OnExited(area);

			Node areaParent = area.GetParent();

			if (areaParent is not null && areaParent is CharacterBody2D)
			{
				OnPlayerExited((CharacterBody2D)areaParent);
			}
		};
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta) {}

	public virtual void OnPassedPlayer() {}

	public virtual void OnEntered(Area2D area) {}
	public virtual void OnPlayerEntered(CharacterBody2D /*Replace with Player*/ player) {}

	public virtual void OnExited(Area2D area) {}
	public virtual void OnPlayerExited(CharacterBody2D /*Replace with Player*/ player) {}
}
