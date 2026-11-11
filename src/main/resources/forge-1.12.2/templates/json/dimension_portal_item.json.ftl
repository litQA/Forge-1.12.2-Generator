<#function itemTex holder="">
	<#if holder?is_hash && !holder.isEmpty()>
		<#return holder.format("%s:items/%s")>
	</#if>
	<#return "minecraft:items/flint_and_steel">
</#function>
{
    "parent": "item/generated",
    "textures": {
        "layer0": "${itemTex(data.texture!"")}"
    }
}
