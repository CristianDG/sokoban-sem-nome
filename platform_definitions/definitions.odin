package platform_definitions

Color :: [4]f32

debug_draw_square_t : #type proc(x, y, width, height: i32, color: Color)

Platform_Functions :: struct {
  debug_draw_square: type_of(debug_draw_square_t)
}

Game_Memory :: struct {
  is_initialized: bool,
  using fns: Platform_Functions
}

