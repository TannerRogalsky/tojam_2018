local function getPieceAt(player, grid, x, y)
  for i, piece in ipairs(player.pieces) do
    if x == piece.x and y == piece.y then
      return piece, i
    end
  end
end

return getPieceAt
