# rs-chardet
![CI](https://github.com/emattiza/rs_chardet/actions/workflows/release.yaml/badge.svg)
[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/emattiza/rs_chardet/blob/master/LICENSE.txt)

This is a thin wrapper utilizing [chardet-ng] for character encoding detection.

## Benchmarking
### Results

| Library    | Version | Rate (call(s)/s)    |
|------------|---------|---------------------|
| chardet    | v5.1.0  | 0.20407073211428026 |
| rs_chardet | v0.1.1  | 25.446704726774133  |
| cchardet   | v2.1.18 | 917.8711484593837   |

### Benchmark System Information: 
[benchmark-py]
Hetzner CPX31 (4vCPU, 8GB Ram) in the US


[chardet-ng]: https://github.com/hsivonen/chardetng
[benchmark-py]: ./benchmark/bench.py
