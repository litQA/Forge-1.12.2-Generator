<#-- @formatter:off -->
<#function hasProcedure object="">
    <#if !object??>
        <#return false>
    <#elseif object?is_hash>
        <#-- MCreator procedure beans are exposed as hashes by the template wrapper. -->
        <#assign procedureName = (object.getName())!"" >
        <#return procedureName?has_content && procedureName != "null">
    <#elseif object?is_string>
        <#return object?has_content && object != "null">
    <#else>
        <#assign procedureName = (object.getName())!"" >
        <#return procedureName?has_content && procedureName != "null">
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

<#function hasReturnValueOf object type>
    <#if !hasProcedure(object)>
        <#return false>
    <#elseif object?is_string>
        <#assign procedureElement = (generator.getWorkspace().getModElementByName(object))!>
        <#if !procedureElement?has_content>
            <#return false>
        </#if>
        <#assign procedureObject = procedureElement.getGeneratableElement()>
        <#if type == "EnumActionResult" || type == "ActionResultType">
            <#-- Procedure return types are encoded in the Blockly XML; generatable elements do not expose them directly. -->
            <#return (procedureObject.procedurexml!"")?contains("ActionResultType")>
        </#if>
    <#else>
        <#assign procedureObject = object>
    </#if>
    <#if procedureObject.getReturnValueType??>
        <#return procedureObject.getReturnValueType(generator.getWorkspace()) == type>
    <#else>
        <#return false>
    </#if>
</#function>

<#macro procedureOBJToCode object="">
    <#if hasProcedure(object)>
        <#if object?is_hash>
            <@procedureToCode name=object.getName() dependencies=object.getDependencies(generator.getWorkspace())/>
        <#elseif object?is_string>
            <#assign procedureElement = (generator.getWorkspace().getModElementByName(object))!>
            <#if procedureElement?has_content>
                <@procedureToCode name=object dependencies=procedureElement.getGeneratableElement().getDependencies()/>
            </#if>
        </#if>
    </#if>
</#macro>

<#macro procedureOBJToCodeWithTarget object="">
    <#if hasProcedure(object)>
        <#if object?is_hash>
            <#assign values = {}>
            <#assign values += {"entity": "target"}>
            <@procedureCode object=object customVals=values/>
        <#elseif object?is_string>
            <#assign procedureElement = (generator.getWorkspace().getModElementByName(object))!>
            <#if procedureElement?has_content>
                <#assign values = {}>
                <#assign values += {"entity": "target"}>
                <@procedureToCode name=object dependencies=procedureElement.getGeneratableElement().getDependencies() customVals=values/>
            </#if>
        </#if>
    </#if>
</#macro>

<#macro procedureOBJToConditionCode object="">
    <#if hasProcedure(object)>
        <#if object?is_hash>
            <@procedureToRetvalCode name=object.getName() dependencies=object.getDependencies(generator.getWorkspace())/>
        <#elseif object?is_string>
            <#assign procedureElement = (generator.getWorkspace().getModElementByName(object))!>
            <#if procedureElement?has_content>
                <@procedureToRetvalCode name=object dependencies=procedureElement.getGeneratableElement().getDependencies()/>
            <#else>
                true
            </#if>
        </#if>
    <#else>
        true
    </#if>
</#macro>

<#macro procedureOBJToConditionCodeWithStack object="">
    <#if hasProcedure(object)>
        <#if object?is_hash>
            <#assign values = {}>
            <#assign values += {"itemstack": "stack"}>
            <@procedureToRetvalCode name=object.getName() dependencies=object.getDependencies(generator.getWorkspace()) customVals=values/>
        <#elseif object?is_string>
            <#assign procedureElement = (generator.getWorkspace().getModElementByName(object))!>
            <#assign values = {}>
            <#assign values += {"itemstack": "stack"}>
            <#if procedureElement?has_content>
                <@procedureToRetvalCode name=object dependencies=procedureElement.getGeneratableElement().getDependencies() customVals=values/>
            <#else>
                true
            </#if>
        </#if>
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

<#-- Executes a procedure with explicit dependency expressions. Used by entity, GUI
     and projectile templates where the standard dependency names are not enough. -->
<#macro procedureCode object="" customVals={}>
    <#if hasProcedure(object) && object?is_hash>
        <@procedureToCode name=object.getName() dependencies=object.getDependencies(generator.getWorkspace()) customVals=customVals/>
    </#if>
</#macro>

<#macro procedureOBJToStringCode object="">
    <#if hasProcedure(object) && object?is_hash && object.getDependencies??>
        (String) <@procedureToRetvalCode name=object.getName() dependencies=object.getDependencies(generator.getWorkspace())/>
    <#else>
        ""
    </#if>
</#macro>

<#macro procedureOBJToInteractionResultCode object="">
    <#if hasReturnValueOf(object, "EnumActionResult") || hasReturnValueOf(object, "ActionResultType")>
        <#if object?is_hash>
            (EnumActionResult) <@procedureToRetvalCode name=object.getName() dependencies=object.getDependencies(generator.getWorkspace())/>
        <#elseif object?is_string>
            <#assign procedureElement = (generator.getWorkspace().getModElementByName(object))!>
            (EnumActionResult) <@procedureToRetvalCode name=object dependencies=procedureElement.getGeneratableElement().getDependencies()/>
        </#if>
    <#else>
        EnumActionResult.PASS
    </#if>
</#macro>
<#-- @formatter:on -->
