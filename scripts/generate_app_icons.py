import os
from PIL import Image

def generate_icons():
    # Source image
    master_path = r'C:\Users\Benoit\.gemini\antigravity-ide\brain\99a6c071-bc7e-47c4-8105-c3962e493817\test_square_crop.png'
    if not os.path.exists(master_path):
        raise FileNotFoundError(f"Master image not found at {master_path}")

    master = Image.open(master_path).convert('RGB')
    print(f"Loaded master image: {master.size}, mode={master.mode}")

    # --- 1. iOS AppIcon.appiconset ---
    ios_dir = r'ios/Runner/Assets.xcassets/AppIcon.appiconset'
    os.makedirs(ios_dir, exist_ok=True)

    ios_icons = {
        'Icon-App-20x20@1x.png': (20, 20),
        'Icon-App-20x20@2x.png': (40, 40),
        'Icon-App-20x20@3x.png': (60, 60),
        'Icon-App-29x29@1x.png': (29, 29),
        'Icon-App-29x29@2x.png': (58, 58),
        'Icon-App-29x29@3x.png': (87, 87),
        'Icon-App-40x40@1x.png': (40, 40),
        'Icon-App-40x40@2x.png': (80, 80),
        'Icon-App-40x40@3x.png': (120, 120),
        'Icon-App-60x60@2x.png': (120, 120),
        'Icon-App-60x60@3x.png': (180, 180),
        'Icon-App-76x76@1x.png': (76, 76),
        'Icon-App-76x76@2x.png': (152, 152),
        'Icon-App-83.5x83.5@2x.png': (167, 167),
        'Icon-App-1024x1024@1x.png': (1024, 1024),
    }

    print("Generating iOS icons (100% RGB, zero alpha)...")
    for filename, (w, h) in ios_icons.items():
        out_path = os.path.join(ios_dir, filename)
        resized = master.resize((w, h), Image.Resampling.LANCZOS)
        # Ensure RGB mode without alpha channel
        rgb_img = resized.convert('RGB')
        rgb_img.save(out_path, format='PNG')
        print(f"  [iOS] Saved {filename} ({w}x{h})")

    # --- 2. Android mipmap-* ---
    android_res_dir = r'android/app/src/main/res'
    android_icons = {
        'mipmap-mdpi': (48, 48),
        'mipmap-hdpi': (72, 72),
        'mipmap-xhdpi': (96, 96),
        'mipmap-xxhdpi': (144, 144),
        'mipmap-xxxhdpi': (192, 192),
    }

    print("Generating Android mipmap icons...")
    for folder, (w, h) in android_icons.items():
        folder_path = os.path.join(android_res_dir, folder)
        os.makedirs(folder_path, exist_ok=True)
        out_path = os.path.join(folder_path, 'ic_launcher.png')
        resized = master.resize((w, h), Image.Resampling.LANCZOS)
        resized.save(out_path, format='PNG')
        print(f"  [Android] Saved {folder}/ic_launcher.png ({w}x{h})")

    # --- 3. Web Icons ---
    web_dir = r'web'
    web_icons_dir = r'web/icons'
    os.makedirs(web_icons_dir, exist_ok=True)

    web_icons = {
        os.path.join(web_dir, 'favicon.png'): (32, 32),
        os.path.join(web_icons_dir, 'Icon-192.png'): (192, 192),
        os.path.join(web_icons_dir, 'Icon-512.png'): (512, 512),
        os.path.join(web_icons_dir, 'Icon-maskable-192.png'): (192, 192),
        os.path.join(web_icons_dir, 'Icon-maskable-512.png'): (512, 512),
    }

    print("Generating Web icons...")
    for file_path, (w, h) in web_icons.items():
        resized = master.resize((w, h), Image.Resampling.LANCZOS)
        resized.save(file_path, format='PNG')
        print(f"  [Web] Saved {file_path} ({w}x{h})")

    print("\nAll application icons successfully generated!")

if __name__ == '__main__':
    generate_icons()
