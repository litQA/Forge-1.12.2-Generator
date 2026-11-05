{
    "parent": "item/generated",
    "textures": {
        "layer0": "${(data.textureBucket?? && !data.textureBucket.isEmpty())?then(data.textureBucket.format("%s:items/%s"), modid + ":items/" + registryname + "_bucket")}"
    }
}
