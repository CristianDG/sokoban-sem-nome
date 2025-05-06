package platform_definitions

Color :: [4]f32

game_update : #type proc(^Game_Memory, Platform_Functions)
debug_draw_square_t : #type proc(x, y, width, height: i32, color: Color)

Platform_Functions :: struct {
  debug_draw_square: type_of(debug_draw_square_t)
}

Game_Memory :: struct {
  is_initialized: bool,
  permanent_memory: rawptr,
  permanent_memory_size: int,
  scratch_memory: rawptr,
  scratch_memory_size: int,
}

