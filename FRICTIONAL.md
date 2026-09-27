# Verification and friction — 2026-09-24 21:05 UTC heartbeat

Read original README, project configuration, both complete scripts and full
test scene. No source 3D AGENTS.md found. Target verified absent before copy;
no active Godot/render workers found. Local title changed, test added; original
source and baked resources preserved, including map license attribution.

Godot 4.7.2 headless import and 120-frame runtime exit 0 without script errors.
modes-20260924.log: 42 assertions pass. Synthetic Space events cycle all five
GI states twice, checking labels and LightmapGI/VoxelGI visibility and SDFGI
flag. R cycles reflection disabled/once/always twice with visibility/update
mode assertions. F cycles four screen-space states twice, checking SSAO/SSIL
flags. No runtime fixes were needed.

The reported rendering method is forward_plus, but this is HEADLESS: matching
properties do not prove GPU lighting support, rendered pixels, reflections,
bake quality or performance. Compatibility fallback, Shift reverse cycling,
camera movement/mouse capture remain untested. No gameplay footage produced.

Both film tasks remain pending the existing visible-capture constraint after
the user closed earlier recording windows. No visible window reopened or
human approval fabricated. Proceed next feasible item without retiring either
film; return for genuine visual/input verification and required film skills
when capture is available.
