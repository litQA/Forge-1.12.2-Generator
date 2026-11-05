<#-- @formatter:off -->
<#--
  Central failure point for features that cannot be represented with the Forge
  1.12.2 API. Failing generation is intentional: silently emitting missing or
  invalid code is not allowed.
-->
<#stop "Forge 1.12.2 generator: " + (var_feature!"this feature") + " is not supported yet. See MIGRATION-REPORT.md for the current support matrix.">
<#-- @formatter:on -->
