# Smartfitness-bridge-case

Case for the Freenove ESP32-S3 dev board with a TOF sensor: a 3D-printable Bauhaus-style enclosure for the **Freenove ESP32-S3-WROOM** (FNK0085, 2× USB-C) and a **TOF400C / VL53L1X** distance sensor, made for [hubwerk/Smartfitness-bridge](https://github.com/hubwerk/Smartfitness-bridge).

![Overview](views/overview.png)

Outer dimensions: **71.2 × 38.9 × 34 mm**

## Files

| File | Description |
|---|---|
| `enclosure.scad` | Parametric OpenSCAD model (all dimensions at the top of the file) |
| `logo_smartfitness.scad` | Logo polygons taken from the web interface |
| `enclosure_base.stl` | Base |
| `enclosure_lid.stl` | Lid with engraved logo and "SmartFitness BRIDGE" lettering |
| `button_b.stl`, `button_r.stl` | Button caps with recessed "b" / "r" labels |
| `lid_logo_inlay.stl` | Optional inlay for multi-color printing (0.6 mm) |
| `views/` | Renderings from all directions |

## Design

- The sensor sits upright in the middle of the long side, its lens cap flush with the outside. Use a **right-angle pin header** on the sensor so the Dupont plugs run flat along the wall.
- The USB-C sockets are flush with the end face. Drop the board in and slide it toward the USB wall; a latch on the lid holds it in place.
- The lid hooks under the USB wall at the front and is fastened at the rear with 2× M3 countersunk screws.
- Button labels: "b" = BOOT, "r" = RESET. Check the mapping against your board and swap `btn_labels` if needed.

## Measure before printing

Button and LED positions (`buttons`, `leds`), USB position and overhang (`usb_y`, `usb_ov`), sensor cap height (`cap_h`), and the right-angle header dimensions (`tof_plug`, `tof_plug_len`).

## Export

```sh
openscad -D 'part="box"'        -o enclosure_base.stl   enclosure.scad
openscad -D 'part="lid"'        -o enclosure_lid.stl      enclosure.scad
openscad -D 'part="btn_b"'      -o button_b.stl             enclosure.scad
openscad -D 'part="btn_r"'      -o button_r.stl             enclosure.scad
openscad -D 'part="logo_inlay"' -o lid_logo_inlay.stl  enclosure.scad
```

Anthracite renderings: copy `views/anthracite.json` into OpenSCAD's `color-schemes/render/` folder and render with `--colorscheme=Anthracite --render`.
