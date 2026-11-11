<#if !data.flyingMob && !data.waterMob>
<#include "/aiconditions.java.ftl">
this.tasks.addTask(${cbi+1}, new EntityAIOpenDoor(this, false)<@conditionCode field$condition/>);
</#if>

