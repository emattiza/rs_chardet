use chardetng::EncodingDetector;
use pyo3::prelude::*;

#[pyfunction]
fn detect(a: &[u8]) -> &str {
    let mut detector = EncodingDetector::new();
    detector.feed(a, true);
    let encoding = detector.guess(None, true);
    encoding.name()
}

/// A Python module implemented in Rust.
#[pymodule]
fn rs_chardet(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(detect, m)?)?;
    Ok(())
}
