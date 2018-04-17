Cool Komodo
---

Set of scripts for benchmarking/load testing MindMatch stack

### Tooling

* *wkr*
* Lua programming language

### Testing the mather_api endpoint

```shell
wrk --latency --script matcher_api.lua http://localhost:8000
```
