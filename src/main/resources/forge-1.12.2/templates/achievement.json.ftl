<#-- @formatter:off -->
<#include "/mcitems.ftl">
<#assign hasParent = data.parent?has_content && data.parent != "none" && !data.parent.toString().contains("@")>
{
	<#if !data.disableDisplay>
	"display": {
		<#if !hasParent>
		"background": <#if !data.background?has_content || data.background == "Default">"minecraft:textures/blocks/stone.png"<#else>"${modid}:textures/screens/${data.background}"</#if>,
		</#if>
		"icon": ${mappedMCItemToItemObjectJSON(data.achievementIcon)},
		"title": {
			"translate": "advancements.${registryname}.title"
		},
		"description": {
			"translate": "advancements.${registryname}.descr"
		},
		"frame": "${data.achievementType}",
		"show_toast": ${data.showPopup?c},
		"announce_to_chat": ${data.announceToChat?c},
		"hidden": ${data.hideIfNotCompleted?c}
	},
	</#if>
	"criteria": {
		${triggercode?keep_before_last(",")}
	}
	<#if data.hasRewards()>,
	"rewards": {
		"experience": ${data.rewardXP?c}
		<#if data.rewardFunction?has_content>,
		"function": "${generator.getResourceLocationForModElement(data.rewardFunction)}"
		</#if>
		<#if data.rewardLoot?has_content>,
		"loot": [
			<#list data.rewardLoot as value>"${generator.getResourceLocationForModElement(value)}"<#sep>,</#list>
		]
		</#if>
		<#if data.rewardRecipes?has_content>,
		"recipes": [
			<#list data.rewardRecipes as value>"${generator.getResourceLocationForModElement(value)}"<#sep>,</#list>
		]
		</#if>
	}
	</#if>
	<#if hasParent>,
	"parent": "${data.parent}"
	</#if>
}
<#-- @formatter:on -->
