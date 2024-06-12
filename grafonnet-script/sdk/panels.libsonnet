local g = import 'g.libsonnet';

{
  timeSeries: {
    local timeSeries = g.panel.timeSeries,
    local custom = timeSeries.fieldConfig.defaults.custom,
    local options = timeSeries.options,

    base(title, targets):
      timeSeries.new(title)
      + timeSeries.queryOptions.withTargets(targets)
      + timeSeries.queryOptions.withInterval('5s')
      + options.legend.withDisplayMode('table')
      + options.legend.withCalcs([
        'lastNotNull',
        'max',
      ])
      + custom.withFillOpacity(10)
      + custom.withShowPoints('never'),

    short(title, targets):
      self.base(title, targets)
      + timeSeries.standardOptions.withUnit('short')
      + timeSeries.standardOptions.withDecimals(0),

    seconds(title, targets):
      self.base(title, targets)
      + timeSeries.standardOptions.withUnit('s')
      + timeSeries.standardOptions.withDecimals(0)
  },

}