return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "1.1.5",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 5,
  height = 5,
  tilewidth = 256,
  tileheight = 256,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "birds",
      firstgid = 1,
      filename = "../scenarios/birds.tsx",
      tilewidth = 256,
      tileheight = 256,
      spacing = 0,
      margin = 0,
      image = "../images/birds.png",
      imagewidth = 774,
      imageheight = 774,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 256,
        height = 256
      },
      properties = {},
      terrains = {},
      tilecount = 9,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 5,
      height = 5,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 2, 0, 0, 0,
        0, 0, 2, 0, 0,
        0, 0, 2, 0, 0,
        0, 0, 0, 0, 0,
        0, 0, 0, 0, 0
      }
    }
  }
}
