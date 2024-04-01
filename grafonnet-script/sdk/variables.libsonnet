local g = import './g.libsonnet';
local var = g.dashboard.variable;

{
  datasource:
    var.datasource.new('datasource', 'prometheus'),

  namespace:
      var.query.new('namespace')
      + var.query.withDatasourceFromVariable(self.datasource)
      + var.query.queryTypes.withLabelValues(
        'namespace',
      )
      + var.query.withRefresh(2)
      + var.query.selectionOptions.withMulti()
      + var.query.selectionOptions.withIncludeAll(),


}
