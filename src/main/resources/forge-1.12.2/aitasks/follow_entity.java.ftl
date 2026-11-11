<#include "/aiconditions.java.ftl">
<#if !data.waterMob || data.flyingMob>
this.tasks.addTask(${cbi+1}, new EntityAIFollow(this, ${field$speed}, (float) ${field$maxrange}, (float) ${field$followarea})<@conditionCode field$condition/>);
</#if>

