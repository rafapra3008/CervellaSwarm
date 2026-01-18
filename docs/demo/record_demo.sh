#!/bin/bash
# Record animated HTML as GIF using playwright + ffmpeg

cd "$(dirname "$0")"

echo "Starting recording..."

# Use playwright to record video
python3 << 'EOF'
from playwright.sync_api import sync_playwright
import os
import time

demo_dir = os.path.dirname(os.path.abspath(__file__)) or '.'
os.chdir(demo_dir)

html_path = os.path.join(demo_dir, 'conversation_animated.html')
video_path = os.path.join(demo_dir, 'recording.webm')

with sync_playwright() as p:
    browser = p.chromium.launch()

    context = browser.new_context(
        viewport={'width': 900, 'height': 700},
        record_video_dir=demo_dir,
        record_video_size={'width': 900, 'height': 700}
    )

    page = context.new_page()
    page.goto(f'file://{html_path}')

    # Wait for animation to complete (11 seconds + buffer)
    page.wait_for_timeout(12000)

    # Get the video path before closing
    video = page.video
    context.close()

    # Rename the video
    if video:
        original_path = video.path()
        if os.path.exists(original_path):
            os.rename(original_path, video_path)
            print(f"Video saved: {video_path}")

    browser.close()

EOF

echo "Converting to GIF..."

# Convert to GIF with ffmpeg (optimized settings)
ffmpeg -y -i recording.webm \
    -vf "fps=8,scale=800:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=128[p];[s1][p]paletteuse=dither=bayer:bayer_scale=3" \
    -loop 0 \
    collaboration_demo.gif

# Optimize with gifsicle if available
if command -v gifsicle &> /dev/null; then
    echo "Optimizing with gifsicle..."
    gifsicle -O3 --lossy=60 collaboration_demo.gif -o collaboration_demo_opt.gif
    mv collaboration_demo_opt.gif collaboration_demo.gif
fi

# Show result
ls -lh collaboration_demo.gif
echo "Done!"
