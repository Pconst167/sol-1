XGA: A NEW GRAPHICS STANDARD

Combine a fast VGA, a graphics coprocessor, and bus mastering, and you
have XGA

AUTHOR:  Jake Richter



Three and a half years after introducing both the VGA and 8514/A
graphics standards, IBM has finally unveiled its next-generation PS/2
graphics hardware -- the XGA (Extended Graphics Array).

In 1987, the VGA was shipped standard with the newly announced PS/2
systems. Now the XGA is shipped as the default graphics display
platform with IBM's newest PS/2s, the Model 90 XP 486 and the Model 95
XP 486. In the desktop Model 90, the XGA is on the motherboard; in the
Model 95 (a tower unit), it is located on a separate Micro Channel
architecture add-in board. The XGA Display Adapter/A is also available
for other 386- and i486-based PS/2s.

IBM's replacement of the VGA with the XGA as a default graphics
platform is remarkable. A couple of years ago, rumors were rampant
about IBM's implementing its 8514/A advanced graphics technology on
PS/2 motherboards. But the 8514/A lacked one major feature that was
necessary for this to occur: backward compatibility. The XGA's full
VGA hardware compatibility eliminates this problem; therefore, it is
suitable for a motherboard implementation.

In some ways, the XGA is a merger between the VGA and 8514/A graphics
platforms. The table shows a feature comparison of several mass-market
graphics hardware platforms demonstrating how the XGA has evolved.

The XGA Is Born
The XGA was developed in the U.K. at IBM's Hursley Labs, as were the
8514/A and the niche-oriented Image Adapter/A. Therefore, it is not
surprising that in its design the XGA maintains many of the 8514/A's
features, although it accesses these features in a different fashion.

Some of the new features, such as bus mastering, are designed to take
advantage of the Micro Channel architecture bus, which is standard in
most PS/2s. Other features, such as a memory-mapped frame buffer and
hardware cursor, provide greater flexibility over existing designs,
easing the burden for software developers. Another boon to software
developers is that IBM has released full register specifications for
the XGA, unlike its tight-lipped approach to the 8514/A. An Adapter
Interface comes with the XGA to provide backward compatibility for all
those applications that supported the 8514/A via the Adapter
Interface.

Multiple Modes
The XGA has three distinct modes: VGA compatibility, 132-column VGA-
compatible text, and extended graphics. The extended-graphics mode is
the most interesting, since it provides higher resolutions and
substantial graphics acceleration.

In addition to maintaining full compatibility with the VGA standard it
originally created, IBM learned some lessons from the vast number of
VGA clones out there and implemented a larger data path. The VGA mode,
while still having only an 8-bit internal data path, supports a 32-
bit-wide bus. It also has an internal write cache that allows the chip
to break down and write the bus data without holding up the rest of
the system with unnecessary wait states.

According to IBM documents, when the XGA is in VGA mode, it is up to
90 percent faster than the original VGA under DOS and up to 50 percent
faster under Windows. Except for performance improvements, there is no
change in VGA functionality in this mode.

It's important to note, however, that while you can have up to eight
XGAs in one system (the configuration software only supports up to
six), you can only have one VGA active in the system at any one time.
Therefore, if you switch an XGA into VGA mode, you must ensure that no
other VGA is active in the system; otherwise, the system might crash
due to I/O conflicts.

Using the 132-column text mode (a VGA extension), you can display and
manipulate 132 characters per line of text on the screen. The
character width is 8 pixels for a virtual horizontal resolution of
1056. Character height depends on the font used, which means that you
can have text screen resolutions of 132 by 43, 132 by 50, or 132 by 60
pixels.

Currently, you can access the 132-column text mode only by manually
manipulating the XGA registers. Ultimately, however, this mode will be
accessible by switching into video mode 14 (hexadecimal). For all
practical purposes, note that the 132-column text mode is a VGA mode
and the same multiple-VGA caveat applies.

The extended-graphics mode has many exciting features, such as 65,536
colors (i.e., 1024- by 768-pixel resolution), bus mastering, drawing
acceleration, and the hardware cursor. While some of this mode's
features are available in the other modes, most of the XGA registers
and functions are dedicated for use in the extended-graphics mode.

XGA Registers
The XGA design consists of video RAM, a type of dual-ported RAM
designed for use in graphics-display systems; glue logic; and two
custom chips, the graphics coprocessor and the display controller,
which are the core of the XGA. The graphics coprocessor controls VGA
compatibility, drawing functions, and memory management, and the
display controller contains the RAM D/A converter (RAMDAC) with a
color lookup table, the CRT controller, hardware cursor support, and a
VRAM serializer (a device that extracts data from VRAM for display).

Access to the XGA is accomplished via two sets of registers: The first
set is mapped into the system's I/O space, while the other set of
registers is mapped into memory. The addresses of these registers
vary, due to the configurability of the XGA. This variable addressing
allows for multiple XGAs in the same system.

The I/O registers are mapped in at a hexadecimal I/O address of 21X0,
where X is the instance (or occurrence) of the XGA. According to IBM,
in systems with only one XGA, the instance is typically 6, resulting
in a base hexadecimal I/O address of 2160.

The memory-mapped registers occupy 128 bytes of memory in the last
kilobyte of an 8K-byte chunk. This chunk resides on an 8K-byte
boundary anywhere between PC addresses 0C0000h and 0DFFFFh. The
purpose of having an 8K-byte chunk is that the first 7K bytes of the
chunk contains ROM data, but only on an XGA Display Adapter/A. The
motherboard implementation of the XGA does not require its own ROM, as
the main motherboard ROMs contain all the necessary information, such
as XGA initialization code. The XGA instance number determines the
location of the 128 bytes within the 8K-byte chunk.

The I/O registers pertain predominantly to the XGA's display
controller. The memory-mapped registers, however, refer primarily to
the graphics coprocessor. The XGA's power-on self test routines set
the base addresses for both registers, and by examining the PS/2 POST
registers for the XGA in question, you can determine the addresses.

Many of the memory-mapped registers are 32 bits in size, because the
XGA is designed to fit into a 32-bit environment like that of the
Intel 386 and i486. Also, due to the software support IBM developed
for the XGA, it only works in a 386 or 386-based PS/2 (including
386SX-based PS/2s). The XGA also offers Motorola format addressing (a
different byte ordering compared to an Intel format), which allows a
Motorola 68000 or similar processor to take advantage of the XGA,
assuming the XGA was ported to such hardware environs.

Initialization
Initialization is a necessary step in using any graphics device. In
the case of the XGA, initialization mainly involves setting the XGA
into extended-graphics mode via the operating-mode register. You can
then generate the proper CRT control register data for the desired
resolution. Selectable resolutions are 640 by 480 and 1024 by 768
pixels. But you can only access the 640- by 480-pixel by 65,536-color
and 1024- by 768-pixel by 256-color modes with 1 megabyte of RAM.

The 16-bit-per-pixel (65,536-color) resolution provides almost perfect
photo-realistic output. Thus, you can scan or capture a full-color
picture and, using this 65,536-color mode, see an almost exact replica
on your XGA screen. The 16-bit pixel is laid out as 5 bits of red, 6
bits of green, and 5 bits of blue (5-6-5), or in other words, 32
shades of blue, 64 shades of green, and 32 shades of blue -- in each
pixel.

This configuration varies from the PC standard TARGA format of 5-5-5
(1 bit is used for overlay) and the i860 format of 6-6-4. According to
a technical contact at IBM, the 5-6-5 approach was used because of
other similar implementations already in place in various IBM
installations.

Apparently, the eye is also more sensitive to variations in green than
in red or blue. (The reason for the choice of red, green, and blue is
that these are the three color guns found in all color monitors. The
beams from the three guns combine to display just about any color,
depending on the intensity of each gun.)

The Display Controller
You use the display controller during initialization, but it has other
uses as well. Two such uses are the color lookup table and the sprite.
The sprite is a 64- by 64-pixel block that overlays the screen.

You use the lookup table to translate the 1-, 2-, 4-, or 8-bit-pixel
value into appropriate RGB values. The pixel value is used as an index
into the lookup table. The resultant RGB values are then converted
from digital levels into analog voltage levels via a built-in DAC.

As with the VGA and 8514/A, the XGA's lookup table supports 64 levels
(6 bits) of each primary color, for a total of 262,144 possible color
combinations. Thus, in a 256-color mode, you can choose 256 colors
from this palette of 262,144.

Each pixel in the sprite has four possible values: sprite color 0,
sprite color 1, transparent, and complement. Special registers define
the sprite colors, and they let you specify the RGB values for each
color. These RGB values are passed directly to the DAC. Their use
permits applications to fully modify the local color palette without
having to save two entries for the cursor or your having to worry
about the cursor changing color as it goes over various portions of
the display.

The transparency setting allows cursors that are smaller than 64 by 64
pixels to be defined. Users who want a cursor that is always visible
against any background can use the complement setting.

Task Switching
One of the biggest headaches for systems software developers in
creating a multitasking environment is saving the current state of the
graphics hardware to allow another application to take over the
graphics device. This state save also has to account for the
possibility that the hardware might be in the middle of an operation
or a palette update.

The XGA was apparently designed with task switching in mind, because
it has extensive facilities for saving and restoring the state of the
hardware, including interrupted operations.

Defining Drawing Space
One of the XGA's features that is unique among current PC graphics
standards is the use of bit maps, which must be defined to perform any
drawing function. These bit maps are linear regions of memory that are
defined with a pixel width, height, and depth (or bits per pixel). As
such, an 8-bit-per-pixel bit map, with a width of 10 and a height of 6
pixels, would require 60 bytes of memory. The last pixel/byte of a
given line of the bit map is directly adjacent in memory to the first
pixel/ byte in the following line.

The best feature of these bit maps is that they can exist anywhere in
the system's address and memory space. Thus, if you define a bit map
that resides in your program's data area, the XGA can draw into it or
read from it, saving you the effort of manually copying data to and
from the XGA (i.e., with your system processor).

The XGA VRAM is mapped into the system's address space so that when
you want to specify it for a bit-map definition, you just use its
address. The VRAM is usually located in the uppermost addresses of the
386's 4-gigabyte address space. As a result, there should never be a
memory conflict.

Bus-Mastering Pitfalls
When the XGA accesses a bit map, it determines whether the access is
local (VRAM) or remote (system). For remote access, the XGA arbitrates
for the bus and starts accessing system memory. Here is where the
XGA's bus-mastering capability comes into play. There is additional
overhead in the use of system memory for bit maps, beyond that being
used for accessing local VRAM. But there is also the performance
benefit of having the XGA processor manipulate memory while the system
processor is doing something else.

This bus mastering has some potential pitfalls. The 386 and i486
processors support virtual memory via an internal page-mapping table.
The page-mapping table allows control applications, such as expanded-
memory managers, DOS extenders, and advanced operating systems, to
create virtual PC addresses 4K bytes (or a page) at a time. So, while
the software application thinks it is writing data to address WWWWW,
the page-mapping table might translate that address to physical
address QQQQQ.

In many cases, there is no way for an application to know that the
address it is using is not the physical address. And, to properly bus
master, the XGA requires a physical address; otherwise, it may copy
data to and from an incorrect address, with disastrous results. There
is a possible solution to this dilemma, however, with some control
software environments.

If an application has access to the control software's page-mapping
table, it can pass this information to the XGA, which then makes use
of the page-mapping table, and it can do its own virtual-to-physical
address translations. Unfortunately, many control programs and
operating systems do not provide access to the page-mapping table. In
any case, regular DOS applications have the best chance of using bus
mastering, because the first 640K bytes of memory are generally the
least likely to be virtualized.

In addition to always having the VRAM mapped into high memory,
software can map the XGA into a 64K-byte bank at either A0000h or
B0000h, the standard PC video-memory addresses. Accessing different
64K-byte banks in the XGA's VRAM via this approach requires only that
an index value be written into the aperture index register. This
banking mechanism is handy for real-mode applications. Alternatively,
the whole 1-MB chunk of VRAM can be mapped somewhere in the first 16
MB of the system's memory, assuming there is no memory conflict. This
type of mapping is useful only for protected-mode applications.

With respect to the bit maps, the XGA has three generic bit maps
available for definition: maps A, B, and C. These maps are referenced
when drawing commands are executed.

The drawing commands may require one or more bit maps: source,
destination, and pattern. Source bit maps contain the data you want to
either copy or use as a tile; destination bit maps are those into
which you draw or copy data; and pattern bit maps contain a
monochromatic (1-bit-per-pixel) pattern that you can use as an area
pattern or a pixel-exclusion pattern.

The XGA also supports an additional map, referred to as the mask map.
The mask map is a monochromatic bit map that you use to perform
arbitrary clipping (i.e., a method of clipping to nongeometric
shapes). When enabled, each 0 bit in the map indicates a pixel that
should not be modified during a drawing operation, while a 1 bit is a
signal to draw the applicable pixel. If the dimension of the mask map
is smaller than that of the destination map for a given operation,
then the outer edges of the mask map also define a clipping rectangle.

The mask map is extremely useful in windowing environments where you
have overlapping windows, because you can draw on underlying windows
without having to manually pre-clip all the objects you're drawing.
Instead, you just define a mask map that permits drawing only in the
exposed area of the desired window. A full-screen 1024- by 768-pixel
mask map occupies only 96K bytes of memory. You can also partially
enable a mask map so that it acts only as a clipping rectangle and
does not perform the arbitrary pixel-by-pixel clip.

All four maps are defined via 5-pixel map registers. The first pixel
in the bit map, which is in the upper left corner of a display bit
map, has a coordinate of 0,0. The mask-map origin registers define the
mask-map position over the destination map. All maps are limited to a
height and width of 4096 by 4096 pixels.

Drawing with the XGA
Before you can draw anything with the XGA, you must at least define
the destination map for the operation you want to perform. Some
operations also require a source map, such as a BitBlt. A BitBlt is an
operation that copies bits from one place to another. The available
drawing operations on the XGA are lines, short vectors, filled
rectangles, BitBlts, and area fills.

Unfortunately, drawing lines is not as simple as just providing an x,y
coordinate pair. The XGA uses a Bresenham line-drawing algorithm, but
you must first calculate the initial Bresenham parameters, a process
that creates a bit of overhead when drawing short lines.
Coincidentally, the method for calculating these parameters is
virtually identical to that used in drawing lines on the 8514/A. A
description of this algorithm for optimized line drawing on computer
displays can be found in Foley and Van Dam's Fundamentals of
Interactive Computer Graphics (Addison-Wesley, 1982).

The XGA's short vectors are similar to the 8514/A's short stroke
vectors. These vectors can be up to 15 pixels in length, and they can
point in any direction that is a multiple of 45 degrees (e.g.,
horizontal, vertical, and diagonal). The benefit of the XGA's short
vectors is that the definition for each one consumes only a byte, and
up to 4 bytes can be passed at a time, allowing for a quick data
transfer rate and, therefore, a quick drawing rate.

Filled rectangles are quite straightforward. You just specify a width,
height, and position, and off you go. BitBlts are similar to a filled
rectangle except that you have to specify a source map as well as a
destination map. The XGA also has the ability to perform a simple
color-expansion BitBlt, one in which the source is monochromatic and
each 0 bit is converted to one color and each 1 bit to another color.
The destination map can be anything from 1 to 8 bits in depth. Color
expansion is useful for displaying rendered fonts on a high-color-
content screen or bit map.

Area fills are a modified rectangle fill in which the XGA graphics
coprocessor uses the pattern map as a guideline for a scan conversion.
This type of fill uses 1-bit flags to toggle the fill state as it
scans each line in the pattern bit map. Initially, for each line, the
fill state is off. On hitting a 1 bit, each subsequent pixel (or bit)
in the pattern map is filled until the next 1 bit is encountered.

Lines, short vectors, and filled rectangles can also use a source map
and a pattern map. You can use the pattern map for line patterns and
area patterns, while you can use the source map for tiling a region
(in the case of a filled rectangle) or for providing a color line
pattern for lines and short vectors.

All the drawing functions are also affected by four types of drawing
modifiers: drawing colors, mixes, color compare, and the pixel bit
mask. Drawing colors are simple to use. The foreground color specifies
what color you would normally draw in, while the background color
specifies the color you would use in color expansions (for a 0 bit).

Mixes, known as raster operations or raster ops on other graphics
platforms, provide a mechanism by which the destination pixel (the one
in the destination map at the current drawing position) and the source
pixel (the foreground color or source map pixel) are mixed. A typical
mix is XOR, the exclusive OR operation, which is used for cursors and
highlights.

You can use color compare during normal pixel updates to determine
whether a given pixel should be updated, based on its color. The
destination pixel value (or color) is compared to the destination
color-compare value register by using the compare-operation set in the
destination color-compare condition. Therefore, if the result of the
comparison is TRUE, the pixel is not updated.

There are eight compare conditions: always TRUE, always FALSE, greater
than, less than, equal to, not equal to, less than or equal to, and
greater than or equal to. This color comparison can be useful in cases
where you need to protect a range of colors from being updated, such
as background and foreground objects in graphical scenery.

The pixel bit mask controls which bits in a pixel can be modified. Its
biggest use is in protecting binary color ranges and planes of color.

Why XGA?
From a technical standpoint, the XGA is a very elegant piece of work.
It fixes just about all the problems that the 8514/A has had, except
interlaced displays and simplified line drawing. The added features --
definable bit maps, bus mastering, memory mapping, and state saving --
are well thought out. Software developers who want to get the most out
of the XGA should find them quite useful.

In addition, IBM has finally made the right move in providing full
register-level documentation on the XGA. The lack of this type of
documentation hurt the acceptance of the 8514/A. The fact that IBM has
provided it for the XGA should increase the level of support it
receives.

Because of its high-powered nature, the XGA will probably not have a
serious effect on Super VGAs or 8514/A clones in the short term. But
it is reasonable to expect XGA clones to be announced before the end
of this year.

To obtain further technical information on the XGA, you can call IBM's
technical books group directly at (800) 426-7282.


----------------------------------------------------------------------
Jake Richter is the president of Panacea, Inc., a graphics software
development and consulting company located in Londonderry, New
Hampshire. He can be reached on BIX as "jrichter."
----------------------------------------------------------------------




X-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-X

 Another file downloaded from:                               NIRVANAnet(tm)

 & the Temple of the Screaming Electron   Jeff Hunter          510-935-5845
 Salted Slug Systems                      Strange              408-454-9368
 Burn This Flag                           Zardoz               408-363-9766
 realitycheck                             Poindexter Fortran   415-567-7043
 Lies Unlimited                           Mick Freen           415-583-4102
 Tomorrow's 0rder of Magnitude            Finger_Man           408-961-9315
 My Dog Bit Jesus                         Suzanne D'Fault      510-658-8078

   Specializing in conversations, obscure information, high explosives,
       arcane knowledge, political extremism, diversive sexuality,
       insane speculation, and wild rumours. ALL-TEXT BBS SYSTEMS.

  Full access for first-time callers.  We don't want to know who you are,
   where you live, or what your phone number is. We are not Big Brother.

                          "Raw Data for Raw Nerves"

X-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-X
