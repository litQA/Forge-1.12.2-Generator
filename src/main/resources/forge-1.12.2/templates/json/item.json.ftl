{
    "parent": "item/generated",
    "textures": {
<#if var_item?? && var_item == "helmet">
        "layer0": "${data.textureHelmet.format("%s:items/%s")}"
<#elseif var_item?? && var_item == "body">
        "layer0": "${data.textureBody.format("%s:items/%s")}"
<#elseif var_item?? && var_item == "leggings">
        "layer0": "${data.textureLeggings.format("%s:items/%s")}"
<#elseif var_item?? && var_item == "boots">
        "layer0": "${data.textureBoots.format("%s:items/%s")}"
<#else>
        "layer0": "${data.texture.format("%s:items/%s")}"
</#if>
    }
}
