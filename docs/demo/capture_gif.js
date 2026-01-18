const { chromium } = require('playwright');
const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

async function captureAnimation() {
    const browser = await chromium.launch();
    const page = await browser.newPage();

    // Set viewport
    await page.setViewportSize({ width: 900, height: 720 });

    // Load the HTML file
    const htmlPath = path.join(__dirname, 'conversation_animated.html');
    await page.goto(`file://${htmlPath}`);

    // Record video
    const videoDir = path.join(__dirname, 'video_temp');
    if (!fs.existsSync(videoDir)) {
        fs.mkdirSync(videoDir);
    }

    // Take screenshots at intervals to create GIF frames
    const frames = [];
    const totalDuration = 11000; // 11 seconds (animation duration)
    const frameInterval = 200; // 200ms per frame = 5 fps
    const numFrames = totalDuration / frameInterval;

    console.log('Capturing frames...');

    for (let i = 0; i <= numFrames; i++) {
        const framePath = path.join(videoDir, `frame_${String(i).padStart(3, '0')}.png`);
        await page.screenshot({ path: framePath });
        frames.push(framePath);

        if (i < numFrames) {
            await page.waitForTimeout(frameInterval);
        }

        if (i % 10 === 0) {
            console.log(`Frame ${i}/${numFrames}`);
        }
    }

    await browser.close();

    console.log('Creating GIF with gifsicle...');

    // Create GIF using ImageMagick
    const outputGif = path.join(__dirname, 'collaboration_animated.gif');

    try {
        // Use convert (ImageMagick) to create GIF
        execSync(`convert -delay 20 -loop 0 ${videoDir}/frame_*.png -resize 800x640 ${outputGif}`);

        // Optimize with gifsicle
        const optimizedGif = path.join(__dirname, 'collaboration_animated_opt.gif');
        execSync(`gifsicle -O3 --colors 128 --lossy=80 ${outputGif} -o ${optimizedGif}`);

        console.log('GIF created successfully!');
        console.log(`Output: ${optimizedGif}`);

        // Get file size
        const stats = fs.statSync(optimizedGif);
        console.log(`Size: ${(stats.size / 1024 / 1024).toFixed(2)} MB`);

    } catch (err) {
        console.error('Error creating GIF:', err.message);
    }

    // Cleanup frames
    // fs.rmSync(videoDir, { recursive: true });
}

captureAnimation().catch(console.error);
