<#--
  Converts MCreator tag elements to Forge 1.12.2 ore dictionary names and
  registration code. 1.12.2 has no tag registry, so the tag UI is kept for
  familiarity while the generated backend uses the ore dictionary.
-->
<#function oreDictionaryName tag>
    <#assign path = tag.resourcePath()>
    <#assign namespace = path?keep_before(":")>
    <#assign name = path?keep_after(":")>

    <#if namespace == "forge" || namespace == "minecraft">
        <#if name?starts_with("ores/")>
            <#return "ore" + camelCase(name?replace("ores/", ""))>
        <#elseif name?starts_with("storage_blocks/")>
            <#return "block" + camelCase(name?replace("storage_blocks/", ""))>
        <#elseif name?starts_with("ingots/")>
            <#return "ingot" + camelCase(name?replace("ingots/", ""))>
        <#elseif name?starts_with("nuggets/")>
            <#return "nugget" + camelCase(name?replace("nuggets/", ""))>
        <#elseif name?starts_with("dusts/")>
            <#return "dust" + camelCase(name?replace("dusts/", ""))>
        <#elseif name?starts_with("gems/")>
            <#return "gem" + camelCase(name?replace("gems/", ""))>
        <#elseif name?starts_with("raw_materials/")>
            <#return "raw" + camelCase(name?replace("raw_materials/", ""))>
        <#elseif name == "planks">
            <#return "plankWood">
        <#elseif name == "logs" || name == "logs_that_burn">
            <#return "logWood">
        <#elseif name == "stone_tool_materials" || name == "stone_crafting_materials">
            <#return "stoneToolMaterial">
        </#if>
    </#if>

    <#return (namespace + "_" + name)?replace(":", "_")?replace("/", "_")?replace("-", "_")?replace(".", "_")?lower_case>
</#function>

<#function camelCase value>
    <#assign result = "">
    <#list value?split("_") as part>
        <#assign result = result + part?cap_first>
    </#list>
    <#return result>
</#function>

<#function registryNameFor value>
    <#assign name = value?replace("EXTERNAL:", "")>
    <#if !name?contains(":")>
        <#assign name = "minecraft:" + name>
    </#if>
    <#return name>
</#function>

<#macro registerBlockTagEntry entry oreName>
    <#assign value = entry.name()>
    <#if value?starts_with("CUSTOM:")>
        <#assign element = w.getWorkspace().getModElementByName(value?replace("CUSTOM:", ""))>
        <#if element?? && element.getTypeString() == "block">
        net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", ${package}.init.${JavaModName}Blocks.${element.getRegistryNameUpper()});
        </#if>
    <#elseif value?starts_with("EXTERNAL:")>
        <#assign lookup = registryNameFor(value)>
        if (net.minecraft.block.Block.getBlockFromName("${lookup}") != null) {
            net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", net.minecraft.block.Block.getBlockFromName("${lookup}"));
        }
    <#elseif value?contains(":")>
        if (net.minecraft.block.Block.getBlockFromName("${value}") != null) {
            net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", net.minecraft.block.Block.getBlockFromName("${value}"));
        }
    <#elseif value?has_content && !value?starts_with("TAG:") && !value?starts_with("#")>
        net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", ${value?split("#")[0]});
    </#if>
</#macro>

<#macro registerItemTagEntry entry oreName>
    <#assign value = entry.name()>
    <#if value?starts_with("CUSTOM:")>
        <#assign element = w.getWorkspace().getModElementByName(value?replace("CUSTOM:", ""))>
        <#if element??>
            <#if element.getTypeString() == "block">
                <#if element.getGeneratableElement().hasBlockItem>
        net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", new net.minecraft.item.ItemStack(${package}.init.${JavaModName}Items.${element.getRegistryNameUpper()}_ITEM));
                </#if>
            <#elseif element.getTypeString() == "item">
        net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", new net.minecraft.item.ItemStack(${package}.init.${JavaModName}Items.${element.getRegistryNameUpper()}));
            </#if>
        </#if>
    <#elseif value?starts_with("EXTERNAL:")>
        <#assign lookup = registryNameFor(value)>
        if (net.minecraft.item.Item.getByNameOrId("${lookup}") != null) {
            net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", net.minecraft.item.Item.getByNameOrId("${lookup}"));
        }
    <#elseif value?contains(":")>
        if (net.minecraft.item.Item.getByNameOrId("${value}") != null) {
            net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", net.minecraft.item.Item.getByNameOrId("${value}"));
        }
    <#elseif value?has_content && !value?starts_with("TAG:") && !value?starts_with("#")>
        net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", ${mappedMCItemToItemStackCode(w.itemBlock(value), 1)});
    </#if>
</#macro>
