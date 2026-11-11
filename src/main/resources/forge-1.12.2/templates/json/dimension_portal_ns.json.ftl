<#function portalTex holder="">
	<#if holder?is_hash && !holder.isEmpty()>
		<#return holder.format("%s:blocks/%s")>
	</#if>
	<#return "minecraft:blocks/portal">
</#function>
<#assign portalTexturePath = portalTex(data.portalTexture!"")>
{
    "textures": {
        "particle": "${portalTexturePath}",
        "portal": "${portalTexturePath}"
    },
    "elements": [
        {
            "from": [0, 0, 6],
            "to": [16, 16, 10],
            "faces": {
                "north": {"uv": [0, 0, 16, 16], "texture": "#portal"},
                "south": {"uv": [0, 0, 16, 16], "texture": "#portal"}
            }
        }
    ]
}
