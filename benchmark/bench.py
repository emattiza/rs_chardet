from io import TextIOBase
import sys
import time
from typing import Any, Callable, Optional
from pathlib import Path


def benchmark_impl(
    msg: bytes,
    detector: Callable[[Any], Any],
    n_calls: int,
    module: Any,
    output_buf: Optional[TextIOBase] = None,
):
    result = 0
    for _ in range(n_calls):
        start = time.time()
        detector(msg)
        result += time.time() - start
    print(
        "%s v%s:" % (module.__name__, module.__version__),
        1 / (result / n_calls),
        "call(s)/s",
        file=(output_buf or sys.stdout),
    )


def main():
    import chardet
    import cchardet
    import rs_chardet

    do_times = 20
    path = (
        Path(__file__).parent
    ) / "samples/wikipediaJa_One_Thousand_and_One_Nights_SJIS.txt"
    with path.open("rb") as f:
        msg = f.read()

        # detector_chardet = lambda msg: chardet.detect(msg)
        detector_rschardet = lambda msg: rs_chardet.detect_rs_enc_name(msg)
        detector_cchardet = lambda msg: cchardet.detect(msg)

        # Test chardet
        # benchmark_impl(msg, detector_chardet, do_times, chardet, None)
        benchmark_impl(msg, detector_rschardet, do_times, rs_chardet, None)
        benchmark_impl(msg, detector_cchardet, do_times, cchardet, None)


if __name__ == "__main__":
    main()
