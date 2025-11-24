# App Icon Design Instructions

## Generate the Trace App Icon

### Recommended Tool
Use [Midjourney](https://midjourney.com) or [DALL-E 3](https://openai.com/dall-e-3)

### Exact Prompt

```
iOS app icon design for a mindfulness drawing app called "Trace". Minimalist style. 
A single, imperfect, organic charcoal circle drawn in the center. 
The stroke is textured, rough, and dry, looking like real charcoal on paper. 
The background is a textured, warm off-white unbleached paper color (#F2F0E9). 
High quality, 4k, soft natural lighting, matte finish, no gloss, no shadows, 
Japanese wabi-sabi aesthetic, flat design but with material texture. 
--v 6.0 --style raw
```

### Required Sizes

After generating, export to these sizes:
- 1024x1024 (App Store)
- 180x180 (iPhone 3x)
- 120x120 (iPhone 2x)
- 167x167 (iPad Pro)
- 152x152 (iPad 2x)
- 76x76 (iPad)

### Online Icon Generators

Use these tools to auto-generate all sizes:
- [AppIcon.co](https://appicon.co)
- [MakeAppIcon](https://makeappicon.com)
- [App Icon Generator](https://www.appicongenerator.com)

### Manual Process

1. Generate icon at 1024x1024
2. Upload to icon generator
3. Download complete icon set
4. Replace contents of `Assets.xcassets/AppIcon.appiconset/`

### Design Notes

**Do:**
- Keep it simple (single element)
- Use matte finish
- Maintain paper texture
- Stay minimalist

**Don't:**
- Add gradients
- Use bright colors
- Include text
- Make it glossy

### Color Palette Reference

```
Background: #F2F0E9 (Unbleached Paper)
Charcoal:   #2C2C2C (Dried Charcoal)
```

### Alternative Quick Icon

If you need a placeholder immediately, use this CSS-generated version:

```html
<div style="
  width: 1024px; 
  height: 1024px; 
  background: #F2F0E9;
  display: flex;
  align-items: center;
  justify-content: center;
">
  <svg width="600" height="600">
    <circle 
      cx="300" cy="300" r="250" 
      fill="none" 
      stroke="#2C2C2C" 
      stroke-width="8"
      stroke-linecap="round"
      style="filter: url(#roughen)"
    />
    <defs>
      <filter id="roughen">
        <feTurbulence baseFrequency="0.05" numOctaves="3" result="noise"/>
        <feDisplacementMap in="SourceGraphic" in2="noise" scale="3"/>
      </filter>
    </defs>
  </svg>
</div>
```

Save as PNG and use as temporary icon.

## Testing the Icon

1. Add to Xcode project
2. Build to simulator
3. Check home screen appearance
4. Verify all sizes render correctly
5. Test on real device (most important)

## Final Notes

The icon should feel:
- **Calm** (not energetic)
- **Organic** (not digital)
- **Premium** (not cheap)
- **Mysterious** (inviting curiosity)

It should stand out among colorful app icons by being almost monochromatic.
