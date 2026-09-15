pub mod window;

pub fn build() -> tauri::Builder<tauri::Wry> {
    tauri::Builder::default().invoke_handler(tauri::generate_handler![
        crate::window::cmd_set_click_through,
        crate::window::cmd_run_click_through_latency_test,
    ])
}
