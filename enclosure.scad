// SmartFitness Bridge – Gehäuse im Bauhaus-Stil (kompakt)
// Freenove ESP32-S3-WROOM (FNK0085, 2x USB-C) + TOF400C (VL53L1X) mittig in der Längsseite.
// Außen spiegelsymmetrisch zur Längsachse (Ausnahme: USB-Ports, Taster/LEDs folgen dem Board).
// Logo + Schriftzug aus dem Webinterface von hubwerk/Smartfitness-bridge.
//
// Sensor wird 90° gedreht (Kappe hochkant) mit GEWINKELTER Stiftleiste montiert:
// die Dupont-Stecker laufen flach an der Wand entlang nach vorn -> schmales Gehäuse.
//
// Alle Maße in mm. VOR DEM DRUCK nachmessen und unten anpassen!
// part = "box" | "lid" | "btn_b" | "btn_r" | "logo_inlay" | "assembly"
part = "assembly";
show_electronics = false;  // Board/Sensor-Platzhalter in der Baugruppe anzeigen

include <logo_smartfitness.scad>

/* ---------- Druck / allgemein ---------- */
wall     = 2.0;
usb_wall = 3.0;
floor_t  = 2.0;
lid_t    = 2.4;
clr      = 0.4;
edge_ch  = 0.6;
$fn = 64;

/* ---------- ESP32-S3 Board ---------- */
esp_l = 63.5;  esp_w = 26.5;  esp_t = 1.6;
esp_under = 26;   // Stiftleisten nach unten + Dupont-Stecker + Platz zum Abknicken der Kabel
esp_above = 8;
esp_pin_keepout = 4.2;
esp_mod_w = 18; esp_mod_h = 3.2;   // ESP32-S3-WROOM Modul (mittig, am hinteren Board-Ende)

usb_y   = [-6.5, 6.5];  // USB-C Mitte relativ zur Platinenmitte
usb_cw  = 8.94; usb_ch = 3.26; usb_ov = 0.8; usb_clr = 0.3;
usb_chamfer = 1.0;   // 45°-Fase außen um die USB-Öffnungen (Einführhilfe, Platz für dicke Stecker)

// Taster / LEDs: [x ab USB-Platinenkante, y ab Platinenmitte (+ = Sensorseite)]
buttons  = [[11, -8], [11, 8]];
btn_d    = 6;
btn_h    = 2.0;
btn_proud = 0.8;
leds  = [[17, -10.5], [17, 10.5]];
led_d = 3;

/* ---------- TOF400C (Foto-Maße), hochkant montiert ---------- */
// lokale Koordinaten: u = waagrecht ab Stiftleisten-Kante, v = senkrecht ab Unterkante
tof_t   = 1.6;
tof_len = 20;    // jetzt senkrecht
tof_wid = 12;    // jetzt waagrecht
tof_strip = 3.5; // Stiftleisten-Streifen (12 - 8.5)
tof_strip_v = [1.25, 16.25];
cap_w  = 12.4; cap_hh = 9.6; cap_h = 2.5; cap_clr = 0.25;
cap_u  = 7.75;   // Kappenmitte ab Stiftleisten-Kante
cap_v  = 9.5;    // Kappenmitte ab Unterkante
tof_plug = 4.5;  // Tiefe gewinkelte Stiftleiste + Dupont hinter der Platine
tof_plug_len = 22; // Länge Stecker nach vorn ab Platinenkante
tof_margin = 1.0;
eye_d = 18; eye_dep = 0.8;

/* ---------- Lüftung ---------- */
side_slots = [18, 15, 12];
slot_w = 2.2; slot_angle = 22;
lid_slot_len = 3.6; lid_slot_w = 1.6; lid_slot_n = 12; lid_slot_rot = -50;

/* ---------- Deckel ---------- */
lid_fit = 0.25;
hook_w = 18; hook_d = 1.6; hook_t = 1.2;   // Haken vorn unter die USB-Wand
corbel = 6; corbel_z = esp_under + 3;      // Schraubkonsolen hinten (über dem Board, das darunter durchgeschoben wird)
screw_pilot = 2.5; screw_hole = 3.3; screw_head = 6.2;
engrave = 0.6;
logo_h  = 12;
title   = "SmartFitness";
subtitle = "BRIDGE";
btn_labels = ["b", "r"];   // Kennzeichnung der Tasterkappen (gleiche Schriftart)
btn_label_dep = 0.4;
anthracite = "#383E42";
font_b  = "Liberation Sans:style=Bold";
font_r  = "Liberation Sans:style=Regular";

/* ---------- abgeleitete Maße (innen: Boden z=0, USB-Wand x=0) ---------- */
in_h = esp_under + esp_t + esp_above;
board_x0 = -(usb_wall - usb_ov);
x_e   = board_x0 + esp_l;
slide = usb_wall + 0.4;
esp_y0 = clr;
in_w = esp_y0 + esp_w + clr + tof_margin + tof_plug + tof_t + (cap_h - wall);
in_l = x_e + slide + 1.5;
top_z = in_h + lid_t;
out_x0 = -usb_wall; out_x1 = in_l + wall;
out_y0 = -wall;     out_y1 = in_w + wall;
yc = in_w/2;
esp_c = esp_y0 + esp_w/2;

cap_x = (out_x0 + out_x1)/2;
cap_z = (top_z - floor_t)/2;
sx0 = cap_x - cap_u;          // Stiftleisten-Kante (vorn)
sz0 = cap_z - cap_v;          // Platinen-Unterkante
y_c = in_w + wall - cap_h;    // Platinen-Vorderseite -> Kappe bündig außen
y_b = y_c - tof_t;

function bx(p) = board_x0 + p[0];
function by(p) = esp_c + p[1];

echo(str("Außenmaß: ", out_x1 - out_x0, " x ", out_y1 - out_y0, " x ", top_z + floor_t, " mm"));
assert(sx0 - tof_plug_len > 0, "Sensorstecker ragen in die USB-Wand");

/* ---------- Grundformen ---------- */
module ch_box(x0, x1, y0, y1, z0, z1, c) hull() {
    translate([x0 + c, y0 + c, z0]) cube([x1 - x0 - 2*c, y1 - y0 - 2*c, z1 - z0]);
    translate([x0, y0, z0 + c]) cube([x1 - x0, y1 - y0, z1 - z0 - 2*c]);
}
module stadium(w, h) hull() for (s = [-1, 1]) translate([s*(w - h)/2, 0]) circle(d = h);
module polyline(pts, w) for (i = [0:len(pts) - 2])
    hull() { translate(pts[i]) circle(d = w, $fn = 16); translate(pts[i + 1]) circle(d = w, $fn = 16); }
module mirror_y() { children(); translate([0, in_w, 0]) mirror([0, 1, 0]) children(); }

/* ---------- Logo + Schriftzug (2D) ---------- */
module logo2d(h = logo_h) {
    k = h / (logo_bbox[1][1] - logo_bbox[0][1]);
    scale(k) translate([0, -logo_bbox[0][1]]) {
        difference() {
            union() { polygon(logo_mountain_1); polygon(logo_mountain_2); }
            polyline(logo_road, logo_road_w);
        }
        polyline(logo_pole, max(logo_pole_w, 0.7/k));
        polygon(logo_flag);
    }
}
// Breite der Gruppe = brand_w, zentriert um [0,0]
// Leserichtung: von der Sensorseite (+y) aus lesbar
read_rot = 180;
module brand2d() rotate(read_rot) {
    tw = brand_w - logo_h*1.06 - 3;
    translate([-brand_w/2, -logo_h/2]) {
        logo2d();
        translate([logo_h*1.06 + 3, logo_h*0.42])
            resize([tw, 0], auto = true) text(title, font = font_b, size = 5, valign = "baseline");
        translate([logo_h*1.06 + 3, logo_h*0.0])
            text(subtitle, font = font_r, size = 2.6, spacing = 1.9);
    }
}
// Deckel-Layout: Schlitzreihen auf den LED-Linien, Schriftzug auf der Board-Achse dazwischen
slot_hx = lid_slot_len/2*cos(lid_slot_rot) + lid_slot_w/2*abs(sin(lid_slot_rot));
slot_x0 = bx(leds[0]) + led_d/2 + 0.7 + slot_hx;
slot_x1 = x_e - 1.5 - 1.25 - 1.5 - slot_hx;   // vor den hinteren Niederhalter-Stiften
lid_slot_pitch = (slot_x1 - slot_x0)/(lid_slot_n - 1);
brand_w = slot_x1 - slot_x0 + 2*slot_hx;
brand_c = [(slot_x0 + slot_x1)/2, esp_c];

/* ================= Unterteil ================= */
module box() {
    difference() {
        union() {
            difference() {
                ch_box(out_x0, out_x1, out_y0, out_y1, -floor_t, top_z, edge_ch);
                cube([in_l, in_w, top_z + 1]);
            }
            esp_supports();
            tof_mount();
            // Konsole -y: abgestuft, damit das Modul beim Einschieben darunter durchpasst
            corbel_low_w = esp_c - esp_mod_w/2 - 0.25;
            mod_top = esp_under + esp_t + esp_mod_h + 0.4;
            translate([in_l - corbel, 0, corbel_z]) cube([corbel, corbel_low_w, in_h - corbel_z]);
            translate([in_l - corbel, 0, mod_top]) cube([corbel, corbel, in_h - mod_top]);
            translate([in_l - corbel, in_w - corbel, corbel_z]) cube([corbel, corbel, in_h - corbel_z]);
        }
        usb_cutouts();
        tof_window();
        blind_eye();
        mirror_y() { eye_ring(); side_vents(); }
        // Hakenschlitz vorn
        translate([-hook_d - 0.3, yc - hook_w/2 - 0.3, in_h - 0.1]) cube([hook_d + 0.31, hook_w + 0.6, hook_t + 0.3]);
        for (y = [corbel/2, in_w - corbel/2]) translate([in_l - corbel/2, y, corbel_z + 0.5])
            cylinder(d = screw_pilot, h = in_h);
    }
}

module esp_supports() {
    sw = esp_w - 2*esp_pin_keepout;
    yb = esp_y0 + esp_pin_keepout;
    translate([0, yb, 0]) cube([4, sw, esp_under]);
    translate([x_e - 5, yb, 0]) cube([5 + slide + 0.5, sw, esp_under]);
    // Führung Sensorseite (vorn übernimmt die Wand -y)
    translate([x_e - 5, esp_y0 + esp_w + clr, 0]) cube([4, 1.5, esp_under + esp_t + 1]);
}

module usb_cutouts() {
    skin = usb_ov - 0.2;
    px0 = skin < 0.6 ? -usb_wall - 1 : board_x0 - 0.2;
    translate([px0, esp_y0 - clr, esp_under - 1]) cube([-px0 + 0.01, esp_w + 2*clr, esp_t + 1.3]);
    for (dy = usb_y)
        translate([-usb_wall - 1, esp_c + dy, esp_under + esp_t + usb_ch/2])
        rotate([0, 90, 0]) rotate([0, 0, 90]) linear_extrude(usb_wall + 1.1)
            stadium(usb_cw + 2*usb_clr, usb_ch + 2*usb_clr);
    for (dy = usb_y)
        translate([-usb_wall - 0.01, esp_c + dy, esp_under + esp_t + usb_ch/2])
        rotate([0, 90, 0]) rotate([0, 0, 90]) hull() {
            linear_extrude(0.01) offset(r = usb_chamfer + 0.01) stadium(usb_cw + 2*usb_clr, usb_ch + 2*usb_clr);
            translate([0, 0, usb_chamfer + 0.01]) linear_extrude(0.01) stadium(usb_cw + 2*usb_clr, usb_ch + 2*usb_clr);
        }
}

module tof_mount() {
    // Auflage unter der Platine (nur oberer Teil, Stiftleiste bleibt frei)
    translate([sx0 + tof_strip + 0.5, y_b, 0]) cube([tof_wid - tof_strip - 1, in_w - y_b + 0.01, sz0]);
    if (y_c < in_w)
        translate([sx0 - 1, y_c, 0]) cube([tof_wid + 2, in_w - y_c + 0.01, sz0 + tof_len + 1]);
}
module tof_window() {
    if (y_c > in_w)
        translate([sx0 - clr, in_w - 0.01, sz0 - clr]) cube([tof_wid + 2*clr, y_c - in_w + 0.01, tof_len + 2*clr]);
    translate([cap_x, y_c - 0.5, cap_z]) rotate([-90, 0, 0])
        linear_extrude(cap_h + 2) rotate(90) stadium(cap_w + 2*cap_clr, cap_hh + 2*cap_clr);
}
module eye_ring() translate([cap_x, out_y1 - eye_dep, cap_z]) rotate([-90, 0, 0]) cylinder(d = eye_d, h = eye_dep + 1);
module blind_eye() translate([cap_x, -wall - 1, cap_z]) rotate([-90, 0, 0])
    linear_extrude(1 + eye_dep + 0.4) rotate(90) stadium(cap_w + 2*cap_clr, cap_hh + 2*cap_clr);
module side_vents() for (s = [-1, 1], i = [0:len(side_slots) - 1])
    translate([cap_x + s*(eye_d/2 + 4 + i*4.6), in_w - 1, cap_z])
    rotate([-90, 0, 0]) rotate([0, 0, 90 + s*slot_angle]) linear_extrude(wall + 2) stadium(side_slots[i], slot_w);

/* ================= Deckel (Einbaulage, bündig) ================= */
module lid_assembled() {
    difference() {
        union() {
            translate([lid_fit, lid_fit, in_h]) cube([in_l - 2*lid_fit, in_w - 2*lid_fit, lid_t]);
            // Haken vorn (untere Hälfte der Deckelstärke)
            translate([-hook_d, yc - hook_w/2, in_h]) cube([hook_d + lid_fit + 0.01, hook_w, hook_t]);
            for (x = [2, x_e - 1.5], y = [esp_y0 + 1.2, esp_y0 + esp_w - 1.2])
                translate([x, y, esp_under + esp_t + 0.2]) cylinder(d = 2.5, h = esp_above);
            // Riegel hinter dem Platinenende
            translate([x_e + 0.2, esp_c - 7, esp_under + 0.3]) cube([slide - 0.4, 14, in_h - esp_under]);
            // Federzunge drückt den Sensor in die Öffnung
            hull() {
                translate([sx0 + tof_strip + 1, y_b - 2.15, sz0 + tof_len - 7]) cube([tof_wid - tof_strip - 1.5, 1.2, 0.1]);
                translate([sx0 + tof_strip + 1, y_b - 2.15, sz0 + tof_len - 5]) cube([tof_wid - tof_strip - 1.5, 2, in_h - sz0 - tof_len + 5.1]);
            }
            // Führungshülsen Taster
            intersection() {
                for (b = buttons) translate([bx(b), by(b), in_h - 2.5]) difference() {
                    cylinder(d = btn_d + 2 + 0.6 + 2, h = 2.6);
                    translate([0, 0, -1]) cylinder(d = btn_d + 2 + 0.6, h = 5);
                }
                translate([lid_fit, lid_fit, 0]) cube([in_l, in_w - 2*lid_fit, in_h + 1]);
            }
        }
        for (y = [corbel/2, in_w - corbel/2]) {
            translate([in_l - corbel/2, y, in_h - 1]) cylinder(d = screw_hole, h = lid_t + 2);
            translate([in_l - corbel/2, y, top_z - 1.6 + 0.01]) cylinder(d1 = screw_hole, d2 = screw_head, h = 1.6);
        }
        for (b = buttons) translate([bx(b), by(b), in_h - 1]) cylinder(d = btn_d + 0.5, h = lid_t + 2);
        for (l = leds) translate([bx(l), by(l), in_h - 1]) cylinder(d = led_d, h = lid_t + 2);
        // Logo + Schriftzug vertieft (optional farbig füllen)
        translate([brand_c[0], brand_c[1], top_z - engrave]) linear_extrude(engrave + 1) brand2d();
        // sportliche Lüftungsschlitze, symmetrisch über/unter dem Schriftzug, zeigen nach vorn
        for (l = leds, i = [0:lid_slot_n - 1])
            translate([slot_x0 + i*lid_slot_pitch, by(l), in_h - 1])
            rotate([0, 0, sign(l[1])*lid_slot_rot]) linear_extrude(lid_t + 2) stadium(lid_slot_len, lid_slot_w);
    }
}

/* ================= Tasterkappe (2x drucken, Kappe nach unten) ================= */
module button(label = "") difference() {
  union() {
    stem_len = in_h - (esp_under + esp_t + btn_h) - 0.3;
    cylinder(d = btn_d, h = lid_t + btn_proud);
    translate([0, 0, lid_t + btn_proud]) cylinder(d = btn_d + 2, h = 1.2);
    translate([0, 0, lid_t + btn_proud]) cylinder(d = 3, h = stem_len);
  }
  // Beschriftung vertieft in der Oberseite (z=0 = sichtbare Fläche)
  translate([0, 0, -0.01]) mirror([0, 1, 0]) linear_extrude(btn_label_dep + 0.01)
    rotate(-read_rot) text(label, font = font_b, size = btn_d*0.6, halign = "center", valign = "center");
}

/* ================= Ausgabe ================= */
module to_bed() translate([usb_wall, wall, floor_t]) children();

if (part == "box") to_bed() box();
else if (part == "lid") rotate([180, 0, 0]) translate([0, 0, -top_z]) lid_assembled();
else if (part == "logo_inlay")  // für Mehrfarbdruck: passt genau in die Vertiefung des Deckels
    rotate([180, 0, 0]) translate([0, 0, -top_z]) translate([brand_c[0], brand_c[1], top_z - engrave]) linear_extrude(engrave) brand2d();
else if (part == "btn_b") button(btn_labels[0]);
else if (part == "btn_r") button(btn_labels[1]);
else if (part == "assembly") to_bed() view_cut() {
    color(anthracite) {
        box();
        if (lid_lift >= 0) translate([0, 0, lid_lift]) {
            lid_assembled();
            for (i = [0:len(buttons) - 1])
                translate([bx(buttons[i]), by(buttons[i]), top_z + btn_proud + lid_lift*0.6])
                    rotate([180, 0, 0]) button(btn_labels[i]);
        }
    }
    if (show_electronics) electronics();
}

/* ---------- Visualisierung (nur Renderings) ---------- */
lid_lift = 0;          // Deckel anheben (Explosionsansicht); < 0 = Deckel ausblenden
cut = "none";          // "none" | "xz" (Schnitt längs durch die Board-Achse) | "yz" (quer durch den Sensor)

module view_cut() {
    if (cut == "xz") difference() { children(); color("#d0452f") translate([-50, esp_c, -50]) cube([200, 100, 200]); }
    else if (cut == "yz") difference() { children(); color("#d0452f") translate([cap_x - 200, -50, -50]) cube([200, 200, 200]); }
    else children();
}

module electronics() {
    pin_n = 20; pin_p = 2.54; row_off = 1.82;
    px0 = board_x0 + (esp_l - (pin_n - 1)*pin_p)/2;
    wire_cols = ["#d62d20", "#222222", "#ffa700", "#0057e7", "#008744", "#eeeeee"];
    // ESP32-S3 Board
    color("#1d1d1d") translate([board_x0, esp_y0, esp_under]) cube([esp_l, esp_w, esp_t]);
    color("#2a2a2a") translate([x_e - 26, esp_c - 9, esp_under + esp_t]) cube([25.5, esp_mod_w, 0.8]);
    color("#c9ccce") translate([x_e - 26 + 0.7, esp_c - 8.3, esp_under + esp_t + 0.8]) cube([18, 16.6, 2.4]);
    for (dy = usb_y) color("#b8bcc0")
        translate([board_x0 - usb_ov, esp_c + dy, esp_under + esp_t + usb_ch/2]) rotate([0, 90, 0]) rotate([0, 0, 90])
            linear_extrude(7.3) stadium(usb_cw, usb_ch);
    for (b = buttons) {
        color("#d8d8d8") translate([bx(b) - 2, by(b) - 1.5, esp_under + esp_t]) cube([4, 3, 1.2]);
        color("#333") translate([bx(b), by(b), esp_under + esp_t]) cylinder(d = 1.6, h = btn_h);
    }
    for (i = [0:len(leds) - 1]) color(i == 0 ? "#ff3030" : "#30ff60")
        translate([bx(leds[i]) - 0.8, by(leds[i]) - 0.4, esp_under + esp_t]) cube([1.6, 0.8, 0.6]);
    // Stiftleisten + Dupont-Buchsen unter dem Board
    for (y = [esp_y0 + row_off, esp_y0 + esp_w - row_off], i = [0:pin_n - 1]) {
        color("#111") translate([px0 + i*pin_p - 1.25, y - 1.25, esp_under - 2.5]) cube([2.5, 2.5, 2.5]);
        color("#111") translate([px0 + i*pin_p - 1.2, y - 1.2, esp_under - 2.5 - 14]) cube([2.4, 2.4, 14]);
        color(wire_cols[i % len(wire_cols)]) translate([px0 + i*pin_p, y, 1.5]) cylinder(d = 1.3, h = esp_under - 2.5 - 14 - 1.5 + 0.1, $fn = 12);
    }
    // TOF400C (hochkant)
    color("#1565c0") {
        translate([sx0 + tof_strip, y_b, sz0]) cube([tof_wid - tof_strip, tof_t, tof_len]);
        translate([sx0, y_b, sz0 + tof_strip_v[0]]) cube([tof_strip, tof_t, tof_strip_v[1] - tof_strip_v[0]]);
    }
    color("#0b0b0b") translate([cap_x, y_c, cap_z]) rotate([-90, 0, 0]) linear_extrude(cap_h) rotate(90) stadium(cap_w, cap_hh);
    // gewinkelte Stiftleiste + Dupont-Stecker + Kabel
    n_tof = 6;
    for (j = [0:n_tof - 1]) {
        z = sz0 + tof_strip_v[0] + 1.27 + j*2.54;
        color("#d4af37") {
            translate([sx0 + 1.75 - 0.3, y_b - 2.5, z - 0.3]) cube([0.6, 2.5 + tof_t + 0.5, 0.6]);
            translate([sx0 - 6, y_b - 2.5 - 0.3, z - 0.3]) cube([6 + 1.75 + 0.3, 0.6, 0.6]);
        }
        color("#111") translate([sx0 - 1 - 14, y_b - 2.5 - 1.2, z - 1.2]) cube([14, 2.4, 2.4]);
        color(wire_cols[j]) translate([sx0 - 15, y_b - 2.5, z]) rotate([0, -90, 0]) cylinder(d = 1.3, h = tof_plug_len - 15, $fn = 12);
    }
    color("#111") translate([sx0 - 1.5, y_b - 2.5 - 1.25, sz0 + tof_strip_v[0]]) cube([1.5, 2.5, tof_strip_v[1] - tof_strip_v[0]]);
}
