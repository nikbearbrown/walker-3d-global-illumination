# walker-3d-global-illumination — Game Design Document (recovered)

| | |
|---|---|
| Version | 0.1.0-recovered |
| Date | 2026-09-27 |
| Author | Zelda (agent, silent), for Nik Bear Brown |
| Mode | recovered — `/gdd reverse --path godot silent` |
| Revision | 1 |
| Gates | vision ○ · systems ○ · world ○ · scope ○ — gate — unsigned at time of writing |
| Project kind | **tech demo** (free-fly lighting comparison in one baked level), not a game |

Provenance tags: `[OBSERVED path:line]` the code or scene does this · `[INFERRED]` the code strongly implies this, evidence stated · `[MISSING]` the code cannot tell you this; logged in `decisions.md`. Paths are relative to `godot/` unless they name a folder-root file. This document describes what exists. It approves none of it.

**Evidence image:** `godot/screenshots/global_illumination.png` — upstream screenshot shipped with the source; embedded in `design/DECK.html`.
*`[OBSERVED godot/screenshots/global_illumination.png]` — shipped with the upstream Godot demo. Not a Walker capture: "GPU lighting, reflection appearance … remain unverified" (`README.md`).*

## 1. Vision summary

**What it is.** A free-flying camera inside one baked arena map, carrying a box and a reflective sphere, with three keys that cycle five global-illumination modes, three reflection-probe modes and four screen-space lighting modes. `[OBSERVED test.gd:3-25, 97-114; camera.gd; test.tscn:50-167]`

**Upstream purpose.** "Showcases Godot's global illumination systems: LightmapGI, VoxelGI, SDFGI, ReflectionProbe, and screen-space effects like SSAO and SSIL." `[OBSERVED project.godot:14; godot/README.md:3-4]`

**Why it is in Walker.** Independent title-only copy of Godot `3d/global_illumination` at commit a3b5c113; both native-4K Liam films pending. `[OBSERVED README.md]` Film purpose and audience `[MISSING]` (Q-01).

**Player fantasy / logline.** None. The first-person camera looks like a game, but there is no goal, collision, fail state or score — the camera flies through walls. `[OBSERVED camera.gd:30-45 — position += velocity, no physics body]` Calling this a walking sim would be invention.

**Biggest unresolved question.** Which trade-off is the film about — baked vs real-time GI, or cost vs quality across all five? Q-01.

## 2. Design pillars

None stated. `[MISSING]` (Q-02). Implied `[INFERRED]`:
1. **Same room, swap the lighting.** Two copies of the level mesh exist only so GI modes can be swapped in place (`test.gd:67-69` comment). Evidence: `test.tscn:56-61`.
2. **A dynamic object is the test probe.** The box and sphere ride on the camera so every mode is judged on moving objects too. Evidence: `godot/README.md:15-17`; `test.tscn:126-167`.
3. **Cost labelled next to quality.** Every mode label carries a cost word (Fastest / Fast / Average / Slow). Evidence: `test.gd:28-49`.

## 3. Core loop

No game loop. Recovered **exploration loop** (`diagrams/mode-cycles.svg`):
1. Fly — WASD / arrows, Q / E for down / up, mouse look while captured. `[OBSERVED camera.gd:14-45; project.godot:50-89]`
2. Stop somewhere interesting.
3. Cycle a mode — Space (GI), R (reflection), F (screen-space); Shift reverses. `[OBSERVED test.gd:97-114]`
4. Compare the image and the FPS / ms label. `[OBSERVED test.gd:117-118]`
5. Repeat. No end state.

## 4. Player Experience Goals

None stated. `[MISSING]` (Q-01). Candidate learning outcome, unconfirmed `[INFERRED from godot/README.md:17-24]`: the viewer understands why the box casts no shadow on static surfaces in "Lightmap All" and what the blob-shadow decal is compensating for.

## 5. Mechanics

### M-01 Free-fly camera `[OBSERVED camera.gd]`
`MOUSE_SENSITIVITY 0.002`; pitch clamped ±1.57; `MOVE_SPEED 1.5`; velocity damped ×0.85 per frame (frame-rate dependent `[INFERRED]` — damping is not scaled by delta, line 44). Mouse captured at start (line 11); Escape or F10 toggles capture (lines 23-27; `project.godot:74-79`). Untested. `[OBSERVED FRICTIONAL.md "camera movement/mouse capture remain untested"]`

### M-02 GI mode cycle (Space) `[OBSERVED test.gd:98-106, 121-232]`
| Mode | Level copy shown | GI node | Sky contribution | Light bake mode | Box gi_mode |
|---|---|---|---|---|---|
| 0 Environment Lighting (Fastest) | LightmapAll | none | 0.5 | DYNAMIC | disabled |
| 1 Baked Lightmap All (Fast) | LightmapAll | LightmapGIAll | 0.5 | STATIC | dynamic |
| 2 Baked Lightmap Indirect (Average) | LightmapIndirect | LightmapGIIndirect | 0.5 | DYNAMIC | dynamic |
| 3 VoxelGI (Slow) | LightmapAll | VoxelGI | 1.0 | DYNAMIC | disabled |
| 4 SDFGI (Slow) | LightmapAll | `sdfgi_enabled` | 1.0 | DYNAMIC | disabled |

Three engine workarounds are encoded as comments: lightmaps visible when hidden in Compatibility (`:127-129`); VoxelGI and SDFGI invisible while LightmapGIData is attached (`:193-194, 214-215`). These are upstream observations of engine bugs, not Walker findings. `[OBSERVED]`

### M-03 Reflection probe cycle (R) `[OBSERVED test.gd:108-110, 235-248]`
Disabled (hidden, update once) → Once → Always. The probe is parented to the camera-carried sphere. `[OBSERVED test.tscn:152]`

### M-04 Screen-space cycle (F) `[OBSERVED test.gd:112-114, 251-272]`
Disabled → SSAO → SSIL → SSAO + SSIL. Under Compatibility the label says "Not supported" and nothing changes (`:253-256`).

### M-05 Compatibility fallback `[OBSERVED test.gd:72-89, 100-104]`
GI cycle limited to modes 0-2; lights dimmed; help text drops the F line. Upstream comment: "the actual GI mode is the opposite of what's being set here, due to a bug" (`:102-103`). Untested here. `[OBSERVED FRICTIONAL.md]`

## 6. Systems

### S-01 Scene graph `[OBSERVED test.tscn]`
`Test` (Node3D, `test.gd`) → WorldEnvironment (53); two `zdm2.glb` instances (56, 60); VoxelGI with baked data (63); LightmapGIAll / Indirect with `.lmbake` data (69, 77); Sun, GrateOmniLight, GarageOmniLight, CornerSpotLight (84-112); GlowingBox (`cube.glb`, 120); Camera (`camera.gd`, 126) → Box + BlobShadow decal, ReflectiveSphere → ReflectionProbe + BlobShadow (130-167); five labels (169-223).

### S-02 Input map `[OBSERVED project.godot:33-89]`
| Action | Keys |
|---|---|
| `cycle_gi_mode` | Space |
| `cycle_reflection_probe_mode` | R |
| `cycle_ssil_mode` | F |
| `move_forward` / `back` / `left` / `right` | W/S/A/D + arrows |
| `move_up` / `move_down` | E / Q |
| `toggle_mouse_capture` | Escape, F10 |

On-screen help lists Space, R, F and Escape/F10 only (`test.tscn:220-223`); movement keys, including Q/E, are not shown in-game. `[OBSERVED]`

### S-03 Signals
None: no editor connections, no custom signals, no `@export` vars. All input via `_input` polling. `[OBSERVED]`

### S-04 Baked data `[OBSERVED godot/]`
`zdm2_all.lmbake` + `.exr` (≈5.7 MB), `zdm2_indirect.lmbake` + `.exr`, `test_VoxelGIData.res` (≈5.1 MB). Not modified. `[OBSERVED README.md "No geometry or bake data was modified"]` Rebaking procedure `[MISSING]` (Q-05).

## 7. Progression
None. `[OBSERVED]` Mode order is cheapest → most expensive `[INFERRED from the cost words]`.

## 8. World
One map, `zdm2`, derived from Cube 2: Sauerbraten's "zdm2" arena, CC BY 4.0. `[OBSERVED godot/README.md:30-35]` It is a lighting test room with a grate, a garage and a corner spotlight named in its lights. `[OBSERVED test.tscn:93-112]` No lore, and none should be invented from an arena map.

## 9. Narrative
None, correctly. `[OBSERVED]`

## 10. Characters
None. The box and sphere are measuring instruments. `[OBSERVED]`

## 11. Features and priority

| ID | Feature | Exists | Verified how | Priority |
|---|---|---|---|---|
| F-01 | GI mode cycle | yes | 20 assertions: 5 modes × 2 cycles, label + node/env state `[OBSERVED modes-20260924.log]` | [MISSING] |
| F-02 | Reflection cycle | yes | 6 assertions | [MISSING] |
| F-03 | Screen-space cycle | yes | 16 assertions (mode + flags) | [MISSING] |
| F-04 | Free-fly camera + capture toggle | yes | **untested** | [MISSING] |
| F-05 | Shift reverse cycling | yes | **untested** | [MISSING] |
| F-06 | Compatibility fallback | yes | **untested** | [MISSING] |
| F-07 | FPS label | yes | not a benchmark | [MISSING] |
| F-08 | Forward+ capture | **no** (proposed) | — | [MISSING] |
| F-09 | Two native-4K Liam films | **no** (proposed) | — | [MISSING] |

42 assertions total, 0 failures; headless reports `forward_plus`, which proves property state, not pixels. `[OBSERVED FRICTIONAL.md; modes-20260924.log]` CORE percentage undetermined (Q-06).

## 12. Out of scope
Observed absences: collision, objectives, audio, save, rebake tooling, settings menu. `[OBSERVED]` `import/blender/enabled=false` means the `.blend` sources are not re-imported. `[OBSERVED project.godot:31]`

## 13. Technical
- Godot 4.7 tag `[OBSERVED project.godot:17]`; 4.7.2.stable in logs.
- Renderer unset → Forward+ (confirmed headless: `RENDERING_METHOD forward_plus`). `[OBSERVED modes-20260924.log:3]`
- Soft shadow quality 3 (directional + positional), debanding, SDFGI probe ray count 2, screen-space AA = FXAA (1), web MSAA 4×. `[OBSERVED project.godot:91-98]`
- Scripts: `test.gd` (272 lines), `camera.gd` (45), `test_modes.gd` (Walker probe, 41).
- Assets: `zdm2.glb/.blend`, `cube.glb/.blend`, bake data above. Maturity L4 upstream. `[INFERRED]`

## 14. Risks

| ID | Risk | L / I | Evidence |
|---|---|---|---|
| R-01 | Headless "forward_plus" read as proof of GPU GI | M / H | FRICTIONAL.md warns explicitly |
| R-02 | Map licence (CC BY 4.0) attribution missing from a published film | M / H | `godot/README.md:30-35` |
| R-03 | Camera damping is frame-rate dependent; flythrough speed differs by machine | M / M | `camera.gd:44` |
| R-04 | SDFGI / VoxelGI cost makes capture stutter at 4K | M / M | labels say "Slow"; untested |
| R-05 | Recording blocker holds both films | H / H | README |

**Top 3.** R-05 blocks visible work; R-02 is the obligation; R-01 is the overclaim.

## 15. Open questions
In `decisions.md`: Q-01 film purpose; Q-02 pillars; Q-03 capture path through the map; Q-04 in-game help omits movement keys; Q-05 rebake procedure; Q-06 CORE; Q-07 Compatibility capture — include or exclude.

## 16. Tests

Existing `[OBSERVED godot/test_modes.gd; modes-20260924.log]`: T-01 GI cycle ×2 (label + LightmapGIAll/Indirect/VoxelGI visibility + SDFGI flag); T-02 reflection cycle ×2 (visibility + update mode); T-03 screen-space cycle ×2 (mode + SSAO/SSIL flags). 42 pass.

Proposed (dashed):
| ID | Setup | Action | Expected | Links |
|---|---|---|---|---|
| T-04 | any mode | Shift+Space | mode decrements, wraps 0 → 4 | F-05 |
| T-05 | Compatibility | Space ×3 | cycles 0-2; label vs actual per upstream bug note | F-06 |
| T-06 | captured mouse | Escape | cursor visible; F10 restores | F-04 |
| T-07 | Forward+ visible | fixed camera, cycle 5 GI modes | five captures at matched pose | F-08 |
| T-08 | 30 vs 120 FPS cap | hold W 2 s | distance travelled compared (R-03) | M-01 |

## Zelda's notes (silent mode; what I would have said out loud)

7 Failure Mode read:
1. **Ghost Center — PRESENT, expected.**
2. **Mechanic Mirage — ABSENT by refusal.**
3. **Implementation Void — PARTIAL.** Mode state is thoroughly tested; the camera — the thing a film is shot through — is not tested at all.
4. **Priority Inflation — cannot assess.**
5. **Novelist's Trap — ABSENT.** The arena map could tempt someone to write a setting. Don't.
6. **Completeness Fallacy — PRESENT.** Seven open questions.
7. **Stagnant Artifact — ABSENT.**

What the structure suggests `[INFERRED]`: a lighting-artist's comparison room, not a player's space. The cost words on every label say the intended viewer is choosing a GI method for their own project.

**First fix:** Q-03 — pick three fixed camera poses in the map before any capture, so five GI modes can be compared at matched framing. The free-fly camera is frame-rate dependent (R-03); do not rely on it for matched shots.
