{
    "variants": {
<#list 0..15 as level>
        "level=${level}": { "model": "${modid}:${registryname}" }<#if level?has_next>,</#if>
</#list>
    }
}
