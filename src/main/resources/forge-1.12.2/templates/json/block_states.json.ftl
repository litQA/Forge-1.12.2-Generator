<#-- @formatter:off -->
<#function customStateModel definedStates registryname property1 value1 property2 value2>
    <#local model = registryname>
    <#list definedStates as state>
        <#local matches = true>
        <#list state.stateMap.keySet() as key>
            <#if key.getName() == property1.getName() && state.stateMap.get(key) != value1><#local matches = false></#if>
            <#if key.getName() == property2.getName() && state.stateMap.get(key) != value2><#local matches = false></#if>
        </#list>
        <#if matches><#local model = registryname + "_" + state?index></#if>
    </#list>
    <#return model>
</#function>
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
        "facing=east,half=lower,hinge=left,open=false,powered=false": { "model": "${modid}:${registryname}_bottom" },
        "facing=east,half=lower,hinge=left,open=false,powered=true": { "model": "${modid}:${registryname}_bottom" },
        "facing=south,half=lower,hinge=left,open=false,powered=false": { "model": "${modid}:${registryname}_bottom", "y": 90 },
        "facing=south,half=lower,hinge=left,open=false,powered=true": { "model": "${modid}:${registryname}_bottom", "y": 90 },
        "facing=west,half=lower,hinge=left,open=false,powered=false": { "model": "${modid}:${registryname}_bottom", "y": 180 },
        "facing=west,half=lower,hinge=left,open=false,powered=true": { "model": "${modid}:${registryname}_bottom", "y": 180 },
        "facing=north,half=lower,hinge=left,open=false,powered=false": { "model": "${modid}:${registryname}_bottom", "y": 270 },
        "facing=north,half=lower,hinge=left,open=false,powered=true": { "model": "${modid}:${registryname}_bottom", "y": 270 },
        "facing=east,half=lower,hinge=right,open=false,powered=false": { "model": "${modid}:${registryname}_bottom_rh" },
        "facing=east,half=lower,hinge=right,open=false,powered=true": { "model": "${modid}:${registryname}_bottom_rh" },
        "facing=south,half=lower,hinge=right,open=false,powered=false": { "model": "${modid}:${registryname}_bottom_rh", "y": 90 },
        "facing=south,half=lower,hinge=right,open=false,powered=true": { "model": "${modid}:${registryname}_bottom_rh", "y": 90 },
        "facing=west,half=lower,hinge=right,open=false,powered=false": { "model": "${modid}:${registryname}_bottom_rh", "y": 180 },
        "facing=west,half=lower,hinge=right,open=false,powered=true": { "model": "${modid}:${registryname}_bottom_rh", "y": 180 },
        "facing=north,half=lower,hinge=right,open=false,powered=false": { "model": "${modid}:${registryname}_bottom_rh", "y": 270 },
        "facing=north,half=lower,hinge=right,open=false,powered=true": { "model": "${modid}:${registryname}_bottom_rh", "y": 270 },
        "facing=east,half=lower,hinge=left,open=true,powered=false": { "model": "${modid}:${registryname}_bottom_rh", "y": 90 },
        "facing=east,half=lower,hinge=left,open=true,powered=true": { "model": "${modid}:${registryname}_bottom_rh", "y": 90 },
        "facing=south,half=lower,hinge=left,open=true,powered=false": { "model": "${modid}:${registryname}_bottom_rh", "y": 180 },
        "facing=south,half=lower,hinge=left,open=true,powered=true": { "model": "${modid}:${registryname}_bottom_rh", "y": 180 },
        "facing=west,half=lower,hinge=left,open=true,powered=false": { "model": "${modid}:${registryname}_bottom_rh", "y": 270 },
        "facing=west,half=lower,hinge=left,open=true,powered=true": { "model": "${modid}:${registryname}_bottom_rh", "y": 270 },
        "facing=north,half=lower,hinge=left,open=true,powered=false": { "model": "${modid}:${registryname}_bottom_rh" },
        "facing=north,half=lower,hinge=left,open=true,powered=true": { "model": "${modid}:${registryname}_bottom_rh" },
        "facing=east,half=lower,hinge=right,open=true,powered=false": { "model": "${modid}:${registryname}_bottom", "y": 270 },
        "facing=east,half=lower,hinge=right,open=true,powered=true": { "model": "${modid}:${registryname}_bottom", "y": 270 },
        "facing=south,half=lower,hinge=right,open=true,powered=false": { "model": "${modid}:${registryname}_bottom" },
        "facing=south,half=lower,hinge=right,open=true,powered=true": { "model": "${modid}:${registryname}_bottom" },
        "facing=west,half=lower,hinge=right,open=true,powered=false": { "model": "${modid}:${registryname}_bottom", "y": 90 },
        "facing=west,half=lower,hinge=right,open=true,powered=true": { "model": "${modid}:${registryname}_bottom", "y": 90 },
        "facing=north,half=lower,hinge=right,open=true,powered=false": { "model": "${modid}:${registryname}_bottom", "y": 180 },
        "facing=north,half=lower,hinge=right,open=true,powered=true": { "model": "${modid}:${registryname}_bottom", "y": 180 },
        "facing=east,half=upper,hinge=left,open=false,powered=false": { "model": "${modid}:${registryname}_top" },
        "facing=east,half=upper,hinge=left,open=false,powered=true": { "model": "${modid}:${registryname}_top" },
        "facing=south,half=upper,hinge=left,open=false,powered=false": { "model": "${modid}:${registryname}_top", "y": 90 },
        "facing=south,half=upper,hinge=left,open=false,powered=true": { "model": "${modid}:${registryname}_top", "y": 90 },
        "facing=west,half=upper,hinge=left,open=false,powered=false": { "model": "${modid}:${registryname}_top", "y": 180 },
        "facing=west,half=upper,hinge=left,open=false,powered=true": { "model": "${modid}:${registryname}_top", "y": 180 },
        "facing=north,half=upper,hinge=left,open=false,powered=false": { "model": "${modid}:${registryname}_top", "y": 270 },
        "facing=north,half=upper,hinge=left,open=false,powered=true": { "model": "${modid}:${registryname}_top", "y": 270 },
        "facing=east,half=upper,hinge=right,open=false,powered=false": { "model": "${modid}:${registryname}_top_rh" },
        "facing=east,half=upper,hinge=right,open=false,powered=true": { "model": "${modid}:${registryname}_top_rh" },
        "facing=south,half=upper,hinge=right,open=false,powered=false": { "model": "${modid}:${registryname}_top_rh", "y": 90 },
        "facing=south,half=upper,hinge=right,open=false,powered=true": { "model": "${modid}:${registryname}_top_rh", "y": 90 },
        "facing=west,half=upper,hinge=right,open=false,powered=false": { "model": "${modid}:${registryname}_top_rh", "y": 180 },
        "facing=west,half=upper,hinge=right,open=false,powered=true": { "model": "${modid}:${registryname}_top_rh", "y": 180 },
        "facing=north,half=upper,hinge=right,open=false,powered=false": { "model": "${modid}:${registryname}_top_rh", "y": 270 },
        "facing=north,half=upper,hinge=right,open=false,powered=true": { "model": "${modid}:${registryname}_top_rh", "y": 270 },
        "facing=east,half=upper,hinge=left,open=true,powered=false": { "model": "${modid}:${registryname}_top_rh", "y": 90 },
        "facing=east,half=upper,hinge=left,open=true,powered=true": { "model": "${modid}:${registryname}_top_rh", "y": 90 },
        "facing=south,half=upper,hinge=left,open=true,powered=false": { "model": "${modid}:${registryname}_top_rh", "y": 180 },
        "facing=south,half=upper,hinge=left,open=true,powered=true": { "model": "${modid}:${registryname}_top_rh", "y": 180 },
        "facing=west,half=upper,hinge=left,open=true,powered=false": { "model": "${modid}:${registryname}_top_rh", "y": 270 },
        "facing=west,half=upper,hinge=left,open=true,powered=true": { "model": "${modid}:${registryname}_top_rh", "y": 270 },
        "facing=north,half=upper,hinge=left,open=true,powered=false": { "model": "${modid}:${registryname}_top_rh" },
        "facing=north,half=upper,hinge=left,open=true,powered=true": { "model": "${modid}:${registryname}_top_rh" },
        "facing=east,half=upper,hinge=right,open=true,powered=false": { "model": "${modid}:${registryname}_top", "y": 270 },
        "facing=east,half=upper,hinge=right,open=true,powered=true": { "model": "${modid}:${registryname}_top", "y": 270 },
        "facing=south,half=upper,hinge=right,open=true,powered=false": { "model": "${modid}:${registryname}_top" },
        "facing=south,half=upper,hinge=right,open=true,powered=true": { "model": "${modid}:${registryname}_top" },
        "facing=west,half=upper,hinge=right,open=true,powered=false": { "model": "${modid}:${registryname}_top", "y": 90 },
        "facing=west,half=upper,hinge=right,open=true,powered=true": { "model": "${modid}:${registryname}_top", "y": 90 },
        "facing=north,half=upper,hinge=right,open=true,powered=false": { "model": "${modid}:${registryname}_top", "y": 180 },
        "facing=north,half=upper,hinge=right,open=true,powered=true": { "model": "${modid}:${registryname}_top", "y": 180 }
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
        "facing=south,in_wall=false,open=false,powered=false": { "model": "${modid}:${registryname}_closed", "uvlock": true },
        "facing=south,in_wall=false,open=false,powered=true": { "model": "${modid}:${registryname}_closed", "uvlock": true },
        "facing=west,in_wall=false,open=false,powered=false": { "model": "${modid}:${registryname}_closed", "uvlock": true, "y": 90 },
        "facing=west,in_wall=false,open=false,powered=true": { "model": "${modid}:${registryname}_closed", "uvlock": true, "y": 90 },
        "facing=north,in_wall=false,open=false,powered=false": { "model": "${modid}:${registryname}_closed", "uvlock": true, "y": 180 },
        "facing=north,in_wall=false,open=false,powered=true": { "model": "${modid}:${registryname}_closed", "uvlock": true, "y": 180 },
        "facing=east,in_wall=false,open=false,powered=false": { "model": "${modid}:${registryname}_closed", "uvlock": true, "y": 270 },
        "facing=east,in_wall=false,open=false,powered=true": { "model": "${modid}:${registryname}_closed", "uvlock": true, "y": 270 },
        "facing=south,in_wall=false,open=true,powered=false": { "model": "${modid}:${registryname}_open", "uvlock": true },
        "facing=south,in_wall=false,open=true,powered=true": { "model": "${modid}:${registryname}_open", "uvlock": true },
        "facing=west,in_wall=false,open=true,powered=false": { "model": "${modid}:${registryname}_open", "uvlock": true, "y": 90 },
        "facing=west,in_wall=false,open=true,powered=true": { "model": "${modid}:${registryname}_open", "uvlock": true, "y": 90 },
        "facing=north,in_wall=false,open=true,powered=false": { "model": "${modid}:${registryname}_open", "uvlock": true, "y": 180 },
        "facing=north,in_wall=false,open=true,powered=true": { "model": "${modid}:${registryname}_open", "uvlock": true, "y": 180 },
        "facing=east,in_wall=false,open=true,powered=false": { "model": "${modid}:${registryname}_open", "uvlock": true, "y": 270 },
        "facing=east,in_wall=false,open=true,powered=true": { "model": "${modid}:${registryname}_open", "uvlock": true, "y": 270 },
        "facing=south,in_wall=true,open=false,powered=false": { "model": "${modid}:${registryname}_wall_closed", "uvlock": true },
        "facing=south,in_wall=true,open=false,powered=true": { "model": "${modid}:${registryname}_wall_closed", "uvlock": true },
        "facing=west,in_wall=true,open=false,powered=false": { "model": "${modid}:${registryname}_wall_closed", "uvlock": true, "y": 90 },
        "facing=west,in_wall=true,open=false,powered=true": { "model": "${modid}:${registryname}_wall_closed", "uvlock": true, "y": 90 },
        "facing=north,in_wall=true,open=false,powered=false": { "model": "${modid}:${registryname}_wall_closed", "uvlock": true, "y": 180 },
        "facing=north,in_wall=true,open=false,powered=true": { "model": "${modid}:${registryname}_wall_closed", "uvlock": true, "y": 180 },
        "facing=east,in_wall=true,open=false,powered=false": { "model": "${modid}:${registryname}_wall_closed", "uvlock": true, "y": 270 },
        "facing=east,in_wall=true,open=false,powered=true": { "model": "${modid}:${registryname}_wall_closed", "uvlock": true, "y": 270 },
        "facing=south,in_wall=true,open=true,powered=false": { "model": "${modid}:${registryname}_wall_open", "uvlock": true },
        "facing=south,in_wall=true,open=true,powered=true": { "model": "${modid}:${registryname}_wall_open", "uvlock": true },
        "facing=west,in_wall=true,open=true,powered=false": { "model": "${modid}:${registryname}_wall_open", "uvlock": true, "y": 90 },
        "facing=west,in_wall=true,open=true,powered=true": { "model": "${modid}:${registryname}_wall_open", "uvlock": true, "y": 90 },
        "facing=north,in_wall=true,open=true,powered=false": { "model": "${modid}:${registryname}_wall_open", "uvlock": true, "y": 180 },
        "facing=north,in_wall=true,open=true,powered=true": { "model": "${modid}:${registryname}_wall_open", "uvlock": true, "y": 180 },
        "facing=east,in_wall=true,open=true,powered=false": { "model": "${modid}:${registryname}_wall_open", "uvlock": true, "y": 270 },
        "facing=east,in_wall=true,open=true,powered=true": { "model": "${modid}:${registryname}_wall_open", "uvlock": true, "y": 270 }
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
        "${bp.property().getName()?replace("CUSTOM:", "")?lower_case}=${b?c},${ep.property().getName()?replace("CUSTOM:", "")?lower_case}=${e?lower_case},${ip.property().getName()?replace("CUSTOM:", "")?lower_case}=${i}": { "model": "${modid}:${model}" }<#sep>,
        </#list>
        <#if !e?is_last>,</#if>
        </#list>
        <#if !b?is_last>,</#if>
        </#list>
        <#elseif customProps?size == 2 && boolProps?size == 2>
        <#assign p1 = boolProps[0]><#assign p2 = boolProps[1]>
        <#list [false, true] as v1>
        <#list [false, true] as v2>
        "${p1.property().getName()?replace("CUSTOM:", "")?lower_case}=${v1?c},${p2.property().getName()?replace("CUSTOM:", "")?lower_case}=${v2?c}": { "model": "${modid}:${customStateModel(definedStates, registryname, p1.property(), v1, p2.property(), v2)}" }<#sep>,
        </#list>
        <#if !v1?is_last>,</#if>
        </#list>
        <#elseif customProps?size == 2 && boolProps?size == 1 && enumProps?size == 1>
        <#assign bp = boolProps[0]><#assign ep = enumProps[0]>
        <#list [false, true] as b>
        <#list ep.property().getArrayData() as e>
        "${bp.property().getName()?replace("CUSTOM:", "")?lower_case}=${b?c},${ep.property().getName()?replace("CUSTOM:", "")?lower_case}=${e?lower_case}": { "model": "${modid}:${customStateModel(definedStates, registryname, bp.property(), b, ep.property(), e)}" }<#sep>,
        </#list>
        <#if !b?is_last>,</#if>
        </#list>
        <#elseif customProps?size == 2 && boolProps?size == 1 && intProps?size == 1>
        <#assign bp = boolProps[0]><#assign ip = intProps[0]>
        <#list [false, true] as b>
        <#list ip.property().getMin()..ip.property().getMax() as i>
        "${bp.property().getName()?replace("CUSTOM:", "")?lower_case}=${b?c},${ip.property().getName()?replace("CUSTOM:", "")?lower_case}=${i}": { "model": "${modid}:${customStateModel(definedStates, registryname, bp.property(), b, ip.property(), i)}" }<#sep>,
        </#list>
        <#if !b?is_last>,</#if>
        </#list>
        <#elseif customProps?size == 2 && enumProps?size == 1 && intProps?size == 1>
        <#assign ep = enumProps[0]><#assign ip = intProps[0]>
        <#list ep.property().getArrayData() as e>
        <#list ip.property().getMin()..ip.property().getMax() as i>
        "${ep.property().getName()?replace("CUSTOM:", "")?lower_case}=${e?lower_case},${ip.property().getName()?replace("CUSTOM:", "")?lower_case}=${i}": { "model": "${modid}:${customStateModel(definedStates, registryname, ep.property(), e, ip.property(), i)}" }<#sep>,
        </#list>
        <#if !e?is_last>,</#if>
        </#list>
        <#elseif customProps?has_content && customProps?size == 1>
        <#assign property = customProps[0]>
        <#assign customName = property.property().getName()?replace("CUSTOM:", "")?lower_case>
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
        "${customName}=${value?lower_case}": { "model": "${modid}:${model}" }<#sep>,
        </#list>
        </#if>
        <#elseif combos?has_content>
        <#list combos as model>
        "<#list model.stateMap.keySet() as property>${property.getName()?replace("CUSTOM:", "")?lower_case}=${model.stateMap.get(property)}<#sep>,</#list>": { "model": "${modid}:${registryname}_${model?index}" }<#sep>,
        </#list>
        <#else>
        "normal": { "model": "${modid}:${registryname}" }
        </#if>
    </#if>
    }
}
</#if>
<#-- @formatter:on -->
