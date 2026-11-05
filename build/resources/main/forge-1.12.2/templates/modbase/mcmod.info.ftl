<#-- @formatter:off -->
[{
    "modid": "${settings.getModID()?json_string}",
    "name": "${settings.getModName()?json_string}",
    "description": "${(settings.getDescription()!"")?json_string}",
    "version": "${settings.getVersion()?json_string}",
    "credits": "${(settings.getCredits()!"")?json_string}",
    <#if settings.getModPicture()??>
    "logoFile": "assets/${modid}/textures/${settings.getModPicture()?json_string}.png",
    <#else>
    "logoFile": "",
    </#if>
    "mcversion": "1.12.2",
    "url": "${(settings.getWebsiteURL()!"")?json_string}",
    "updateUrl": "${(settings.getUpdateURL()!"")?json_string}",
    <#if settings.getAuthor()?has_content>
    "authorList": ["${settings.getAuthor()?json_string}"],
    </#if>
    "dependencies": [
        "forge@[${generator.getGeneratorBuildFileVersion()}]"<#if settings.getDependencies()?has_content>,</#if>
        <#list settings.getDependencies() as dependency>
        "${dependency?json_string}"<#if dependency?has_next>,</#if>
        </#list>
    ],
    "dependants": [
        <#list settings.getDependants() as dependant>
        "${dependant?json_string}"<#if dependant?has_next>,</#if>
        </#list>
    ],
    "requiredMods": [
        <#list settings.getRequiredMods() as requiredMod>
        "${requiredMod?json_string}"<#if requiredMod?has_next>,</#if>
        </#list>
    ],
    "useDependencyInformation": "true"
}]
<#-- @formatter:on -->
