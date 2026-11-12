{
	net.minecraft.entity.Entity _entity = ${input$entity};
	if (_entity != null) {
		_entity.attackEntityFrom(${input$damagesource}, ${opt.toFloat(input$amount)});
	}
}
