using Godot;

namespace RunnerGame.Level;

public partial class Avoidable: Obstical
{
    public override void OnPlayerEntered(PlayerCharacter player)
    {
        base.OnPlayerEntered(player);

        // player.kill()
    }
}