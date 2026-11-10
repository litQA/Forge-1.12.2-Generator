<#-- @formatter:off -->
<#function hasProcedure object="">
    <#if !object??>
        <#return false>
    <#elseif object?is_string>
        <#return object?has_content && object != "null">
    <#else>
        <#return object.getName() != "null">
    </#if>
</#function>

<#macro procedureToCode name dependencies customVals={}>
{
    java.util.Map<String, Object> $_dependencies = new java.util.HashMap<>();
    <#list dependencies as dependency>
        <#if !customVals[dependency.getName()]??>
    $_dependencies.put("${dependency.getName()}", ${dependency.getName()});
        </#if>
    </#list>
    <#list customVals as key, value>
    $_dependencies.put("${key}", ${value});
    </#list>
    ${package}.procedures.${name}Procedure.executeProcedure($_dependencies);
}
</#macro>

<#macro procedureOBJToCode object="">
    <#if hasProcedure(object) && object?is_hash>
        <@procedureToCode name=object.getName() dependencies=object.getDependencies(generator.getWorkspace())/>
    </#if>
</#macro>

<#macro procedureOBJToConditionCode object="">
    <#if hasProcedure(object) && object?is_hash>
        <@procedureToRetvalCode name=object.getName() dependencies=object.getDependencies(generator.getWorkspace())/>
    <#else>
        true
    </#if>
</#macro>

<#macro procedureToRetvalCode name dependencies customVals={}>
    <#assign depsBuilder = []>
    <#list dependencies as dependency>
        <#if !customVals[dependency.getName()]??>
            <#assign depsBuilder += [dependency.getName()]>
        </#if>
    </#list>
    ${package}.procedures.${name}Procedure.executeProcedure(com.google.common.collect.ImmutableMap.<String, Object>builder()
        <#list dependencies as dependency>
            <#if !customVals[dependency.getName()]??>
        .put("${dependency.getName()}", ${dependency.getName()})
            </#if>
        </#list>
        <#list customVals as key, value>
        .put("${key}", ${value})
        </#list>
        .build())
</#macro>

<#macro procedureOBJToRetvalCode object="">
    <#if hasProcedure(object) && object?is_hash>
        <@procedureToRetvalCode name=object.getName() dependencies=object.getDependencies(generator.getWorkspace())/>
    </#if>
</#macro>

<#macro procedureOBJToNumberCode object="">
    <#if hasProcedure(object) && object?is_hash && object.getDependencies??>
        ((Number) <@procedureToRetvalCode name=object.getName() dependencies=object.getDependencies(generator.getWorkspace())/>).doubleValue()
    <#elseif object??>
        ${(object.getFixedValue())?c}
    <#else>
        0
    </#if>
</#macro>

<#macro procedureOBJToItemstackCode object="">
    <#if hasProcedure(object) && object?is_hash && object.getDependencies??>
        (ItemStack) <@procedureToRetvalCode name=object.getName() dependencies=object.getDependencies(generator.getWorkspace())/>
    <#else>
        ItemStack.EMPTY
    </#if>
</#macro>
<#-- @formatter:on -->
