<#--
  Resolves the creative tab used by an element.

  Forge 1.12.2 only supports a single creative tab per item, so the first tab of a
  multi-tab selection is used. This degradation is documented in MIGRATION-REPORT.md.
-->
<#function creativeTabValue tabs>
    <#if !tabs?has_content>
        <#return "null">
    </#if>

    <#assign tab = tabs?first>
    <#assign raw = tab.getUnmappedValue()>

    <#if !raw?has_content || raw == "No creative tab entry">
        <#return "null">
    <#elseif raw?starts_with("CUSTOM:")>
        <#return package + ".init." + JavaModName + "Tabs.TAB_" + generator.getRegistryNameFromFullName(raw)?upper_case>
    <#else>
        <#return generator.map(raw, "tabs")>
    </#if>
</#function>
