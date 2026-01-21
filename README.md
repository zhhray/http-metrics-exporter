# http-metrics-expoter

# Quick start

## Build binary
```bash
make build-linux
```

## Build docker image
```bash
make docker-build
```

## Local Test
```bash
# Start container
docker run -d \
  --name metrics-test \
  -p 8080:8080 \
  http-metrics-exporter:v1.0.0

# Check logs
docker logs metrics-test

# Check metrics
curl http://localhost:8080/metrics

# Output:

# HELP go_gc_duration_seconds A summary of the pause duration of garbage collection cycles.
# TYPE go_gc_duration_seconds summary
go_gc_duration_seconds{quantile="0"} 0
go_gc_duration_seconds{quantile="0.25"} 0
go_gc_duration_seconds{quantile="0.5"} 0
go_gc_duration_seconds{quantile="0.75"} 0
go_gc_duration_seconds{quantile="1"} 0
go_gc_duration_seconds_sum 0
go_gc_duration_seconds_count 0
# HELP go_goroutines Number of goroutines that currently exist.
# TYPE go_goroutines gauge
go_goroutines 6
# HELP go_info Information about the Go environment.
# TYPE go_info gauge
go_info{version="go1.25.5"} 1
# HELP go_memstats_alloc_bytes Number of bytes allocated and still in use.
# TYPE go_memstats_alloc_bytes gauge
go_memstats_alloc_bytes 137984
# HELP go_memstats_alloc_bytes_total Total number of bytes allocated, even if freed.
# TYPE go_memstats_alloc_bytes_total counter
go_memstats_alloc_bytes_total 137984
# HELP go_memstats_buck_hash_sys_bytes Number of bytes used by the profiling bucket hash table.
# TYPE go_memstats_buck_hash_sys_bytes gauge
go_memstats_buck_hash_sys_bytes 1.443887e+06
# HELP go_memstats_frees_total Total number of frees.
# TYPE go_memstats_frees_total counter
go_memstats_frees_total 0
# HELP go_memstats_gc_sys_bytes Number of bytes used for garbage collection system metadata.
# TYPE go_memstats_gc_sys_bytes gauge
go_memstats_gc_sys_bytes 1.40264e+06
# HELP go_memstats_heap_alloc_bytes Number of heap bytes allocated and still in use.
# TYPE go_memstats_heap_alloc_bytes gauge
go_memstats_heap_alloc_bytes 137984
# HELP go_memstats_heap_idle_bytes Number of heap bytes waiting to be used.
# TYPE go_memstats_heap_idle_bytes gauge
go_memstats_heap_idle_bytes 2.58048e+06
# HELP go_memstats_heap_inuse_bytes Number of heap bytes that are in use.
# TYPE go_memstats_heap_inuse_bytes gauge
go_memstats_heap_inuse_bytes 1.220608e+06
# HELP go_memstats_heap_objects Number of allocated objects.
# TYPE go_memstats_heap_objects gauge
go_memstats_heap_objects 454
# HELP go_memstats_heap_released_bytes Number of heap bytes released to OS.
# TYPE go_memstats_heap_released_bytes gauge
go_memstats_heap_released_bytes 2.58048e+06
# HELP go_memstats_heap_sys_bytes Number of heap bytes obtained from system.
# TYPE go_memstats_heap_sys_bytes gauge
go_memstats_heap_sys_bytes 3.801088e+06
# HELP go_memstats_last_gc_time_seconds Number of seconds since 1970 of last garbage collection.
# TYPE go_memstats_last_gc_time_seconds gauge
go_memstats_last_gc_time_seconds 0
# HELP go_memstats_lookups_total Total number of pointer lookups.
# TYPE go_memstats_lookups_total counter
go_memstats_lookups_total 0
# HELP go_memstats_mallocs_total Total number of mallocs.
# TYPE go_memstats_mallocs_total counter
go_memstats_mallocs_total 454
# HELP go_memstats_mcache_inuse_bytes Number of bytes in use by mcache structures.
# TYPE go_memstats_mcache_inuse_bytes gauge
go_memstats_mcache_inuse_bytes 4832
# HELP go_memstats_mcache_sys_bytes Number of bytes used for mcache structures obtained from system.
# TYPE go_memstats_mcache_sys_bytes gauge
go_memstats_mcache_sys_bytes 15704
# HELP go_memstats_mspan_inuse_bytes Number of bytes in use by mspan structures.
# TYPE go_memstats_mspan_inuse_bytes gauge
go_memstats_mspan_inuse_bytes 33280
# HELP go_memstats_mspan_sys_bytes Number of bytes used for mspan structures obtained from system.
# TYPE go_memstats_mspan_sys_bytes gauge
go_memstats_mspan_sys_bytes 48960
# HELP go_memstats_next_gc_bytes Number of heap bytes when next garbage collection will take place.
# TYPE go_memstats_next_gc_bytes gauge
go_memstats_next_gc_bytes 4.194304e+06
# HELP go_memstats_other_sys_bytes Number of bytes used for other system allocations.
# TYPE go_memstats_other_sys_bytes gauge
go_memstats_other_sys_bytes 716081
# HELP go_memstats_stack_inuse_bytes Number of bytes in use by the stack allocator.
# TYPE go_memstats_stack_inuse_bytes gauge
go_memstats_stack_inuse_bytes 393216
# HELP go_memstats_stack_sys_bytes Number of bytes obtained from system for stack allocator.
# TYPE go_memstats_stack_sys_bytes gauge
go_memstats_stack_sys_bytes 393216
# HELP go_memstats_sys_bytes Number of bytes obtained from system.
# TYPE go_memstats_sys_bytes gauge
go_memstats_sys_bytes 7.821576e+06
# HELP go_threads Number of OS threads created.
# TYPE go_threads gauge
go_threads 6
# HELP http_requests_in_flight Current number of HTTP requests in flight
# TYPE http_requests_in_flight gauge
http_requests_in_flight 0
# HELP process_cpu_seconds_total Total user and system CPU time spent in seconds.
# TYPE process_cpu_seconds_total counter
process_cpu_seconds_total 0.06
# HELP process_max_fds Maximum number of open file descriptors.
# TYPE process_max_fds gauge
process_max_fds 1.048576e+06
# HELP process_open_fds Number of open file descriptors.
# TYPE process_open_fds gauge
process_open_fds 8
# HELP process_resident_memory_bytes Resident memory size in bytes.
# TYPE process_resident_memory_bytes gauge
process_resident_memory_bytes 7.831552e+06
# HELP process_start_time_seconds Start time of the process since unix epoch in seconds.
# TYPE process_start_time_seconds gauge
process_start_time_seconds 1.76883925285e+09
# HELP process_virtual_memory_bytes Virtual memory size in bytes.
# TYPE process_virtual_memory_bytes gauge
process_virtual_memory_bytes 1.263263744e+09
# HELP process_virtual_memory_max_bytes Maximum amount of virtual memory available in bytes.
# TYPE process_virtual_memory_max_bytes gauge
process_virtual_memory_max_bytes 1.8446744073709552e+19
# HELP promhttp_metric_handler_requests_in_flight Current number of scrapes being served.
# TYPE promhttp_metric_handler_requests_in_flight gauge
promhttp_metric_handler_requests_in_flight 1
# HELP promhttp_metric_handler_requests_total Total number of scrapes by HTTP status code.
# TYPE promhttp_metric_handler_requests_total counter
promhttp_metric_handler_requests_total{code="200"} 0
promhttp_metric_handler_requests_total{code="500"} 0
promhttp_metric_handler_requests_total{code="503"} 0
```

## Check metrics
```bash
# Test Health Check Endpoint
echo -e "\n=== Testing Health Check Endpoint ==="
curl -f http://localhost:8080/health
if [ $? -eq 0 ]; then
echo "✓ Health check passed"
else
echo "✗ Health check failed"
fi

# Test Main Endpoint
echo -e "\n=== Testing Main Endpoint ==="
curl http://localhost:8080/

# Test Prometheus Metrics Endpoint
echo -e "\n=== Testing Prometheus Metrics Endpoint ==="
curl -s http://localhost:8080/metrics | head -20

# Test Multiple Requests to Generate Metrics
echo -e "\n=== Generating Request Metrics ==="
for i in {1..5}; do
curl -s http://localhost:8080/ > /dev/null
echo "Request $i completed"
sleep 0.5
done

# Check Generated Metrics Data
echo -e "\n=== Checking Generated Metrics ==="
curl -s http://localhost:8080/metrics | grep -E "http_requests_total|http_request_duration_seconds|http_requests_in_flight"
# Output:
# HELP http_request_duration_seconds HTTP request duration in seconds
# TYPE http_request_duration_seconds histogram
http_request_duration_seconds_bucket{method="GET",path="/",le="0.05"} 0
http_request_duration_seconds_bucket{method="GET",path="/",le="0.1"} 0
http_request_duration_seconds_bucket{method="GET",path="/",le="0.25"} 2
http_request_duration_seconds_bucket{method="GET",path="/",le="0.5"} 6
http_request_duration_seconds_bucket{method="GET",path="/",le="1"} 6
http_request_duration_seconds_bucket{method="GET",path="/",le="2.5"} 6
http_request_duration_seconds_bucket{method="GET",path="/",le="5"} 6
http_request_duration_seconds_bucket{method="GET",path="/",le="+Inf"} 6
http_request_duration_seconds_sum{method="GET",path="/"} 1.822652
http_request_duration_seconds_count{method="GET",path="/"} 6
# HELP http_requests_in_flight Current number of HTTP requests in flight
# TYPE http_requests_in_flight gauge
http_requests_in_flight 0
# HELP http_requests_total Total number of HTTP requests
# TYPE http_requests_total counter
http_requests_total{method="GET",path="/",status="200"} 6

# Check Container Processes
echo -e "\n=== Container Processes ==="
docker top metrics-test

# Check Container Resource Usage
echo -e "\n=== Container Resource Usage ==="
docker stats metrics-test --no-stream
```

## Deploy to Kubernetes
```bash
kubectl apply -f deploy/resources.yaml
kubectl apply -f deploy/servicemonitor.yaml

# Add following content to cpaas-system/cpaas-monitor-prometheus-adapter configmap:
      # HTTP 请求速率规则
      - seriesQuery: 'http_requests_total{namespace!="",pod!=""}'
        seriesFilters: []
        resources:
          overrides:
            namespace: {resource: "namespace"}
            pod: {resource: "pod"}
        name:
          matches: "http_requests_total"
          as: "http_requests_per_second"
        metricsQuery: 'sum(rate(<<.Series>>{<<.LabelMatchers>>}[2m])) by (<<.GroupBy>>)'

# Delete prometheus-adapter pod to reload config
kubectl delete pod -n cpaas-system $(kubectl get pod -n cpaas-system | grep prometheus-adapter | awk '{print $1}')

# Check metrics
kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1/namespaces/demo-ns/pods/*/http_requests_per_second" | jq .
{
  "kind": "MetricValueList",
  "apiVersion": "custom.metrics.k8s.io/v1beta1",
  "metadata": {},
  "items": [
    {
      "describedObject": {
        "kind": "Pod",
        "namespace": "demo-ns",
        "name": "metrics-app-79d749bbd-bvdw7",
        "apiVersion": "/v1"
      },
      "metricName": "http_requests_per_second",
      "timestamp": "2026-01-20T10:27:46Z",
      "value": "295m",
      "selector": null
    },
    {
      "describedObject": {
        "kind": "Pod",
        "namespace": "demo-ns",
        "name": "metrics-app-79d749bbd-j8vkd",
        "apiVersion": "/v1"
      },
      "metricName": "http_requests_per_second",
      "timestamp": "2026-01-20T10:27:46Z",
      "value": "304m",
      "selector": null
    }
  ]
}

# Apply hpa
kubectl apply -f deploy/hpa.yaml
```

## Check hpa and scaling test
```bash
kubectl get hpa -n demo-ns
# scp deploy/load-test-scaling.sh to the master node of k8s cluster which the metrics-app is running
chmod +x load-test-scaling.sh
./load-test-scaling.sh
# you can see the result of load-test-scaling.sh:
=== Effective Load Test Script ===
1. Current Status:
NAME              REFERENCE                TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
metrics-app-hpa   Deployment/metrics-app   295m/5    1         10        1          17h

2. Creating load test Pod...
pod/load-test-pod created
3. Waiting for load test Pod to start...
pod/load-test-pod condition met
4. Monitoring HPA changes (5 minutes)...
Timestamp | Desired Replicas | Current Replicas | Current Metric | Status
-----------------------------------------------------------------------
11:48:44 | 1               | 1               | .30            | ⏸️ Stable
11:48:55 | 1               | 1               | 39.38          | ⏸️ Stable
11:49:05 | 1               | 1               | 39.38          | ⏸️ Stable
11:49:15 | 3               | 1               | 97.19          | ⬆️ Scaling Up
11:49:26 | 3               | 1               | 151.96         | ⬆️ Scaling Up
11:49:36 | 3               | 3               | 151.96         | ⏸️ Stable
11:49:47 | 6               | 3               | 180.46         | ⬆️ Scaling Up
11:49:57 | 6               | 3               | 84.36          | ⬆️ Scaling Up
11:50:08 | 6               | 6               | 90.73          | ⏸️ Stable
11:50:18 | 10              | 6               | 61.33          | ⬆️ Scaling Up
11:50:29 | 10              | 6               | 58.10          | ⬆️ Scaling Up
11:50:39 | 10              | 10              | 56.58          | ⏸️ Stable
11:50:49 | 10              | 10              | 44.74          | ⏸️ Stable
11:51:00 | 10              | 10              | 34.19          | ⏸️ Stable
11:51:10 | 10              | 10              | 31.17          | ⏸️ Stable
11:51:20 | 10              | 10              | 33.69          | ⏸️ Stable
11:51:31 | 10              | 10              | 33.84          | ⏸️ Stable
11:51:41 | 10              | 10              | 31.80          | ⏸️ Stable
11:51:52 | 10              | 10              | 32.83          | ⏸️ Stable
11:52:02 | 10              | 10              | 32.26          | ⏸️ Stable
11:52:12 | 10              | 10              | 31.62          | ⏸️ Stable
11:52:23 | 10              | 10              | 31.94          | ⏸️ Stable
11:52:33 | 10              | 10              | 28.20          | ⏸️ Stable
11:52:44 | 10              | 10              | 27.83          | ⏸️ Stable
11:52:54 | 10              | 10              | 30.93          | ⏸️ Stable
11:53:05 | 10              | 10              | 30.47          | ⏸️ Stable
11:53:15 | 10              | 10              | 30.32          | ⏸️ Stable
11:53:25 | 10              | 10              | 29.80          | ⏸️ Stable
11:53:36 | 10              | 10              | 29.42          | ⏸️ Stable
11:53:46 | 10              | 10              | 28.87          | ⏸️ Stable

5. Cleaning up load test Pod...
pod "load-test-pod" force deleted

Final Status:
NAME              REFERENCE                TARGETS    MINPODS   MAXPODS   REPLICAS   AGE
metrics-app-hpa   Deployment/metrics-app   29217m/5   1         10        10         17h
```
