<#include "tags.ftl">
<#assign itemCode = mappedMCItemToItemStackCode(input$a)>
<#if input$b?is_string && input$b?starts_with('"') && input$b?ends_with('"')>
<#assign oreName = tagNameToOreDictionary(input$b?replace('"', ''))>
(OreDictionary.containsMatch(true, OreDictionary.getOres("${oreName}"), ${itemCode}))
<#else>
(OreDictionary.containsMatch(true, OreDictionary.getOres(((( ${input$b}) + "").replace("mod:", "${modid}:").replace(':', '_').replace('/', '_').replace('-', '_').replace('.', '_').toLowerCase())), ${itemCode}))
</#if>