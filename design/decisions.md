# Open questions log — walker-3d-global-illumination

Recovered by `/gdd reverse --path godot silent`, 2026-09-27 · gate — unsigned at time of writing. Every `[MISSING]` in `GDD.md` is one row. Nothing below is decided.

Format per entry: THE QUESTION / THE STAKES / DECISION DEADLINE / OPTIONS / OWNER / STATUS.

| # | Question | Stakes | Deadline | Options | Owner | Status |
|---|---|---|---|---|---|---|
| Q-01 | What do the two native-4K Liam films teach, and to whom? | No vision → a mode slideshow (Ghost Center) | Before capture | (a) baked vs real-time GI; (b) cost/quality ladder across all five; (c) reflections + SSAO/SSIL as a second film | Nik Bear Brown | Open |
| Q-02 | Pillars for the Walker adaptation | Nothing to judge shots against | With Q-01 | adopt the three `[INFERRED]` pillars in GDD §2, or replace | Nik Bear Brown | Open |
| Q-03 | Fixed camera poses for matched comparisons | Free-fly speed is frame-rate dependent; unmatched framing makes mode comparison meaningless | Before capture | pick 3 poses by hand; add a pose script (touches godot/, needs approval); record pose coordinates only | Nik Bear Brown | Open |
| Q-04 | In-game help omits movement keys (WASD/arrows, Q/E) | A viewer following the film cannot fly | Before the walkthrough film | narrate the keys; add to help label (needs approval); leave | Nik Bear Brown | Open |
| Q-05 | Rebake procedure if the level or lights change | Bake data is opaque; a change without rebake silently breaks modes 1-3 | Before any scene edit | document upstream bake settings; forbid edits; rebake and re-verify | Nik Bear Brown | Open |
| Q-06 | Which features are CORE? | CORE % cannot be computed | With Q-01 | mark F-01..F-09 | Nik Bear Brown | Open |
| Q-07 | Show the Compatibility fallback on camera? | Upstream notes the label and actual GI mode are swapped there; filming it invites a wrong claim | Before capture | exclude; include with the caveat on screen; test first (T-05) | Nik Bear Brown | Open |
