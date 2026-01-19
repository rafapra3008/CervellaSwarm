## W3-A Test Suite
**Status**: ⚠️ OK + BUG FOUND
**Fatto**: Test suite completa (29 test) per REQ-01 to REQ-08
**Test**: 4/4 quick pass, full suite BLOCKED
**Bug**: semantic_search.py scansiona node_modules (17k+ file, >5min)
**Run**: `pytest tests/utils/test_semantic_quick.py -v`
**Next**: Fix semantic_search.py exclude patterns prima di full test
