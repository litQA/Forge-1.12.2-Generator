if (entity instanceof net.minecraft.entity.player.EntityPlayerMP) {
    ((net.minecraft.entity.player.EntityPlayerMP) entity).sendStatusMessage(new net.minecraft.util.text.TextComponentString(${input$text}), ${input$actbar});
}
