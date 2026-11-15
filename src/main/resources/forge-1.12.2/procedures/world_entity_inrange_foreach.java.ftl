{
	final Vec3d _center = new Vec3d(${input$x}, ${input$y}, ${input$z});
	for (Entity entityiterator : world.getEntitiesWithinAABB(Entity.class, new AxisAlignedBB(_center, _center).grow(${input$range} / 2d), e -> true)
		.stream().sorted(Comparator.comparingDouble((Entity _entcnd) -> _entcnd.getDistanceSq(_center.x, _center.y, _center.z))).collect(Collectors.toList())) {
		${statement$foreach}
	}
}