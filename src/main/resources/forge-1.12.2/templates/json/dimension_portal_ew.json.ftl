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
            "from": [6, 0, 0],
            "to": [10, 16, 16],
            "faces": {
                "east": {"uv": [0, 0, 16, 16], "texture": "#portal"},
                "west": {"uv": [0, 0, 16, 16], "texture": "#portal"}
            }
        }
    ]
}
