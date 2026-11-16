<#assign soundName = generator.map(field$sound, "sounds")?replace("CUSTOM:", "${modid}:")>
<#if soundName?has_content>
world.playSound(null, ${input$x}, ${input$y}, ${input$z},
    net.minecraft.util.SoundEvent.REGISTRY.getObject(new net.minecraft.util.ResourceLocation("${soundName}")),
    net.minecraft.util.SoundCategory.NEUTRAL, (float) ${input$level}, (float) ${input$pitch});
</#if>
