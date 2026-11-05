<#-- @formatter:off -->
<#if data.renderType == 13>
{
    "parent": "block/crop",
    "textures": {
        "crop": "${data.texture.format("%s:blocks/%s")}",
        "particle": "${data.getParticleTexture().format("%s:blocks/%s")}"
    }
}
<#elseif data.renderType == 2>
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
