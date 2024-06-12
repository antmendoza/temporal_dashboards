local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;

local variables = import './variables.libsonnet';

{
  request_vs_failures: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum(rate(temporal_request_total{namespace=~"$namespace"}[$__rate_interval])) by (namespace)
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      request - {{namespace}}
    |||),
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum(rate(temporal_request_failure_total{namespace=~"$namespace"}[$__rate_interval])) by (namespace)
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      failure - {{namespace}}
    |||),
  ],
  request_per_operation: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum(rate(temporal_request_total{namespace=~"$namespace"}[$__rate_interval])) by (operation)
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{operation}}
    |||),
  ],
  failures_per_operation: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum(rate(temporal_request_failure_total{namespace=~"$namespace"}[$__rate_interval])) by (operation)
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{operation}}
    |||),
  ],
  rpc_latencies: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        histogram_quantile(0.95, sum by (namespace, operation, le) (rate(temporal_request_latency_seconds_bucket{namespace=~"$namespace"}[5$__rate_interval])))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{ namespace }} - {{ operation }}
    |||),
  ],

  //workflow queries
  workflow_completed: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum by (namespace) (rate(temporal_workflow_completed_total{namespace=~"$namespace"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
            {{namespace}}
    |||),
  ],
  workflow_completed_by_type: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum by (namespace, workflow_type) (rate(temporal_workflow_completed_total{namespace=~"$namespace"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{namespace}} - {{workflow_type}}
    |||),
  ],
  workflow_failed_by_type: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum by (namespace, workflow_type) (rate(temporal_workflow_task_execution_failed_total{namespace=~"$namespace"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{namespace}} - {{workflow_type}}
    |||),
  ],
  workflow_type_latencies: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        histogram_quantile(0.95, sum by (namespace, workflow_type, le) (rate(temporal_workflow_endtoend_latency_seconds_bucket{namespace=~"$namespace"}[5$__rate_interval])))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{ namespace }} - {{ workflow_type }}
    |||),
  ],


}
