{
    <#if parent?? && parent.hasGUITexture?? && parent.hasGUITexture()><#assign guiTexture = parent.guiTexture><#elseif data.guiTexture??><#assign guiTexture = data.guiTexture></#if>
    <#if guiTexture?has_content>
    "loader": "forge:separate-perspective",
    "base": { <@modelDefinition/> },
    "perspectives": {
        "gui": {
            "parent": "item/generated",
            "textures": {
                "layer0": "${guiTexture.format("%s:items/%s")}"
            }
        },
        "fixed": {
            "parent": "item/generated",
            "textures": {
                "layer0": "${guiTexture.format("%s:items/%s")}"
            }
        },
        "ground": {
            "parent": "item/generated",
            "textures": {
                "layer0": "${guiTexture.format("%s:items/%s")}"
            }
        }
    }
    <#else>
    <@modelDefinition/>
    </#if>
    <#macro modelDefinition>
    <#if var_item??> <#-- used by armor where item type is specified (helmet, body, ...) -->
    "parent": "${modid}:custom/${data.getItemCustomModelNameFor(var_item)}",
    "textures": {
      <@textures data.getItemModelTextureMap(var_item)/>
      "particle": "${data.getItemTextureFor(var_item).format("%s:items/%s")}"
    }
    <#else>
    "parent": "${modid}:custom/${data.customModelName.split(":")[0]}",
    "textures": {
      <@textures data.getTextureMap()/>
      "particle": "${data.texture.format("%s:items/%s")}"
    }
    </#if>
    </#macro>
    <#if data.getModels?? && data.getModels()?has_content>,
    "overrides": [
        <#list data.getModels() as model>
        {
            "predicate": {
                <#list model.stateMap.keySet() as property>
                    <#assign value = model.stateMap.get(property)>
                    "${generator.map(property.getPrefixedName(registryname + "_"), "itemproperties")}": ${value?is_boolean?then(value?then("1", "0"), value)}<#sep>,
                </#list>
            },
            "model": "${modid}:item/${registryname}_${model?index}"
        }<#sep>,
        </#list>
    ]
    </#if>
}

<#macro textures textureMap>
    <#if textureMap??>
        <#list textureMap.entrySet() as texture>
            "${texture.getKey()}": "${texture.getValue().format("%s:blocks/%s")}",
        </#list>
    </#if>
</#macro>