<#include "mcitems.ftl">
<#--
  Converts MCreator tag elements to Forge 1.12.2 ore dictionary names and
  registration code. 1.12.2 has no tag registry, so the tag UI is kept for
  familiarity while the generated backend uses the ore dictionary.
-->
<#function oreDictionaryName tag>
    <#assign namespace = tag.getMinecraftNamespace(w.getWorkspace())>
    <#assign name = tag.getName()>

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

<#function resolveTagPath path>
    <#list w.getWorkspace().getTagElements().entrySet() as tagEntry>
        <#assign tag = tagEntry.getKey()>
        <#assign minecraftPath = tag.getMinecraftNamespace(w.getWorkspace()) + ":" + tag.getName()>
        <#if minecraftPath == path || tag.resourcePath() == path>
            <#return minecraftPath>
        </#if>
    </#list>
    <#return path>
</#function>

<#function findTagElement path type="">
    <#assign resolvedPath = resolveTagPath(path)>
    <#list w.getWorkspace().getTagElements().entrySet() as tagEntry>
        <#assign tag = tagEntry.getKey()>
        <#if (type == "" || tag.type().name() == type)
                && ((tag.getMinecraftNamespace(w.getWorkspace()) + ":" + tag.getName()) == resolvedPath || tag.resourcePath() == path)>
            <#return tag>
        </#if>
    </#list>
    <#return "">
</#function>

<#function tagEntriesFor tag>
    <#list w.getWorkspace().getTagElements().entrySet() as tagEntry>
        <#if tagEntry.getKey() == tag>
            <#return tagEntry.getValue()>
        </#if>
    </#list>
    <#return []>
</#function>

<#function collectTagEntries tag visited="">
    <#assign result = []>
    <#assign tagPath = tag.getMinecraftNamespace(w.getWorkspace()) + ":" + tag.getName()>
    <#if visited?contains("|" + tagPath + "|")>
        <#return result>
    </#if>
    <#assign nextVisited = visited + "|" + tagPath + "|">
    <#list tagEntriesFor(tag) as entry>
        <#if entry.name()?starts_with("TAG:")>
            <#assign child = findTagElement(entry.name()?remove_beginning("TAG:"), tag.type().name())>
            <#if child?has_content>
                <#assign result = result + collectTagEntries(child, nextVisited)>
            </#if>
        <#else>
            <#assign result = result + [entry]>
        </#if>
    </#list>
    <#return result>
</#function>

<#function tagNameToOreDictionary path>
    <#if !path?contains(":")>
        <#assign path = "minecraft:" + path>
    </#if>
    <#assign path = resolveTagPath(path)>
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

<#function classConstantToRegistry value>
    <#assign path = value?keep_before("#")>
    <#return "minecraft:" + path?keep_after(".")?lower_case>
</#function>

<#macro registerBlockTagEntry entry oreName>
    <#assign value = entry.name()>
    <#if value?starts_with("CUSTOM:")>
        <#assign element = (w.getWorkspace().getModElementByName(value?replace("CUSTOM:", "")))!>
        <#if element?has_content && (element.getTypeString() == "block" || element.getTypeString() == "plant" || element.getTypeString() == "fluid")>
        if (net.minecraft.item.Item.getItemFromBlock(${package}.init.${JavaModName}Blocks.${element.getRegistryNameUpper()}) != net.minecraft.init.Items.AIR) {
            net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", ${package}.init.${JavaModName}Blocks.${element.getRegistryNameUpper()});
        }
        <#else>
        // Unsupported custom block tag entry: ${value}
        </#if>
    <#elseif value?starts_with("EXTERNAL:")>
        <#assign lookup = registryNameFor(value)>
        if (net.minecraft.block.Block.getBlockFromName("${lookup}") != null
                && net.minecraft.item.Item.getItemFromBlock(net.minecraft.block.Block.getBlockFromName("${lookup}")) != net.minecraft.init.Items.AIR) {
            net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", net.minecraft.block.Block.getBlockFromName("${lookup}"));
        }
    <#elseif value?starts_with("TAG:")>
        // Nested tags are not supported by the 1.12.2 Ore Dictionary: ${value}
    <#elseif value?contains(":")>
        if (net.minecraft.block.Block.getBlockFromName("${value}") != null
                && net.minecraft.item.Item.getItemFromBlock(net.minecraft.block.Block.getBlockFromName("${value}")) != net.minecraft.init.Items.AIR) {
            net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", net.minecraft.block.Block.getBlockFromName("${value}"));
        }
    <#elseif value?starts_with("Blocks.")>
        <#assign lookup = classConstantToRegistry(value)>
        if (net.minecraft.block.Block.getBlockFromName("${lookup}") != null
                && net.minecraft.item.Item.getItemFromBlock(net.minecraft.block.Block.getBlockFromName("${lookup}")) != net.minecraft.init.Items.AIR) {
            net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", net.minecraft.block.Block.getBlockFromName("${lookup}"));
        }
    <#elseif value?starts_with("Items.")>
        // Unsupported block tag entry: ${value}
    <#elseif value?has_content && !value?starts_with("TAG:") && !value?starts_with("#")>
        if (net.minecraft.item.Item.getItemFromBlock(${value?split("#")[0]}) != net.minecraft.init.Items.AIR) {
            net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", ${value?split("#")[0]});
        }
    <#else>
        // Unsupported block tag entry: ${value}
    </#if>
</#macro>

<#macro registerItemTagEntry entry oreName>
    <#assign value = entry.name()>
    <#if value?starts_with("CUSTOM:")>
        <#assign element = (w.getWorkspace().getModElementByName(value?replace("CUSTOM:", "")))!>
        <#if element?has_content>
            <#if element.getTypeString() == "block" || element.getTypeString() == "plant">
                <#if element.getGeneratableElement().hasBlockItem>
        net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", new net.minecraft.item.ItemStack(${package}.init.${JavaModName}Items.${element.getRegistryNameUpper()}_ITEM));
                </#if>
            <#elseif element.getTypeString() == "item" || element.getTypeString() == "tool" || element.getTypeString() == "specialentity">
        net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", new net.minecraft.item.ItemStack(${package}.init.${JavaModName}Items.${element.getRegistryNameUpper()}));
            <#elseif element.getTypeString() == "fluid">
                <#if element.getGeneratableElement().generateBucket>
        net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", new net.minecraft.item.ItemStack(${package}.init.${JavaModName}Items.${element.getRegistryNameUpper()}_BUCKET));
                </#if>
            <#elseif element.getTypeString() == "dimension">
                <#if element.getGeneratableElement().hasIgniter()>
        net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", new net.minecraft.item.ItemStack(${package}.init.${JavaModName}Items.${element.getRegistryNameUpper()}));
                </#if>
            <#elseif element.getTypeString() == "armor">
                <#if element.getGeneratableElement().enableHelmet>
        net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", new net.minecraft.item.ItemStack(${package}.init.${JavaModName}Items.${element.getRegistryNameUpper()}_HELMET));
                </#if>
                <#if element.getGeneratableElement().enableBody>
        net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", new net.minecraft.item.ItemStack(${package}.init.${JavaModName}Items.${element.getRegistryNameUpper()}_CHESTPLATE));
                </#if>
                <#if element.getGeneratableElement().enableLeggings>
        net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", new net.minecraft.item.ItemStack(${package}.init.${JavaModName}Items.${element.getRegistryNameUpper()}_LEGGINGS));
                </#if>
                <#if element.getGeneratableElement().enableBoots>
        net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", new net.minecraft.item.ItemStack(${package}.init.${JavaModName}Items.${element.getRegistryNameUpper()}_BOOTS));
                </#if>
            <#else>
        // Unsupported custom item tag entry: ${value}
            </#if>
        <#else>
        // Missing custom item tag entry: ${value}
        </#if>
    <#elseif value?starts_with("EXTERNAL:")>
        <#assign lookup = registryNameFor(value)>
        if (net.minecraft.item.Item.getByNameOrId("${lookup}") != null) {
            net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", net.minecraft.item.Item.getByNameOrId("${lookup}"));
        }
    <#elseif value?starts_with("TAG:")>
        // Nested tags are not supported by the 1.12.2 Ore Dictionary: ${value}
    <#elseif value?contains(":")>
        if (net.minecraft.item.Item.getByNameOrId("${value}") != null) {
            net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", net.minecraft.item.Item.getByNameOrId("${value}"));
        }
    <#elseif value?starts_with("Blocks.") || value?starts_with("Items.")>
        <#assign lookup = classConstantToRegistry(value)>
        if (net.minecraft.item.Item.getByNameOrId("${lookup}") != null) {
            net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", net.minecraft.item.Item.getByNameOrId("${lookup}"));
        }
    <#elseif value?has_content && !value?starts_with("TAG:") && !value?starts_with("#")>
        net.minecraftforge.oredict.OreDictionary.registerOre("${oreName}", ${mappedMCItemToItemStackCode(w.itemBlock(value), 1)});
    <#else>
        // Unsupported item tag entry: ${value}
    </#if>
</#macro>
