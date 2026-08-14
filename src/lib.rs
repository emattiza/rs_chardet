use chardetng::{EncodingDetector, Iso2022JpDetection, Utf8Detection};
use pyo3::prelude::*;

/// Detect a character set from an array of bytes
/// Returns the name as found by chardet-ng
#[pyfunction]
fn detect_rs_enc_name(a: &[u8]) -> PyResult<&str> {
    let mut detector = EncodingDetector::new(Iso2022JpDetection::Allow);
    detector.feed(a, true);
    let encoding = detector.guess(None, Utf8Detection::Allow);
    let rust_name = encoding.name();
    Ok(rust_name)
}

/// Detect a character set from an array of bytes
/// Returns the name as found by codecs.lookup from python
#[pyfunction]
fn detect_codec(py: Python<'_>, a: &[u8]) -> PyResult<Py<PyAny>> {
    let enc_rs_name = detect_rs_enc_name(a)?;
    let lookup_fn = py.import("codecs")?.getattr("lookup")?;
    let lookup_value = lookup_fn.call1((enc_rs_name,))?;
    Ok(lookup_value.into())
}

/// Chardet-NG support in python from rust
/// Enables character set detection provided a byte sample
#[pymodule]
fn rs_chardet(_py: Python, m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add("__version__", env!("CARGO_PKG_VERSION"))?;
    m.add_function(wrap_pyfunction!(detect_rs_enc_name, m)?)?;
    m.add_function(wrap_pyfunction!(detect_codec, m)?)?;
    Ok(())
}
