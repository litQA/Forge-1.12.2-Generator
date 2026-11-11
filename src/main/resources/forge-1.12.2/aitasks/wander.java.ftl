<#include "/aiconditions.java.ftl">
this.tasks.addTask(${cbi+1}, new EntityAIWander(this, ${field$speed})<@conditionCode field$condition/>);

