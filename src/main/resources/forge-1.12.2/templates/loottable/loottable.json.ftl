<#-- @formatter:off -->
<#include "/mcitems.ftl">
{
    "pools": [
        <#list data.pools as pool>
        {
            <#if pool.minrolls == pool.maxrolls>
            "rolls": ${pool.minrolls},
            <#else>
            "rolls": {
                "min": ${pool.minrolls},
                "max": ${pool.maxrolls}
            },
            </#if>
            <#if pool.hasbonusrolls>
            <#if pool.minbonusrolls == pool.maxbonusrolls>
            "bonus_rolls": ${pool.minbonusrolls},
            <#else>
            "bonus_rolls": {
                "min": ${pool.minbonusrolls},
                "max": ${pool.maxbonusrolls}
            },
            </#if>
            </#if>
            "entries": [
                <#list pool.entries as entry>
                {
                    <#assign item = mappedMCItemToRegistryName(entry.item)>
                    <#if entry.item.isAir() || item == "minecraft:air">
                    "type": "empty",
                    <#else>
                    "type": "${entry.type}",
                    "name": "${item}",
                    </#if>
                    "weight": ${entry.weight},
                    "functions": [
                        {
                            "function": "set_count",
                            <#if entry.minCount == entry.maxCount>
                            "count": ${entry.minCount}
                            <#else>
                            "count": {
                                "min": ${entry.minCount},
                                "max": ${entry.maxCount}
                            }
                            </#if>
                        }
                        <#if entry.minEnchantmentLevel != 0 || entry.maxEnchantmentLevel != 0>
                        ,{
                            "function": "enchant_with_levels",
                            "treasure": true,
                            "levels": {
                                "min": ${entry.minEnchantmentLevel},
                                "max": ${entry.maxEnchantmentLevel}
                            }
                        }
                        </#if>
                    ]
                }<#if entry?has_next>,</#if>
                </#list>
            ]
        }<#if pool?has_next>,</#if>
        </#list>
    ]
}
<#-- @formatter:on -->
