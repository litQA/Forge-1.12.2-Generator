<#if (data.tameable && data.breedable)>
<#include "/aiconditions.java.ftl">
this.tasks.addTask(${cbi+1}, new EntityAIOwnerHurtTarget(this)<@conditionCode field$condition/>);
</#if>

