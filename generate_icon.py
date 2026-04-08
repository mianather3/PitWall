from PIL import Image, ImageDraw

size = 1024
img = Image.new('RGB', (size, size), '#0a0a0a')
draw = ImageDraw.Draw(img)

# Red background circle
draw.ellipse([62, 62, 962, 962], fill='#e8002d')

# Black inner circle
draw.ellipse([112, 112, 912, 912], fill='#0a0a0a')

# Draw checkered flag pattern - centered
square = 80
cols = 6
rows = 6
total_w = cols * square
total_h = rows * square
start_x = (size - total_w) // 2
start_y = (size - total_h) // 2

for row in range(rows):
    for col in range(cols):
        x = start_x + col * square
        y = start_y + row * square
        if (row + col) % 2 == 0:
            draw.rectangle([x, y, x+square, y+square], fill='white')

img.save('pitwall_icon.png')
print("Icon generated!")
