package ui

Mouse_Buttons :: enum {
  LEFT,
  RIGHT,
  MIDDLE,
}

Mouse_State :: enum {
  RELEASED,
  HELD,
  CLICKED,
}

Draw_Command :: struct {
  x, y, w, h: f32,
  color: enum {
    RED,
    BLUE,
    GREEN,
  }
}

UI :: struct {
  mouse_pos: [2]f32,
  mouse_buttons: [Mouse_Buttons]Mouse_State,
  active: ID,
  draw_commands: [dynamic]Draw_Command
}

ID :: struct {
  id: u32,
}

Element :: struct {
  id: ID,
}

begin :: proc(ui: ^UI) { }
end :: proc(ui: ^UI) { }

button :: proc(ui: ^UI, x, y, w, h: f32) -> (clicked := false) {
  command: Draw_Command

  command.x = x
  command.y = y
  command.w = w
  command.h = h

  command.color = .GREEN
  if ( ui.mouse_pos.x >= x
    && ui.mouse_pos.x <= x + w
    && ui.mouse_pos.y >= y
    && ui.mouse_pos.y <= y + h
  ) {
    command.color = .BLUE
    if ui.mouse_buttons[.LEFT] == .HELD {
      command.color = .RED
    }
    if ui.mouse_buttons[.LEFT] == .CLICKED {
      command.color = .RED
      clicked = true
    }
  }

  append(&ui.draw_commands, command)
  return
}

update :: proc(
  ui: ^UI,
  mouse_x, mouse_y: f32,
  mouse_buttons: [Mouse_Buttons]bool
) {
  ui.mouse_pos.x = mouse_x
  ui.mouse_pos.y = mouse_y
  for button in Mouse_Buttons {
    if ui.mouse_buttons[button] == .HELD && !mouse_buttons[button] {
      ui.mouse_buttons[button] = .CLICKED
    } else if mouse_buttons[button] {
      ui.mouse_buttons[button] = .HELD
    } else if !mouse_buttons[button] {
      ui.mouse_buttons[button] = .RELEASED
    }
  }
}


