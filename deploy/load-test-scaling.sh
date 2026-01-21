#!/bin/bash
set -e

NAMESPACE="demo-ns"
LOAD_TEST_IMAGE="busybox:latest"

echo "=== Effective Load Test Script ==="
echo

# 1. Check current status
echo "1. Current Status:"
kubectl get hpa -n $NAMESPACE metrics-app-hpa
echo

# 2. Create a dedicated load test Pod
echo "2. Creating load test Pod..."
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: load-test-pod
  namespace: $NAMESPACE
spec:
  securityContext:
    seccompProfile:
      type: RuntimeDefault
    runAsNonRoot: true
    runAsUser: 1000
    runAsGroup: 1000
  containers:
  - name: load-test
    image: $LOAD_TEST_IMAGE
    securityContext:
      allowPrivilegeEscalation: false
      capabilities:
        drop:
        - ALL
      seccompProfile:
        type: RuntimeDefault
    command: ["/bin/sh"]
    args:
    - -c
    - |
      # Install wget (busybox comes with it)
      echo "Starting high-intensity load test..."
      echo "Target: Reach 50+ RPS"

      # Use more efficient request method
      # Create request script
      cat > /tmp/load.sh <<'SCRIPT'
      #!/bin/sh
      URL="http://metrics-app.demo-ns.svc.cluster.local:8080/"
      while true; do
        # Use wget with timeout
        wget -q -T 5 -O /dev/null \$URL &
        # Send continuously, don't wait
        sleep 0.01
      done
      SCRIPT

      chmod +x /tmp/load.sh

      # Start 20 parallel processes to send requests
      echo "Starting 20 concurrent request processes..."
      for i in \$(seq 1 20); do
        /tmp/load.sh &
      done

      # Run for 5 minutes
      sleep 300

      # Cleanup
      killall wget 2>/dev/null || true
      echo "Load test completed"
    resources:
      requests:
        memory: "128Mi"
        cpu: "500m"
      limits:
        memory: "256Mi"
        cpu: "1000m"
  restartPolicy: Never
EOF

# 3. Wait for load test Pod to start
echo "3. Waiting for load test Pod to start..."
sleep 10
kubectl wait --for=condition=Ready pod/load-test-pod -n $NAMESPACE --timeout=30s

# 4. Monitor HPA changes
echo "4. Monitoring HPA changes (5 minutes)..."
echo "Timestamp | Desired Replicas | Current Replicas | Current Metric | Status"
echo "-----------------------------------------------------------------------"

for i in {1..30}; do
  TIMESTAMP=$(date '+%H:%M:%S')

  # Get HPA status
  HPA_OUTPUT=$(kubectl get hpa -n $NAMESPACE metrics-app-hpa -o json 2>/dev/null || echo '{}')

  if echo "$HPA_OUTPUT" | grep -q '"status"'; then
    DESIRED=$(echo "$HPA_OUTPUT" | jq -r '.status.desiredReplicas // 0')
    CURRENT=$(echo "$HPA_OUTPUT" | jq -r '.status.currentReplicas // 0')

    # Get current metric
    METRIC_VALUE=$(kubectl get --raw "/apis/custom.metrics.k8s.io/v1beta1/namespaces/$NAMESPACE/pods/*/http_requests_per_second" 2>/dev/null | \
      jq -r '[.items[].value | sub("m$"; "") | tonumber] | if length > 0 then add / length else 0 end' 2>/dev/null || echo "0")

    CURRENT_METRIC_RPS=$(echo "scale=2; $METRIC_VALUE / 1000" | bc 2>/dev/null || echo "0")

    if [ "$DESIRED" -gt "$CURRENT" ]; then
      STATUS="⬆️ Scaling Up"
    elif [ "$DESIRED" -lt "$CURRENT" ]; then
      STATUS="⬇️ Scaling Down"
    else
      STATUS="⏸️ Stable"
    fi

    printf "%-8s | %-15s | %-15s | %-14s | %s\n" \
      "$TIMESTAMP" \
      "$DESIRED" \
      "$CURRENT" \
      "$CURRENT_METRIC_RPS" \
      "$STATUS"
  else
    echo "$TIMESTAMP | Error | Failed to get HPA status | N/A | ❌"
  fi

  sleep 10
done

# 5. Cleanup
echo -e "\n5. Cleaning up load test Pod..."
kubectl delete pod load-test-pod -n $NAMESPACE --force --grace-period=0 2>/dev/null || true

echo -e "\nFinal Status:"
kubectl get hpa -n $NAMESPACE metrics-app-hpa
