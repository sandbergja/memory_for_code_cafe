# Troubleshooting memory

I had code that worked fine locally, but got killed on the prod server due to high memory usage

## Triage

To confirm that we have the right idea about what is causing the trouble:

`free -h`

`watch free -h`

## Memory Profiler gem

Easiest way to add:
```
bundle add memory_profiler
require 'memory_profiler'
MemoryProfiler.start
MemoryProfiler.stop.pretty_print
```

Helpful to pipe to less

Note that it does have a memory impact

Helpful areas:
* Allocated memory by location
* Retained memory by location
* String reports

### When you find a bottleneck in allocated memory by location

* Do I need to allocate this in the first place?
* How long do I hang on to it?  Do I need to hang on to it for that long?

## Larger scale memory profiling

rack_mini_profiler also gives you access to the memory_profiler!  For use in a rails app:
`bundle add memory_profiler rack_mini_profiler`, then add ?pp=profile-memory to the URL you want to check