<#include "tags.ftl">
<@addTemplate file="utils/random/item_random_from_tag.java.ftl"/>
<#if input$tag?is_string && input$tag?starts_with('"') && input$tag?ends_with('"')>
<#assign oreName = tagNameToOreDictionary(input$tag?replace('"', ''))>
(getRandomItem("${oreName}"))
<#else>
(getRandomItem((((${input$tag}) + "").replace("mod:", "${modid}:").replace(':', '_').replace('/', '_').replace('-', '_').replace('.', '_').toLowerCase())))
</#if>