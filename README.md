# Cosmetic Kit

A plugin for the [Ballest plugin manager](https://github.com/AnythingGoes-ballest/ballest-plugin-manager): lets other
plugins add their own balls, hats and goal explosions (bfx) to Ballest of Them All's **Customize** page, in a
**custom** section at the bottom of each tab, and remembers which ones you wear.

- Choose a custom cosmetic like any other: click its tile.
- Custom cosmetics are worn on your own ball only: the menu ball and the ball you race with. The game's save, and what
  other players see, keep the last cosmetic you chose from the game's own, so removing a plugin never leaves your
  profile pointing at something that's gone.
- What you wear is saved and put back the next time you start the game.

Cosmetic Kit adds nothing by itself. Install a plugin that uses it, such as
[Example Cosmetics](https://github.com/AnythingGoes-ballest/ballest-example-cosmetics).

## Install

In the game: footer **plugins** > **browse** > Cosmetic Kit > **install**. Plugins that need it install it
for you. Needs the plugin manager host 0.8.0 or newer.

## Making cosmetics

List `cosmetic-kit` in your plugin's `[meta] dependencies` and import its functions:

```angelscript
import bool AddBall(const string &in, const string &in, const string &in, const string &in, const string &in) from "cosmetic-kit";
import bool AddHat(const string &in, const string &in, const string &in, double, const string &in, const string &in) from "cosmetic-kit";
import bool AddBfx(const string &in, const string &in, const string &in, double, const string &in, const string &in, const string &in) from "cosmetic-kit";
```

`main.as` describes each argument, and the plugin manager's
[custom cosmetics guide](https://anythinggoes-ballest.github.io/ballest-plugin-manager/guides/cosmetics/) covers ball
textures and models: 3D parts with depth or movement, built from simple shapes, and 3D model files from Blender or
other tools (glTF `.glb`/`.gltf` or `.obj`, with their colours, textures and animations; host 0.16.0 and newer).

## License

MIT
