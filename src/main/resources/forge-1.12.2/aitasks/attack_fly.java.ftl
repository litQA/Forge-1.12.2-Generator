<#include "/aiconditions.java.ftl">
this.tasks.addTask(${cbi+1}, new EntityAIBase() {
	{
		this.setMutexBits(1);
	}

	@Override public boolean shouldExecute() {
		return ${name}Entity.this.getAttackTarget() != null && !${name}Entity.this.getMoveHelper().isUpdating();
	}

	@Override public boolean shouldContinueExecuting() {
		return ${name}Entity.this.getMoveHelper().isUpdating() && ${name}Entity.this.getAttackTarget() != null && ${name}Entity.this.getAttackTarget().isEntityAlive();
	}

	@Override public void startExecuting() {
		EntityLivingBase livingentity = ${name}Entity.this.getAttackTarget();
		Vec3d vec3d = livingentity.getPositionEyes(1);
		${name}Entity.this.getMoveHelper().setMoveTo(vec3d.x, vec3d.y, vec3d.z, ${field$speed});
	}

	@Override public void updateTask() {
		EntityLivingBase livingentity = ${name}Entity.this.getAttackTarget();
		double d0 = ${name}Entity.this.getDistanceSq(livingentity);
		if (d0 <= getAttackReachSq(livingentity)) {
			${name}Entity.this.attackEntityAsMob(livingentity);
		} else if (d0 < ${field$radius}) {
			Vec3d vec3d = livingentity.getPositionEyes(1);
			${name}Entity.this.getMoveHelper().setMoveTo(vec3d.x, vec3d.y, vec3d.z, ${field$speed});
		}
	}

	protected double getAttackReachSq(EntityLivingBase attackTarget) {
		return ${name}Entity.this.width * 1.5 * ${name}Entity.this.height * 1.5 + attackTarget.height;
	}

	<@conditionCode field$condition false/>
});

