use std::time::{Duration, Instant};

use serde::Serialize;
use tauri::AppHandle;

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct ToggleLatencySample {
    pub iteration: u32,
    pub enabled: bool,
    pub elapsed_ms: f64,
}

#[derive(Debug, Clone, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct ToggleLatencyReport {
    pub label: String,
    pub target_ms: f64,
    pub total_toggles: u32,
    pub max_ms: f64,
    pub avg_ms: f64,
    pub over_target_count: u32,
    pub passed: bool,
    pub samples: Vec<ToggleLatencySample>,
}

#[tauri::command]
pub fn cmd_set_click_through(app: AppHandle, label: String, enabled: bool) -> Result<(), String> {
    set_click_through(&app, &label, enabled)
}

pub fn set_click_through(app: &AppHandle, label: &str, enabled: bool) -> Result<(), String> {
    let window = app
        .get_webview_window(label)
        .ok_or_else(|| format!("Window '{label}' not found"))?;

    window
        .set_ignore_cursor_events(enabled)
        .map_err(|err| format!("Failed to update click-through on '{label}': {err}"))
}

#[tauri::command]
pub async fn cmd_run_click_through_latency_test(
    app: AppHandle,
    label: String,
    toggles: Option<u32>,
    interval_ms: Option<u64>,
) -> Result<ToggleLatencyReport, String> {
    let total_toggles = toggles.unwrap_or(20).max(2);
    let interval_ms = interval_ms.unwrap_or(100);
    let target_ms = 50.0;
    let mut samples = Vec::with_capacity(total_toggles as usize);
    let mut test_error: Option<String> = None;

    for index in 0..total_toggles {
        let iteration = index + 1;
        let enabled = index % 2 == 0;

        let started = Instant::now();
        if let Err(err) = set_click_through(&app, &label, enabled) {
            test_error = Some(err);
            break;
        }
        let elapsed_ms = started.elapsed().as_secs_f64() * 1_000.0;

        println!(
            "[latency-test:{label}] iteration={iteration}/{total_toggles} enabled={enabled} \
             elapsed_ms={elapsed_ms:.3}"
        );

        samples.push(ToggleLatencySample {
            iteration,
            enabled,
            elapsed_ms,
        });

        if iteration < total_toggles {
            tauri::async_runtime::sleep(Duration::from_millis(interval_ms)).await;
        }
    }

    let reset_result = set_click_through(&app, &label, false);
    match (test_error, reset_result) {
        (Some(err), Ok(())) => return Err(err),
        (Some(err), Err(reset_err)) => {
            return Err(format!(
                "{err}; also failed to reset click-through: {reset_err}"
            ));
        }
        (None, Err(reset_err)) => {
            return Err(format!(
                "Latency test completed but failed to reset click-through: {reset_err}"
            ));
        }
        (None, Ok(())) => {}
    }
    if samples.is_empty() {
        return Err("Latency test did not record any samples".to_string());
    }

    let sample_count = samples.len() as f64;

    let completed_toggles = samples.len() as u32;
    let max_ms = samples
        .iter()
        .map(|sample| sample.elapsed_ms)
        .fold(0.0_f64, f64::max);
    let avg_ms = samples.iter().map(|sample| sample.elapsed_ms).sum::<f64>() / sample_count;
    let over_target_count = samples
        .iter()
        .filter(|sample| sample.elapsed_ms >= target_ms)
        .count() as u32;
    let passed = over_target_count == 0;

    println!(
        "[latency-test:{label}] target_ms={target_ms:.1} total_toggles={completed_toggles} \
         max_ms={max_ms:.3} avg_ms={avg_ms:.3} over_target_count={over_target_count} \
         passed={passed}"
    );

    Ok(ToggleLatencyReport {
        label,
        target_ms,
        total_toggles: completed_toggles,
        max_ms,
        avg_ms,
        over_target_count,
        passed,
        samples,
    })
}
