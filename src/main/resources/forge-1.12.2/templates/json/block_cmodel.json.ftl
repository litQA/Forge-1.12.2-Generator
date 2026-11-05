{
    "parent": "${modid}:custom/${data.customModelName?split(":")[0]}",
    "textures": {
        "all": "${data.texture.format("%s:blocks/%s")}",
        "particle": "${((data.getParticleTexture())!data.texture).format("%s:blocks/%s")}"
        <#if data.getTextureMap()??>
        <#list data.getTextureMap().entrySet() as texture>,
        "${texture.getKey()}": "${texture.getValue().format("%s:blocks/%s")}"
        </#list>
        </#if>
    }
}
