{
    "parent": "item/handheld",
    "textures": {
        "layer0": "${data.texture.format("%s:items/%s")}"
    }<#if data.toolType == "Shield">,
    "overrides": [
        {
            "predicate": {
                "blocking": 1
            },
            "model": "${modid}:item/${registryname}_0"
        }
    ]</#if>
}
