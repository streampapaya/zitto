# ZITTO: Minimal Win32 GUI Framework in Zig

## Overview

ZITTO is a Windows‑desktop GUI framework written in [Zig](https://ziglang.org/).  It uses native Win32 APIs and a simple MVC‑style split between `app`, `controller`, `model` and `view` modules.  The current version (defined in `app_version.zig`) is **1.0.16**.  Major characteristics include:

- **Native windowing:** ZITTO registers a custom window class and creates a borderless popup window using Win32 functions like `RegisterClassW` and `CreateWindowExW`.  The event loop processes Windows messages via `GetMessageW`, `TranslateMessage` and `DispatchMessageW`.
- **Simple architecture:** `main.zig` delegates to an `app` module which calls a `window_controller`; the controller constructs a `WindowModel` and hands it to a view for creation and event‑loop processing.
- **Configurable layout:** A central configuration file defines layout styles (`full`, `minimal`, `empty`), the app name, window class, default resolution and theme colours.  The layout engine computes regions for the title bar, sidebar, centre, terminal and footer panels, and the layout view draws coloured rectangles accordingly.
- **Stateful model:** A `WindowModel` stores window width, height, title height and initial position.  This allows the controller to pass mutable state to the view without global variables.
- **Unicode support:** Helper functions convert UTF‑8 strings to UTF‑16 before registering the window class and window title.
- **GDI rendering:** Panels are drawn using GDI calls (`CreateSolidBrush`, `Rectangle`, `DeleteObject`) and are collected into a `LayoutRender` structure before being rendered.
- **Event handling:** The window procedure routes messages to dedicated handlers: `WM_PAINT` triggers a redraw via `win32_wm_paint`, `WM_SIZE` invalidates the window so it will repaint after resizing, `WM_NCHITTEST` makes the top title area draggable by returning `HTCAPTION` when the mouse is inside the title height and `WM_DESTROY` posts a quit message.

## Current Scope

The repository currently delivers a skeleton GUI framework with the following features (see `docs/FEATURES.md` for the original checklist):

- **Borderless popup window:** A custom class is registered and a borderless popup window is created.  There are no minimise/close buttons yet.
- **MVC split:** Code is organised into `app`, `controller`, `model` and `view` modules.
- **Layout styles:** Three layout modes are supported: `empty` (title bar only), `minimal` (title bar + centre panel) and `full` (title bar, left panel, centre panel, right panel, terminal and footer).  The current default is `empty`.
- **Fixed geometry:** `layout_engine.zig` calculates fixed widths and heights for panels (title height 40 px, footer height 25 px, left panel 220 px, right panel 260 px and terminal height 200 px) and positions them accordingly.
- **Colour themes:** Theme colours for each panel are defined in `config.zig`.
- **UTF‑16 registration:** The helper module converts strings to UTF‑16 before calling Win32 APIs.

## Roadmap

The project is currently in an early proof‑of‑concept stage.  The following high‑level goals provide a roadmap for future development:

1. **Complete the panel modules** – The `src/views/panels/title_panel.zig` file is empty; implement a title panel that renders the app name and optional buttons (minimise/close).  Similarly, consider adding modules for left/right sidebars, terminal and footer panels so each can encapsulate its own drawing logic.
2. **Make the layout responsive** – `layout_engine.zig` uses fixed sizes.  Update it to compute panel sizes proportionally based on the window’s dimensions and respond to `WM_SIZE` by recalculating layout rather than simply invalidating the window.
3. **Handle user input events** – Constants for mouse and keyboard events exist (e.g., `WM_MOUSEMOVE`, `WM_LBUTTONDOWN`, `WM_KEYDOWN`) but are unused.  Implement event handlers for dragging, clicking and keyboard shortcuts.  For example, allow users to resize panels with the mouse or invoke commands using keys.
4. **Add widgets and content** – Currently, panels are plain coloured rectangles.  Introduce widgets such as buttons, labels or a terminal emulator inside the `terminal` panel.  This may require creating a simple widget system or embedding existing components.
5. **Improve aesthetics** – Provide custom title‑bar buttons, drop shadows and rounded corners.  Allow users to customise the colour theme, perhaps by loading settings from a configuration file.
6. **Cross‑platform exploration** – Although ZITTO targets Win32 today, explore whether portions of the architecture can be abstracted for cross‑platform rendering (e.g., using SDL, GLFW or native APIs on Linux/macOS).  This may be a long‑term goal but would broaden adoption.
7. **Packaging and deployment** – Set up build scripts to produce signed installers for Windows and automate versioning based on `app_version.zig`.  Document the build process in the README.

## Tasks To Do

Below is a concrete, non‑exhaustive list of tasks derived from the roadmap and examination of the repository:

- **Implement TitlePanel:** Fill `src/views/panels/title_panel.zig` with code that draws the app name.  Add optional minimise and close buttons and handle their click events.
- **Panel modules for other sections:** Create `left_panel.zig`, `center_panel.zig`, `right_panel.zig`, `terminal_panel.zig` and `footer_panel.zig` under `src/views/panels` to encapsulate drawing and event handling for each area.
- **Responsive layout:** Modify `layout_engine.computeLayout` to use percentages or weights instead of fixed values.  Update `win32_wm_size` to recalculate layout when the window resizes.
- **Mouse and keyboard handling:** Extend `win32_window_proc.zig` to route `WM_MOUSEMOVE`, `WM_LBUTTONDOWN`, `WM_LBUTTONUP`, `WM_KEYDOWN` and `WM_KEYUP` messages to appropriate handlers.  For instance, allow dragging to resize panels or clicking on title‑bar buttons to close the window.
- **Terminal emulation:** In the `terminal` panel, integrate a simple text buffer to display log messages and possibly accept user input.  This could reuse existing Zig crates or embed a console control.
- **Configuration persistence:** Read configuration (layout style, theme colours) from an external file (e.g., TOML or JSON) and persist changes between runs.  Provide command‑line flags to override defaults.
- **Theming support:** Allow users to switch between light and dark themes by defining multiple `Theme` structures in `config.zig` and selecting one at runtime.
- **Version consistency:** The branch `1.0.15` contains `app_version.zig` with version "1.0.16".  Clarify versioning and update the branch or file accordingly.
- **Documentation and examples:** Expand `docs/FEATURES.md` to include usage instructions and screenshots.  Provide a sample project demonstrating how to build and extend the framework.

This README summarises the current capabilities of ZITTO and outlines areas for further development.  It should serve as both an overview for new contributors and a checklist for ongoing work.  Contributions and suggestions are welcome!
