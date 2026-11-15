<#if field$damagetype?starts_with("CUSTOM:")>
(${package}.damage.${field$damagetype?remove_beginning("CUSTOM:")}.DAMAGE_SOURCE)
<#else>
(${generator.map(field$damagetype, "damagesources")})
</#if>
