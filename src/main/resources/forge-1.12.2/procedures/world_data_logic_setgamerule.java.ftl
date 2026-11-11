if (!world.isRemote)
	world.getGameRules().setOrCreateGameRule(${generator.map(field$gamerulesboolean, "gamerules")}, String.valueOf(${input$gameruleValue}));
