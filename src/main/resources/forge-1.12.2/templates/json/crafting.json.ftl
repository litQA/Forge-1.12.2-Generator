<#include "/mcitems.ftl">
{
    "group": "${(data.group!"")?json_string}",
<#if data.recipeShapeless>
    "type": "minecraft:crafting_shapeless",
    "ingredients": [
        <#assign first = true>
        <#list data.recipeSlots as slot>
        <#if slot?? && !slot.isEmpty()>
        <#if !first>,</#if>{
            ${mappedMCItemToIngameItemName(slot)}
        }
        <#assign first = false>
        </#if>
        </#list>
    ],
<#else>
    <#assign recipeArray = data.getOptimisedRecipe()>
    <#assign keyEntries = [], index = 0>
    "type": "minecraft:crafting_shaped",
    "pattern": [
        <#list recipeArray as row>
        "<#list row as slot><#if slot?? && !slot.isEmpty()><#assign keyEntries += ["\"" + index + "\": {" + mappedMCItemToIngameItemName(slot) + "}"]>${index}<#else> </#if><#assign index = index + 1></#list>"<#if row?has_next>,</#if>
        </#list>
    ],
    "key": {
        <#list keyEntries as keyEntry>
        ${keyEntry}<#if keyEntry?has_next>,</#if>
        </#list>
    },
</#if>
    "result": {
        ${mappedMCItemToIngameItemName(data.recipeReturnStack)},
        "count": ${data.recipeRetstackSize}
    }
}
