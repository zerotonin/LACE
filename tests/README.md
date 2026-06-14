# LACE tests

Home for the MATLAB unit-test suite. Test classes / function-based
tests placed here are discovered automatically by the `test` task in
`buildfile.m` (run `buildtool test` locally, or via the CI workflow).

No tests ship with the initial 1.0.0 packaging yet; add `*_test.m` or
`matlab.unittest.TestCase` classes here and CI will pick them up.
