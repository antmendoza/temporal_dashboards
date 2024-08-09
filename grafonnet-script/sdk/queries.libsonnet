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
        histogram_quantile(0.95, sum by (namespace, operation, le) (rate(temporal_request_latency_seconds_bucket{namespace=~"$namespace"}[$__rate_interval])))
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
        histogram_quantile(0.95, sum by (namespace, workflow_type, le) (rate(temporal_workflow_endtoend_latency_seconds_bucket{namespace=~"$namespace"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{ namespace }} - {{ workflow_type }}
    |||),
  ],


  //workflow task
  workflow_task_by_workflow_type: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum by (workflow_type) (rate(temporal_workflow_task_queue_poll_succeed_total{namespace=~"$namespace"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{workflow_type}}
    |||),
  ],

  workflow_task_by_namespace: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum by (namespace) (rate(temporal_workflow_task_queue_poll_succeed_total{namespace=~"$namespace"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{namespace}}
    |||),
  ],


  workflow_task_schedule_to_start_workflow_type: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        histogram_quantile(0.95, sum by (workflow_type,  le) (rate(temporal_workflow_task_schedule_to_start_latency_seconds_bucket{namespace=~"$namespace"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{workflow_type}}
    |||),
  ],


  workflow_task_schedule_to_start_namespace: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        histogram_quantile(0.95, sum by (namespace,  le) (rate(temporal_workflow_task_schedule_to_start_latency_seconds_bucket{namespace=~"$namespace"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{namespace}}
    |||),
  ],





  workflow_task_failed_workflow_type: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum by (workflow_type) (rate(temporal_workflow_task_execution_failed_total{namespace=~"$namespace"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{workflow_type}}
    |||),
  ],

  workflow_task_failed_namespace: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum by (namespace) (rate(temporal_workflow_task_execution_failed_total{namespace=~"$namespace"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{namespace}}
    |||),
  ],



  workflow_task_execution_latency_workflow_type: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        histogram_quantile(0.95, sum by (workflow_type,  le) (rate(temporal_workflow_task_execution_latency_seconds_bucket{namespace=~"$namespace"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{workflow_type}}
    |||),
  ],

  workflow_task_execution_latency_namespace: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        histogram_quantile(0.95, sum by (namespace,  le) (rate(temporal_workflow_task_execution_latency_seconds_bucket{namespace=~"$namespace"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{namespace}}
    |||),
  ],



  workflow_task_replay_latency_workflow_type: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        histogram_quantile(0.95, sum by (workflow_type,  le) (rate(temporal_workflow_task_replay_latency_seconds_bucket{namespace=~"$namespace"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{workflow_type}}
    |||),
  ],

  workflow_task_replay_latency_namespace: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        histogram_quantile(0.95, sum by (namespace,  le) (rate(temporal_workflow_task_replay_latency_seconds_bucket{namespace=~"$namespace"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{namespace}}
    |||),
  ],

  empty_polls: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum by (namespace) (rate(temporal_workflow_task_queue_poll_empty_total{namespace=~"$namespace"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      Empty Polls - {{namespace}}
    |||),
  ],

//activities

  activity_throughput: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum by (namespace, activity_type) (rate(temporal_activity_execution_latency_seconds_bucket{namespace=~"$namespace"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{namespace}} - {{activity_type}}
    |||),
  ],




  activity_failed: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        sum by (namespace, activity_type) (rate(temporal_activity_execution_failed_total{namespace=~"$namespace"}[$__rate_interval]))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{namespace}} - {{activity_type}}
    |||),
  ],


  activity_executin_latency: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        histogram_quantile(0.95, sum by (namespace, activity_type , le) (rate(temporal_activity_execution_latency_seconds_bucket{namespace=~"$namespace"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{namespace}} - {{activity_type}}
    |||),
  ],


  activity_schedule_to_start_latency: [
    prometheusQuery.new(
      '$' + variables.datasource.name,
      |||
        histogram_quantile(0.95, sum by (namespace, activity_type , le) (rate(temporal_activity_schedule_to_start_latency_seconds_bucket{namespace=~"$namespace"}[$__rate_interval])))
      |||
    )
    + prometheusQuery.withIntervalFactor(2)
    + prometheusQuery.withLegendFormat(|||
      {{namespace}} - {{activity_type}}
    |||),
  ],




}
