CREATE TABLE test_reindex ();
CREATE INDEX idxtest_reindex ON test_reindex USING zombodb((test_reindex.*));
REINDEX INDEX idxtest_reindex;
DROP TABLE test_reindex;