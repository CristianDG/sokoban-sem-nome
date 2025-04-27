package game
import "core:fmt"

import def "../platform_definitions"

global_memory : def.Game_Memory
platform : def.Platform_Functions

@export
update :: proc(mem: ^def.Game_Memory) {
  global_memory = mem^
  platform = mem.fns

  if !mem.is_initialized {
    mem.is_initialized = true
    fmt.println("eae, blz?")
  }

  platform.debug_draw_square(10, 10, 50, 50, {.3, .2, .8, 1})
  platform.debug_draw_square(200, 50, 50, 50, {.3, .2, .8, 1})
}
