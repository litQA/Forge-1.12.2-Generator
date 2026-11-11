<#if (data.tameable && data.breedable)>
<#include "/aiconditions.java.ftl">
this.tasks.addTask(${cbi+1}, new EntityAIOwnerHurtByTarget(this)<@conditionCode field$condition/>);
</#if>

