<#if !data.flyingMob && !data.waterMob>
<#include "/aiconditions.java.ftl">
this.tasks.addTask(${cbi+1}, new EntityAIBreakDoor(this)<@conditionCode field$condition/>);
</#if>

