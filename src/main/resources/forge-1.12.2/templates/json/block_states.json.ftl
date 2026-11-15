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
<#elseif blockBase == "Door">
{
    "variants": {
        "facing=east,half=lower,hinge=left,open=false": { "model": "${modid}:${registryname}_bottom" },
        "facing=south,half=lower,hinge=left,open=false": { "model": "${modid}:${registryname}_bottom", "y": 90 },
        "facing=west,half=lower,hinge=left,open=false": { "model": "${modid}:${registryname}_bottom", "y": 180 },
        "facing=north,half=lower,hinge=left,open=false": { "model": "${modid}:${registryname}_bottom", "y": 270 },
        "facing=east,half=lower,hinge=right,open=false": { "model": "${modid}:${registryname}_bottom_rh" },
        "facing=south,half=lower,hinge=right,open=false": { "model": "${modid}:${registryname}_bottom_rh", "y": 90 },
        "facing=west,half=lower,hinge=right,open=false": { "model": "${modid}:${registryname}_bottom_rh", "y": 180 },
        "facing=north,half=lower,hinge=right,open=false": { "model": "${modid}:${registryname}_bottom_rh", "y": 270 },
        "facing=east,half=lower,hinge=left,open=true": { "model": "${modid}:${registryname}_bottom_rh", "y": 90 },
        "facing=south,half=lower,hinge=left,open=true": { "model": "${modid}:${registryname}_bottom_rh", "y": 180 },
        "facing=west,half=lower,hinge=left,open=true": { "model": "${modid}:${registryname}_bottom_rh", "y": 270 },
        "facing=north,half=lower,hinge=left,open=true": { "model": "${modid}:${registryname}_bottom_rh" },
        "facing=east,half=lower,hinge=right,open=true": { "model": "${modid}:${registryname}_bottom", "y": 270 },
        "facing=south,half=lower,hinge=right,open=true": { "model": "${modid}:${registryname}_bottom" },
        "facing=west,half=lower,hinge=right,open=true": { "model": "${modid}:${registryname}_bottom", "y": 90 },
        "facing=north,half=lower,hinge=right,open=true": { "model": "${modid}:${registryname}_bottom", "y": 180 },
        "facing=east,half=upper,hinge=left,open=false": { "model": "${modid}:${registryname}_top" },
        "facing=south,half=upper,hinge=left,open=false": { "model": "${modid}:${registryname}_top", "y": 90 },
        "facing=west,half=upper,hinge=left,open=false": { "model": "${modid}:${registryname}_top", "y": 180 },
        "facing=north,half=upper,hinge=left,open=false": { "model": "${modid}:${registryname}_top", "y": 270 },
        "facing=east,half=upper,hinge=right,open=false": { "model": "${modid}:${registryname}_top_rh" },
        "facing=south,half=upper,hinge=right,open=false": { "model": "${modid}:${registryname}_top_rh", "y": 90 },
        "facing=west,half=upper,hinge=right,open=false": { "model": "${modid}:${registryname}_top_rh", "y": 180 },
        "facing=north,half=upper,hinge=right,open=false": { "model": "${modid}:${registryname}_top_rh", "y": 270 },
        "facing=east,half=upper,hinge=left,open=true": { "model": "${modid}:${registryname}_top_rh", "y": 90 },
        "facing=south,half=upper,hinge=left,open=true": { "model": "${modid}:${registryname}_top_rh", "y": 180 },
        "facing=west,half=upper,hinge=left,open=true": { "model": "${modid}:${registryname}_top_rh", "y": 270 },
        "facing=north,half=upper,hinge=left,open=true": { "model": "${modid}:${registryname}_top_rh" },
        "facing=east,half=upper,hinge=right,open=true": { "model": "${modid}:${registryname}_top", "y": 270 },
        "facing=south,half=upper,hinge=right,open=true": { "model": "${modid}:${registryname}_top" },
        "facing=west,half=upper,hinge=right,open=true": { "model": "${modid}:${registryname}_top", "y": 90 },
        "facing=north,half=upper,hinge=right,open=true": { "model": "${modid}:${registryname}_top", "y": 180 }
    }
}
<#elseif blockBase == "TrapDoor">
{
    "variants": {
        "facing=north,half=bottom,open=false": { "model": "${modid}:${registryname}_bottom" },
        "facing=south,half=bottom,open=false": { "model": "${modid}:${registryname}_bottom" },
        "facing=east,half=bottom,open=false": { "model": "${modid}:${registryname}_bottom" },
        "facing=west,half=bottom,open=false": { "model": "${modid}:${registryname}_bottom" },
        "facing=north,half=top,open=false": { "model": "${modid}:${registryname}_top" },
        "facing=south,half=top,open=false": { "model": "${modid}:${registryname}_top" },
        "facing=east,half=top,open=false": { "model": "${modid}:${registryname}_top" },
        "facing=west,half=top,open=false": { "model": "${modid}:${registryname}_top" },
        "facing=north,half=bottom,open=true": { "model": "${modid}:${registryname}_open" },
        "facing=south,half=bottom,open=true": { "model": "${modid}:${registryname}_open", "y": 180 },
        "facing=east,half=bottom,open=true": { "model": "${modid}:${registryname}_open", "y": 90 },
        "facing=west,half=bottom,open=true": { "model": "${modid}:${registryname}_open", "y": 270 },
        "facing=north,half=top,open=true": { "model": "${modid}:${registryname}_open" },
        "facing=south,half=top,open=true": { "model": "${modid}:${registryname}_open", "y": 180 },
        "facing=east,half=top,open=true": { "model": "${modid}:${registryname}_open", "y": 90 },
        "facing=west,half=top,open=true": { "model": "${modid}:${registryname}_open", "y": 270 }
    }
}
<#elseif blockBase == "FenceGate">
{
    "variants": {
        "facing=south,in_wall=false,open=false": { "model": "${modid}:${registryname}_closed", "uvlock": true },
        "facing=west,in_wall=false,open=false": { "model": "${modid}:${registryname}_closed", "uvlock": true, "y": 90 },
        "facing=north,in_wall=false,open=false": { "model": "${modid}:${registryname}_closed", "uvlock": true, "y": 180 },
        "facing=east,in_wall=false,open=false": { "model": "${modid}:${registryname}_closed", "uvlock": true, "y": 270 },
        "facing=south,in_wall=false,open=true": { "model": "${modid}:${registryname}_open", "uvlock": true },
        "facing=west,in_wall=false,open=true": { "model": "${modid}:${registryname}_open", "uvlock": true, "y": 90 },
        "facing=north,in_wall=false,open=true": { "model": "${modid}:${registryname}_open", "uvlock": true, "y": 180 },
        "facing=east,in_wall=false,open=true": { "model": "${modid}:${registryname}_open", "uvlock": true, "y": 270 },
        "facing=south,in_wall=true,open=false": { "model": "${modid}:${registryname}_wall_closed", "uvlock": true },
        "facing=west,in_wall=true,open=false": { "model": "${modid}:${registryname}_wall_closed", "uvlock": true, "y": 90 },
        "facing=north,in_wall=true,open=false": { "model": "${modid}:${registryname}_wall_closed", "uvlock": true, "y": 180 },
        "facing=east,in_wall=true,open=false": { "model": "${modid}:${registryname}_wall_closed", "uvlock": true, "y": 270 },
        "facing=south,in_wall=true,open=true": { "model": "${modid}:${registryname}_wall_open", "uvlock": true },
        "facing=west,in_wall=true,open=true": { "model": "${modid}:${registryname}_wall_open", "uvlock": true, "y": 90 },
        "facing=north,in_wall=true,open=true": { "model": "${modid}:${registryname}_wall_open", "uvlock": true, "y": 180 },
        "facing=east,in_wall=true,open=true": { "model": "${modid}:${registryname}_wall_open", "uvlock": true, "y": 270 }
    }
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
        <#assign customProps = data.customProperties![]>
        <#assign definedStates = data.getDefinedStates()![]>
        <#assign boolProps = []>
        <#assign intProps = []>
        <#assign enumProps = []>
        <#list customProps as property>
            <#if property.value()?is_boolean><#assign boolProps += [property]>
            <#elseif property.value()?is_number><#assign intProps += [property]>
            <#elseif property.value()?is_string><#assign enumProps += [property]>
            </#if>
        </#list>
        <#if customProps?size == 3 && boolProps?has_content && intProps?has_content && enumProps?has_content>
        <#assign bp = boolProps[0]><#assign ip = intProps[0]><#assign ep = enumProps[0]>
        <#list [false, true] as b>
        <#list ep.property().getArrayData() as e>
        <#list ip.property().getMin()..ip.property().getMax() as i>
        <#assign model = registryname>
        <#list definedStates as state>
            <#assign ok = true>
            <#list state.stateMap.keySet() as key>
                <#if (key.getName() == bp.property().getName() && state.stateMap.get(key) != b) || (key.getName() == ep.property().getName() && state.stateMap.get(key) != e) || (key.getName() == ip.property().getName() && state.stateMap.get(key) != i)><#assign ok = false></#if>
            </#list>
            <#if ok><#assign model = registryname + "_" + state?index></#if>
        </#list>
        "${bp.property().getName()?replace("CUSTOM:", "")}=${b?c},${ep.property().getName()?replace("CUSTOM:", "")}=${e},${ip.property().getName()?replace("CUSTOM:", "")}=${i}": { "model": "${modid}:${model}" }<#sep>,
        </#list>
        <#if !e?is_last>,</#if>
        </#list>
        <#if !b?is_last>,</#if>
        </#list>
        <#elseif customProps?has_content && customProps?size == 1>
        <#assign property = customProps[0]>
        <#assign customName = property.property().getName()?replace("CUSTOM:", "")>
        <#if property.value()?is_boolean>
        <#list [false, true] as value>
        <#assign model = registryname>
        <#list definedStates as state><#list state.stateMap.keySet() as key><#if key.getName() == property.property().getName() && state.stateMap.get(key) == value><#assign model = registryname + "_" + state?index></#if></#list></#list>
        "${customName}=${value?c}": { "model": "${modid}:${model}" }<#sep>,
        </#list>
        <#elseif property.value()?is_number>
        <#list property.property().getMin()..property.property().getMax() as value>
        <#assign model = registryname>
        <#list definedStates as state><#list state.stateMap.keySet() as key><#if key.getName() == property.property().getName() && state.stateMap.get(key) == value><#assign model = registryname + "_" + state?index></#if></#list></#list>
        "${customName}=${value}": { "model": "${modid}:${model}" }<#sep>,
        </#list>
        <#elseif property.value()?is_string>
        <#list property.property().getArrayData() as value>
        <#assign model = registryname>
        <#list definedStates as state><#list state.stateMap.keySet() as key><#if key.getName() == property.property().getName() && state.stateMap.get(key) == value><#assign model = registryname + "_" + state?index></#if></#list></#list>
        "${customName}=${value}": { "model": "${modid}:${model}" }<#sep>,
        </#list>
        </#if>
        <#elseif combos?has_content>
        <#list combos as model>
        "<#list model.stateMap.keySet() as property>${property.getName()?replace("CUSTOM:", "")}=${model.stateMap.get(property)}<#sep>,</#list>": { "model": "${modid}:${registryname}_${model?index}" }<#sep>,
        </#list>
        <#else>
        "normal": { "model": "${modid}:${registryname}" }
        </#if>
    </#if>
    }
}
</#if>
<#-- @formatter:on -->
