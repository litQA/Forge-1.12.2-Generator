<#-- @formatter:off -->
<#if data.blockBase == "Fence">
{
    "multipart": [
        { "apply": { "model": "${modid}:block/${registryname}_post" } },
        { "when": { "north": "true" }, "apply": { "model": "${modid}:block/${registryname}", "uvlock": true } },
        { "when": { "south": "true" }, "apply": { "model": "${modid}:block/${registryname}", "y": 180, "uvlock": true } },
        { "when": { "west": "true" }, "apply": { "model": "${modid}:block/${registryname}", "y": 270, "uvlock": true } },
        { "when": { "east": "true" }, "apply": { "model": "${modid}:block/${registryname}", "y": 90, "uvlock": true } }
    ]
}
<#elseif data.blockBase == "Wall">
{
    "multipart": [
        { "when": { "up": "true" }, "apply": { "model": "${modid}:block/${registryname}_post" } },
        { "when": { "north": "true" }, "apply": { "model": "${modid}:block/${registryname}", "uvlock": true } },
        { "when": { "east": "true" }, "apply": { "model": "${modid}:block/${registryname}", "y": 90, "uvlock": true } },
        { "when": { "south": "true" }, "apply": { "model": "${modid}:block/${registryname}", "y": 180, "uvlock": true } },
        { "when": { "west": "true" }, "apply": { "model": "${modid}:block/${registryname}", "y": 270, "uvlock": true } }
    ]
}
<#else>
{
    "variants": {
    <#if data.blockBase == "Stairs">
        "facing=east,half=bottom,shape=straight": { "model": "${modid}:block/${registryname}" },
        "facing=west,half=bottom,shape=straight": { "model": "${modid}:block/${registryname}", "y": 180, "uvlock": true },
        "facing=south,half=bottom,shape=straight": { "model": "${modid}:block/${registryname}", "y": 90, "uvlock": true },
        "facing=north,half=bottom,shape=straight": { "model": "${modid}:block/${registryname}", "y": 270, "uvlock": true },
        "facing=east,half=bottom,shape=inner_right": { "model": "${modid}:block/${registryname}_inner" },
        "facing=west,half=bottom,shape=inner_right": { "model": "${modid}:block/${registryname}_inner", "y": 180, "uvlock": true },
        "facing=south,half=bottom,shape=inner_right": { "model": "${modid}:block/${registryname}_inner", "y": 90, "uvlock": true },
        "facing=north,half=bottom,shape=inner_right": { "model": "${modid}:block/${registryname}_inner", "y": 270, "uvlock": true },
        "facing=east,half=bottom,shape=inner_left": { "model": "${modid}:block/${registryname}_inner", "y": 270, "uvlock": true },
        "facing=west,half=bottom,shape=inner_left": { "model": "${modid}:block/${registryname}_inner", "y": 90, "uvlock": true },
        "facing=south,half=bottom,shape=inner_left": { "model": "${modid}:block/${registryname}_inner" },
        "facing=north,half=bottom,shape=inner_left": { "model": "${modid}:block/${registryname}_inner", "y": 180, "uvlock": true },
        "facing=east,half=top,shape=straight": { "model": "${modid}:block/${registryname}", "x": 180, "uvlock": true },
        "facing=west,half=top,shape=straight": { "model": "${modid}:block/${registryname}", "x": 180, "y": 180, "uvlock": true },
        "facing=south,half=top,shape=straight": { "model": "${modid}:block/${registryname}", "x": 180, "y": 90, "uvlock": true },
        "facing=north,half=top,shape=straight": { "model": "${modid}:block/${registryname}", "x": 180, "y": 270, "uvlock": true },
        "facing=east,half=top,shape=outer_right": { "model": "${modid}:block/${registryname}_outer", "x": 180, "y": 90, "uvlock": true },
        "facing=west,half=top,shape=outer_right": { "model": "${modid}:block/${registryname}_outer", "x": 180, "y": 270, "uvlock": true },
        "facing=south,half=top,shape=outer_right": { "model": "${modid}:block/${registryname}_outer", "x": 180, "y": 180, "uvlock": true },
        "facing=north,half=top,shape=outer_right": { "model": "${modid}:block/${registryname}_outer", "x": 180, "uvlock": true },
        "facing=east,half=top,shape=outer_left": { "model": "${modid}:block/${registryname}_outer", "x": 180, "uvlock": true },
        "facing=west,half=top,shape=outer_left": { "model": "${modid}:block/${registryname}_outer", "x": 180, "y": 180, "uvlock": true },
        "facing=south,half=top,shape=outer_left": { "model": "${modid}:block/${registryname}_outer", "x": 180, "y": 90, "uvlock": true },
        "facing=north,half=top,shape=outer_left": { "model": "${modid}:block/${registryname}_outer", "x": 180, "y": 270, "uvlock": true },
        "facing=east,half=top,shape=inner_right": { "model": "${modid}:block/${registryname}_inner", "x": 180, "y": 90, "uvlock": true },
        "facing=west,half=top,shape=inner_right": { "model": "${modid}:block/${registryname}_inner", "x": 180, "y": 270, "uvlock": true },
        "facing=south,half=top,shape=inner_right": { "model": "${modid}:block/${registryname}_inner", "x": 180, "y": 180, "uvlock": true },
        "facing=north,half=top,shape=inner_right": { "model": "${modid}:block/${registryname}_inner", "x": 180, "uvlock": true },
        "facing=east,half=top,shape=inner_left": { "model": "${modid}:block/${registryname}_inner", "x": 180, "uvlock": true },
        "facing=west,half=top,shape=inner_left": { "model": "${modid}:block/${registryname}_inner", "x": 180, "y": 180, "uvlock": true },
        "facing=south,half=top,shape=inner_left": { "model": "${modid}:block/${registryname}_inner", "x": 180, "y": 90, "uvlock": true },
        "facing=north,half=top,shape=inner_left": { "model": "${modid}:block/${registryname}_inner", "x": 180, "y": 270, "uvlock": true },
        "facing=east,half=bottom,shape=outer_right": { "model": "${modid}:block/${registryname}_outer" },
        "facing=west,half=bottom,shape=outer_right": { "model": "${modid}:block/${registryname}_outer", "y": 180, "uvlock": true },
        "facing=south,half=bottom,shape=outer_right": { "model": "${modid}:block/${registryname}_outer", "y": 90, "uvlock": true },
        "facing=north,half=bottom,shape=outer_right": { "model": "${modid}:block/${registryname}_outer", "y": 270, "uvlock": true },
        "facing=east,half=bottom,shape=outer_left": { "model": "${modid}:block/${registryname}_outer", "y": 270, "uvlock": true },
        "facing=west,half=bottom,shape=outer_left": { "model": "${modid}:block/${registryname}_outer", "y": 90, "uvlock": true },
        "facing=south,half=bottom,shape=outer_left": { "model": "${modid}:block/${registryname}_outer" },
        "facing=north,half=bottom,shape=outer_left": { "model": "${modid}:block/${registryname}_outer", "y": 180, "uvlock": true }
    <#elseif data.blockBase == "Slab">
        "half=bottom": { "model": "${modid}:block/${registryname}_slab" },
        "half=top": { "model": "${modid}:block/${registryname}_slab_top" },
        "half=double": { "model": "${modid}:block/${registryname}_double" }
    <#else>
        "normal": { "model": "${modid}:block/${registryname}" }
    </#if>
    }
}
</#if>
<#-- @formatter:on -->
