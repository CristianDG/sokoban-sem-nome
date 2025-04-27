package game_platform

import "core:fmt"
import "core:log"
import "core:mem"
import rl "vendor:raylib"
import def "./platform_definitions"
import hot_reload "deps/hot_reload"

import "./game"

import "core:dynlib"
import "core:time"

Game :: struct {
  update: type_of(game.update),
  __last_time_modified : time.Time,
  __swap: bool,
  __handle : dynlib.Library,
  metadata: hot_reload.Metadata,
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


game_dll : Game

load_game_lib :: proc() {
  LIB_NAME :: "game_lib" + (".dll" when ODIN_OS == .Windows else ".so")

  new, lib_ok := hot_reload.load_lib(&game_dll, &game_dll.metadata, LIB_NAME)
  assert(lib_ok)
}

main :: proc() {
  context.logger = log.create_console_logger()

  when true {
    track: mem.Tracking_Allocator
    mem.tracking_allocator_init(&track, context.allocator)
    defer mem.tracking_allocator_destroy(&track)
    context.allocator = mem.tracking_allocator(&track)

    defer for _, leak in track.allocation_map {
      log.errorf("%v leaked %m\n", leak.location, leak.size)
    }
  }


  rl.InitWindow(640, 480, "sokoban sem nome")
  defer rl.CloseWindow()

  load_game_lib()

  game_memory : def.Game_Memory = {
    fns = {
      debug_draw_square = debug_draw_square
    },
  }

  rl.SetTargetFPS(15)
  for !rl.WindowShouldClose() {
    load_game_lib()

    rl.BeginDrawing()
    {
      game_dll.update(&game_memory)
    }
    rl.EndDrawing()

  }

}
