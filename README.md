# coax-trap-form
Parametric OpenSCAD model for making coil forms for coax-traps for wire antennas.

# Electrical Design
Electrical design from the 2015 ARRL Antenna Handbook 
page 10-15, section 10.2.2, "Five Band W3DZZ Trap Antenna"
The idea is a trap resonant at 7.2MHz, which natively builds a 40/80m
antenna. But the series capacitance in the trap allows the total antenna
length to resonate at 20, 15, and 10m as well, at higher harmonics.
The idea being a 5 band antenna with only a single pair of traps.

The book shows two designs, depending on which diagram you look at:
1. Traps: 60pF, 8.2uH, 22' outer wire length
1. Traps: 100pF, 4.9uH, 21' outer wire length

Both have 32' inner length, and are fed with 75ohm.

My goal is to make these traps using the coax trap design discussed
later in the chapter.

# My Antenna
Using: https://www.qsl.net/ve6yp/coaxtrap.zip coax trap calculator, 
and C/ft numbers for coax I had on hand (RG8/X and RG58), I wasn't
able to make a coax trap with the exact values above; all common coax has
too much C/ft to get down to 100pF.  The best I could do was with my 
RG8/X, down to 137pF and 3.575uH, 6.25 turn on a 3.1in form.

This is that form, with holes in the right places for coax and attachments.
Printed vertically like a tower, **THIS WILL NOT BE STRUCTURAL!**
My intention is to feed the antenna wire through a nylon rope so the 
rope is tensioned, but the wire is not.  The trap structure will just be loosely
hanging from the wire ends that stick out from the rope an inch or two.

# Your Antenna!
But the OpenSCAD file is entirely parametric. You can adjust the variables:
```
// Calculator: https://www.qsl.net/ve6yp/coaxtrap.zip
form_diameter = 3.1*in2mm;
num_turns = 6.25;
// RG8/X, LMR240 = 0.242
coax_diameter = 0.242*in2mm;
// No 10-24
bolt_diameter = 0.200*in2mm;
form_thickness = .200*in2mm;
```
OpenSCAD uses millimeters, but the coil form calculator uses inches (and I'm
a dirty American ;-), so I included `in2mm = 25.4;` to convert.

# Show me your antenna!
If you build something with this model, I'd appreciate it if you sent me
a picture and/or description of what you built.  I'm [https://twitter.com/SmittyHalibut](@SmittyHalibut on Twitter).

73 de KR6ZY, @SmittyHalibut
-Mark
