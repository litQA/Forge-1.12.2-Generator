<#include "/aiconditions.java.ftl">
this.tasks.addTask(${cbi+1}, new EntityAIAttackMelee(this, ${field$speed}, ${field$longmemory?lower_case}) {

	@Override protected double getAttackReachSqr(EntityLivingBase entity) {
		return ${field$range?number * field$range?number};
	}

	<@conditionCode field$condition false/>
});

