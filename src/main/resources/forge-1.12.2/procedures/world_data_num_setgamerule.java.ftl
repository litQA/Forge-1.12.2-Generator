if (!world.isRemote)
	world.getGameRules().setOrCreateGameRule(${generator.map(field$gamerulesnumber, "gamerules")}, Integer.toString(${opt.toInt(input$gameruleValue)}));
