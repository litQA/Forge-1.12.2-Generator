<#-- @formatter:off -->
<#assign tex = (data.texture)!((data.textureFront())!"")>
<#assign top = (data.textureTop())!tex>
<#assign front = (data.textureFront())!tex>
<#assign back = (data.textureBack())!tex>
<#assign right = (data.textureRight())!tex>
<#assign left = (data.textureLeft())!tex>
<#assign particle = (data.getParticleTexture(tex))!tex>
{
<#if data.renderType == 12>
    "parent": "block/cross",
    "textures": {
        "cross": "${front.format("%s:blocks/%s")}",
        "particle": "${particle.format("%s:blocks/%s")}"
    }
<#elseif data.renderType == 13>
    "parent": "block/crop",
    "textures": {
        "crop": "${front.format("%s:blocks/%s")}",
        "particle": "${particle.format("%s:blocks/%s")}"
    }
<#elseif data.renderType == 2>
    "parent": "${modid}:custom/${data.customModelName?split(":")[0]}",
    "textures": {
        "all": "${tex.format("%s:blocks/%s")}",
        "particle": "${particle.format("%s:blocks/%s")}"
        <#if data.getTextureMap()??>
        <#list data.getTextureMap().entrySet() as texture>,
        "${texture.getKey()}": "${texture.getValue().format("%s:blocks/%s")}"
        </#list>
        </#if>
    }
<#else>
    "parent": "block/cube",
    "textures": {
        "particle": "${particle.format("%s:blocks/%s")}",
        "down": "${tex.format("%s:blocks/%s")}",
        "up": "${top.format("%s:blocks/%s")}",
        "north": "${front.format("%s:blocks/%s")}",
        "south": "${back.format("%s:blocks/%s")}",
        "east": "${right.format("%s:blocks/%s")}",
        "west": "${left.format("%s:blocks/%s")}"
    }
</#if>
}
<#-- @formatter:on -->
