<#include "/procedures.ftl">
<#-- @formatter:off -->
<#--
  Adds optional AI task start/continue conditions to an anonymous EntityAIBase.
  The condition string is the standard MCreator "start,continue" pair.
-->
<#macro conditionCode conditionfield="" includeBrackets=true>
    <#if conditionfield?has_content>
        <#assign conditions = generator.procedureNamesToObjects(conditionfield)>
        <#if hasProcedure(conditions[0]) || hasProcedure(conditions[1])>
            <#if includeBrackets>{</#if>
                <#if hasProcedure(conditions[0])>
                @Override public boolean shouldExecute() {
                    double x = ${name}Entity.this.posX;
                    double y = ${name}Entity.this.posY;
                    double z = ${name}Entity.this.posZ;
                    Entity entity = ${name}Entity.this;
                    World world = ${name}Entity.this.world;
                    return super.shouldExecute() && <@procedureOBJToConditionCode conditions[0]/>;
                }
                </#if>
                <#if hasProcedure(conditions[1])>
                @Override public boolean shouldContinueExecuting() {
                    double x = ${name}Entity.this.posX;
                    double y = ${name}Entity.this.posY;
                    double z = ${name}Entity.this.posZ;
                    Entity entity = ${name}Entity.this;
                    World world = ${name}Entity.this.world;
                    return super.shouldContinueExecuting() && <@procedureOBJToConditionCode conditions[1]/>;
                }
                </#if>
            <#if includeBrackets>}</#if>
        </#if>
    </#if>
</#macro>
<#-- @formatter:on -->

