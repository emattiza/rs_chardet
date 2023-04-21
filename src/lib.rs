use chardetng::EncodingDetector;
use pyo3::prelude::*;

#[pyfunction]
fn detect_rs_enc_name(a: &[u8]) -> PyResult<&str> {
    let mut detector = EncodingDetector::new();
    detector.feed(a, true);
    let encoding = detector.guess(None, true);
    let rust_name = encoding.name();

    Ok(rust_name)
}

#[pyfunction]
fn detect_codec(a: &[u8]) -> PyResult<PyAny> {
    let enc_rs_name = detect_rs_enc_name(
        a
        )?;
    Python::with_gil(|py| {
        let codecs = PyModule::import(py, "codecs");
        codecs.getattr("lookup")?.call1(enc_rs_name)?.extract()?
    })
}

/// A Python module implemented in Rust.
#[pymodule]
fn rs_chardet(_py: Python, m: &PyModule) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(detect, m)?)?;
    Ok(())
}
