Cool Komodo
---

Set of scripts for load testing MindMatch stack

### Testing the mather_api endpoint

```shell
wrk --latency --script matcher_api.lua http://localhost:8000
```

or a bit more customized

```shell
wrk --connections 4 --duration 1m --timeout 2s --latency --script matcher_api.lua http://localhost:8000
```

### Testing the core api endpoint

```shell
wrk --connections 4 --duration 1m --timeout 2s --latency --script mindmatch.lua http://localhost:5000
```

### Tooling

* [*wkr*](https://github.com/wg/wrk)
* [Lua programming language](https://www.lua.org)

