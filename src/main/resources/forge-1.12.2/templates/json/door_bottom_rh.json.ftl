<#assign doorTop = data.textureTop()>
<#if !doorTop?has_content><#assign doorTop = data.texture></#if>
{
    "parent": "minecraft:block/door_bottom_rh",
    "textures": {
        "bottom": "${data.texture.format("%s:blocks/%s")}",
        "top": "${doorTop.format("%s:blocks/%s")}"
    }
}
