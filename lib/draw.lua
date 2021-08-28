local Draw = {}

function Draw(img, x, y, scale, angle)
  love.graphics.draw(img, x, y, angle, scale, scale, img:getWidth() / 2, img:getHeight() / 2)
end

return Draw