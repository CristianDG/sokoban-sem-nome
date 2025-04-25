package platform_definitions


debug_draw_square_t : #type proc(x, y, w, h: i32)

Platform_Functions :: struct {
  debug_draw_square: type_of(debug_draw_square_t)
}

Game_Memory :: struct {
  is_initialized: bool,
  using fns: Platform_Functions
}

