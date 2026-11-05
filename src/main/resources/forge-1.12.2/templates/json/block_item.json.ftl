<#assign blockBase = data.blockBase!"">
{
    "parent": "${modid}:block/${registryname}<#if blockBase == 'Stairs'><#elseif blockBase == 'Slab'>_slab<#elseif blockBase == 'Fence' || blockBase == 'Wall'>_inventory</#if>"
}
