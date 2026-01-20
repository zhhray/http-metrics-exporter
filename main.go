package main

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

// Define Prometheus metrics
var (
	httpRequestTotal = promauto.NewCounterVec(
		prometheus.CounterOpts{
			Name: "http_requests_total",
			Help: "Total number of HTTP requests",
		},
		[]string{"method", "path", "status"},
	)

	httpRequestDuration = promauto.NewHistogramVec(
		prometheus.HistogramOpts{
			Name:    "http_request_duration_seconds",
			Help:    "HTTP request duration in seconds",
			Buckets: []float64{0.05, 0.1, 0.25, 0.5, 1, 2.5, 5},
		},
		[]string{"method", "path"},
	)

	httpRequestsInFlight = promauto.NewGauge(
		prometheus.GaugeOpts{
			Name: "http_requests_in_flight",
			Help: "Current number of HTTP requests in flight",
		},
	)
)

// Wrap handler to collect metrics
func withMetrics(next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()

		rw := &responseWriter{ResponseWriter: w, statusCode: http.StatusOK}

		httpRequestsInFlight.Inc()
		defer httpRequestsInFlight.Dec()

		next(rw, r)

		duration := time.Since(start).Seconds()
		httpRequestDuration.WithLabelValues(r.Method, r.URL.Path).Observe(duration)

		httpRequestTotal.WithLabelValues(r.Method, r.URL.Path, fmt.Sprintf("%d", rw.statusCode)).Inc()
	}
}

// responseWriter wraps http.ResponseWriter to capture the status code
type responseWriter struct {
	http.ResponseWriter
	statusCode int
}

func (rw *responseWriter) WriteHeader(code int) {
	rw.statusCode = code
	rw.ResponseWriter.WriteHeader(code)
}

// Main handler function
func mainHandler(w http.ResponseWriter, r *http.Request) {
	time.Sleep(time.Duration(100+time.Now().UnixNano()%400) * time.Millisecond)

	message := fmt.Sprintf("Hello! Current time: %s\n", time.Now().Format(time.RFC3339))
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(message))
}

// Health check handler
func healthHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("OK"))
}

func main() {
	// Register routes
	http.HandleFunc("/", withMetrics(mainHandler))
	http.HandleFunc("/health", withMetrics(healthHandler))
	http.Handle("/metrics", promhttp.Handler())

	// Start server
	port := ":8080"
	log.Printf("Starting server on %s", port)
	log.Println("Available endpoints:")
	log.Println("  GET / - Main endpoint")
	log.Println("  GET /health - Health check")
	log.Println("  GET /metrics - Prometheus metrics")

	if err := http.ListenAndServe(port, nil); err != nil {
		log.Fatal(err)
	}
}
