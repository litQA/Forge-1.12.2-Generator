<#if field$damagetype?starts_with("CUSTOM:")>
(new net.minecraft.util.EntityDamageSource(${package}.damage.${field$damagetype?remove_beginning("CUSTOM:")}.DAMAGE_SOURCE.getDamageType(), ${input$cause}))
<#else>
(new net.minecraft.util.EntityDamageSource(${generator.map(field$damagetype, "damagesources", 1)}, ${input$cause}))
</#if>
