package game_platform

import "core:fmt"
import "core:log"
import "core:mem"
import rl "vendor:raylib"
import def "../platform_definitions"
import hot_reload "../deps/hot_reload"

Game :: struct {
  update: type_of(def.game_update),
  metadata: hot_reload.Metadata,
}

game : Game

load_game_lib :: proc() {
  LIB_NAME :: "game_lib" + (".dll" when ODIN_OS == .Windows else ".so")

  new, lib_ok := hot_reload.load_lib(&game, &game.metadata, LIB_NAME)
  assert(lib_ok)
}

platform_color_to_rl_color :: proc(platform_color: def.Color) -> rl.Color {
  return {
    u8(platform_color.r * 255),
    u8(platform_color.g * 255),
    u8(platform_color.b * 255),
    u8(platform_color.a * 255),
  }
}

debug_draw_square :: proc(x, y, w, h: i32, color: def.Color) {
  rl.DrawRectangle(x, y, w, h, platform_color_to_rl_color(color))
}


main :: proc() {
  context.logger = log.create_console_logger()

  when true {
    track: mem.Tracking_Allocator
    mem.tracking_allocator_init(&track, context.allocator)
    context.allocator = mem.tracking_allocator(&track)

    defer{
      for _, leak in track.allocation_map {
        log.errorf("%v leaked %m\n", leak.location, leak.size)
      }
      mem.tracking_allocator_destroy(&track)
    }
  }

  rl.InitWindow(640, 480, "sokoban sem nome")
  defer rl.CloseWindow()

  load_game_lib()

  fns : def.Platform_Functions = {
    debug_draw_square = debug_draw_square
  }

  permanent_memory_size := mem.Gigabyte
  permanent_memory, permanent_memory_alloc_err := mem.alloc(permanent_memory_size)
  if permanent_memory_alloc_err != nil {
    log.errorf("could not allocate %v bytes", permanent_memory_size)
    return
  }
  defer mem.free(permanent_memory)

  scratch_memory_size := 20 * mem.Megabyte
  scratch_memory, scratch_memory_alloc_err := mem.alloc(scratch_memory_size)
  if scratch_memory_alloc_err != nil {
    log.errorf("could not allocate %v bytes", scratch_memory_size)
    return
  }
  defer mem.free(scratch_memory)

  game_memory : def.Game_Memory = {
    permanent_memory = permanent_memory,
    permanent_memory_size = permanent_memory_size,
    scratch_memory_size = scratch_memory_size,
  }

  rl.SetTargetFPS(60)
  for !rl.WindowShouldClose() {
    load_game_lib()

    rl.BeginDrawing()
    {
      game.update(&game_memory, fns)
    }
    rl.EndDrawing()
  }

}
