package game

import "core:fmt"
import rl "vendor:raylib"
import "ui"

import def "../platform_definitions"

global_memory : def.Game_Memory
platform : def.Platform_Functions

Game_State :: struct {
  scene : enum {
    MAIN_MENU,
    GAME,
  },
}

ui_state : ui.UI
@export
update :: proc(game_memory: ^def.Game_Memory, platform_functions: def.Platform_Functions) {
  assert(size_of(Game_State) < game_memory.permanent_memory_size)

  global_memory = game_memory^
  platform = platform_functions
  game_state := transmute(^Game_State)global_memory.permanent_memory

  if !game_memory.is_initialized {
    game_memory.is_initialized = true

    fmt.println("eae, blz?")
  }

  if rl.IsKeyPressed(.SPACE) {
    if game_state.scene == .MAIN_MENU {
      game_state.scene = .GAME
    } else if game_state.scene == .GAME {
      game_state.scene = .MAIN_MENU
    }
  }

  mouse_pos := rl.GetMousePosition()

  // .LEFT if rl.IsMouseButtonDown(.LEFT) else .NONE
  ui.update(&ui_state, mouse_pos.x, mouse_pos.y, #partial {
    .LEFT = rl.IsMouseButtonDown(.LEFT),
  })

  rl.ClearBackground(rl.BLACK)

  ui.begin(&ui_state)
  if ui.button(&ui_state, 20, 20, 30, 30) do fmt.println("cliquei")
  ui.end(&ui_state)

  for command in ui_state.draw_commands {
    color := rl.GREEN
    #partial switch command.color {
    case .RED: color = rl.RED
    case .BLUE: color = rl.BLUE
    }
    rl.DrawRectangleV({command.x, command.y}, {command.w, command.h}, color)
  }

  switch game_state.scene {
  case .MAIN_MENU: {
    rl.DrawRectangle(
      rl.GetMouseX(), rl.GetMouseY(),
      10, 10,
      rl.RED if rl.IsMouseButtonDown(.LEFT) else rl.YELLOW)
    if rl.IsMouseButtonPressed(.RIGHT) do game_state.scene = .GAME
  }
  case .GAME: {
    rl.DrawRectangle(10, 10, 10, 10, rl.YELLOW)
  }
  }
  // platform.debug_draw_square(10, 10, 50, 50, {.3, .2, .8, 1})
  // platform.debug_draw_square(200, 50, 50, 50, {.3, .2, .8, 1})
}


