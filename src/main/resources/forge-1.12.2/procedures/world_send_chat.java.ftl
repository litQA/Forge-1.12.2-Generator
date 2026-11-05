if (world.getMinecraftServer() != null) {
    world.getMinecraftServer().getPlayerList().sendMessage(new net.minecraft.util.text.TextComponentString(${input$text}));
}
