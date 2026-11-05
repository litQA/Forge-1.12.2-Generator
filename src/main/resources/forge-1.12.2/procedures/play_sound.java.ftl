world.playSound(null, ${input$x}, ${input$y}, ${input$z},
    net.minecraft.util.SoundEvent.REGISTRY.getObject(new net.minecraft.util.ResourceLocation("${generator.map(field$sound, "sounds")?replace("CUSTOM:", "${modid}:")}")),
    net.minecraft.util.SoundCategory.NEUTRAL, (float) ${input$level}, (float) ${input$pitch});
