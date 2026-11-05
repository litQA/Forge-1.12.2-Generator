{
    "parent": "block/cube",
    "textures": {
        "particle": "${data.getParticleTexture(data.texture).format("%s:blocks/%s")}",
        "down": "${data.texture.format("%s:blocks/%s")}",
        "up": "${data.textureTop().format("%s:blocks/%s")}",
        "north": "${data.textureFront().format("%s:blocks/%s")}",
        "south": "${data.textureBack().format("%s:blocks/%s")}",
        "east": "${data.textureRight().format("%s:blocks/%s")}",
        "west": "${data.textureLeft().format("%s:blocks/%s")}"
    }
}
