extends SceneTree

var failures := 0
func _initialize() -> void:
	call_deferred("run")
func check(ok: bool, label: String) -> void:
	print("PASS " if ok else "FAIL ", label)
	if not ok:
		failures += 1
func key(code: Key) -> void:
	for pressed in [true, false]:
		var event := InputEventKey.new()
		event.physical_keycode = code
		event.pressed = pressed
		root.push_input(event, true)
		await process_frame
func run() -> void:
	var demo: Node = load("res://test.tscn").instantiate()
	root.add_child(demo)
	await process_frame
	print("RENDERING_METHOD ", RenderingServer.get_current_rendering_method())
	var count := 3 if demo.is_compatibility else 5
	for i in count * 2:
		await key(KEY_SPACE)
		var expected := (i + 1) % count
		check(demo.gi_mode == expected and demo.gi_mode_label.text.contains(demo.gi_mode_texts[expected]), "GI mode and label " + str(expected))
		check(demo.get_node("LightmapGIAll").visible == (expected == 1) and demo.get_node("LightmapGIIndirect").visible == (expected == 2) and demo.get_node("VoxelGI").visible == (expected == 3) and demo.environment.sdfgi_enabled == (expected == 4), "GI node/environment state " + str(expected))
	for i in 6:
		await key(KEY_R)
		var expected := (i + 1) % 3
		check(demo.reflection_probe_mode == expected and demo.reflection_probe.visible == (expected != 0) and demo.reflection_probe.update_mode == (1 if expected == 2 else 0), "reflection cycle " + str(expected))
	for i in 8:
		await key(KEY_F)
		var expected := (i + 1) % 4
		check(demo.ssil_mode == expected, "screen-space mode " + str(expected))
		if not demo.is_compatibility:
			check(demo.environment.ssao_enabled == (expected == 1 or expected == 3) and demo.environment.ssil_enabled == (expected >= 2), "screen-space flags " + str(expected))
	print("HEADLESS STATE ONLY: no GI/reflection pixels, performance or films verified; failures=", failures)
	demo.queue_free()
	await process_frame
	quit(1 if failures else 0)
