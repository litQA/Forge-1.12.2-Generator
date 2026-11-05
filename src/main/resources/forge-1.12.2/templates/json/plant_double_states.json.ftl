{
    "variants": {
<#list ["east", "west", "south", "north"] as facing>
<#list ["lower", "upper"] as half>
        "facing=${facing},half=${half},variant=sunflower": { "model": "${modid}:${registryname}_<#if half == 'lower'>bottom<#else>top</#if>"<#if facing == 'west'>, "y": 180<#elseif facing == 'south'>, "y": 90<#elseif facing == 'north'>, "y": 270</#if> }<#sep>,
</#list>
</#list>
    }
}
