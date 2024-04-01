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

}
