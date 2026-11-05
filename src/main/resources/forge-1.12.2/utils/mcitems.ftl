<#--
  Forge 1.12.2 MCItem/Block helpers.

  Mapped values use the two-column form of mappings/*.yaml:
    index 0 -> Java expression (example: Blocks.STONE#1)
    index 1 -> registry name (example: stone#1)
-->
<#function mcItemRaw mappedItem>
    <#if mappedItem?is_hash>
        <#return mappedItem.getUnmappedValue()>
    <#else>
        <#return mappedItem?string>
    </#if>
</#function>

<#function mcItemMapped mappedItem index=0>
    <#if mappedItem?is_hash>
        <#return mappedItem.getMappedValue(index)>
    <#else>
        <#return mappedItem?string>
    </#if>
</#function>

<#function mcItemIsCustom mappedItem>
    <#return mcItemRaw(mappedItem)?starts_with("CUSTOM:")>
</#function>

<#function mcItemIsTag mappedItem>
    <#return mcItemRaw(mappedItem)?starts_with("TAG:")>
</#function>

<#function mcItemModElement mappedItem>
    <#assign elementName = mcItemRaw(mappedItem)?replace("CUSTOM:", "")>
    <#return w.getWorkspace().getModElementByName(elementName)>
</#function>

<#function splitMetadata mapped>
    <#return mapped?split("#")>
</#function>

<#function mappedMCItemToItemStackCode mappedItem amount=1>
    <#if mcItemIsCustom(mappedItem)>
        <#assign element = mcItemModElement(mappedItem)>
        <#if element??>
            <#if element.getTypeString() == "block">
                <#if element.getGeneratableElement().hasBlockItem>
            <#return "new ItemStack(" + package + ".init." + JavaModName + "Items." + element.getRegistryNameUpper() + "_ITEM, " + amount + ")">
                <#else>
            <#return "new ItemStack(net.minecraft.item.Item.getItemFromBlock(" + package + ".init." + JavaModName + "Blocks." + element.getRegistryNameUpper() + "), " + amount + ")">
                </#if>
            <#else>
            <#return "new ItemStack(" + package + ".init." + JavaModName + "Items." + element.getRegistryNameUpper() + ", " + amount + ")">
            </#if>
        <#else>
            <#return "ItemStack.EMPTY">
        </#if>
    <#else>
        <#assign parts = splitMetadata(mcItemMapped(mappedItem, 0))>
        <#if parts?size gt 1>
            <#return "new ItemStack(" + parts[0] + ", " + amount + ", " + parts[1] + ")">
        <#else>
            <#return "new ItemStack(" + parts[0] + ", " + amount + ")">
        </#if>
    </#if>
</#function>

<#function mappedMCItemToItem mappedItem>
    <#return mappedMCItemToItemStackCode(mappedItem, 1) + ".getItem()">
</#function>

<#function mappedMCItemToRegistryName mappedItem>
    <#if mcItemIsCustom(mappedItem)>
        <#assign element = mcItemModElement(mappedItem)>
        <#if element??>
            <#return modid + ":" + element.getRegistryName()>
        <#else>
            <#return "minecraft:air">
        </#if>
    <#else>
        <#assign parts = splitMetadata(mcItemMapped(mappedItem, 1))>
        <#return "minecraft:" + parts[0]>
    </#if>
</#function>

<#function mappedMCItemToIngameItemName mappedItem>
    <#if mcItemIsCustom(mappedItem)>
        <#assign element = mcItemModElement(mappedItem)>
        <#if element??>
            <#return "\"item\": \"" + modid + ":" + element.getRegistryName() + "\"">
        <#else>
            <#return "\"item\": \"minecraft:air\"">
        </#if>
    <#elseif mcItemIsTag(mappedItem)>
        <#return "\"type\": \"forge:ore_dict\", \"ore\": \""
            + mcItemRaw(mappedItem)?replace("TAG:", "")?replace("mod:", modid + ":")?replace(":", "")?replace("/", "")?lower_case
            + "\"">
    <#else>
        <#assign parts = splitMetadata(mcItemMapped(mappedItem, 1))>
        <#if parts?size gt 1>
            <#return "\"item\": \"minecraft:" + parts[0] + "\", \"data\": " + parts[1]>
        <#else>
            <#return "\"item\": \"minecraft:" + parts[0] + "\"">
        </#if>
    </#if>
</#function>

<#function hasMetadata mappedItem>
    <#return mcItemMapped(mappedItem, 0)?contains("#")>
</#function>

<#function mappedMCItemToIngredient mappedItem>
    <#if mcItemIsTag(mappedItem)>
        <#assign ore = mcItemRaw(mappedItem)?replace("TAG:", "")?replace("mod:", modid + ":")?replace(":", "")?replace("/", "")?lower_case>
        <#return "new net.minecraftforge.oredict.OreIngredient(\"" + ore + "\")">
    <#elseif mcItemMapped(mappedItem, 1)?starts_with("#")>
        <#return "new net.minecraftforge.oredict.OreIngredient(\"" + mcItemMapped(mappedItem, 1)?replace("#", "") + "\")">
    <#else>
        <#return "net.minecraft.item.crafting.Ingredient.fromStacks(" + mappedMCItemToItemStackCode(mappedItem, 1) + ")">
    </#if>
</#function>

<#function mappedBlockToBlockStateCode mappedItem>
    <#if mcItemIsCustom(mappedItem)>
        <#assign element = mcItemModElement(mappedItem)>
        <#if element?? && element.getTypeString() == "block">
            <#return package + ".init." + JavaModName + "Blocks." + element.getRegistryNameUpper() + ".getDefaultState()">
        </#if>
        <#return "net.minecraft.init.Blocks.STONE.getDefaultState()">
    <#else>
        <#return mcItemMapped(mappedItem, 0)?split("#")[0] + ".getDefaultState()">
    </#if>
</#function>
