// Cosmetic Kit: lets other plugins add their own balls, hats and goal explosions (bfx) to the game's Customize page, in a
// "custom" section of each tab. It remembers which custom ones the player wears and puts them back on next launch.
//
// A plugin that adds cosmetics lists "cosmetic-kit" in its [meta] dependencies and imports these functions:
//
//   import bool AddBall(const string &in, const string &in, const string &in, const string &in, const string &in) from "cosmetic-kit";
//   import bool AddHat(const string &in, const string &in, const string &in, double, const string &in, const string &in) from "cosmetic-kit";
//   import bool AddBfx(const string &in, const string &in, const string &in, double, const string &in, const string &in, const string &in) from "cosmetic-kit";
//
// Ids should start with the adding plugin's id ("example-cosmetics.smiley"), so two plugins never clash. Files (images,
// models) are full paths inside that plugin's folder: Plugins::Folder() + "ball.png".
//
// A model is a text file of simple shapes (spheres, boxes, cylinders, cones, capsules, discs, rings, saw blades, cups)
// with plastic, metal or glowing colours, in groups that can spin: parts with depth or movement on a ball, or a whole
// hat. It can also place 3D model files as Blender exports them (glTF .glb/.gltf, or .obj), with their colours,
// textures and animations; or a model can be such a file on its own (host 0.16.0 and newer). The format is in the
// host's documentation (custom cosmetics guide), and Example Cosmetics has examples of both.
//
// Custom cosmetics are worn on the player's own ball only: the game's save (and what other players are told) keeps
// the last game cosmetic chosen, so removing a plugin never leaves the profile pointing at something that is gone.

const array<string> KINDS = {"ball", "hat", "bfx"};

array<string> restoring = {"", "", ""};     // worn last session, put back once the plugin that adds it has
array<string> saved = {"", "", ""};         // what Storage holds

// A ball: `image` is the ball's texture, wrapped around the ball as u = around, v = top to bottom (2:1, e.g.
// 1024x512); `preview` is the picture on its tile ("" to show the texture); `model` is a model file built around the
// ball and rolling with it ("" for none).
bool AddBall(const string &in id, const string &in name, const string &in image, const string &in preview,
             const string &in model)
{
    return Added(Cosmetics::Ball, id, Cosmetics::AddBall(id, name, image, preview, model));
}

// A hat: `mesh` is a static mesh asset path in the game or engine ("/Engine/BasicShapes/Cone.Cone"), or "" when the
// hat is a `model` file instead, built where the game puts hats (the top of the ball); `scale` sizes either (1 = as
// it is; the engine's 1 m shapes want about 0.45).
bool AddHat(const string &in id, const string &in name, const string &in mesh, double scale, const string &in preview,
            const string &in model)
{
    return Added(Cosmetics::Hat, id, Cosmetics::AddHat(id, name, mesh, scale, preview, model));
}

// A goal explosion: one of the game's (`base`, a data asset path such as
// "/Game/Art/DataAssets/GoalExplosions/Fire1/DA_Fire1.DA_Fire1") at another size (`scale`, 1 = the same), optionally
// with another of the game's Niagara effects (`effect`) and sounds (`sound`) instead of the base's ("" keeps them).
bool AddBfx(const string &in id, const string &in name, const string &in base, double scale, const string &in preview,
            const string &in effect, const string &in sound)
{
    return Added(Cosmetics::Bfx, id, Cosmetics::AddBfx(id, name, base, scale, preview, effect, sound));
}

bool Added(Cosmetics::Kind kind, const string &in id, bool ok)
{
    if (!ok)
    {
        Log::Warn("could not add " + KINDS[kind] + " " + id);
        return false;
    }
    Log::Info("added " + KINDS[kind] + " " + id);
    if (restoring[kind] == id)
    {
        Cosmetics::Equip(kind, id);
        restoring[kind] = "";
        Log::Info("wearing " + KINDS[kind] + " " + id + " again");
    }
    return true;
}

void Main()
{
    for (uint k = 0; k < KINDS.length(); k++)
        saved[k] = restoring[k] = Storage::Get(KINDS[k], "");
}

// What the player wears is saved when it changes. While a custom one from last session has not been added yet (its
// plugin loads later, or was removed), the saved choice is kept.
void Update(float dt)
{
    for (uint k = 0; k < KINDS.length(); k++)
    {
        string worn = Cosmetics::Equipped(Cosmetics::Kind(k));
        if (restoring[k] != "" && worn != "")
            restoring[k] = "";              // the player chose another custom one meanwhile
        if (restoring[k] != "")
            continue;
        if (worn != saved[k])
        {
            saved[k] = worn;
            Storage::Set(KINDS[k], worn);
        }
    }
}
