package game_platform

import rl "vendor:raylib"
import def "./platform_definitions"
import "./game"

debug_draw_square :: proc(x, y, w, h: i32) {
  rl.DrawRectangle(x, y, w, h, rl.RED)
}

main :: proc() {
  rl.InitWindow(640, 480, "sokoban sem nome")
  defer rl.CloseWindow()

  game_memory : def.Game_Memory = {
    fns = {
      debug_draw_square = debug_draw_square
    },
  }

  for !rl.WindowShouldClose() {

    rl.BeginDrawing()
    {
      game.update(&game_memory)
    }
    rl.EndDrawing()

  }

}
