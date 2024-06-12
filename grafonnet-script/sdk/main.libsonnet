local g = import 'g.libsonnet';

local row = g.panel.row;

local panels = import './panels.libsonnet';
local variables = import './variables.libsonnet';
local queries = import './queries.libsonnet';

g.dashboard.new('Temporal SDK (Java)')
+ g.dashboard.withDescription(|||
  Temporal SDK (Java)
|||)
+ g.dashboard.graphTooltip.withSharedCrosshair()
+ g.dashboard.time.withFrom('now-1h')
+ g.dashboard.withVariables([
  variables.datasource,
  variables.namespace,
])
+ g.dashboard.withPanels(
  g.util.grid.makeGrid([
    row.new('Requests')
    + row.withPanels([
      panels.timeSeries.short('Requests Vs Failures', queries.request_vs_failures),
      panels.timeSeries.short('Requests per operation', queries.request_per_operation),
      panels.timeSeries.short('Failures per operation', queries.failures_per_operation),
      panels.timeSeries.seconds('RPC Latencies', queries.rpc_latencies),
    ]),
    row.new('Workflow')
    + row.withPanels([
      panels.timeSeries.short('Workflow Completion', queries.workflow_completed),
      panels.timeSeries.seconds('Workflow End-To-End Latencies', queries.workflow_type_latencies),
      panels.timeSeries.short('Workflow Success By Type', queries.workflow_completed_by_type),
      panels.timeSeries.short('Workflow Failures By Type', queries.workflow_failed_by_type),
    ]),
  ], panelWidth=12),
)
