<#-- @formatter:off -->
<#if data.blockingRenderType != 0>
<#stop "Forge 1.12.2 generator: custom shield blocking models are not supported yet. Use the built-in blocking model.">
</#if>
{
    "parent": "item/handheld",
    "textures": {
        "layer0": "${data.texture.format("%s:items/%s")}"
    },
    "display": {
        "thirdperson_righthand": {
            "rotation": [ 45, -35, 0 ]
        },
        "thirdperson_lefthand": {
            "rotation": [ 45, -35, 0 ]
        },
        "firstperson_righthand": {
            "rotation": [ 0, 0, 5 ],
            "translation": [ -5, 2, -1 ]
        },
        "firstperson_lefthand": {
            "rotation": [ 0, 0, 5 ],
            "translation": [ -5, 2, -1 ]
        }
    }
}
<#-- @formatter:on -->
