<#-- @formatter:off -->
<#assign blockBase = data.blockBase!"">
<#if blockBase == "Fence">
{
    "multipart": [
        { "apply": { "model": "${modid}:${registryname}_post" } },
        { "when": { "north": "true" }, "apply": { "model": "${modid}:${registryname}", "uvlock": true } },
        { "when": { "south": "true" }, "apply": { "model": "${modid}:${registryname}", "y": 180, "uvlock": true } },
        { "when": { "west": "true" }, "apply": { "model": "${modid}:${registryname}", "y": 270, "uvlock": true } },
        { "when": { "east": "true" }, "apply": { "model": "${modid}:${registryname}", "y": 90, "uvlock": true } }
    ]
}
<#elseif blockBase == "Wall">
{
    "multipart": [
        { "when": { "up": "true" }, "apply": { "model": "${modid}:${registryname}_post" } },
        { "when": { "north": "true" }, "apply": { "model": "${modid}:${registryname}", "uvlock": true } },
        { "when": { "east": "true" }, "apply": { "model": "${modid}:${registryname}", "y": 90, "uvlock": true } },
        { "when": { "south": "true" }, "apply": { "model": "${modid}:${registryname}", "y": 180, "uvlock": true } },
        { "when": { "west": "true" }, "apply": { "model": "${modid}:${registryname}", "y": 270, "uvlock": true } }
    ]
}
<#else>
{
    "variants": {
    <#if blockBase == "Stairs">
        "facing=east,half=bottom,shape=straight": { "model": "${modid}:${registryname}" },
        "facing=west,half=bottom,shape=straight": { "model": "${modid}:${registryname}", "y": 180, "uvlock": true },
        "facing=south,half=bottom,shape=straight": { "model": "${modid}:${registryname}", "y": 90, "uvlock": true },
        "facing=north,half=bottom,shape=straight": { "model": "${modid}:${registryname}", "y": 270, "uvlock": true },
        "facing=east,half=bottom,shape=inner_right": { "model": "${modid}:${registryname}_inner" },
        "facing=west,half=bottom,shape=inner_right": { "model": "${modid}:${registryname}_inner", "y": 180, "uvlock": true },
        "facing=south,half=bottom,shape=inner_right": { "model": "${modid}:${registryname}_inner", "y": 90, "uvlock": true },
        "facing=north,half=bottom,shape=inner_right": { "model": "${modid}:${registryname}_inner", "y": 270, "uvlock": true },
        "facing=east,half=bottom,shape=inner_left": { "model": "${modid}:${registryname}_inner", "y": 270, "uvlock": true },
        "facing=west,half=bottom,shape=inner_left": { "model": "${modid}:${registryname}_inner", "y": 90, "uvlock": true },
        "facing=south,half=bottom,shape=inner_left": { "model": "${modid}:${registryname}_inner" },
        "facing=north,half=bottom,shape=inner_left": { "model": "${modid}:${registryname}_inner", "y": 180, "uvlock": true },
        "facing=east,half=top,shape=straight": { "model": "${modid}:${registryname}", "x": 180, "uvlock": true },
        "facing=west,half=top,shape=straight": { "model": "${modid}:${registryname}", "x": 180, "y": 180, "uvlock": true },
        "facing=south,half=top,shape=straight": { "model": "${modid}:${registryname}", "x": 180, "y": 90, "uvlock": true },
        "facing=north,half=top,shape=straight": { "model": "${modid}:${registryname}", "x": 180, "y": 270, "uvlock": true },
        "facing=east,half=top,shape=outer_right": { "model": "${modid}:${registryname}_outer", "x": 180, "y": 90, "uvlock": true },
        "facing=west,half=top,shape=outer_right": { "model": "${modid}:${registryname}_outer", "x": 180, "y": 270, "uvlock": true },
        "facing=south,half=top,shape=outer_right": { "model": "${modid}:${registryname}_outer", "x": 180, "y": 180, "uvlock": true },
        "facing=north,half=top,shape=outer_right": { "model": "${modid}:${registryname}_outer", "x": 180, "uvlock": true },
        "facing=east,half=top,shape=outer_left": { "model": "${modid}:${registryname}_outer", "x": 180, "uvlock": true },
        "facing=west,half=top,shape=outer_left": { "model": "${modid}:${registryname}_outer", "x": 180, "y": 180, "uvlock": true },
        "facing=south,half=top,shape=outer_left": { "model": "${modid}:${registryname}_outer", "x": 180, "y": 90, "uvlock": true },
        "facing=north,half=top,shape=outer_left": { "model": "${modid}:${registryname}_outer", "x": 180, "y": 270, "uvlock": true },
        "facing=east,half=top,shape=inner_right": { "model": "${modid}:${registryname}_inner", "x": 180, "y": 90, "uvlock": true },
        "facing=west,half=top,shape=inner_right": { "model": "${modid}:${registryname}_inner", "x": 180, "y": 270, "uvlock": true },
        "facing=south,half=top,shape=inner_right": { "model": "${modid}:${registryname}_inner", "x": 180, "y": 180, "uvlock": true },
        "facing=north,half=top,shape=inner_right": { "model": "${modid}:${registryname}_inner", "x": 180, "uvlock": true },
        "facing=east,half=top,shape=inner_left": { "model": "${modid}:${registryname}_inner", "x": 180, "uvlock": true },
        "facing=west,half=top,shape=inner_left": { "model": "${modid}:${registryname}_inner", "x": 180, "y": 180, "uvlock": true },
        "facing=south,half=top,shape=inner_left": { "model": "${modid}:${registryname}_inner", "x": 180, "y": 90, "uvlock": true },
        "facing=north,half=top,shape=inner_left": { "model": "${modid}:${registryname}_inner", "x": 180, "y": 270, "uvlock": true },
        "facing=east,half=bottom,shape=outer_right": { "model": "${modid}:${registryname}_outer" },
        "facing=west,half=bottom,shape=outer_right": { "model": "${modid}:${registryname}_outer", "y": 180, "uvlock": true },
        "facing=south,half=bottom,shape=outer_right": { "model": "${modid}:${registryname}_outer", "y": 90, "uvlock": true },
        "facing=north,half=bottom,shape=outer_right": { "model": "${modid}:${registryname}_outer", "y": 270, "uvlock": true },
        "facing=east,half=bottom,shape=outer_left": { "model": "${modid}:${registryname}_outer", "y": 270, "uvlock": true },
        "facing=west,half=bottom,shape=outer_left": { "model": "${modid}:${registryname}_outer", "y": 90, "uvlock": true },
        "facing=south,half=bottom,shape=outer_left": { "model": "${modid}:${registryname}_outer" },
        "facing=north,half=bottom,shape=outer_left": { "model": "${modid}:${registryname}_outer", "y": 180, "uvlock": true }
    <#elseif blockBase == "Slab">
        "half=bottom": { "model": "${modid}:${registryname}_slab" },
        "half=top": { "model": "${modid}:${registryname}_slab_top" },
        "half=double": { "model": "${modid}:${registryname}_double" }
    <#else>
        <#assign combos = (data.getStateCombinations?? && data.getStateCombinations()?has_content)?then(data.getStateCombinations(), [])>
        <#assign customProps = data.customProperties![]>
        <#if combos?has_content>
        <#list combos as model>
        "<#list model.stateMap.keySet() as property>${property.getName()?replace("CUSTOM:", "")}=${model.stateMap.get(property)}<#sep>,</#list>": { "model": "${modid}:${registryname}_${model?index}" }<#sep>,
        </#list>
        <#elseif customProps?has_content && customProps?size == 1>
        <#assign property = customProps[0]>
        <#assign customName = property.property().getName()?replace("CUSTOM:", "")>
        <#if property.value()?is_boolean>
        "${customName}=false": { "model": "${modid}:${registryname}" },
        "${customName}=true": { "model": "${modid}:${registryname}" }
        <#elseif property.value()?is_number>
        <#list property.property().getMin()..property.property().getMax() as value>
        "${customName}=${value}": { "model": "${modid}:${registryname}" }<#sep>,
        </#list>
        <#elseif property.value()?is_string>
        <#list property.property().getArrayData() as value>
        "${customName}=${value}": { "model": "${modid}:${registryname}" }<#sep>,
        </#list>
        <#else>
        "normal": { "model": "${modid}:${registryname}" }
        </#if>
        <#else>
        "normal": { "model": "${modid}:${registryname}" }
        </#if>
    </#if>
    }
}
</#if>
<#-- @formatter:on -->
