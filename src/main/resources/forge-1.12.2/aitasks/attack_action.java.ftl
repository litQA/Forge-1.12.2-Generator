<#include "/aiconditions.java.ftl">
this.targetTasks.addTask(${cbi+1}, new EntityAIHurtByTarget(this, ${field$callhelp?lower_case})<@conditionCode field$condition/>);

