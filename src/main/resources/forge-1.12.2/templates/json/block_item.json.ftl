<#assign blockBase = data.blockBase!"">
<#if data.itemTexture?? && !data.itemTexture.isEmpty()>
{
    "parent": "item/generated",
    "textures": {
        "layer0": "${data.itemTexture.format("%s:items/%s")}"
    }
}
<#else>
{
    "parent": "${modid}:block/${registryname}<#if blockBase == 'Stairs'><#elseif blockBase == 'Slab'>_slab<#elseif blockBase == 'Fence' || blockBase == 'Wall'>_inventory</#if>"
}
</#if>
