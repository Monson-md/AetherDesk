/// A material preset applied to a [SceneObject3d], each shaded differently
/// by the real per-face Lambertian lighting model in `Scene3dViewport`:
/// [matte] is plain diffuse+ambient, [metallic] boosts contrast for a
/// shinier look, [glass] is drawn semi-transparent, and [emissive] ignores
/// scene lighting and renders at full brightness.
enum MaterialPreset { matte, metallic, glass, emissive }
