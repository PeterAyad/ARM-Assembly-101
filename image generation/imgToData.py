from PIL import Image
import os


def image_to_arm_asm(image_path, output_file, BGR=False):
    file_name = os.path.basename(image_path)
    var_name = os.path.splitext(file_name)[0]

    img = Image.open(image_path).convert("RGB")
    width, height = img.size

    # Convert image to RGB565 format (5 bits Red, 6 bits Green, 5 bits Blue)
    #  or BGR565 format (5 bits Blue, 6 bits Green, 5 bits Red)
    pixel_data = []
    for y in range(height):
        for x in range(width):
            r, g, b = img.getpixel((x, y))
            if BGR:
                bgr565 = ((b >> 3) << 11) | ((g >> 2) << 5) | (r >> 3)
                pixel_data.append(bgr565)
            else:
                rgb565 = ((r >> 3) << 11) | ((g >> 2) << 5) | (b >> 3)
                pixel_data.append(rgb565)

    with open(output_file, "w") as f:
        f.write(f"    AREA MYIMAGE, DATA, READONLY\n")
        f.write(f"    EXPORT {var_name}\n\n")

        f.write(f"{var_name}\n")
        f.write(f"    DCD {width}\n")
        f.write(f"    DCD {height}\n")  # Image width and height

        for i, pixel in enumerate(pixel_data):
            if i % 8 == 0:
                f.write("    DCW ")  # Use DCW for 16-bit data in legacy syntax
            f.write(f"0x{pixel:04X}")
            if (i + 1) % 8 == 0 or i == len(pixel_data) - 1:
                f.write("\n")
            else:
                f.write(", ")

        f.write(f"\n    END\n")

    print(f"Assembly file {output_file} generated successfully.")


# Choose BGR or RGB depending on hardware
#  or just try both
image_to_arm_asm(image_path="./killua.png",
                 output_file="data.s",
                 BGR=True)
