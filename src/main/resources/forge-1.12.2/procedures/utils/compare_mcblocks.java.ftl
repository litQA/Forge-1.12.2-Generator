private static boolean compareBlocks(IBlockState a, IBlockState b) {
    Block aBlock = a.getBlock(), bBlock = b.getBlock();
    try {
      return (aBlock == bBlock) && (aBlock.getMetaFromState(a) == bBlock.getMetaFromState(b));
    } catch(Exception e) {
      return (aBlock == bBlock);
    }
}