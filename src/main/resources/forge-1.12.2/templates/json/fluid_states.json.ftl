{
    "forge_marker": 1,
    "defaults": {
        "model": "forge:fluid"
    },
    "variants": {
<#list 0..15 as level>
        "level=${level}": [
            {
                "custom": {
                    "fluid": "${registryname}"
                }
            }
        ]<#if level?has_next>,</#if>
</#list>
    }
}
