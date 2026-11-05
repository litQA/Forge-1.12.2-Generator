{
    "variants": {
<#list ["sunflower", "syringa", "double_grass", "double_fern", "double_rose", "paeonia"] as variant>
<#list ["east", "west", "south", "north"] as facing>
<#list ["lower", "upper"] as half>
        "facing=${facing},half=${half},variant=${variant}": { "model": "${modid}:${registryname}_<#if half == "lower">bottom<#else>top</#if>"<#if facing == "west">, "y": 180<#elseif facing == "south">, "y": 90<#elseif facing == "north">, "y": 270</#if> }<#if half?is_last && facing?is_last && variant?is_last><#else>,</#if>
</#list>
</#list>
</#list>
    }
}
