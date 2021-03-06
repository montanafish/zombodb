# Configuration Settings

ZomboDB provides a number of configuration settings that affect how it operates.

## `postgresql.conf`-only settings

The below settings can only be set in `postgresql.conf` and require a Postgres configuration reload (or server restart) to be changed.



```
zdb.default_elasticsearch_url

Type: string
Default: null
```

Defines the default URL for your Elasticsearch cluster so you can elite setting it on every index during `CREATE INDEX`.  The value used must end with a forward slash (`/`).

Example:  `zdb.default_elasticsearch_url = 'http://es.cluster.ip:9200/'`



```
zdb.default_replicas

Type: integer
Default: 0
```

Defines the number of replicas all new indices should have.  Changing this value does not propogate to existing indices.


## Session-level "GUC" settings

The below settings may be set in `postgresql.conf`, but they can also be changed per session/transaction using Postgres `SET key TO value` command;



```
zdb.batch_mode

Type: boolean
Default: false
```

When sychronizing changes from COPY/INSERT/UPDATE/DELETE statements to Elasticsearch, ZomboDB does so at the end of each *statement*.  For long-running transactions that modify lots of individual rows, it may make sense to turn `zdb.batch_mode` to on.  This indicates that ZDB should batch Elasticsearch index synchronization changes until the transaction `COMMIT`s.  This can significantly improve performance in these kinds of situations.

Note that if `zdb.batch_mode` is on, ZomboDB queries won't see the index changes until after the controlling transaction commits.




```
zdb.default_row_estimate

Type: integer
Default: 2500
Range: [-1, INT_MAX]
```

ZomboDB needs to provide Postgres with an estimate of the number of rows Elasticsearch will return for any given query.  2500 is a sensible default estimate that generally convinces Postgres to use an IndexScan plan.  Setting this to `-1` will cause ZomboDB to execute an Elasticsearch `_count` request for every query to return the exact number.



```
zdb.ignore_visibility

Type: boolean
Default: false
```

ZomboDB applies MVCC visibility rules to all queries and aggregate functions.  Setting this to true instructs ZomboDB to **not** do that, which means aggregate functions (such as `zdb.terms()`) will see dead rows, aborted rows, and in-flight rows.  Generally, this should only be used for debugging.



```
zdb.curl_verbose

Type: boolean
Default: false
```

ZomboDB uses libcurl to communicate with Elasticsearch.  Turning this on puts libcurl into debug mode and its debugging output goes to the Postgres log.



```
zdb.log_level

Type: enum
Default: DEBUG1
Possible Values: DEBUG2, DEBUG5, DEBUG4, DEBUG3, DEBUG2, DEBUG1, INFO, NOTICE, WARNING, LOG
```

The Postgres log level ZomboDB sends all of its (non-vacuum) log messages.


