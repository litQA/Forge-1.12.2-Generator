<#if data.breedable>
<#include "/aiconditions.java.ftl">
this.tasks.addTask(${cbi+1}, new EntityAIFollowParent(this, ${field$speed})<@conditionCode field$condition/>);
</#if>

