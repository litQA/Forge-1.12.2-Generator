<#include "mcitems.ftl">
<#include "tags.ftl">
<#assign block = mappedBlockToBlock(input$a)>
<#if input$b?is_string && input$b?starts_with('"') && input$b?ends_with('"')>
    <#assign oreName = tagNameToOreDictionary(input$b?replace('"', ''))>
(isBlockInOreDictionary("${oreName}", ${block}))
<#else>
(isBlockInOreDictionary((((${input$b}) + "").replace(':', '_').replace('/', '_').replace('-', '_').replace('.', '_').toLowerCase()), ${block}))
</#if>
