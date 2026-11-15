<#if input$tag?is_string && input$tag?replace('"', '') == "minecraft:is_fire">
(${input$damagesource}.isFireDamage())
<#else>
(false)
</#if>
