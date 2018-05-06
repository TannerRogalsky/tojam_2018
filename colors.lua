local colorsByName = {
  Purple = { 0xd5 / 0xff, 0x42 / 0xff, 0xc2 / 0xff, 1 },
  -- Brown = { 0xd0 / 0xff, 0x64 / 0xff, 0x14 / 0xff, 1 },
  Blue = { 0x1b / 0xff, 0xa9 / 0xff, 0xeb / 0xff, 1 },
  Pink = { 0xf3 / 0xff, 0x2f / 0xff, 0x74 / 0xff, 1 },
  Green = { 0x23 / 0xff, 0xc7 / 0xff, 0x1b / 0xff, 1 },
  Yellow = { 0xff / 0xff, 0xca / 0xff, 0x27 / 0xff, 1 },
  Orange = { 0xff / 0xff, 0x86 / 0xff, 0x25 / 0xff, 1 },
  Red = { 0xe8 / 0xff, 0x26 / 0xff, 0x11 / 0xff, 1 },
}

local namesByColors = {}
for k,v in pairs(colorsByName) do
  namesByColors[v] = k
end

local colors = {}
for _,v in pairs(colorsByName) do
  table.insert(colors, v)
end

return {
  colors = colors,
  namesByColors = namesByColors,
  colorsByName = colorsByName,
}
