<#-- @formatter:off -->
<#if (data.renderType?is_number && data.renderType == 13) || (data.customModelName?contains("Crop"))>
{
    "parent": "block/crop",
    "textures": {
        "crop": "${data.texture.format("%s:blocks/%s")}",
        "particle": "${data.getParticleTexture().format("%s:blocks/%s")}"
    }
}
<#elseif (data.renderType?is_number && data.renderType == 2) || (data.customModelName?contains("Custom"))>
{
    "parent": "${modid}:custom/${data.customModelName?split(":")[0]}",
    "textures": {
        "all": "${data.texture.format("%s:blocks/%s")}",
        "particle": "${data.getParticleTexture().format("%s:blocks/%s")}"
    }
}
<#else>
{
    "parent": "block/cross",
    "textures": {
        "cross": "${data.texture.format("%s:blocks/%s")}",
        "particle": "${data.getParticleTexture().format("%s:blocks/%s")}"
    }
}
</#if>
<#-- @formatter:on -->
