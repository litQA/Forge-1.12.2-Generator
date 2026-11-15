<#if field$damagetype?starts_with("CUSTOM:")>
(${input$damagesource}.getDamageType().equals(${package}.damage.${field$damagetype?remove_beginning("CUSTOM:")}.DAMAGE_SOURCE.getDamageType()))
<#else>
(${input$damagesource}.getDamageType().equals(${generator.map(field$damagetype, "damagesources", 1)}))
</#if>
