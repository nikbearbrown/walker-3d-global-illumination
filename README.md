# Walker — Global Illumination

**What this is.** An independent, title-only copy of the official Godot demo
`3d/global_illumination`: a free-flying camera inside one baked arena map,
carrying a box and a reflective sphere, with keys that cycle five global
illumination modes (environment lighting, baked lightmap all / indirect,
VoxelGI, SDFGI), three reflection-probe modes and four screen-space lighting
modes (SSAO, SSIL). It is a tech demo, not a game.

**Why it is in Walker.** It is one of Walker's Godot demo adaptations and the
source for two planned native-4K Liam films.

**What was found and verified.** Import/runtime and 42 headless mode-state
assertions pass (`modes-20260924.log`): every GI, reflection and screen-space
state is reached twice with matching labels, node visibility and environment
flags. The headless run reports `forward_plus`, but that proves property state,
not rendered light. GPU lighting, reflection appearance, camera interaction,
performance and both native-4K Liam films remain unverified.

## How to run

Open `godot/project.godot` in Godot 4.7 and run the main scene (`test.tscn`).

Controls (from the source):

- Mouse: look around (mouse is captured at start)
- W / A / S / D or arrow keys: move; E / Q: move up / down
- Space: cycle global illumination modes
- R: cycle reflection probe modes
- F: cycle screen-space lighting effect modes
- Hold Shift with Space, R or F: cycle backwards
- Escape or F10: toggle mouse capture

## Design

- [GDD.md](GDD.md) — recovered game design document (identical copy of
  `design/GDD.md`)
- [design/DECK.html](design/DECK.html) — review slides
- [design/IMPLEMENTATION-MAP.md](design/IMPLEMENTATION-MAP.md) — feature → scene/script/line
- [design/decisions.md](design/decisions.md) — open questions

The GDD was recovered from the code by Walker's Zelda GDD skill
(`/gdd reverse`, silent). It describes what exists; it is not an approved
design, and every gate is unsigned.

## Source & license

Upstream: Godot `3d/global_illumination`, commit
`a3b5c113112f77291d5f3d1360f33a882fdc52f7`. Source checkout untouched;
upstream MIT license, assets, bake data, UIDs and original README retained.
The original README attributes `zdm2.glb` to Cube 2: Sauerbraten's zdm2 map,
under CC BY 4.0, with the original attribution/license link retained there.
No geometry or bake data was modified.

## Status

GPU lighting, reflection appearance, camera interaction, performance and both
native-4K Liam films remain unverified. Compatibility fallback, Shift reverse
cycling and camera movement / mouse capture are untested. See `FRICTIONAL.md`
for the dated work log.

Repository: https://github.com/nikbearbrown/walker-3d-global-illumination
