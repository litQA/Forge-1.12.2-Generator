<#include "/aiconditions.java.ftl">
this.targetTasks.addTask(${cbi+1}, new EntityAINearestAttackableTarget(this, ${generator.map(field$entity, "entities")}.class, ${field$insight?lower_case}, ${field$nearby?lower_case})<@conditionCode field$condition/>);

