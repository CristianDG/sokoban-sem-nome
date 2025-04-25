package game
import "core:fmt"

import def "../platform_definitions"

global_memory : def.Game_Memory

update :: proc(mem: ^def.Game_Memory) {
  global_memory = mem^

  if !mem.is_initialized {
    mem.is_initialized = true
    fmt.println("eae, blz?")
  }

  global_memory.debug_draw_square(10, 10, 50, 50)
}
