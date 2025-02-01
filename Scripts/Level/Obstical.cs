using Godot;
using System;

namespace RunnerGame.Level;

public partial class Obstical : Area2D
{
	// Describes whether the Obstical has passed the player yet.
	public bool PassedPlayer { get; set; } = false;

	// Describes whether the Obstical has appeared OnScreen yet.
	public bool EnteredScreen { get; set; } = false;

	// Describes whether the Obstical has fully exited the screen yet.
	public bool ExitedScreen { get; set; } = false;

	// Describes whether the Obstical is OnScreen.
	public bool OnScreen { get => EnteredScreen && !ExitedScreen; }

	[Export]
	public float Width { get; set; } = 10f;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		AreaEntered += (area) => {
			OnEntered(area);

			Node areaParent = area.GetParent();

			if (areaParent is not null && areaParent is PlayerCharacter)
			{
				OnPlayerEntered((PlayerCharacter)areaParent);
			}
		};

		AreaExited += (area) => {
			OnExited(area);

			Node areaParent = area.GetParent();

			if (areaParent is not null && areaParent is PlayerCharacter)
			{
				OnPlayerExited((PlayerCharacter)areaParent);
			}
		};
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta) {}

	/// <summary>
	/// Runs when the Obstical has passed the player.
	/// </summary>
	public virtual void OnPassedPlayer() {}

	/// <summary>
	/// Runs when some other Area2D has entered the Obstical's Area2D.
	/// </summary>
	/// <param name="area"></param>
	public virtual void OnEntered(Area2D area) {}

	/// <summary>
	/// Runs when the Player has entered the Obstical's Area2D.
	/// </summary>
	/// <param name="player"></param>
	public virtual void OnPlayerEntered(PlayerCharacter /*Replace with Player*/ player) {}

	/// <summary>
	/// Runs when some other Area2D has exited the Obstical's Area2D.
	/// </summary>
	/// <param name="area"></param>
	public virtual void OnExited(Area2D area) {}

	/// <summary>
	/// Runs when the Player has exited the Obstical's Area2D.
	/// </summary>
	/// <param name="player"></param>
	public virtual void OnPlayerExited(PlayerCharacter /*Replace with Player*/ player) {}

	/// <summary>
	/// Runs when the Obstical has entered the screen for the first time.
	/// </summary>
	public virtual void OnScreenEntered() { GD.Print("Entered Screen"); }

	/// <summary>
	/// Runs when the Obstical has exited the screen for the last time.
	/// </summary>
	public virtual void OnScreenExited() { GD.Print("Exited Screen"); }
}
