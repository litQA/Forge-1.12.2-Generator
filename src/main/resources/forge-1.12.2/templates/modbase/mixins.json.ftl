{
    "required": true,
    "minVersion": "0.7.11",
    "package": "${package}.mixin",
    "compatibilityLevel": "JAVA_8",
    "refmap": "mixins.modid.refmap.json",
    "mixins": [
        <#if (biomes![])?has_content>"${JavaModName}WorldBiomeMixin"</#if>
    ],
    "client": [],
    "server": []
}
